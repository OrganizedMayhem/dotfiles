# ============================================================================
# Silver's Cloud Engineer PowerShell Profile
# ============================================================================

$script:ProfileTimer = [System.Diagnostics.Stopwatch]::StartNew()

$ProgressPreference = 'SilentlyContinue'

# ----------------------------------------------------------------------------
# Core Helpers
# ----------------------------------------------------------------------------

function Test-Command {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Name
    )

    return $null -ne (
        Get-Command -Name $Name -ErrorAction SilentlyContinue
    )
}

function Invoke-NativeCommand {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Command,

        [Parameter()]
        [object[]]$ArgumentList = @()
    )

    & $Command @ArgumentList

    if ($LASTEXITCODE -ne 0) {
        throw "'$Command' exited with code $LASTEXITCODE."
    }
}

# ----------------------------------------------------------------------------
# Oh My Posh
# ----------------------------------------------------------------------------

if ($env:POSH_CONFIG -and (Test-Command -Name 'oh-my-posh')) {
    try {
        oh-my-posh init pwsh --config $env:POSH_CONFIG |
            Invoke-Expression
    }
    catch {
        Write-Warning (
            "Oh My Posh initialization failed: " +
            $_.Exception.Message
        )
    }
}

# ----------------------------------------------------------------------------
# PSReadLine
# ----------------------------------------------------------------------------

if (
    $Host.Name -eq 'ConsoleHost' -and
    (Get-Module -Name PSReadLine)
) {
    try {
        Set-PSReadLineOption -HistorySaveStyle SaveNothing
        Set-PSReadLineOption -PredictionSource History
        Set-PSReadLineOption -PredictionViewStyle ListView
        Set-PSReadLineOption -EditMode Windows
    }
    catch {
        Write-Warning (
            "PSReadLine configuration failed: " +
            $_.Exception.Message
        )
    }
}

# ----------------------------------------------------------------------------
# Basic Aliases
# ----------------------------------------------------------------------------

Set-Alias -Name tf -Value terraform -Scope Global

# Built-in aliases (gl, gp, gcm) take precedence over the git functions below.
Remove-Item -Path Alias:gl, Alias:gp, Alias:gcm -Force -ErrorAction Ignore

# ----------------------------------------------------------------------------
# Navigation
# ----------------------------------------------------------------------------

function home {
    Set-Location -Path $HOME
}

function repos {
    $path = 'C:\Code'

    if (-not (Test-Path -LiteralPath $path -PathType Container)) {
        throw "Repository directory not found: $path"
    }

    Set-Location -LiteralPath $path
}

# ----------------------------------------------------------------------------
# Terraform
# ----------------------------------------------------------------------------

function tfp {
    $arguments = @('plan') + $args

    Invoke-NativeCommand `
        -Command 'terraform' `
        -ArgumentList $arguments
}

function tfv {
    $arguments = @('validate') + $args

    Invoke-NativeCommand `
        -Command 'terraform' `
        -ArgumentList $arguments
}

function tff {
    $arguments = @('fmt', '-recursive') + $args

    Invoke-NativeCommand `
        -Command 'terraform' `
        -ArgumentList $arguments
}

function tfo {
    $arguments = @('output') + $args

    Invoke-NativeCommand `
        -Command 'terraform' `
        -ArgumentList $arguments
}

# ----------------------------------------------------------------------------
# Azure
# ----------------------------------------------------------------------------

function azctx {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ArgumentCompleter({
            param(
                $CommandName,
                $ParameterName,
                $WordToComplete,
                $CommandAst,
                $FakeBoundParameters
            )

            # az is slow to start; cache the subscription list per session.
            if (
                -not $global:AzSubscriptionCache -and
                (Get-Command -Name az -ErrorAction SilentlyContinue)
            ) {
                $global:AzSubscriptionCache = @(
                    az account list `
                        --query '[].{Name:name,Id:id}' `
                        --output tsv 2>$null
                )
            }

            foreach ($line in $global:AzSubscriptionCache) {
                $name, $id = $line -split "`t", 2

                if ($name -like "$WordToComplete*") {
                    [System.Management.Automation.CompletionResult]::new(
                        $id,
                        $name,
                        'ParameterValue',
                        "$name [$id]"
                    )
                }
            }
        })]
        [string]$Subscription
    )

    Invoke-NativeCommand `
        -Command 'az' `
        -ArgumentList @(
            'account'
            'set'
            '--subscription'
            $Subscription
        )

    az account show `
        --query '{Name:name,SubscriptionId:id,TenantId:tenantId}' `
        --output table
}

