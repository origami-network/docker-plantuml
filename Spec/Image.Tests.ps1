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
        $diagramFileName = 'diagram.puml'
        $diagramFile = Join-Path $TestDrive $diagramFileName
        $diagram = @"
@startuml

class ArrayList
ArrayList : add()
ArrayList : remove()

@enduml
"@
        Set-Content -Value $diagram -Path $diagramFile

        $volumePath = "C:\Volume"
        $volumeFile = Join-Path $volumePath $diagramFileName
        $docker = @(
            'run',
            '-v', "$($TestDrive):$($volumePath)"
            $ImageName
        )

        It "generates PNG diagram from file" {
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
    
        It "generates SVG diagram from file" {
            Write-Error "TODO: implement it"
        }
    }


    It "can use custom include path" {
        $arguments = @(
            '--env', "PLANTUML_INCLUDE_PATH=TODO: define test path"
        )
        Write-Error "TODO: implement it"
    }
}
