Instructions: How to use SFTP over SSH on KOBO ereaders with Nickel menu and KOReader.

Quick copying of files to your ereader using any sftp client 
For example with Android APPs: File Manager+ or Total Commander with SFTP plugin.

You must have KOReader and Nickel Menu installed on your (KOBO) ereader device (see here https://www.reddit.com/r/kobo/comments/1chz6tz/ko_reader_install/).

1. Make a USB Connection with your ereader with your PC (preferred is Linux).
2. Your KOBO ereader will usually be connected at /media/$USER/KOBOeReader   (where $USER is replaced by your login user name on Linux)
3. Download file sshkeypair.sh to a directory on your PC and cd to that download directory
4. Run sudo ./sshkeypair.sh and hit enter or yes when asked for questions: 

========START========

sudo ./sshkeypair.sh

Generating a keypair to access your Kobo. You will be prompted for a passphrase

Generating public/private ECDSA key pair.
id_kobo already exists.
Overwrite (y/n)? y
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in id_kobo
Your public key has been saved in id_kobo.pub
The key fingerprint is:
SHA256:7prDWnDjzX2rHRhxkFugcMYll+DPWROJE5KJnHtN9cY MyKey@Kobo
The key's randomart image is:
+---[ECDSA 256]---+
|   . oo+.oo.     |
|    +.+.=+.=     |
|     o.*= +.E    |
|    o ==oo.+     |
|     =..S...     |
|    . +.  .o     |
|     = +... .    |
|      *oo ....   |
|     ooo. .oo.   |
+----[SHA256]-----+
Installing key in your SSH keyring

'/root/.ssh/id_kobo' is verwijderd
'id_kobo' -> '/root/.ssh/id_kobo'
'/root/.ssh/id_kobo.pub' is verwijderd
'id_kobo.pub' -> '/root/.ssh/id_kobo.pub'

Device found. Uploading key to device...
'id_kobo.pub' -> '/media/<user>/KOBOeReader/.adds/koreader/settings/SSH/authorized_keys/key.pub'

Agent pid 5419
Identity added: /root/.ssh/id_kobo (MyKey@Kobo)
========END========

5. Check if key.pub is added in /media/<user>/KOBOeReader/.adds/koreader/settings/SSH/authorized_keys/ (where <user> is your user login name on Linux) 
6. Copy and Add following text in the file:  /media/<user>/KOBOeReader/.adds/nm/config   
   (Download therefore this file: add_this_in KOBOeReader_.adds_nm_config.txt)
   
========START========
menu_item :main    :Dropbear_SFTP (toggle)  :cmd_output         :500:quiet :/usr/bin/pkill -f "dropbear"
  chain_success:skip:5
  chain_failure                      :cmd_spawn          :quiet :/bin/mount -t devpts | /bin/grep -q /dev/pts || { /bin/mkdir -p /dev/pts && /bin/mount -t devpts devpts /dev/pts; }
  chain_success                      :cmd_spawn          :quiet :sh /mnt/onboard/.adds/koreader/scripts/mydropbear.sh
  chain_success                      :dbg_toast          :Started Dropbear server on port 2222
  chain_failure                      :dbg_toast          :Error starting Dropbear server on port 2222
  chain_always:skip:-1
  chain_success                        :dbg_toast        :Stopped Dropbox server on port 2222 

========END========

7. A menu entry in Nickel Menu will appear with the name "Dropbear_SFTP (toggle)"
8. Copy and Add the following text in a file called: /media/<user>/KOBOeReader/.adds/koreader/scripts/mydropbear.sh  (where <user> is your user login name on Linux)

========START========
#!/bin/sh
cat /mnt/onboard/.adds/koreader/plugins/terminal.koplugin/profile | grep PATH
PATH="${PATH}:${TERMINAL_DATA}/scripts:${TERMINAL_HOME}/plugins/terminal.koplugin/"
export PATH=$PATH:/mnt/onboard/.adds/koreader/scripts
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/mnt/onboard/.adds/koreader/libs
export HOME=/mnt/onboard/.adds/koreader/
cd $HOME
dropbear -E -R -p2222 -P /tmp/dropbear_koreader.pid
========END========

9. Unmount and Eject your ereader when all the files are properly saved on your ereader and reboot
10. Start ereader and go to Nickel Menu and start Dropbear_SFTP (toggle)
11. Start the SFTP APP on your mobile and connect to the IP address using port 2222 and user: admin with password: admin and accept the public key when prompted.
12. Now use also filezilla or othe sftp clients.
