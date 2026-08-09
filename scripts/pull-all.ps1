. "$PSScriptRoot\common.ps1"

Write-Title "PULL WORKSPACE"

$Success = @()
$Skipped = @()
$Failed  = @()

foreach ($repo in Get-Repositories) {

    Write-Host ""
    Write-Host "==================================================" -ForegroundColor DarkGray
    Write-Host "Repository : $($repo.Name)" -ForegroundColor Yellow

    if (!(Test-Path $repo.Path)) {
        Write-ErrorMsg "Directory not found."
        $Failed += $repo.Name
        continue
    }

    Push-Location $repo.Path

    try {

        if (!(Test-Path ".git")) {
            Write-ErrorMsg "Not a Git repository."
            $Failed += $repo.Name
            continue
        }

        # Skip repositories with local changes
        $status = git status --porcelain

        if ($status) {
            Write-Warning "Local changes detected. Skipping."
            $Skipped += $repo.Name
            continue
        }

        # Detect default branch from origin
        $defaultBranch = git symbolic-ref refs/remotes/origin/HEAD 2>$null

        if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($defaultBranch)) {
            Write-ErrorMsg "Cannot determine default branch."
            $Failed += $repo.Name
            continue
        }

        $branch = $defaultBranch.Replace("refs/remotes/origin/", "").Trim()

        Write-Host "Branch : $branch"

        git switch $branch --quiet

        if ($LASTEXITCODE -ne 0) {
            Write-ErrorMsg "Failed to switch to branch '$branch'."
            $Failed += $repo.Name
            continue
        }

        git pull origin $branch

        if ($LASTEXITCODE -eq 0) {
            Write-Success "Pull successful."
            $Success += $repo.Name
        }
        else {
            Write-ErrorMsg "Pull failed."
            $Failed += $repo.Name
        }
    }
    catch {

        Write-ErrorMsg $_.Exception.Message
        $Failed += $repo.Name
    }
    finally {

        Pop-Location
    }
}

Write-Title "PULL SUMMARY"

Write-Host ""
Write-Host "Successful : $($Success.Count)" -ForegroundColor Green
foreach ($r in $Success) {
    Write-Host "  $r"
}

Write-Host ""
Write-Host "Skipped : $($Skipped.Count)" -ForegroundColor Yellow
foreach ($r in $Skipped) {
    Write-Host "  $r"
}

Write-Host ""
Write-Host "Failed : $($Failed.Count)" -ForegroundColor Red
foreach ($r in $Failed) {
    Write-Host "  $r"
}

Write-Host ""
Write-Success "Workspace pull complete."
