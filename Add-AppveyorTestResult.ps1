[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingCmdletAliases", "")]

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
    [string[]] $Path,

    [ValidateSet('NUnit')]
    [string] $Framework = 'NUnit'
)


begin {
    $uploadUrl = "https://ci.appveyor.com/api/testresults/$($Framework.ToLower())/$($env:APPVEYOR_JOB_ID)"
    $webClient = New-Object 'System.Net.WebClient'
}

process {
    $Path |
        % {
            $webClient.UploadFile($uploadUrl, (Resolve-Path $Path))
        }
}

end {}
