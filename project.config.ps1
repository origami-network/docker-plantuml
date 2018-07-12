$script:PluntUmlVersion = "x.x.x" 

@{
    Name = "origaminetwork/plantuml"
    Image = @{
        Arguments = @{
            PluntUml = @{
                Version = $script:PluntUmlVersion
            }
            GraphViz = @{
                Version = "2.38"
            }
        }
    }
}
