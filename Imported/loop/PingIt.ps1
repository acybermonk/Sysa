<#
Writen by cybermonk
Copyright 09/2004

Ping it
Get contents of computers to Ping

#>

param ([string]$SubScriptPath,[string]$GroupFile_SelectedFilePath,[string]$FileName,[string]$Process,[string]$loopOption)
    $PSCommandPath
    Write-Host "Script           : $SubScriptPath"
    Write-Host "GroupFile Path   : $GroupFile_SelectedFilePath"
    Write-Host "GroupFile Name   : $FileName"
    Write-Host "Process          : $Process"
    Write-Host "LoopOption       : $loopOption"
    Pause

# Set strict Mode
Set-StrictMode -Version Latest

function TestPath{
    # Test Path Permissions
    if (Test-Path -Path $Global:Path){
        $Global:pathCheck = $true
        LocalLogWrite "        Path :: $Global:Path :: $Global:pathCheck"
        Set-Location -Path $Global:Path
        Write-Output("       Path Set:   True")
    }
}

function CheckADM{
    # Check users ADM access in local group
    $Global:username = whoami
    $Global:username = $Global:username -split "\\"
    $Global:username = $Global:username[1]
    [System.Collections.ArrayList]$Global:rights = @(Get-LocalGroupMember -Name 'Administrators' | select -Property Name)
    $Global:rights = $Global:rights.Name
    foreach ($u in $Global:rights){
        $u = $u.ToString()
        $uSplit = $u -split "\\"
        $approvedUser = $uSplit[1]
        if ($approvedUser -eq $Global:username){
            $Global:access = $true
        }
    }
    LocalLogWrite "    ADM Accesss :: $Global:username :: $Global:access" 
    Write-Output("    ADM Accesss:   " + $Global:access)
}

function GetDateNow{
    $Global:date = Get-Date -DisplayHint Date
}

function LocalLogWrite{
    Param ([string]$logString)
    Add-Content $Global:localLog -Value $logString
}

function DisplayHeader{
    # Write Title
    Write-Host -ForegroundColor Magenta "========================================"
    Write-Host -ForegroundColor Magenta "Data Pulled from $FileName"
    Write-Host -ForegroundColor Magenta "----------------------------------------"
    Write-Host -ForegroundColor Magenta "  Username : $Global:username"
    Write-Host -ForegroundColor Magenta "----------------------------------------"
    Write-host -ForegroundColor Magenta "  Attempts : $Global:tryCount"
    Write-Host -ForegroundColor Magenta "========================================"
}

function FoundIt{
    Write-Output("_____")
    Write-Host -ForegroundColor DarkGreen "Removing"
    foreach ($d in $Global:found){
        Write-Host -ForegroundColor DarkGreen "$d"
        LocalLogWrite "Removing : $d"
        $Global:c += 1
        $out = Get-Content $GroupFile_SelectedFilePath | Select-String -Pattern $d -NotMatch
        Set-Content -Path $GroupFile_SelectedFilePath -Value $out
    }
    Write-Output("..")
    if ($Global:c -ne 0){
        Write-Output("Remove Count : ${Global:c}")
    }
    Write-Output("_____")
    LocalLogWrite "*----------------------------------------*"
}

function ReRun{
    $Global:tryCount = $Global:tryCount - 1
    if ($Global:tryCount -gt 0){
        $Global:dataCount = $Global:dataCount - $Global:c
        if ($Global:dataCount -ge 1){
            Write-Host -ForegroundColor Magenta "Attempts remaining : ${Global:tryCount}"
            Write-Host -ForegroundColor Magenta "*----------------------------------------*"
            [System.Collections.ArrayList]$Global:found = @()
            $Global:c = 0
            $data = $null
            $dataSplit = $null
            $system = $null
            $user = $null
            $group = $null
            $pingCheck = $null
            $errResult = $null
            $minutes = $Global:sleep / 60
            Write-Host -ForegroundColor Magenta "Sleep for ${minutes} Please wait..."
            write-Host -ForegroundColor DarkRed "(Press CTRL + C to exit)"
            Start-Sleep -Seconds $Global:sleep 
            doIt
        }else{
            Write-Output("**COMPLETED RE-RUN DATA**")
            LocalLogWrite "**COMPLETED RE-RUN DATA**"
            LocalLogWrite "*========================================*"
            LocalLogWrite "*========================================*"
            Pause
            Exit
        }
    }else{
        Write-Output("*COMPLETED ALL ATTEMPTS*")
        LocalLogWrite "*COMPLETED ALL ATTEMPTS*"
        LocalLogWrite "*========================================*"
        LocalLogWrite "*========================================*"
        Pause
        Exit
    }
}

