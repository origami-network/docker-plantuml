param (
    [Parameter(Mandatory = $true)]
    $ImageName,

    $Here = (Split-Path -Parent $MyInvocation.MyCommand.Path),
    $ModulesPath = (Join-Path $Here "Modules")
)

Import-Module (Join-Path $ModulesPath 'TestDrive.psm1') -Force


Describe "PlantUML image" {
    It "has configured GraphViz" {
        $plantuml = @(
            '-testdot'
        )
        $docker = @(
            'run', $ImageName
        )
        $arguments = $docker + $plantuml

        Write-Host "> docker $($arguments -join ' ')"
        $result = & docker $arguments
        $result |
            Write-Host

        $LASTEXITCODE |
            Should -Be 0
        $result |
            ? { $_ -like 'Error:*' } |
            Should -HaveCount 0
        $result |
            ? { $_ -like '*OK*' } |
            Should -HaveCount 1
    }

    Context "Simple diagram" {
        $diagram = New-TestDriveFile 'diagram.puml' @"
@startuml

class ArrayList
ArrayList : add()
ArrayList : remove()

@enduml
"@

        $volumePath = "C:\Volume"
        $volumeFile = Join-Path $volumePath $diagram.File
        $docker = @(
            'run',
            '-v', "$($TestDrive):$($volumePath)"
            $ImageName
        )

        It "generates PNG diagram from file" {
            $resultFile = [System.IO.Path]::ChangeExtension($diagram.TestFile, '.png')
            $plantuml = @(
                $volumeFile
            )
            $arguments = $docker + $plantuml

            Write-Host "> docker $($arguments -join ' ')"
            & docker $arguments |
                Write-Host

            $LASTEXITCODE |
                Should -Be 0
            $resultFile |
                Should -Exist
        }

        It "generates SVG diagram from file" {
            $resultFile = [System.IO.Path]::ChangeExtension($diagram.TestFile, '.svg')
            $plantuml = @(
                '-tsvg', $volumeFile
            )
            $arguments = $docker + $plantuml

            Write-Host "> docker $($arguments -join ' ')"
            & docker $arguments |
                Write-Host

            $LASTEXITCODE |
                Should -Be 0
            $resultFile |
                Should -Exist
        }
    }

    Context "Custom include path" {
        $include = New-TestDriveFile 'Include\include.puml' @"
@startuml

interface List
List : add()
List : remove()

@enduml
"@

        $diagram = New-TestDriveFile 'diagram.puml' @"
@startuml

!include $($include.FileName)

class ArrayList
ArrayList : size()

List <|.. ArrayList

@enduml
"@

        $volumePath = "C:\Volume"
        $volumeFile = Join-Path $volumePath $diagram.File
        $docker = @(
            'run',
            '-e', "PLANTUML_INCLUDE_PATH=$(Join-Path $volumePath $include.SubPath)"
            '-v', "$($TestDrive):$($volumePath)"
            $ImageName
        )

        It "finds include file" {
            $resultFile = [System.IO.Path]::ChangeExtension($diagram.TestFile, '.png')
            $plantuml = @(
                $volumeFile
            )
            $arguments = $docker + $plantuml

            Write-Host "> docker $($arguments -join ' ')"
            & docker $arguments |
                Write-Host

            $LASTEXITCODE |
                Should -Be 0
            $resultFile |
                Should -Exist
        }
    }
}
