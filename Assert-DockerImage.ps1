[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingCmdletAliases", "")]

#Requires -Modules Pester

[CmdletBinding()]
param(
    [string] $BasePath = (Get-Location),

    [hashtable] $Project = (. (Join-Path $BasePath 'project.config.ps1')),

    [string] $Name = $Project.Image.Name,

    [string] $SpecificationPath = (Join-Path $BasePath $Project.Image.Specification.Path),

    [string] $ArtifactsPath = (
        $BasePath |
        Join-Path -ChildPath $Project.Artifacts.Path |
        Join-Path -ChildPath $Project.Image.Specification.Path
    ),
    [string] $ArtifactNUnitFile = (Join-Path $ArtifactsPath 'DockerImage.NUnit.xml')
)

$ErrorActionPreference = 'Stop'


Write-Verbose "Docker Image: prepare artifacts path"
New-Item $ArtifactsPath -ItemType Directory -Force -ErrorAction SilentlyContinue |
    Out-Null

Write-Verbose "Docker Image: assert specification"
$script = @(
    @{
        Path = $SpecificationPath
        Parameters = @{ ImageName = $Name }
    }
)
Invoke-Pester -Script $script -OutputFormat NUnitXml -OutputFile $ArtifactNUnitFile
