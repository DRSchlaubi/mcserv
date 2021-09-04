Import-Module au

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyInstall.ps1" = @{
            "(^\s*url64bit\s*=\s*)('.*')" = "`$1'$($Latest.URL64)'"
             "(^\s*checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"

        }
        "mcserv.nuspec" = @{
            "(\<releaseNotes\>).*?(\</releaseNotes\>)" = "`${1}$($Latest.ReleaseNotes)`$2"
        }
    }
}

function global:au_GetLatest {
    $tagName = $env:GITHUB_REF.Replace("refs/tags/", "")
    $version = $tagName.Replace("v", "")
    $uri = "https://github.com/DRSchlaubi/mcserv/releases/download/${tagName}/mcserv-${version}.msi";
    $changelog = $env:CHANGELOG

    @{ URL64 = $uri; Version = $version; ReleaseNotes = $changelog}
}

update -ChecksumFor 64
