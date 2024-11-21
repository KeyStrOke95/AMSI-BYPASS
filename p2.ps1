$ObfInit = Get-Date;

$Str = [Text.Encoding]::ASCII.GetString([Convert]::FromBase64String('bWFnaWMsc2NyaXB0'))
$Str2 = $Str.Replace('ma', 'xy').Replace('gi', 'z').Replace('c,', '!')
$Str3 = $Str.Replace('sc', 'py').Replace('ript', 'zz')

$Module = [APIs]::GetModuleHandle($Str)
$Func = [APIs]::GetProcAddress($Module, $Str2 + $Str3)

$Assemblies = [AppDomain]::CurrentDomain.GetAssemblies() | ForEach-Object {
    if ($_.Location -ne $null) {
        $_.GetTypes()
    }
}

$FuncPtr = $Assemblies[0].Methods[0].MethodHandle.GetFunctionPointer()
