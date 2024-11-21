# Memory Search Function
function Perform-MemorySearch {
    param (
        [IntPtr]$Address,
        [IntPtr]$Pointer,
        $InitOffset,
        $NegOffset,
        $MaxOffset,
        $ReadSize
    )
    $Buffer = [byte[]]::new($ReadSize)
    $BytesRead = 0
    for ($Offset = $InitOffset; $Offset -lt $MaxOffset; $Offset += $NegOffset) {
        $CurrentAddress = [IntPtr]::Add($Pointer, -$Offset)
        $Success = [ObfAPIs]::ReadProcessMemory($Address, $CurrentAddress, $Buffer, $Buffer.Length, [ref]$BytesRead)
        if ($Success -and $BytesRead -gt 0) {
            Write-Host "[*] Data read at offset $Offset: $($Buffer[0..15] -join ' ')"
        }
    }
}

$Settings = Initialize-MemorySearch -InitOffset 0x50000 -NegOffset 0x50000 -MaxOffset 0x1000000 -ReadSize 0x50000
$ProcessHandle = [ObfAPIs]::GetCurrentProcess()
Perform-MemorySearch -Address $ProcessHandle -Pointer [IntPtr]0x12345678 -InitOffset $Settings.InitOffset -NegOffset $Settings.NegOffset -MaxOffset $Settings.MaxOffset -ReadSize $Settings.ReadSize

Write-Host "[*] Script execution completed."
