$script:PluntUmlVersion = "1.2018.8"
$script:Revision = 0

@{
    Version = "$($script:PluntUmlVersion).$($script:Revision)"

    Image = @{
        Name = "origaminetwork/plantuml"

        Context = @{
            Path = "Image"
        }
        Arguments = @{
            PlantUml = @{
                Version = $script:PluntUmlVersion
            }
            GraphViz = @{
                Version = "2.38"
            }
        }
    }

    Dependencies = @(
        @{ Name = 'Pester'; RequiredVersion = '4.3.1' }
    )
}
