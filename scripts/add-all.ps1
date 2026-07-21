$Root = Split-Path $PSScriptRoot -Parent

Write-Host "========== ADDING CHANGES ==========" -ForegroundColor Cyan

$repos = @(
    @{ Name = "khwab-all"; Path = $Root },
    @{ Name = "khwab"; Path = Join-Path $Root "khwab" },
    @{ Name = "khwab-core"; Path = Join-Path $Root "khwab-core" },
    @{ Name = "khwab-integration"; Path = Join-Path $Root "khwab-integration" }
)

foreach ($repo in $repos) {

    Write-Host ""
    Write-Host ">>> $($repo.Name)" -ForegroundColor Yellow

    if (Test-Path $repo.Path) {
        Push-Location $repo.Path

        if (Test-Path ".git") {
            git add .
            Write-Host "Added changes."
        }
        else {
            Write-Host "Not a Git repository."
        }

        Pop-Location
    }
    else {
        Write-Host "Directory not found: $($repo.Path)"
    }
}

Write-Host ""
Write-Host "========== DONE ==========" -ForegroundColor Green