function azwhoami {
    az account show `
        --query '{Name:name,SubscriptionId:id,TenantId:tenantId,User:user.name}' `
        --output table
}

function azsubs {
    az account list `
        --query '[].{Name:name,SubscriptionId:id,State:state,Default:isDefault}' `
        --output table
}

function azrg {
    az group list `
        --query '[].{Name:name,Location:location,State:properties.provisioningState}' `
        --output table
}

# ----------------------------------------------------------------------------
# Networking
# ----------------------------------------------------------------------------

function publicip {
    [CmdletBinding()]
    param()

    try {
        $result = Invoke-RestMethod `
            -Uri 'https://api.ipify.org?format=json' `
            -TimeoutSec 10

        $result.ip
    }
    catch {
        throw (
            "Public IP lookup failed: " +
            $_.Exception.Message
        )
    }
}

# ----------------------------------------------------------------------------
# Jira Helpers
# ----------------------------------------------------------------------------

function Resolve-JiraKey {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Key
    )

    $Key = $Key.Trim()

    if ($Key -match '^\d+$') {
        return "IT-$Key"
    }

    return $Key.ToUpperInvariant()
}

function Format-JiraDate {
    [CmdletBinding()]
    param(
        [AllowNull()]
        [object]$Date,

        [Parameter()]
        [string]$Default = 'None'
    )

    if (-not $Date) {
        return $Default
    }

    try {
        return ([datetimeoffset]$Date).ToLocalTime().ToString(
            'yyyy-MM-dd HH:mm'
        )
    }
    catch {
        return [string]$Date
    }
}

function Get-JiraFieldValue {
    [CmdletBinding()]
    param(
        [AllowNull()]
        [object]$Value,

        [Parameter()]
        [string]$Default = 'None'
    )

    if ($null -eq $Value) {
        return $Default
    }

    if ($Value -is [string]) {
        if ([string]::IsNullOrWhiteSpace($Value)) {
            return $Default
        }

        return $Value
    }

    foreach ($property in @(
        'displayName'
        'name'
        'value'
        'key'
        'emailAddress'
    )) {
        if ($Value.PSObject.Properties.Name -contains $property) {
            $result = $Value.$property

            if (-not [string]::IsNullOrWhiteSpace([string]$result)) {
                return [string]$result
            }
        }
    }

    return [string]$Value
}

