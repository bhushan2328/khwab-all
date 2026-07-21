function Get-Repositories {

    $Root = Split-Path $PSScriptRoot -Parent

    @(
        @{ Name="khwab-all"; Path=$Root }
        @{ Name="khwab"; Path=(Join-Path $Root "khwab") }
        @{ Name="khwab-core"; Path=(Join-Path $Root "khwab-core") }
        @{ Name="khwab-integration"; Path=(Join-Path $Root "khwab-integration") }
    )
}

function Get-CurrentBranch {

    $branch = git symbolic-ref --short HEAD 2>$null

    if([string]::IsNullOrWhiteSpace($branch)){
        return "(detached)"
    }

    return $branch.Trim()
}

function Write-Title($text){

    Write-Host ""
    Write-Host "==================================================" -ForegroundColor Cyan
    Write-Host $text -ForegroundColor Cyan
    Write-Host "==================================================" -ForegroundColor Cyan
}

function Write-Success($text){
    Write-Host "[OK] $text" -ForegroundColor Green
}

function Write-Warning($text){
    Write-Host "[WARN] $text" -ForegroundColor Yellow
}

function Write-ErrorMsg($text){
    Write-Host "[ERROR] $text" -ForegroundColor Red
}