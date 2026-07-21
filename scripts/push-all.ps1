$Root = Split-Path $PSScriptRoot -Parent

$repos = @(
    @{ Name = "khwab-all"; Path = $Root },
    @{ Name = "khwab"; Path = Join-Path $Root "khwab" },
    @{ Name = "khwab-core"; Path = Join-Path $Root "khwab-core" },
    @{ Name = "khwab-integration"; Path = Join-Path $Root "khwab-integration" }
)

Write-Host ""
Write-Host "========== PUSHING REPOSITORIES ==========" -ForegroundColor Cyan

foreach ($repo in $repos) {

    Write-Host ""
    Write-Host ">>> $($repo.Name)" -ForegroundColor Yellow

    if (!(Test-Path $repo.Path)) {
        Write-Host "Directory not found."
        continue
    }

    Push-Location $repo.Path

    if (!(Test-Path ".git")) {
        Write-Host "Not a Git repository."
        Pop-Location
        continue
    }

    $branch = git branch --show-current

    if ([string]::IsNullOrWhiteSpace($branch)) {
        Write-Host "Unable to determine current branch."
    }
    else {
        Write-Host "Pushing branch: $branch"
        git push origin $branch
    }

    Pop-Location
}

Write-Host ""
Write-Host "========== PUSH COMPLETE ==========" -ForegroundColor Green