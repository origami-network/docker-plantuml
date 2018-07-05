FROM microsoft/windowsservercore as builder

ARG GRAPHVIZ_VERSION=2.38
ARG GRAPHVIZ_URL=https://graphviz.gitlab.io/_pages/Download/windows/graphviz-${GRAPHVIZ_VERSION}.zip

RUN powershell.exe -Command $ErrorActionPreference = 'Stop'; \
  $filePath = Join-Path $env:TEMP graphviz.zip \
  Invoke-WebRequest $env:GRAPHVIZ_URL -OutFile $filePath

# TODO: Upack Graphviz
# TODO: Download PlantUML


FROM openjdk:8u171-jdk-windowsservercore

# FIXME: It is just for test
RUN java -version

# TODO: install Graphviz
# TODO: install PlantUML
