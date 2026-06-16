param (
    [Parameter(Mandatory=$true)]
    [string]$ArtifactPath
)

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$emojiCross = [System.Char]::ConvertFromUtf32(0x274C)
$emojiCheck = [System.Char]::ConvertFromUtf32(0x2705)
$emojiTrash = [System.Char]::ConvertFromUtf32(0x1F5D1) + [char]0xFE0F
$emojiException = [System.Char]::ConvertFromUtf32(0x2755)

function Get-RepoFile {
    param (
        [string]$repoPath,
        [string]$fileName
    )
    
    # 1. Check root
    $rootFile = Join-Path $repoPath $fileName
    if (Test-Path $rootFile) {
        return $rootFile
    }
    
    # 2. Check src/ or folders starting with src
    $srcFolders = Get-ChildItem -Path $repoPath -Directory | Where-Object { $_.Name -like "src*" }
    $level1Files = @()
    foreach ($sf in $srcFolders) {
        $f = Join-Path $sf.FullName $fileName
        if (Test-Path $f) {
            $level1Files += $f
        }
    }
    if ($level1Files.Count -gt 0) {
        return $level1Files[0]
    }
    
    # 3. Check one level down under src/ folders
    $level2Files = @()
    foreach ($sf in $srcFolders) {
        $subdirs = Get-ChildItem -Path $sf.FullName -Directory
        foreach ($sd in $subdirs) {
            $f = Join-Path $sd.FullName $fileName
            if (Test-Path $f) {
                $level2Files += $f
            }
        }
    }
    if ($level2Files.Count -gt 0) {
        return $level2Files[0]
    }
    
    return $null
}

function Compare-Files {
    param (
        [string]$file1,
        [string]$file2
    )
    if ($null -eq $file1 -or $null -eq $file2) { return $false }
    if (-not (Test-Path $file1) -or -not (Test-Path $file2)) { return $false }
    
    # Compare content, ignoring line ending differences and leading/trailing whitespace
    $c1 = [System.IO.File]::ReadAllText($file1).Replace("`r`n", "`n").Trim()
    $c2 = [System.IO.File]::ReadAllText($file2).Replace("`r`n", "`n").Trim()
    return $c1 -eq $c2
}

# Find gld.config in home or profile directory
$configPath = Join-Path $HOME "gld.config"
if (-not (Test-Path $configPath)) {
    $configPath = Join-Path $env:USERPROFILE "gld.config"
}

if (-not (Test-Path $configPath)) {
    Write-Error "Could not locate gld.config in $HOME or $env:USERPROFILE"
    exit 1
}

$config = Get-Content $configPath | ConvertFrom-Json
$reportRows = @()
$ref = 1

