
$ErrorActionPreference = 'Stop';
$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  fileType      = 'MSI'
  url64bit      = 'https://github.com/DRSchlaubi/mcserv/releases/download/v0.0.1/mcserv-0.0.1.msi'

  softwareName  = 'mcserv*'

  checksum64    = '36affeba2bffc2dd132504aa65ca094fd2e60840751124b600fb335b503aa911'
  checksumType64= 'sha256'

  silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs



















