# Powershell Helpers

## Misc

### Search cmdlets
Get-Command -Name *iis*
Get-Help Get-Command | Format-List *

### List cmdlet members
Select-Object -First 1 | Get-Member

### Get IP Address
Get-NetIPAddress -InterfaceAlias Ethernet0

### Windows Event Log for lock/unlock events
Get-WinEvent @{logname='security';starttime=[datetime]::today;id='4800','4801' } | Format-Table TimeCreated, Message

## TFS

## Undo unchanged files in TFS
Set-Location -Path C:\some\path
tfpt uu . /noget /recursive

## IIS

### App pool process ids
Get-WmiObject Win32_Process -Filter "name = 'w3wp.exe'" | Format-Table Handle, CommandLine

### Site info (to help find corresponding C:\inetpub\logs\LogFiles folder for site)
Get-IISSite | Format-Table

### Site name, app pool, physical path
Clear-Host
Get-Website | Sort-Object Name | Format-Table Name, applicationPool, PhysicalPath
Get-WebApplication | Sort-Object Path | Format-Table Path, applicationPool, PhysicalPath

## NuGet 

### Clear cached packages
D:\mwalters\software\nuget\4.1.0\nuget.exe locals all -list
D:\mwalters\software\nuget\4.1.0\nuget.exe locals all -clear

### List all references to a package
Clear-Host
Set-Location "D:\some\location" 
Get-ChildItem -include "packages.config" -recurse | Select-String -pattern "some-pattern" | Sort-Object -Property path -Descending | Select-Object path, line | Format-Table -AutoSize