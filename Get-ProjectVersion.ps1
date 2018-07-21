[CmdletBinding()]
param(
    [string] $BasePath = (Get-Location),

    [long] $BuildNumber
)

$ErrorActionPreference = 'Stop'


$project = . (Join-Path $BasePath 'project.config.ps1')

$publishVersion = $project.Version
$buildVersion = "$($publishVersion).$($BuildNumber)".Trim('.')

[psobject]@{
    Publish = $publishVersion
    Build = $buildVersion
}
