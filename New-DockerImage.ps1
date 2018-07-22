[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingCmdletAliases", "")]

[CmdletBinding()]
param(
    [string] $BasePath = (Get-Location),

    [hashtable] $Image = (. (Join-Path $BasePath 'project.config.ps1')).Image,

    [string] $Name = $Image.Name,
    [string] $ContextPath = (Join-Path $BasePath $Image.Context.Path)
)

$ErrorActionPreference = 'Stop'


Write-Verbose "Docker Image: build '$($Name)'"
$arguments = @(
    'build',
    '--tag', $Name,
    $ContextPath
)
# FIXME: [#6 2.2.] Pass image arguments
& docker $arguments |
    Out-Default
if ($LASTEXITCODE) {
    Write-Error "Docker Image: 'build $($arguments -join ' ')' failed with status $($LASTEXITCODE)."
}
