. "$PSScriptRoot\common.ps1"

Write-Title "ADDING CHANGES"

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
        Write-Warning "Nothing to add."
    }
    else {
        git add .

        if ($LASTEXITCODE -eq 0) {
            Write-Success "Changes added."
        }
        else {
            Write-ErrorMsg "git add failed."
        }
    }

    Pop-Location
}

Write-Host ""
Write-Success "Add operation complete."