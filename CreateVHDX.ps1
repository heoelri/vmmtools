# Use DISM in Windows PowerShell
# https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/use-dism-in-windows-powershell-s14

$WIMPath = "D:\temp\ws2016\sources\install.wim"
$WIMWorkingDir = "D:\temp\mount"
$WorkingDir = "D:\temp"
$Edition = "ServerDatacenterCore"
$UpdDir = "D:\temp\updates"

# Lookup all *.MSU in $UpdDir
$updates = Get-ChildItem -Path $UpdDir -Name *.msu
Write-Output "** Found $($updates.count) Update(s) in $UpdDir"

Mount-WindowsImage -ImagePath $WIMPath -Path $WIMWorkingDir -Index 1

foreach ($update in $updates) {

    # Integrate selected update into the mounted image
    Write-Output "** Integrate $($update.name) into $WIMPath"
    Add-WindowsPackage -Path $WIMWorkingDir -PackagePath "$UpdDir\$($update.FullName)" -IgnoreCheck

}

Dismount-WindowsImage -Path $WIMPath

Convert-WindowsImage -SourcePath $WIMPath -WorkingDirectory $WorkingDir -Edition $Edition -VHDFormat VHDX -VHDPartitionStyle GPT 
