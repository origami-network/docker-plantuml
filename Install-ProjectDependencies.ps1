[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingCmdletAliases", "")]

#Requires -Modules PackageManagement

[CmdletBinding(SupportsShouldProcess)]
param(
    [string] $BasePath = (Get-Location),

    [hashtable[]] $Dependencies = (. (Join-Path $BasePath 'project.config.ps1')).Dependencies,

    [switch] $Force,
    [switch] $SkipPublisherCheck
)

$ErrorActionPreference = 'Stop'


if ($Dependencies) {
    Write-Verbose "Project Dependencies: install module:"
    $Dependencies |
        % {
            Write-Verbose "Project Dependencies:  * $($_.Name)"

            if ($Force -and (-not $_.ContainsKey('Force'))) {
                $_.Add('Force', $Force)
            }
            if ($SkipPublisherCheck) {
                $_.Add('SkipPublisherCheck', $SkipPublisherCheck)
            }
            Install-Module @_
        }
} else {
    Write-Verbose "Project Dependencies: not found"
}
