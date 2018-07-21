$script:PluntUmlVersion = "1.2018.8"
$script:GraphViz = "2.38"

$script:Revision = 0

@{
    Version = "$($script:PluntUmlVersion).$($script:Revision)"

    Image = @{
        Name = "origaminetwork/plantuml"

        Context = @{
            Path = "Image"
        }
        Arguments = @{
            PluntUml = @{
                Version = $script:PluntUmlVersion
            }
            GraphViz = @{
                Version = $script:GraphViz
            }
        }
    }

    Dependencies = @(
        @{ Name = 'Pester'; RequiredVersion = '4.3.1' }
    )
}
