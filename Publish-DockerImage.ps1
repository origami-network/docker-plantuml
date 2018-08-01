[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingCmdletAliases", "")]

[CmdletBinding()]
param(
    [string] $BasePath = (Get-Location),

    [string] $Name = (. (Join-Path $BasePath 'project.config.ps1')).Image.Name,
    [string[]] $Tag,

    [string] $UserName = $env:DOCKER_USERNAME,
    [string] $UserPassword = $env:DOCKER_USERPASSWORD
)

$ErrorActionPreference = 'Stop'


Write-Verbose "Docker Image: validate tag existance"
function Read-DockerImageTags {
    param (
        $Name,
        $Next = "https://hub.docker.com/v2/repositories/$($Name)/tags/" 
    )

    try {
        do {
            $response = Invoke-RestMethod $Next;
            $response.results |
                % { $_.name }

            $Next = $response.next
        } while ($Next)
    } catch {
        if ($_.Exception.Response.StatusCode.Value__ -ne 404) {
            throw
        }
    }
}
$matchedTag = Read-DockerImageTags $Name |
    ? { $Tag -contains $_ } |
    Select-Object -First 1
if ($matchedTag) {
    Write-Error "Docker Image: Tag '$($matchedTag)' exists for image '$($Name)'."
}

Write-Verbose "Docker Image: tag"
$publishTag = $Tag |
    % {
        $newTag = "$($Name):$($_)"
        Write-Verbose "Docker Image:  * $($newTag)"
        $arguments = @(
            'tag', $Name, $newTag
        )
        & docker $arguments |
            Out-Default
        if ($LASTEXITCODE) {
            Write-Error "Docker Image: 'docker $($arguments -join ' ')' failed with status $($LASTEXITCODE)."
        }

        $newTag
    }

if ($UserName) {
    Write-Verbose "Docker Image: login"
    $arguments = @(
        'login',
        '--username', $UserName,
        '--password-stdin'
    )
    $UserPassword |
        & docker $arguments |
        Out-Default
    if ($LASTEXITCODE) {
        Write-Error "Docker Image: 'docker $($arguments -join ' ')' failed with status $($LASTEXITCODE)."
    }
}

Write-Verbose "Docker Image: push"
$publishTag |
    % {
        Write-Verbose "Docker Image:  * $($_)"
        $arguments = @(
            'push', $_
        )
        & docker $arguments |
            Out-Default
        if ($LASTEXITCODE) {
            Write-Error "Docker Image: 'docker $($arguments -join ' ')' failed with status $($LASTEXITCODE)."
        }
    }
