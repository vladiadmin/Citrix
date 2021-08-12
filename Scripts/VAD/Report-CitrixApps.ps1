<# 
Script Name: Get-CitrixApps
Script Source: "https://github.com/vladiadmin/Citrix/tree/main/Scripts/VAD"
Update Date: 12-Aug-2021
Version: Final

.SYNOPSIS
Produces a csv file "CitrixVAD-AppsReport.csv" containing the applications published in Citrix VAD (Formerly XenApp).

.DESCRIPTION
The script must be run either from a Citrix Desktop Delivery Controller (DDC) or with a powershell session connected to Citrix DDC.
Tested on Citrix VAD 7.15.

.PARAMETER

.EXAMPLE

.INPUTS

.OUTPUTS
A CSV file located in the script' root folder. 

#>
Add-PSSnapin citrix*

$Apps=Get-BrokerApplication
$DG=Get-BrokerDesktopGroup -MaxRecordCount 600

$OutFile = $PSScriptRoot + "\CitrixVAD-AppsReport.csv"
If (Test-Path $OutFile) {del $OutFile}

Add-Content "$OutFile" "AppName|AppCommandLine|IsAppEnabled|AppGroups"

$AppName
$AppCommandLine
$AppStatus
$AppGroups

foreach ($App in $Apps) {
$AppName = $App.PublishedName
$AppCommandLine = $App.CommandLineExecutable
$AppStatus = $App.Enabled
$AppGroups = $null

for ($i=0; $i -le $App.AssociatedUserFullNames.Length; $i++) {

if ($i -lt ($App.AssociatedUserFullNames.Length - 1) ) 
    {
        $AppGroups += $App.AssociatedUserFullNames[$i] + "; "
    } 
else
    {
        $AppGroups += $App.AssociatedUserFullNames[$i]
    }
}

Add-Content $OutFile "$AppName|$AppCommandLine|$AppStatus|$AppGroups"
Write-Host "$AppName|$AppCommandLine|$AppStatus|$AppGroups"
}

[string]$CurDate = Get-Date
[string]$Author = $env:USERDOMAIN + "\" + $env:username
Add-Content $OutFile ""
Add-Content $OutFile "Report created on: $CurDate"
Add-Content $OutFile "Report created by: $Author"