param (
    $Here = (Split-Path -Parent $MyInvocation.MyCommand.Path),

    $ImageName = 'origaminetwork/plantuml',

    $ExamplesPath = (Join-Path $Here Examples)
)

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
        $includePath = Join-Path $TestDrive 'Include'
        New-Item -ItemType Directory $includePath |
            Out-Null

        $includeFileName = 'include.puml'
        $includeFile = Join-Path $includePath $includeFileName
        $include = @"
@startuml

interface List
List : add()
List : remove()

@enduml
"@
        Set-Content -Value $include -Path $includeFile

        $diagramFileName = 'diagram.puml'
        $diagramFile = Join-Path $TestDrive $diagramFileName
        $diagram = @"
@startuml

!include $($includeFileName)

class ArrayList
ArrayList : size()

List <|.. ArrayList

@enduml
"@
        Set-Content -Value $diagram -Path $diagramFile

        $volumePath = "C:\Volume"
        $volumeFile = Join-Path $volumePath $diagramFileName
        $docker = @(
            'run',
            '-e', "PLANTUML_INCLUDE_PATH=$(Join-Path $volumePath 'Include')"
            '-v', "$($TestDrive):$($volumePath)"
            $ImageName
        )

        It "finds include file" {
            $resultFile = [System.IO.Path]::ChangeExtension($diagramFile, '.png')
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

function New-TestDriveFile {
    param(
        $File,
        $Value
    )

    $FileName = Split-Path -Leaf $File
    $SubPath = Split-Path -Parent $File
    $TestFile = Join-Path $TestDrive $File

    if ($SubPath) {
        Join-Path $TestDrive $SubPath |
            New-Item -ItemType Directory -ErrorAction SilentlyContinue |
            Out-Null        
    }
    
    Set-Content -Value $Value -Path $TestFile

    Write-Host "== BEGIN: $($File) =="
    Get-Content -Path $path |
        Write-Host
    Write-Host "== END: $($File) =="

    @{
        File = $File
        FileName = $FileName
        SubPath = $SubPath
        TestFile = $TestFile
    }
} 