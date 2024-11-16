# Create Shorcut
Param (
    #[Parameter(Mandatory=$true)]
    [string]$Drive
)
if ($Drive -eq $null -or $Drive -eq ""){
    Write-Error -Message "No Drive Found"
}else{
    $LnkPath = "$env:HOMEDRIVE$env:HOMEPATH\Desktop\Sysa"
    $Target = "$Drive`:\Sysa\Sysa.exe"
    $HomePath = "$Drive`:\Sysa\Sysa"
    <#
    Write-Host "Drive  : $Drive"
    Write-Host "Link   : $LnkPath"
    Write-Host "Target : $Target"
    Pause
    #>
    
    New-Item -ItemType SymbolicLink -Path $LnkPath -Target $Target -Force -Confirm:$false
    if (-not (Test-Path -Path $HomePath)){
        New-Item -ItemType SymbolicLink -Path $HomePath -Target $Target -Force -Confirm:$false
    }
}