$workspace = Split-Path $PSScriptRoot -Parent

Get-ChildItem $workspace -Directory | ForEach-Object {

    $repo = $_.FullName

    if (!(Test-Path "$repo\.git")) {
        return
    }

    Write-Host ""
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "Repository: $($_.Name)" -ForegroundColor Yellow
    Write-Host "=========================================" -ForegroundColor Cyan

    Push-Location $repo

    # Skip repositories with local changes
    $status = git status --porcelain

    if ($status) {
        Write-Host "Local changes detected. Skipping..." -ForegroundColor Red
        Pop-Location
        return
    }

    # Detect default branch from origin
    $defaultBranch = git symbolic-ref refs/remotes/origin/HEAD 2>$null

    if ($LASTEXITCODE -ne 0) {
        Write-Host "Cannot determine default branch." -ForegroundColor Red
        Pop-Location
        return
    }

    $branch = $defaultBranch.Replace("refs/remotes/origin/","")

    Write-Host "Default branch: $branch" -ForegroundColor Green

    git switch $branch

    if ($LASTEXITCODE -ne 0) {
        Write-Host "Failed to switch branch." -ForegroundColor Red
        Pop-Location
        return
    }

    git pull origin $branch

    Pop-Location
}

Write-Host ""
Write-Host "All repositories processed." -ForegroundColor Green