. "$PSScriptRoot\common.ps1"

Write-Title "COMMIT CHANGES"

$CommitMessage = Read-Host "Enter commit message"

if ([string]::IsNullOrWhiteSpace($CommitMessage)) {
    Write-Warning "Commit cancelled."
    return
}

foreach ($repo in Get-Repositories) {

    Write-Host ""
    Write-Host "Repository : $($repo.Name)" -ForegroundColor Yellow

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

    $status = git status --porcelain

    if ([string]::IsNullOrWhiteSpace($status)) {
        Write-Warning "Nothing to commit."
        Pop-Location
        continue
    }

    git add .

    git commit -m "$CommitMessage"

    if ($LASTEXITCODE -eq 0) {
        Write-Success "Commit successful."
    }
    else {
        Write-ErrorMsg "Commit failed."
    }

    Pop-Location
}

Write-Host ""
Write-Success "Commit operation complete."