$Root = Split-Path $PSScriptRoot -Parent

$CommitMessage = Read-Host "Enter commit message"

if ([string]::IsNullOrWhiteSpace($CommitMessage)) {
    Write-Host "Commit cancelled."
    exit
}

$repos = @(
    @{ Name = "khwab-all"; Path = $Root },
    @{ Name = "khwab"; Path = Join-Path $Root "khwab" },
    @{ Name = "khwab-core"; Path = Join-Path $Root "khwab-core" },
    @{ Name = "khwab-integration"; Path = Join-Path $Root "khwab-integration" }
)

Write-Host ""
Write-Host "========== COMMITTING ==========" -ForegroundColor Cyan

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

    git add .

    $status = git status --porcelain

    if ([string]::IsNullOrWhiteSpace($status)) {
        Write-Host "No changes to commit."
    }
    else {
        git commit -m "$CommitMessage"
    }

    Pop-Location
}

Write-Host ""
Write-Host "========== COMMIT COMPLETE ==========" -ForegroundColor Green