function doIt{
# Check for Run Options
# Final Run
    if ($Global:finalRun){
        Write-Host "Final Run Initiated"
        LocalLogWrite "Final Run Initiated"
    }
#Initial Run
    if ($Global:initRun){
        GetDateNow
        LocalLogWrite "Starting Auto Run : $Global:date"
        Write-Host -ForegroundColor Magenta "Starting Auto Run : $Global:date"
        $Global:initRun = $false
    }else{
        GetDateNow
        LocalLogWrite "Looping Re-Run : $Global:date"
        Write-Host -ForegroundColor Magenta "Looping Re-Run : $Global:date"
        $Global:DataList = @()
    }
    $list = Get-Content $GroupFile_SelectedFilePath -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
    if ($list -ne $null){
        foreach ($value in $list){
            $Global:DataList += $value
        }
    }else{
            Write-Output("**NO DATA**")
            LocalLogWrite "**NO DATA**"
            LocalLogWrite "*========================================*"
            LocalLogWrite "*========================================*"
            Pause
            Exit
    }
    Pause
<#&&&#>

    if ($Global:DataList.length -ge 1){
        Write-Host "GE 1"
        Pause
        try{
            $Global:dataCount = $Global:DataList.Count
        }catch{
            if ($Global:dataCount -eq $null){
                $Global:finalRun = $true
                $Global:dataCount = 1
            }
        }
        <#
        if ($Global:dataCount -eq $null){
            $Global:finalRun = $true
            $Global:dataCount = 1
        }
        #>
    }else{
        Write-Host "LT 1"
        Pause
        if ($Global:initRun){
            Write-Output("**NO DATA**")
            LocalLogWrite "**NO DATA**"
            LocalLogWrite "*========================================*"
            LocalLogWrite "*========================================*"
            Pause
            Exit
        }else{
            Write-Output("**COMPLETED ALL DATA**")
            LocalLogWrite "**COMPLETED ALL DATA**"
            LocalLogWrite "*========================================*"
            LocalLogWrite "*========================================*"
            Exit
        }
    }
    Write-Host -ForegroundColor Magenta "Systems remaining $Global:dataCount"
    LocalLogWrite "Systems remaining $Global:dataCount"
    # Loop through list
    foreach ($data in $Global:DataList){
        #[console]::Beep(500,500)
        # Convert data to strings
        $data = $data.toString()
        $dataSplit = $data -split ";"
        $system = $dataSplit[0]
        try{
            $user = $dataSplit[1]
            $system = $dataSplit[0]
        }catch{
            try{
                if ($Process -eq "user"){
                    $user = $dataSplit[0]
                }elseif ($Process -eq "system"){
                    $system = $dataSplit[0]
                }
            }catch{
                $user = $null
                $system = $null
            }
        }
        try{
            $group = $dataSplit[2]
        }catch{
            $group = $null
        }
<#
        if (($system).ToLower() -eq "system"){
            $Global:indivGroupFile = "user"
        }elseif(($user).ToLower() -eq "user"){
            $Global:indivGroupFile = "system"
        }else{
            $Global:indivGroupFile = ""
        }
#>
        # Ping it
        $pingCheck = ping $system -n 1
        if ($pingCheck -like "Reply*"){
            Write-Host "$system is Online"
            try{
                # Run cmd or bat script
                $runPath = "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
                GetDateNow

# ADD CODEC REFERENCE VS HARD CODED
                if ($Process -eq "system"){
                    Write-Host -ForegroundColor DarkGreen "  **Running Process $FileName : $Global:date : SYSTEM $system"
                    LocalLogWrite "Running Process $FileName : $Global:date : SYSTEM $system"
                    $sResult = Start-Process -Wait -PassThru -FilePath $runPath -Verb RunAs -ArgumentList $SubScriptPath,$system
                }elseif ($Process -eq "user"){
                    Write-Host -ForegroundColor DarkGreen "  **Running Process $FileName : $Global:date : USER $user"
                    LocalLogWrite "Running Process $FileName : $Global:date : USER $user"
                    $sResult = Start-Process -Wait -PassThru -FilePath $runPath -Verb RunAs -ArgumentList $SubScriptPath,$user
                }elseif ($Process -eq "combo"){
                    Write-Host -ForegroundColor DarkGreen "  **Running Process $FileName : $Global:date : SYSTEM $system : USER $user"
                    LocalLogWrite "Running Process $FileName : $Global:date : SYSTEM $system : USER $user"
                    $sResult = Start-Process -Wait -PassThru -FilePath $runPath -Verb RunAs -ArgumentList $SubScriptPath,$system,$user
                }elseif ($Process -eq "comboWithGroup"){
                    Write-Host -ForegroundColor DarkGreen "  **Running Process $FileName : $Global:date : SYSTEM $system : USER $user : GROUP $group"
                    LocalLogWrite "Running Process $FileName : $Global:date : SYSTEM $system : USER $user : GROUP $group"
                    $sResult = Start-Process -Wait -PassThru -FilePath $runPath -Verb RunAs -ArgumentList $SubScriptPath,$system,$user,$group
                }
                $errResult = Write-Output($sResult.exitcode)
                #$errResult = $LASTEXITCODE
                LocalLogWrite "ExitCode $errResult"
                LocalLogWrite "*---------------------------------*"
                if ($Process -eq "system"){
                    Write-Host -ForegroundColor DarkGreen "  **Processed script : $FileName, Completed on stystem : $system"
                }elseif($Process -eq "user"){
                    Write-Host -ForegroundColor DarkGreen "  **Processed script : $FileName, Completed on user : $user"
                }elseif($Process -eq "combo"){
                    Write-Host -ForegroundColor DarkGreen "  **Processed script : $FileName, Completed on system : $system; Proccessing user : $user, group : $group"
                }elseif($Process -eq "comboWithGroup"){
                    Write-Host -ForegroundColor DarkGreen "  **Processed script : $FileName, Completed on user : $user"
                }
                LocalLogWrite "Process $FileName Completed : on $system"
                $Global:found.Add("$data") | Out-Null
            }catch{
                Write-Error "  **Process $FileName Failed : on $system"
                LocalLogWrite "Process $FileName Failed : on $system"
            }
        }elseif ($pingCheck -like "Request timed out*"){
            Write-Output("$system Cannot Ping")
        }elseif ($pingCheck -like "Ping request could not find host*"){
            Write-Output("$system is Offline")
        }elseif ($pingCheck -like "Destination host unreachable*"){
            Write-Output("$system is Unreachable")
        }else{
            Write-Output("$system Unknown Value Error")
            Write-Output("$PINGCHECK : $pingCheck") 
        }
    }
    if ($Global:found.Count -ge 1){
        FoundIt
    }
    if ($loopOption -eq "loop"){
        ReRun
    }elseif ($loopOption -eq "noloop"){
        $checkEndData = Get-Content $GroupFile_SelectedFilePath
        if ($checkEndData -eq "" -or $checkEndData -eq $null ){
            LocalLogWrite "ALL DATA PROCESSED AND COMPLETED"
        }else{
            LocalLogWrite "ALL DATA PROCESSED : CHECK FILE FOR INCOMPLETE DATA"
            LocalLogWrite "REMAINING DATA DID NOT RUN IN SCRIPT"
        }
    }

}