foreach ($basepath in $config.repobasepaths) {
    # Check if directory exists
    if (-not (Test-Path $basepath)) {
        Write-Warning "Base path $basepath does not exist."
        continue
    }
    
    $subdirs = Get-ChildItem -Path $basepath -Directory
    # Sort repos alphabetically for a clean report
    $subdirs = $subdirs | Sort-Object Name
    foreach ($subdir in $subdirs) {
        $path = $subdir.FullName
        if (Test-Path "$path\.git") {
            Push-Location $path
            try {
                # 1. Git Fetch
                git fetch origin | Out-Null
                
                # Current and Default branches
                $currentBranch = (git branch --show-current)
                $remoteHeadRef = (git symbolic-ref refs/remotes/origin/HEAD -q)
                $defaultBranch = ""
                if ($remoteHeadRef -match "refs/remotes/origin/(.*)") {
                    $defaultBranch = $Matches[1]
                } else {
                    $remoteHeadRef = (git remote show origin | Select-String "HEAD branch")
                    if ($remoteHeadRef -match "HEAD branch:\s*(\S+)") {
                        $defaultBranch = $Matches[1]
                    }
                }
                
                # Uncommitted status
                $uncommittedCount = (git status --porcelain).Count
                if ($null -eq $uncommittedCount) { $uncommittedCount = 0 }
                
                # Ahead/Behind status
                $ahead = 0
                $behind = 0
                $hasUpstream = $false
                try {
                    $upstream = (git rev-parse --abbrev-ref "@{u}" -q 2>$null)
                    if ($upstream) {
                        $hasUpstream = $true
                        $ahead = [int](git rev-list --count "@{u}..HEAD")
                        $behind = [int](git rev-list --count "HEAD..@{u}")
                    }
                } catch {
                    # No upstream
                }
                
                # Pull check
                if ($uncommittedCount -eq 0 -and $behind -gt 0 -and $currentBranch -eq $defaultBranch) {
                    Write-Host "Pulling $path..."
                    git pull | Out-Null
                    # Recheck behind
                    $behind = [int](git rev-list --count "HEAD..@{u}")
                }
                
                # Determine status
                $gitStatus = "fine"
                if ($currentBranch -ne $defaultBranch) {
                    $gitStatus = "adrift"
                } elseif ($uncommittedCount -gt 0 -or $ahead -gt 0) {
                    $gitStatus = "dirty"
                }
                
                # 2. Common File Check
                # Locate common files to compare against in workspace root or primary files location
                # We assume they are in the directory of the repobasepath or workspace root
                $baseCommonPath = Split-Path $path -Parent
                $commonGitignore = Join-Path $baseCommonPath "common.gitignore"
                $commonEditorconfig = Join-Path $baseCommonPath "common.editorconfig"
                $commonNuget = Join-Path $baseCommonPath "common.nuget.config"
                
                # If they are not in parent, try disk folder if specified in primaryfiles
                if ($config.primaryfiles -and $config.primaryfiles.type -eq "disk") {
                    $commonGitignore = Join-Path $config.primaryfiles.folder "common.gitignore"
                    $commonEditorconfig = Join-Path $config.primaryfiles.folder "common.editorconfig"
                    $commonNuget = Join-Path $config.primaryfiles.folder "common.nuget.config"
                }
                
                $isAiToolbox = $subdir.Name -eq "ai-toolbox"
                
                $giFile = Get-RepoFile -repoPath $path -fileName ".gitignore"
                $ecFile = Get-RepoFile -repoPath $path -fileName ".editorconfig"
                $ngtFile = Get-RepoFile -repoPath $path -fileName "nuget.config"
                
                # GI Status
                $giStatus = $emojiTrash
                if ($giFile) {
                    $match = Compare-Files $giFile $commonGitignore
                    $giStatus = if ($match) { $emojiCheck } else { $emojiCross }
                }
                
                # EC Status
                $ecStatus = $emojiTrash
                if ($isAiToolbox) { $ecStatus = $emojiException }
                elseif ($ecFile) {
                    $match = Compare-Files $ecFile $commonEditorconfig
                    $ecStatus = if ($match) { $emojiCheck } else { $emojiCross }
                }
                
                # NGT Status
                $ngtStatus = $emojiTrash
                if ($isAiToolbox) { $ngtStatus = $emojiException }
                elseif ($ngtFile) {
                    $match = Compare-Files $ngtFile $commonNuget
                    $ngtStatus = if ($match) { $emojiCheck } else { $emojiCross }
                }
                
                # Check if all match or if outdated
                $allMatch = $true
                if ($giStatus -ne $emojiCheck) { $allMatch = $false }
                if ($ecStatus -ne $emojiCheck -and $ecStatus -ne $emojiException) { $allMatch = $false }
                if ($ngtStatus -ne $emojiCheck -and $ngtStatus -ne $emojiException) { $allMatch = $false }
                
                $commonFilesText = ""
                if ($allMatch) {
                    $commonFilesText = "correct"
                } else {
                    $commonFilesText = "outdated .gi$giStatus .ec$ecStatus .ngt$ngtStatus"
                }
                
                $reportRows += [PSCustomObject]@{
                    RepoName = $subdir.Name
                    CurrentStatus = $gitStatus
                    CommonFiles = $commonFilesText
                    Reference = $ref
                    FullPath = $path
                }
                $ref++
                
            } catch {
                Write-Host "Error checking $($subdir.Name): $_"
            }
            Pop-Location
        }
    }
}

# Generate Markdown
$md = "# GoodLittleDev Report`n`n"
$md += "| Repo Name | Current Status | Common Files | Reference | Full Path |`n"
$md += "| :--- | :--- | :--- | :--- | :--- |`n"
foreach ($row in $reportRows) {
    $md += "| $($row.RepoName) | $($row.CurrentStatus) | $($row.CommonFiles) | $($row.Reference) | $($row.FullPath) |`n"
}

# Ensure parent directory of output path exists
$parentDir = Split-Path $ArtifactPath -Parent
if ($parentDir -and -not (Test-Path $parentDir)) {
    New-Item -ItemType Directory -Path $parentDir -Force | Out-Null
}

[System.IO.File]::WriteAllText($ArtifactPath, $md, [System.Text.Encoding]::UTF8)
Write-Host "Report successfully generated at: $ArtifactPath"
