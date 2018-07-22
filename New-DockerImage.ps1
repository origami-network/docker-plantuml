[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingCmdletAliases", "")]

[CmdletBinding()]
param(
    [string] $BasePath = (Get-Location),

    [hashtable] $Image = (. (Join-Path $BasePath 'project.config.ps1')).Image,

    [string] $Name = $Image.Name,
    [string] $ContextPath = (Join-Path $BasePath $Image.Context.Path)
)

$ErrorActionPreference = 'Stop'


Write-Verbose "Docker Image: prepare arguments"
function ConvertTo-FlatArray {
    param (
        [string] $Name,
        [object[]] $Value,

        [string] $Sepeartor = '_'
    )

    begin {}
    process {
        $Value |
            % {
                if ($_ -is [hashtable]) {
                    $_.GetEnumerator() |
                        % { ConvertTo-FlatArray -Name ($Name, $_.Name -join $Sepeartor) -Value $_.Value -Sepeartor $Sepeartor }
                } else {
                    @{
                        Name = $Name
                        Value = $Value
                    }
                }
            }
    }
    end {}
}
$arguments = @(
    'build',
    '--tag', $Name
)
$arguments += ConvertTo-FlatArray -Name 'ARG' -Value $Image.Arguments |
    % {
        '--build-arg'
        "$($_.Name.ToUpper())=$($_.Value)"
    }
$arguments += $ContextPath

Write-Verbose "Docker Image: build '$($Name)'"
& docker $arguments |
    Out-Default
if ($LASTEXITCODE) {
    Write-Error "Docker Image: 'build $($arguments -join ' ')' failed with status $($LASTEXITCODE)."
}
