[CmdletBinding()]
param(
    [string] $BasePath = (Get-Location),

    [hashtable] $Image = (. (Join-Path $BasePath 'project.config.ps1')).Image,

    [string] $Name = $Image.Names,
    [string] $ContextPath = (Join-Path $BasePath $Image.Context.Path)
)

$ErrorActionPreference = 'Stop'


Write-Verbose "Docker Image: build '$($Name)'"
$arguments = @(
    'build',
    '--tag', $Name,
    $ContextPath
)
& docker $arguments |
    Out-Default
if ($LASTEXITCODE) {
    Write-Error "Docker Image: 'build $($arguments -join ' ')' failed with status $($LASTEXITCODE)."
}
