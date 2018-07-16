$script:PluntUmlVersion = "1.2018.8" 
$script:GraphViz = "2.38"

$script:Revision = 0

@{
    Image = @{
        Name = "origaminetwork/plantuml"
        Tag = "$($script:PluntUmlVersion).$($script:Revision)"
        Arguments = @{
            PluntUml = @{
                Version = $script:PluntUmlVersion
            }
            GraphViz = @{
                Version = $script:GraphViz
            }
        }
    }
}
