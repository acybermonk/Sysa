##############################################
#
#    Functionality    : ***** UNINSTALLER ****
#    -----------------------------------------
#    Application Name : Sysa - Uninstall 1.0 
#    Created by       : Daniel Krysty
#    Date started     : September 2024
#    Current as of    : November 2024
#
#
##############################################

# Variables
    $Drive = [System.Environment]::GetEnvironmentVariable('SysaDrive','User')
    $Found = $false
    $Global:FoundDrive = $null
    [System.Collections.ArrayList]$Alpha = @('A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z')
    $logpathdir = "$env:HOMEDRIVE\Sysa\Sysalogs"
    if (-not (Test-Path "$Drive\Sysa\Sysalogs")){
        if (-not (Test-Path $logpathdir)){
            # Make SysaDrive on Windows Drive for log
            $MakeDir = New-Item -Name "Sysa" -ItemType Directory -Path "$env:HOMEDRIVE" -Force -Confirm:$false | Out-Null
            $MakeLogDir = New-Item -Name "logs" -ItemType Directory -Path "$env:HOMEDRIVE\Sysa" -Force -Confirm:$false | Out-Null
        }
    }else{
        $logpathdir = "$Drive\Sysa\Sysalogs"
    }
    $logFile = "sysa.uninstall.log"
# Create Utility Log (Requires String i.e. [utilErr "log message"]
    function utilLog{
        Param ([string]$LogString)
        Add-Content "$logpathdir\$logFile" -Value $LogString
    }
    [bool]$err = $false
