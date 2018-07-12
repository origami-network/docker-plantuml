FROM microsoft/windowsservercore as graphviz

ARG ARG_GRAPHVIZ_VERSION=2.38
ARG ARG_GRAPHVIZ_URL=https://graphviz.gitlab.io/_pages/Download/windows/graphviz-${ARG_GRAPHVIZ_VERSION}.zip
ARG ARG_GRAPHVIZ_PATH=C:\\GraphViz

RUN powershell.exe -Command $ErrorActionPreference = 'Stop' ; \
  $filePath = Join-Path $env:TEMP Graphviz.zip ; \
  [Net.ServicePointManager]::SecurityProtocol = 'Tls', 'Tls11', 'Tls12' ; \
  Invoke-WebRequest $env:ARG_GRAPHVIZ_URL -OutFile $filePath ; \
  Expand-Archive -Path $filePath -DestinationPath $env:ARG_GRAPHVIZ_PATH


FROM microsoft/windowsservercore as pluntuml

ARG ARG_PLANTUML_VERSION=1.2018.8
ARG ARG_PLANTUML_URL=https://downloads.sourceforge.net/project/plantuml/${ARG_PLANTUML_VERSION}/plantuml.${ARG_PLANTUML_VERSION}.jar?r=&ts=0
ARG ARG_PLANTUML_PATH=C:\\PlantUML

RUN powershell.exe -Command $ErrorActionPreference = 'Stop' ; \
  $unused = New-Item -ItemType Directory $env:ARG_PLANTUML_PATH ; \
  $filePath = Join-Path $env:ARG_PLANTUML_PATH plantuml.jar ; \
  [Net.ServicePointManager]::SecurityProtocol = 'Tls', 'Tls11', 'Tls12' ; \
  Invoke-WebRequest $env:ARG_PLANTUML_URL -OutFile $filePath -UserAgent 'Chrome'


FROM openjdk:8u171-jdk-windowsservercore

ARG ARG_GRAPHVIZ_PATH=C:\\GraphViz
ARG ARG_PLANTUML_PATH=C:\\PlantUML

COPY --from=graphviz ${ARG_GRAPHVIZ_PATH} ${ARG_GRAPHVIZ_PATH}
ENV GRAPHVIZ_DOT=${ARG_GRAPHVIZ_PATH}\\release\\bin\\dot.exe

COPY --from=pluntuml ${ARG_PLANTUML_PATH} ${ARG_PLANTUML_PATH}

WORKDIR ${ARG_PLANTUML_PATH}
ENV PLANTUML_INCLUDE_PATH=.

# TODO: enrypoint PlantUML
SHELL ["cmd", "/S", "/C"]
ENTRYPOINT [ "java", "-Dplantuml.include.path=\"%PLANTUML_INCLUDE_PATH%\"", "-jar", "plantuml.jar" ]
