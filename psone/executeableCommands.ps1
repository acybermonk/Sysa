# Run to compile new executabes for Sysa : the admin utility
# Must have ps2exe module installed


# Check for ps2exe Module
$CurrModules = Get-Module -Name ps2exe | Select-Object -ExpandProperty Name
Write-Host "----------------------------------------" -ForegroundColor Yellow
Write-Host "Checking if 'ps2exe' is installed." -ForegroundColor Yellow
Start-Sleep -Seconds 1
if (-not ($CurrModules -eq "ps2exe")){
    try{
        Write-Host " * Importing Module" -ForegroundColor Yellow
        Import-Module ps2exe | Out-Null
        $CurrModules = Get-Module -Name ps2exe | Select-Object -ExpandProperty Name
        if ($CurrModules -eq "ps2exe"){
            Write-Host "   - Successfully imported module" -ForegroundColor Green
        }else{
            Write-Host "   - Failed importing module" -ForegroundColor Red
        }
    }catch{
        try{
            Write-Host " * Installing 'ps2exe'" -ForegroundColor Yellow
            Install-Module -Name ps2exe -Force -Confirm:$false -ErrorAction SilentlyContinue -WarningAction SilentlyContinue | Out-Null
            $CurrModules = Get-Module -Name ps2exe | Select-Object -ExpandProperty Name
            if ($CurrModules -eq "ps2exe"){
                Write-Host "    * Installed 'ps2exe'" -ForegroundColor Green
                # Import Module
                Write-Host " * Importing Module"
                Import-Module ps2exe | Out-Null
                $CurrModules = Get-Module -Name ps2exe | Select-Object -ExpandProperty Name
                if ($CurrModules -eq "ps2exe"){
                    Write-Host " * Module Confirmed"
                }
            }else{
                Write-Host "    * Failed installing 'ps2exe'" -ForegroundColor Red
            }
        }catch{
            Write-Host "    * Failed trying to install 'ps2exe'" -ForegroundColor Red
        }
    }
}else{
    Write-Host " * Module 'ps2exe' is installed and imported" -ForegroundColor Magenta
}
Write-Host "`n----------------------------------------`n----------------------------------------`n" -ForegroundColor Yellow

# App Info
    $appName = "Sysa"
    $ver = "2.2"
# Create Path
    $Drive = "C:"
    $HomePath = "$Drive\$appName"
    Write-Host $HomePath
# Icon
    $icoFilePath = "$HomePath\Imported\img\logo32.ico"
# Get Compile List for Executables 
    $CompileExeList = Get-ChildItem -Path "$HomePath\psone" -Exclude "executeableCommands.ps1","psone.in" -Force | Select-Object -Property FullName,Name,Basename

# Compile each member of list
Write-Host "Compile PS scripts to executables"
foreach ($file in $CompileExeList){
    $FileBaseName = $file.Basename
    $FileName = $file.Name
    $FilePath = $file.FullName
    Write-Host $FilePath
    Invoke-ps2exe -inputFile $FilePath -outputFile “$HomePath\$FileBaseName`.exe" -noConsole -title "Sysa" -version "2.2" -iconFile $icoFilePath -x64 -copyright "October 2024" -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
}