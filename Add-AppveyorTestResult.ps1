[CmdletBinding()]
param(
    [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
    [string[]] $Path,

    [ValidateSet('NUnit')] 
    [string] $Framework = 'NUnit'
)


begin {
    $uploadUrl = "https://ci.appveyor.com/api/testresults/$($Framework.ToLower())/$($env:APPVEYOR_JOB_ID)"
}

process {
    $Path |
        % {
            Invoke-WebRequest -Uri $uploadUrl -Method Post -InFile $_
        }
}

end {}
