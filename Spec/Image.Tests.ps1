Describe "PlantUML image" {
    It "can use GraphViz" {
        (& docker run 'origaminetwork/plantuml' -testdot) |
            % { Write-Host $_ }

        Write-Error "TODO: implement it"
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