$unistConfirm = [Windows.Forms.MessageBox]::Show("Starting Uninstall for all SysaDrives, Files, Logs, and Loaded Packs?`nLog Found at '$logpathdir\$logFile' ","Sysa - Uninstall",[System.Windows.Forms.FormBorderStyle]::FixedSingle)
if ($unistConfirm -eq "OK"){
    # Start Log
        utilLog "#### Uninstall - Utility Started ####`n"
    # Find MyPack Packs and Unload
    # Removes all MyPack Loaded Packs every SysaDrive mounted on the drive
        utilLog "===== Checking for MyPack loaded Packs "
	    foreach($d in $Alpha){
            $removed = $false
            $d = $d.ToString()
            $Path = "$d`:\Sysa\AppPack\MyPack"
		    if (Test-Path "$Path\Pack"){
                $Found = $true
                utilLog "  * Utility found at $d and Checking Pack"
                # Try to unload pack
                    $LoadCheck = Get-ChildItem -Path "$Path\Pack"
                    if (-not ($LoadCheck.Count -eq $null -or $LoadCheck.Count -eq 0 -or $LoadCheck -eq $null)){
                        try{
                            utilLog "    - Pack Contains Contents"
                            $RemovePack = Remove-Item -Path "$Path\Pack" -Recurse -Force -Confirm:$false | Out-Null
                            $removed = $true
                            utilLog "      > Successfully unload Pack"
                        }catch{
                            utilLog "      > Failed unloading Pack"
                            Write-Error -Message "Failed unloading Pack"
                            $err = $true

                        }
                        # Try to prep pack
                        utilLog "    - Prep Pack"
                        if ($removed){
                            try{
                                $ReplacePack = New-Item -Name "Pack" -ItemType Directory -Path "$Path" -Force -Confirm:$false | Out-Null
                                utilLog "      > Successfully prepped Pack"
                            }catch{
                                utilLog "      > Failed prepping Pack"
                                Write-Error -Message "Failed prepping Pack"
                                $err = $true
                            }
                        }
                    }else{
                        utilLog "    - No Pack Loaded"
                    }

                    # Remove Shortcuts
                    $localBackupPath = "$d`:\Sysa\Sysa"
                    utilLog "    - Cheching for backup Shortcut link"
                    if ((Test-Path "$localBackupPath") -eq $true -or (Test-Path "$localBackupPath`.lnk") -eq $true){
                        utilLog "      > Removing local backup shortcut"
                        try{
                            Remove-Item -Path $localBackupPath -Force -Confirm:$false
                            utilLog "        >> Removed local backup shortcut"
                        }catch{
                            utilLog "        >> Failed removing local backup shortcut"
                            Write-Error -Message "Failed removing local backup shortcut"
                            $err = $true
                        }
                    }else{
                        utilLog "    > No local backup shortcut found"
                    }

		    }
	    }
    # Find SysaDrive and Remove
     utilLog "===== Check for SysaDrive"
        if (-not ($Drive -eq $null)){
            utilLog "  * Found SysaDrive"
            utilLog "    - Removing SysaDrive"
            [System.Environment]::SetEnvironmentVariable('SysaDrive','','User')
            if ([System.Environment]::GetEnvironmentVariable('SysaDrive','User') -eq $null){
                utilLog "      > Successfully removed SysaDrive"
            }else{
                utilLog "      > Failed removing SysaDrive"
                Write-Error -Message "Failed removing SysaDrive"
                $err = $true
            }
        }else{
            utilLog "  * No SysaDrive found"
            if ($Found -eq $false){
                utilLog "    - No SysaDrive Options"
                [Windows.Forms.MessageBox]::Show("No SysaDrive. No Packs.","Error") | Out-Null
                $err = $true
            }
        }

    # Set Global: Variables to null
        utilLog "===== Removing all variables for SysaDrive"
        utilLog "  * Starting  to set variables to null"
        $Global:ImgIcon =
        $Global:LogImage =
	    $Global:AppName = 
	    $Global:AppVer = 
        $Global:Copyright = 
        $Global:CpDate = 
        $Global:ErrorCodeLogLocation =
        $Drive =
        $Alpha =
        $Global:LogImage =
        $Global:FoundDrive =
        $Global:SelectDrivePath =
        $ps =
        $Path =
        $Global:Title =
	    $Global:StartPath = 
	    $Global:AppPackPath = 
	    $Global:ImportedPath = 
        $Global:LoopPath = 
	    $Global:DefaultTogleColorRed =
	    $Global:DefaultTogleColorGreen =
        $Global:DefaultColorWhite =
        $Global:DefaultColorBlack =
        $Global:DefaultColor1_GroupFileLabel =
        $Global:DefaultColor2_GroupFileLabel =
	    $Global:DefaultFont9 =
	    $Global:DefaultFont10 =
	    $Global:DefaultFont10Bold =
	    $Global:DefaultFont11 =
	    $Global:DefaultFont10Underline =
	    $Global:DefaultFont12 =
	    $Global:DefaultColor1 =
	    $Global:DefaultColor2 =
		$Global:SystemName =
		$Global:User =
        $Global:FullDateTime =
        $Global:Date =
        $Global:LogDate =
		$Global:SavedLogLocation =
        $Global:SessionLogLocation =
		$Global:LogShow =
		$Global:ErrorCodeVal =
		$Global:ErrorMsg =
        $Global:ProccessName =
        $Global:ProcessCompleted =
        $Global:Started =
        $Global:MyFile =
        $Global:GroupFile_Selected =
        $Global:GroupFile_SelectedPath =
        $Global:LoopOption =
        $Global:LoopLogPath =
        $Global:SessionMode =
        $Global:GroupFileOptions =
        $Global:GroupFileCount =
        $t =
        $n =
        $Extension =
        $Global:GroupFile_RunType =
        $Global:SessionStart =
        $Global:ScriptSelect =
        $FileName =
        $Global:MyPackSelect =
        $Global:Imported =
        $Global:MyPackSelectCount =
        $Global:MyPackPath
        $Global:MyPack_Packs =
        $Global:MyPackLoad =
        $tempName =
        $checkSpace =
        $foundIndex =
        $Type =
        $PreReq_Action =
        $PreReq_Script =
        $PreReq_Username =
        $PreReq_System =
        $CombinationRun =
        $Action =
        $Script =
        $userchk =
        $syschk =
        $RunType =
        $CombinationRun =
        $Username =
        $System =
        $scriptPath =
        $comboRun =
        $comboRunErr =
        $userRun =
        $userRunErr =
        $systemRun =
        $systemRunErr =
        $Global:GroupFileFormat =
        $Global:GroupFile_Selected =
        $Global:GroupFile_SelectedPath =
        $MyFileName =
        $Global:SessionImportedFile =
        $Global:GroupFile_RunType =
        $GroupFileEdit =
        $Global:GroupFileScriptCount =
        $FileList =
        $PreReq_Script =
        $PreReq_FileImported =
        $PreReq_LoopCheck =
        $GroupScript_Selected =
        $SubScriptPath =
        $FileExt =
        $FileDirPath = 
        $Found =
        $log = $null
        $Global:info = $null
        utilLog "    - Successfully set variables to null"

    # Close all open/active Sysa Util
        $process = Get-Process -ProcessName Sysa -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
        utilLog "===== Closing all open SysaDrive sessions"
        if (-not ($process -eq $null)){
            utilLog "  * Found open Sysa App"
            Get-Process -ProcessName Sysa | Stop-Process -Force -Confirm:$false
            Start-Sleep -Seconds 2
            function checkForOpen{
                $process = Get-Process -ProcessName Sysa -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
                if ($process -eq $null){
                    utilLog "    - Successfully closed open utility"
                }else{
                    utilLog "    - Failed closing open utility"
                    Write-Error -Message "Failed closing open utility"
                    $err = $true
                }
            }
            checkForOpen
        }else{
            utilLog "  * No open Sysa App found"
        }
    # check for shortcut
        # Desktop
        utilLog "===== Cheching for Desktop shortcut link"
        $LnkPath = "$env:HOMEDRIVE$env:HOMEPATH\Desktop\Sysa"
        if ((Test-Path "$LnkPath") -eq $true -or (Test-Path "$LnkPath`.lnk") -eq $true){
            utilLog "  * Removing Desktop shortcut"
            Remove-Item -Path $LnkPath -Force -Confirm:$false -ErrorAction SilentlyContinue -WarningAction SilentlyContinue | Out-Null
            if (-not (Test-Path $LnkPath)){
                utilLog "    - Successfully removed Desktop shortcut"
            }else{
                utilLog "    - Failed removing Desktop shortcut"
                Write-Error -Message "Failed at removong logfile"
                $err = $true
            }
        }else{
            utilLog " * No Desktop shortcut found"
        }
    # Remove Files Directory and contents recursively
        utilLog "===== Checking for Files directory"
        if (Test-Path "$Dive\Sysa\Files"){
            utilLog "  * Found Files directory"
            Remove-Item -Path "$Dive\Sysa\Files" -Recurse -Force -Confirm:$false -ErrorAction SilentlyContinue -WarningAction SilentlyContinue | Out-Null
            if (-not (Test-Path "$Dive\Sysa\Files")){
                utilLog "    - Successfully removed Files directory"
            }else{
                utilLog "    - Failed removing Files directory"
                $err = $true
            }
        }else{
            utilLog "  * No Files directory found"
        }
    # Copy and Remove logs All logs (Copy log dirs to a central log dir on main dir, compress dir, remove non compressed dir, make zip hidden)
        utilLog "===== Cheching for Desktop shortcut link"
        $AllLogPaths = Get-ChildItem -Path "$Dive\Sysa" -Exclude sysa.uninstall.log -Recurse -Include *.log, *.slog, *.errlog -ErrorAction SilentlyContinue | Select-Object -Property FullName,Name -ErrorAction SilentlyContinue
        if (-not ($AllLogPaths -eq $null)){
            utilLog "  * Logs Found"
            foreach ($log in $AllLogPaths){
                $logname = $log.Name
                $logpath = $log.FullName
                utilLog "    - Removing '$logname'"
                Remove-Item -Path $logpath -Force -Confirm:$false -ErrorAction SilentlyContinue -WarningAction SilentlyContinue | Out-Null
                if (-not (Test-Path $logpath)){
                    utilLog "      > Successfully removed $logname"
                }else{
                    utilLog "      > Failed removing $logname"
                    Write-Error -Message "Failed removing $logname"
                    $err = $true
                }
            }
        }else{
            utilLog "  * No logs found"
        }
    # End Log
        utilLog "##### Uninstall - Utility Completed #####"
        utilLog "-----------------------------------------"
    # Notify Complete
    if ($err){
        $completeNotify = [Windows.Forms.MessageBox]::Show("Uninstall completed with errors. Check lo; -- ($logpathdir\$logFile)","Sysa - Uninstall",[System.Windows.Forms.MessageBoxButtons]::OK)
    }else{
        $completeNotify = [Windows.Forms.MessageBox]::Show("Uninstall completed","Sysa - Uninstall",[System.Windows.Forms.MessageBoxButtons]::OK)
    }
}