[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingCmdletAliases", "")]

[CmdletBinding()]
param(
    [string] $BasePath = (Get-Location),

    [hashtable] $Name = (. (Join-Path $BasePath 'project.config.ps1')).Image,
    [string[]] $Tag = 'latest',

    [string] $UserName = $env:DOCKER_USERNAME,
    [string] $UserPassword = $env:DOCKER_USERPASSWORD
)

$ErrorActionPreference = 'Stop'


Write-Error 'FIXME: [#6 5.] publish image'
# Invoke-RestMethod https://hub.docker.com/v2/repositories/{name}/tags/?page=1 fo test image exists till next atribute will be empty or tag ware found
# - docker login -u="$env:DOCKER_USER" -p="$env:DOCKER_PASS"
# - docker push me/myfavoriteapp
