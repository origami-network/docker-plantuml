[CmdletBinding]
function New-TestDriveFile {
    param(
        [string] $File,
        [string] $Value
    )

    $FileName = Split-Path -Leaf $File
    $SubPath = Split-Path -Parent $File
    $TestFile = Join-Path $TestDrive $File

    if ($SubPath) {
        New-Item (Join-Path $TestDrive $SubPath) -ItemType Directory -ErrorAction SilentlyContinue |
            Out-Null
    }

    Set-Content -Value $Value -Path $TestFile

    Write-Host "== BEGIN: $($File) =="
    Get-Content -Path $TestFile |
        Write-Host
    Write-Host "== END: $($File) =="

    @{
        File = $File
        FileName = $FileName
        SubPath = $SubPath
        TestFile = $TestFile
    }
}
