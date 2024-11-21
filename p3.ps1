# Search Implementation
$MemoryToScan = [byte[]]::new(0x1000) # Example buffer size
$BytesRead = 0
$Success = [ObfAPIs]::ReadProcessMemory($Address, [IntPtr]$Pointer, $MemoryToScan, $MemoryToScan.Length, [ref]$BytesRead)

if ($Success) {
    Write-Host "[*] Memory read successfully. Bytes read: $BytesRead"
    for ($i = 0; $i -lt $MemoryToScan.Length; $i++) {
        $Chunk = [BitConverter]::ToString($MemoryToScan[$i..($i + 7)])
        Write-Host "[$i] Chunk: $Chunk"
    }
} else {
    Write-Host "[!] Memory read failed. Check permissions."
}

Write-Host "[*] Script execution completed."
