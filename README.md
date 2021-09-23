# bls
Backup Linux System

**bls** is tool for backing up of Linux system and files. It is made with
following limitations:

 - it only runs on UEFI systems
 - there can be multiple EFI system partitions
   but they MUST have same content.
 - it only backs up ext filesystems (btrfs, zfs and ntfs are not supported)
 - backuped files are stored in single gziped tar ball
 - there are no incremental backups
 - tar file will/must be stored on samba share
 - it is intended for Debian based system 
   (this is consequence of the fact, that on installation of the
   scrip to the system, missing packages are also installed.
   That can change in future.)

# Prerequisites
Multiple packages/utilities have to be present on the system, for script
to run. On installation of the script, presence of this packages is checked
and if missing, they are installed.

Caveat is, that this works only on Debian based systems (Ubuntu and likes),
since **apt** is used as package manager.

# Installation
Clone repository to your system, cd to **bls** directory and run:
```
sudo make install
```
This will install **bls** script into `/usr/local/bin` directory. It will also
install autocompletion configuration files for bash and zsh (if given shells are
installed on system). If given shell is installed afterwards, repeat installation
process to install missing autocompletion files.

You can remove **bls** from system by running
```
sudo make uninstall
```
This will **not** remove configuration file `/etc/bls.conf` if one has been
created.

# Execution and usage
By runnins script `bls` without any parameter, basic help will be displayed
```
>bls

   bls - Backup Linux System
   -------------------------------------------------------

   synopsis:
      usage: bls command

   commands:
      info          - show extended info on command usage

      backup [task] - run backup for 'task'
      restore       - restore system from backup
      chroot        - chroot to restored system
      list          - list backups on selected share
      mount         - mount selected samba share

   options:
      -t            - dry run, only list files which would
                      be backed up

```
More extensive info on bls usage can be obtained with 
```
bls info
```

