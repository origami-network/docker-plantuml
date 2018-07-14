Describe "PlantUML image" {
    It "has configured GraphViz" {
        $arguments = @(
            'run', 'origaminetwork/plantuml',
            '-testdot'
        )

        Write-Host "> docker $($arguments -join ' ')"
        $result = & docker $arguments
        Write-Host $result 

        $LASTEXITCODE |
            Should -Be 0
        $result |
            ? { $_ -like 'Error:*' } |
            Should -HaveCount 0
        $result |
            ? { $_ -like '*OK*' } } |
            Should -HaveCount 1
    }

    It "generates PNG diagram from file" {
        Write-Error "TODO: implement it"
    }

    It "generates SVG diagram from file" {
        Write-Error "TODO: implement it"
    }

    It "can use custom include path" {
        $arguments = @(
            '--env', "PLANTUML_INCLUDE_PATH=TODO: define test path"
        )
        Write-Error "TODO: implement it"
    }
}
