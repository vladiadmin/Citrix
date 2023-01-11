<# 	Created: 1-Jul-2021
	Script Name: Report-CitrixUsersInDeliveryGroup.ps1
	Updated: 13-Jul-2021
	Author: vladimir.mihalkov@dxc.com
        Some Update
#>

asnp citrix*

$ExportFolder = "$env:USERPROFILE\Documents"
$ExportPath =  $ExportFolder + "\UsersInDeliveryGroup.csv"


if (!(test-path -Path $ExportFolder)) {mkdir $ExportFolder }

$DG = Get-BrokerDesktop -DesktopGroupName '<group name>' -MaxRecordCount 1000 | select AssociatedUserUPNs, HostedMachineName

Write-Host "HostedMachineName, AssociatedUserUPNs"
Add-Content -Path $ExportPath "HostedMachineName, AssociatedUserUPNs"

for ($q=0; $q -lt $DG.Length; $q++) {
$upns = $null
$hmn = $DG[$q].HostedMachineName

   for ($i=0; $i -lt $DG[$q].AssociatedUserUPNs.length ; $i++) {
       if ($i -ne $DG[$q].AssociatedUserUPNs.length - 1 )    
           {$upns += $DG[$q].AssociatedUserUPNs[$i] + ";"}
       else 
           {$upns += $DG[$q].AssociatedUserUPNs[$i]}
   }

   Add-Content -Path $ExportPath "$hmn,$upns"
   Write-Host "$hmn,$upns"
}
