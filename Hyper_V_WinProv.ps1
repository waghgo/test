Import-VM -Path "C:\Export VM\Base-2012\Base_2012\Virtual Machines\EDB59702-73BF-4BA2-811E-9EE3F849E93A.XML" -GenerateNewId -Copy -VhdDestinationPath "C:\Auto Vdisks"

for ($i=1; $i -lt $vmc.count; $i++)

{

Rename-VM -Name "Base-2012" -NewName $vmc.Name[$i]

Start-VM -Name $vmc.Name[$i]

Stop-VM -Name $vmc.Name[$i]

Set-VM -Name $vmc.Name[$i] -ProcessorCount $vmc.CPU[$i]

$mem = [int64] $vmc.MemorySize[$i].replace("GB","") * 1GB

Set-VMMemory $vmc.Name[$i] -StartupBytes $mem

Set-VM -Name $vmc.Name[$i] -ProcessorCount $vmc.CPU[$i]

Rename-Item -Path 'C:\Auto Vdisks\Base_2012.vhdx' -NewName ($vmc.name[$i] + ".vhdx")

$vhdpath = "C:\Auto Vdisks\" + ($vmc.name[$i] + ".vhdx")

Set-VMHardDiskDrive -VMName $vmc.name[$i] -Path $vhdpath

Start-VM -Name $vmc.Name[$i]

Write-Host "VM built successfully"

winrm set winrm/config/client '@{TrustedHosts="192.168.0.2"}'

Start-Sleep -Seconds 60

Copy-Item "C:\Auto VM configuration\VM-Config-Windows.csv" -Destination "\\192.168.0.2\Net"

Invoke-Command -ComputerName "192.168.0.2" -ScriptBlock {

powershell.exe -ExecutionPolicy Bypass -File "C:\Net\Network-Config-Scripts.ps1"}

Start-Sleep -Seconds 90

$ip="winrm set winrm/config/client '@{TrustedHosts="+'"'+$vmc.IP[$i]+'"'+"}'"

Invoke-Expression $ip

Invoke-Command -ComputerName $vmc.IP[$i] -ScriptBlock {Remove-NetIPAddress -IPAddress 192.168.0.2 -Confirm:$false}

Write-Host "IP successfully configured"

}
