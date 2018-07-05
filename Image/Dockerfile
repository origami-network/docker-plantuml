FROM microsoft/windowsservercore as builder

ARG ARG_GRAPHVIZ_VERSION=2.38
ARG ARG_GRAPHVIZ_URL=https://graphviz.gitlab.io/_pages/Download/windows/graphviz-${ARG_GRAPHVIZ_VERSION}.zip
ARG ARG_GRAPHVIZ_PATH=C:\\Graphviz

RUN powershell.exe -Command $ErrorActionPreference = 'Stop' ; $VerbosePreference = 'Continue' ; \
  $filePath = Join-Path $env:TEMP Graphviz.zip ; \
  Invoke-WebRequest $env:ARG_GRAPHVIZ_URL -OutFile $filePath ; \
  Expand-Archive -Path $filePath -DestinationPath $env:ARG_GRAPHVIZ_PATH

# TODO: Download PlantUML


FROM openjdk:8u171-jdk-windowsservercore

ARG ARG_GRAPHVIZ_PATH=C:\\Graphviz

COPY --from=builder ${ARG_GRAPHVIZ_PATH} ${ARG_GRAPHVIZ_PATH}
ENV GRAPHVIZ_DOT=${ARG_GRAPHVIZ_PATH}\\release\\bin\\dot.exe

# TODO: install PlantUML
