
| master | latest |
| :--: | :--: |
| [![Build status](https://ci.appveyor.com/api/projects/status/ekvnf486e8wdk4hh/branch/master?svg=true)](https://ci.appveyor.com/project/BartDubois/docker-plantuml/branch/master) | [![Build status](https://ci.appveyor.com/api/projects/status/ekvnf486e8wdk4hh?svg=true)](https://ci.appveyor.com/project/BartDubois/docker-plantuml) |


PlantUML - Windows Docker image
==

[PlantUML](http://plantuml.com/) is a tool that allow to write diagrams by using text based language.

Example bellow shows the PlanUML class diagram text definition and its graphics representation.

```
@startuml

class Base
class Subclass

Base <|-- Subclass

@enduml
```

![Example class diagram](https://www.plantuml.com/plantuml/img/SoWkIImgAStDuU9ApaaiBbPmIYnEXJA3IvF032ukaA22JOskBfAOGsfU2b0V0000)


## Usage

This Docker image allows to use PlantUML without need of installation on Windows 2016 and Windows 10.
It accepts all parameters as specified by [PlantUML command line](http://plantuml.com/command-line).


### Pull Docker image

Before start the image need to be pulled from the [Docker Hub](https://hub.docker.com/r/origaminetwork/plantuml/).

```console
> docker pull origaminetwork/plantuml:X.X.X.Y
```

Where `X.X.X.Y` is the version of the image.

### Generate image file

For the file `diagram.puml` located in `C:\Users\UserName\Documents\` folder, fallowing command will generate `diagram.png` image file.

```console
> docker run -v C:\Users\UserName\Documents:C:\Volume origaminetwork/plantuml:X.X.X.Y C:\Volume\diagram.puml
```

If the `.svg` image file should be generated the command below could be used.

```console
> docker run -v C:\Users\UserName\Documents:C:\Volume origaminetwork/plantuml:X.X.X.Y -tsvg C:\Volume\diagram.puml
```

### Include path

Beside the current diagram text file, PlantUML allows to define custom search path where the `!include` files can be found.
While it is passed as the Java property standard image parameters can't be used.

The docker image uses `PLANTUML_INCLUDE_PATH` environment variable to pass it into PlantUML process.
Its value should point to folder inside container mapped as the volume.

For instance our diagram file is located in `C:\Users\UserName\Documents\Diagrams` directory. Files that should be included in `C:\Users\UserName\Documents\Includes` directory. By using command bellow the `!include` file could be found in `C:\Includes` volume folder.

```
> docker run -v C:\Users\UserName\Documents\Diagrams:C:\Diagrams -v C:\Users\UserName\Documents\Includes:C:\Includes -e PLANTUML_INCLUDE_PATH=C:\Includes origaminetwork/plantuml:X.X.X.Y C:\Diagrams\diagram.puml
```


## Contributing

In order to contribute to the project please fallow [Contributing Guidance](CONTRIBUTING.md).


## License

The project is licensed under [MIT License](LICENSE).