function ConvertFrom-JiraContentNode {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [object]$Node,

        [Parameter()]
        [int]$ListDepth = 0
    )

    $newLine = [Environment]::NewLine

    switch ($Node.type) {
        'text' {
            $text = [string]$Node.text

            if ($Node.marks) {
                foreach ($mark in @($Node.marks)) {
                    switch ($mark.type) {
                        'code' {
                            $text = "`"$text`""
                        }

                        'link' {
                            if ($mark.attrs.href) {
                                $text = "$text <$($mark.attrs.href)>"
                            }
                        }
                    }
                }
            }

            return $text
        }

        'hardBreak' {
            return $newLine
        }

        'paragraph' {
            $content = foreach ($child in @($Node.content)) {
                ConvertFrom-JiraContentNode `
                    -Node $child `
                    -ListDepth $ListDepth
            }

            return ($content -join '') + $newLine
        }

        'heading' {
            $content = foreach ($child in @($Node.content)) {
                ConvertFrom-JiraContentNode `
                    -Node $child `
                    -ListDepth $ListDepth
            }

            $heading = ($content -join '').Trim()

            return (
                $newLine +
                $heading.ToUpperInvariant() +
                $newLine
            )
        }

        'bulletList' {
            $output = foreach ($listItem in @($Node.content)) {
                $content = foreach ($child in @($listItem.content)) {
                    ConvertFrom-JiraContentNode `
                        -Node $child `
                        -ListDepth ($ListDepth + 1)
                }

                $cleanContent = ($content -join '').Trim()
                $cleanContent = $cleanContent -replace '\r?\n', ' '

                $indent = '  ' * $ListDepth

                "$indent- $cleanContent$newLine"
            }

            return $output -join ''
        }

        'orderedList' {
            $number = 1

            if ($Node.attrs.order) {
                $number = [int]$Node.attrs.order
            }

            $output = foreach ($listItem in @($Node.content)) {
                $content = foreach ($child in @($listItem.content)) {
                    ConvertFrom-JiraContentNode `
                        -Node $child `
                        -ListDepth ($ListDepth + 1)
                }

                $cleanContent = ($content -join '').Trim()
                $cleanContent = $cleanContent -replace '\r?\n', ' '

                $indent = '  ' * $ListDepth

                "$indent$number. $cleanContent$newLine"

                $number++
            }

            return $output -join ''
        }

        'listItem' {
            $content = foreach ($child in @($Node.content)) {
                ConvertFrom-JiraContentNode `
                    -Node $child `
                    -ListDepth $ListDepth
            }

            return $content -join ''
        }

        'codeBlock' {
            $content = foreach ($child in @($Node.content)) {
                ConvertFrom-JiraContentNode `
                    -Node $child `
                    -ListDepth $ListDepth
            }

            return (
                $newLine +
                ($content -join '').TrimEnd() +
                $newLine
            )
        }

        'blockquote' {
            $content = foreach ($child in @($Node.content)) {
                ConvertFrom-JiraContentNode `
                    -Node $child `
                    -ListDepth $ListDepth
            }

            $quotedLines = (
                ($content -join '').Trim() -split '\r?\n'
            ) | ForEach-Object {
                "> $_"
            }

            return ($quotedLines -join $newLine) + $newLine
        }

        'rule' {
            return ('-' * 40) + $newLine
        }

        'inlineCard' {
            if ($Node.attrs.url) {
                return [string]$Node.attrs.url
            }

            return ''
        }

        'mention' {
            if ($Node.attrs.text) {
                return [string]$Node.attrs.text
            }

            if ($Node.attrs.id) {
                return "@$($Node.attrs.id)"
            }

            return '@unknown'
        }

        'emoji' {
            if ($Node.attrs.text) {
                return [string]$Node.attrs.text
            }

            if ($Node.attrs.shortName) {
                return [string]$Node.attrs.shortName
            }

            return ''
        }

        default {
            $content = foreach ($child in @($Node.content)) {
                ConvertFrom-JiraContentNode `
                    -Node $child `
                    -ListDepth $ListDepth
            }

            return $content -join ''
        }
    }
}

function ConvertFrom-JiraDescription {
    [CmdletBinding()]
    param(
        [AllowNull()]
        [object]$Description
    )

    if ($null -eq $Description) {
        return $null
    }

    if ($Description -is [string]) {
        return $Description.Trim()
    }

    if ($Description.content) {
        $text = foreach ($node in @($Description.content)) {
            ConvertFrom-JiraContentNode -Node $node
        }

        return ($text -join '').Trim()
    }

    return (
        $Description |
            ConvertTo-Json -Depth 20
    )
}

function Join-JiraFieldValues {
    [CmdletBinding()]
    param(
        [AllowNull()]
        [object[]]$Values,

        [Parameter()]
        [string]$Default = 'None'
    )

    $results = foreach ($value in @($Values)) {
        $result = Get-JiraFieldValue -Value $value -Default ''

        if (-not [string]::IsNullOrWhiteSpace($result)) {
            $result
        }
    }

    if (@($results).Count -eq 0) {
        return $Default
    }

    return $results -join ', '
}

# ----------------------------------------------------------------------------
# Jira Commands
# ----------------------------------------------------------------------------

function jira-open {
    [CmdletBinding()]
    param()

    if (-not (Test-Command -Name 'acli')) {
        throw 'ACLI was not found in PATH.'
    }

    Invoke-NativeCommand `
        -Command 'acli' `
        -ArgumentList @(
            'jira'
            'workitem'
            'search'
            '--jql'
            'project = IT AND assignee = currentUser() AND status IN ("To Do", Open, New) ORDER BY priority DESC, created DESC'
        )
}

function jira-wip {
    [CmdletBinding()]
    param()

    if (-not (Test-Command -Name 'acli')) {
        throw 'ACLI was not found in PATH.'
    }

    Invoke-NativeCommand `
        -Command 'acli' `
        -ArgumentList @(
            'jira'
            'workitem'
            'search'
            '--jql'
            'project = IT AND assignee = currentUser() AND status IN ("In Progress", "In Review") ORDER BY updated DESC'
        )
}

function Close-JiraTicket {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Parameter(
            Mandatory,
            Position = 0,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [Alias('Ticket', 'Issue')]
        [ValidatePattern('^(?:[A-Za-z][A-Za-z0-9]+-)?\d+$')]
        [string]$Key
    )

    process {
        if (-not (Test-Command -Name 'acli')) {
            Write-Error 'ACLI was not found in PATH.'
            return
        }

        $resolvedKey = Resolve-JiraKey -Key $Key

        if (
            $PSCmdlet.ShouldProcess(
                $resolvedKey,
                'Transition Jira ticket to Done'
            )
        ) {
            Invoke-NativeCommand `
                -Command 'acli' `
                -ArgumentList @(
                    'jira'
                    'workitem'
                    'transition'
                    '--key'
                    $resolvedKey
                    '--status'
                    'Done'
                    '--yes'
                )
        }
    }
}

function Get-JiraTicket {
    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory,
            Position = 0,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [Alias('Ticket', 'Issue')]
        [ValidatePattern('^(?:[A-Za-z][A-Za-z0-9]+-)?\d+$')]
        [string]$Key
    )

    process {
        if (-not (Test-Command -Name 'acli')) {
            Write-Error 'ACLI was not found in PATH.'
            return
        }

        $resolvedKey = Resolve-JiraKey -Key $Key

        try {
            $json = & acli jira workitem get `
                --key $resolvedKey `
                --output json

            if ($LASTEXITCODE -ne 0) {
                throw "ACLI exited with code $LASTEXITCODE."
            }

            if (-not $json) {
                throw 'No ticket data was returned.'
            }

            $issue = $json | ConvertFrom-Json

            if (-not $issue) {
                throw "Ticket '$resolvedKey' was not found."
            }

            $fields = $issue.fields

            $summary = Get-JiraFieldValue `
                -Value $fields.summary `
                -Default '(No summary)'

            $status = Get-JiraFieldValue `
                -Value $fields.status `
                -Default 'Unknown'

            $priority = Get-JiraFieldValue `
                -Value $fields.priority `
                -Default 'None'

            $assignee = Get-JiraFieldValue `
                -Value $fields.assignee `
                -Default 'Unassigned'

            $reporter = Get-JiraFieldValue `
                -Value $fields.reporter `
                -Default 'Unknown'

            $issueType = Get-JiraFieldValue `
                -Value $fields.issuetype `
                -Default 'Unknown'

            $resolution = Get-JiraFieldValue `
                -Value $fields.resolution `
                -Default 'Unresolved'

            $labels = Join-JiraFieldValues `
                -Values $fields.labels

            $components = Join-JiraFieldValues `
                -Values $fields.components

            $fixVersions = Join-JiraFieldValues `
                -Values $fields.fixVersions

            $description = ConvertFrom-JiraDescription `
                -Description $fields.description

            $separator = '-' * 78

            Write-Host ''
            Write-Host $separator -ForegroundColor DarkGray
            Write-Host "$($issue.key): $summary" -ForegroundColor Cyan
            Write-Host $separator -ForegroundColor DarkGray

            $details = [ordered]@{
                'Status'       = $status
                'Priority'     = $priority
                'Type'         = $issueType
                'Assignee'     = $assignee
                'Reporter'     = $reporter
                'Resolution'   = $resolution
                'Created'      = Format-JiraDate -Date $fields.created -Default 'Unknown'
                'Updated'      = Format-JiraDate -Date $fields.updated -Default 'Unknown'
                'Due Date'     = Format-JiraDate -Date $fields.duedate -Default 'None'
                'Labels'       = $labels
                'Components'   = $components
                'Fix Versions' = $fixVersions
            }

            foreach ($entry in $details.GetEnumerator()) {
                Write-Host ('{0,-12} : ' -f $entry.Key) `
                    -NoNewline `
                    -ForegroundColor DarkGray

                $valueColor = @{}

                if ($entry.Key -eq 'Status') {
                    $valueColor.ForegroundColor = 'Yellow'
                }

                Write-Host $entry.Value @valueColor
            }

            Write-Host ''
            Write-Host 'DESCRIPTION' -ForegroundColor Green
            Write-Host $separator -ForegroundColor DarkGray

            if (-not [string]::IsNullOrWhiteSpace($description)) {
                Write-Host $description
            }
            else {
                Write-Host `
                    '(No description)' `
                    -ForegroundColor DarkGray
            }

            Write-Host ''
            Write-Host $separator -ForegroundColor DarkGray
            Write-Host ''
        }
        catch {
            Write-Error (
                "Unable to retrieve Jira ticket '$resolvedKey': " +
                $_.Exception.Message
            )
        }
    }
}

function jira {
    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory,
            Position = 0,
            ValueFromPipeline
        )]
        [ValidatePattern('^(?:[A-Za-z][A-Za-z0-9]+-)?\d+$')]
        [string]$Key
    )

    process {
        Get-JiraTicket -Key $Key
    }
}

# ----------------------------------------------------------------------------
# Git
# ----------------------------------------------------------------------------

function gs {
    git status @args
}

function gl {
    $arguments = @('pull') + $args

    Invoke-NativeCommand `
        -Command 'git' `
        -ArgumentList $arguments
}

function gp {
    $arguments = @('push') + $args

    Invoke-NativeCommand `
        -Command 'git' `
        -ArgumentList $arguments
}

function gcm {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string]$Message
    )

    Invoke-NativeCommand `
        -Command 'git' `
        -ArgumentList @(
            'commit'
            '-m'
            $Message
        )
}

# ----------------------------------------------------------------------------
# Utility
# ----------------------------------------------------------------------------

function reload {
    try {
        . $PROFILE

        Write-Host (
            "Profile reloaded: $PROFILE"
        ) -ForegroundColor Green
    }
    catch {
        Write-Host (
            "Profile failed to reload: $PROFILE"
        ) -ForegroundColor Red

        Write-Host (
            "Cause: $($_.Exception.Message)"
        ) -ForegroundColor Red

        Write-Host (
            $_.InvocationInfo.PositionMessage
        ) -ForegroundColor Yellow
    }
}

function editprofile {
    if (Test-Command -Name 'zed') {
        zed $PROFILE
    }
    elseif (Test-Command -Name 'code') {
        code $PROFILE
    }
    else {
        notepad.exe $PROFILE
    }
}

function which {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string]$Command
    )

    Get-Command -Name $Command -All |
        Select-Object `
            CommandType,
            Name,
            Version,
            Source,
            Definition
}

# ----------------------------------------------------------------------------
# Log Cleanup
# ----------------------------------------------------------------------------

function Clean-Log {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ValidateScript({
            if (-not (Test-Path -LiteralPath $_ -PathType Leaf)) {
                throw "File not found: $_"
            }

            return $true
        })]
        [string]$Path,

        [Parameter()]
        [string]$OutputPath,

        [Parameter()]
        [switch]$OnlyMatchingLines
    )

    $resolvedPath = (
        Resolve-Path -LiteralPath $Path
    ).Path

    if (-not $OutputPath) {
        $directory = Split-Path `
            -Path $resolvedPath `
            -Parent

        $name = [IO.Path]::GetFileNameWithoutExtension(
            $resolvedPath
        )

        $extension = [IO.Path]::GetExtension(
            $resolvedPath
        )

        $OutputPath = Join-Path `
            -Path $directory `
            -ChildPath "$name-clean$extension"
    }

    $pattern = '\[(?:Verbose|Information|Error)\]'

    Get-Content `
        -LiteralPath $resolvedPath `
        -ReadCount 5000 |
        ForEach-Object {
            foreach ($line in $_) {
                if ($line -match $pattern) {
                    $line -replace "^.*?(?=$pattern)"
                }
                elseif (-not $OnlyMatchingLines) {
                    $line
                }
            }
        } |
        Set-Content `
            -LiteralPath $OutputPath `
            -Encoding utf8

    Get-Item -LiteralPath $OutputPath
}

# ----------------------------------------------------------------------------
# Lazy Terminal Icons
# ----------------------------------------------------------------------------

function Import-TerminalIcons {
    # Attempt once per session; -ListAvailable rescans PSModulePath every call.
    if (-not $script:TerminalIconsAttempted) {
        $script:TerminalIconsAttempted = $true

        Import-Module `
            -Name Terminal-Icons `
            -ErrorAction SilentlyContinue
    }
}

function ll {
    Import-TerminalIcons
    Get-ChildItem @args
}

# ----------------------------------------------------------------------------
# Startup Diagnostics
# ----------------------------------------------------------------------------

$script:ProfileTimer.Stop()

if ($env:PROFILE_DEBUG -eq '1') {
    Write-Host (
        '[Profile] Loaded in {0:N0} ms' -f
        $script:ProfileTimer.Elapsed.TotalMilliseconds
    ) -ForegroundColor DarkGray
}
