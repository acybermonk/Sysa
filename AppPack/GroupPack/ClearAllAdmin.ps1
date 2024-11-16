# Clear all extra admin users on System

param ([string]$System)

if (-not ($System -eq $null)){
    Write-Host "In Sub script $System"
}else{
    Write-Host "Sub script is null"
}

Pause