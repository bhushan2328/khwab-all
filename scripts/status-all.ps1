. "$PSScriptRoot\common.ps1"

Write-Title "KHWAB WORKSPACE STATUS"

foreach ($repo in Get-Repositories) {

    Write-Host ""
    Write-Host "Repository : $($repo.Name)" -ForegroundColor Yellow
    Write-Host "Path       : $($repo.Path)"

    if (!(Test-Path $repo.Path)) {
        Write-ErrorMsg "Directory not found."
        continue
    }

    Push-Location $repo.Path

    if (!(Test-Path ".git")) {
        Write-ErrorMsg "Not a Git repository."
        Pop-Location
        continue
    }

    $branch = Get-CurrentBranch
    $commit = git rev-parse --short HEAD
    $status = git status --short

    Write-Host "Branch     : $branch"
    Write-Host "Commit     : $commit"

    if ([string]::IsNullOrWhiteSpace($status)) {
        Write-Success "Working tree clean"
    }
    else {
        Write-Warning "Working tree has changes"
        Write-Host ""
        $status
    }

    Pop-Location
}

Write-Host ""
Write-Success "Status check complete."