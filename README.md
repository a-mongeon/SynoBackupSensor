# SynoBackupSensor
PRTG Sensor for Synology backup tasks

If you have multiple Synology NAS and a lot of backup tasks, maybe you know the struggle to be aware of failed backups. E-Mails are good, but, if a NAS is down, there is no e-mail alert. 

I'm used to work with PRTG to monitor Windows and Unix networks. This software is pretty cool, specialy for backups sensors. With few Hyper-V hosts and Altaro VM Backup, I'm using this script : https://kb.paessler.com/en/topic/64559-how-can-i-monitor-my-altaro-hyperv-backup-event-logs-and-make-prtg-notify-me to monitor backups. Such a time saving !

So, naturally, I searched a solution to replicate this for Synology HyperBackup. 

First of all, I'm using CMS (Centralized Managed System) | https://www.synology.com/knowledgebase/DSM/help/CMS/cms_desc

This Synology package allows to manage multiple NAS, and, for this case, collect HyperBackup Notifications. CMS use a SQL Lite DataBase to store notifications. This means that it's very simple to query this kind of DataBase.

Imagine we have a dozain of NAS, all connected to the CMS host. Backup Notifications are enabled on each NAS.
The host will receive all notifications relating to backups.

The SQL Lite file is stored in /var/packages/CMS/target/db 

This file is not accessible for normal users. The only way to access it is with SSH access.
For more security, I prefer to bind the folder /var/packages/CMS/target/db to the accessible volume, in a shared folder previously created, with read-only rights :

mount --bind /var/packages/CMS/target/db /volume1/SynoBackupSensor

If your Windows Server use a username with correct rights, you'll can read the file nc_db.sqlite 

P.S: Read-only rights on /volume1/SynoBackupSensor guarantee the good functionning of CMS. 
