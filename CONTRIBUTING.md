Contributing Guidance
==

In order to participate in the project, fork the repository and make pull request of the changes.


## Development

In order to see how the build and test the image use the [`appveyor.yml`](appveyor.yml) CI/CD script.
The sections `build_script` and `test_script` provide respective command lines.


### Image definition

The Docker image definition is located [`Image`](Image/) folder.
Its content will be send to Docker demon during the build. 


### Specification tests

Specification is defined inside [`Spec`](Spec/) folder as `*.Test.ps1` files.

Additional functions used inside tests are located in [`Modules`](Spec/Modules/) sub folder.


## Versioning

The image is versioned by the **version of the PlantUML** and additional **revision number** separated by `.`.

The revision number is used for minor changes in the image, including additional software updates or base image changes.

Both values are managed in [`project.config.ps1`](project.config.ps1) file.
