. "$PSScriptRoot\common.ps1"

Write-Title "PUSH WORKSPACE"

$Success = @()
$Skipped = @()
$Failed = @()

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

        # Refresh remote information
        git fetch origin --quiet 2>$null | Out-Null

        # Safe branch detection
        $branchOutput = git branch --show-current

        if ($null -eq $branchOutput) {
            $branch = ""
        }
        else {
            $branch = ($branchOutput | Out-String).Trim()
        }

        # Detached HEAD
        if ([string]::IsNullOrWhiteSpace($branch)) {

            Write-Warning "Detached HEAD detected."

            $remote = git for-each-ref `
                --format="%(refname:short)" `
                --contains HEAD `
                refs/remotes/origin

            if ($remote) {
                $branch = ($remote | Select-Object -First 1).Replace("origin/","")
                Write-Host "Resolved branch : $branch" -ForegroundColor Cyan
            }
            else {
                Write-Warning "Unable to determine branch. Skipping."
                $Skipped += $repo.Name
                continue
            }
        }

        Write-Host "Branch : $branch"

        $status = git status -sb

        if ($status -match "\[ahead") {

            Write-Host "Status : Ahead of remote"

            git push origin $branch

            if ($LASTEXITCODE -eq 0) {
                Write-Success "Push successful."
                $Success += $repo.Name
            }
            else {
                Write-ErrorMsg "Push failed."
                $Failed += $repo.Name
            }
        }
        else {

            Write-Warning "Nothing to push."
            $Skipped += $repo.Name
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

Write-Title "PUSH SUMMARY"

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
Write-Success "Workspace push complete."