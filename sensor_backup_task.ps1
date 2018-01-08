################################################################################################################
# PowerShell Script for PRTG Synology Backup Sensor | By Areku95                                               #
# V1.0                                                                                                         #
# This script use the external PowerShell module PSSQLite | https://github.com/RamblingCookieMonster/PSSQLite  #
################################################################################################################

# You only have to modify these 2 variables for each sensor : $hostname; $task;

# $hostname = NAS under surveillance
$hostname="NAS1-TEST"

# $task = Name of the task into HyperBackup
$task="DATA_DAILY"

# Specify the location to read the SQL Lite file
$source="path\nc_db.sqlite" # Could be a network share : \\networkdevice\path\nc_db.sqlite

# First, load the module into the PowerShell Session
Import-Module PSSQLite

################################################################################################################
# Synology use Posix format for dates (Epoch)                                                                  #
# Ex. : 1515422124                                                                                             #
# https://en.wikipedia.org/wiki/Epoch_(reference_date)                                                         #
################################################################################################################

# $yesterday is the value of the current day, in Posix Format, and we substract one day (86400 seconds), to have the value of the previous day
$yesterday=[int][double]::Parse((Get-Date -UFormat %s))-86400

# $today is the value of the current day, in Posix Format
$today=[int][double]::Parse((Get-Date -UFormat %s))

$query=Invoke-SqliteQuery -DataSource $source -Query "SELECT hostname, enu, happen_time FROM msg WHERE happen_time BETWEEN '$yesterday' AND '$today' AND hostname LIKE '$hostname' AND enu LIKE '%$task%';"

If ($query -like "*failed*")
{
Write-Host "2:Backup $task failed"
Exit 2;
}
Else {
    If ($query -like "*successful*")
        {Write-Host "0:Backup $task successful"; Exit 0;}
}

Write-Host "2:No Logs for $task on the last 24h"; Exit 2;