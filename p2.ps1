# Function Declaration and Initial Setup
function Initialize-MemorySearch {
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
    return @{
        InitOffset = $InitOffset;
        NegOffset = $NegOffset;
        MaxOffset = $MaxOffset;
        ReadSize = $ReadSize;
    }
}

Write-Host "[*] Function and memory initialization loaded."
