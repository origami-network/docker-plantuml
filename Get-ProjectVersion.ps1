[CmdletBinding()]
param(
    [string] $BasePath = (Get-Location),

    [string] $BaseVersion = (. (Join-Path $BasePath 'project.config.ps1')).Version,
    [long] $BuildNumber
)

$ErrorActionPreference = 'Stop'


Write-Verbose "Project Version: deliver from '$($BaseVersion)'"
$publishVersion = $BaseVersion
$buildVersion = "$($publishVersion).$($BuildNumber)".Trim('.')

[psobject]@{
    Publish = $publishVersion
    Build = $buildVersion
}
