[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingCmdletAliases", "")]

[CmdletBinding()]
param(
    [string] $BasePath = (Get-Location),

    [string] $LowPattern = 'T{1}BD:?',
    [string] $MediumPattern = 'T{1}ODO:?',
    [string] $HighPattern = 'F{1}IXME:?'
)

$ErrorActionPreference = 'Stop'


function New-RemaningTask {
    [CmdletBinding(DefaultParameterSetName = 'ByValue')]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = 'ByMatchesPipe')]
        [Parameter(Mandatory = $true, ParameterSetName = 'ByValue')]
        [string] $Priority,

        [Parameter(ValueFromPipeline = $true, ParameterSetName = 'ByMatchesPipe')]
        [Microsoft.PowerShell.Commands.MatchInfo[]] $Match,

        [Parameter(ParameterSetName = 'ByValue')]
        [string] $File,
        [Parameter(ParameterSetName = 'ByValue')]
        [long] $LineNumber,
        [Parameter(ParameterSetName = 'ByValue')]
        [string] $Example

    )

    begin {}
    process {
        if ($PSCmdlet.ParameterSetName -eq 'ByValue') {
            New-Object PSObject -Property $PSBoundParameters
        } else {
            $Match |
                % {
                    $example = Get-Content $_.Path |
                        Select-Object -Skip ($_.LineNumber - 1) -First 3 |
                        Out-String
                    New-RemaningTask -Priority $Priority -File $_.Path -LineNumber $_.LineNumber -Example $example
                }
        }
    }
    end {}
}

$files = Get-ChildItem $BasePath -Recurse -File

'Low', 'Medium', 'High' |
    % {
        $priority = $_
        $pattern = (Get-Variable -Name "$($priority)Pattern").Value

        Write-Verbose "Remaining Tasks: $($_.ToLower())"
        $files |
            Select-String -Pattern $pattern |
            New-RemaningTask -Priority $priority |
            % {
                Write-Verbose "Remaining Tasks:  * $($_.File):$($_.LineNumber):`n$($_.Example)"
                $_
            }
    }