# Specify variables
$Drive = [System.Environment]::GetEnvironmentVariable('SysaDrive','User')
$Global:Path = "$Drive\Sysa"
$Global:localLog = "$Global:Path\Imported\loop\PingIt\PingAutoLog.log"
[System.Collections.ArrayList]$Global:found = @()
$removeCount = 0
$Global:tryCount = 288 # 24hrs
$Global:sleep = 300 # 5 minutes
$Global:dataCount = 0
[System.Collections.ArrayList]$Global:DataList = @()
$Global:pathCheck = $false
$Global:access = $false
$Global:initRun = $true
$Global:finalRun = $false
$Global:c = 0

# PreReq Check
Write-Host "`n*========================================*" -ForegroundColor Yellow
LocalLogWrite "*========================================*"
Write-Host "        Test PreReqs" -ForegroundColor Yellow
Write-Host "*========================================*" -ForegroundColor Yellow
LocalLogWrite "*========================================*"
LocalLogWrite "Test PreReqs"
TestPath
CheckADM
Write-Host "*========================================*`n" -ForegroundColor Yellow
LocalLogWrite "*========================================*"

# Show Header
DisplayHeader
Pause
# Start Main Functions
if ($Global:pathCheck -and $Global:access){
    Write-Host "In Do it"
    Pause
    doIt
}elseif($Global:access){
    Write-Error -Message "ACCESS DENIED: user does not have permissions to access path." -Category PermissionDenied
    Pause
    Exit
}elseif($Global:access){
    Write-Error -Message "ACCESS DENIED: user needs elevated rights to run script." -Category SecurityError
    Pause
    Exit
}else{
    Write-Error -Message "ACCESS DENIED: user does not have permissions to access path." -Category PermissionDenied
    Write-Error -Message "ACCESS DENIED: user needs elevated rights to run script." -Category SecurityError
    Pause    
    Exit
}