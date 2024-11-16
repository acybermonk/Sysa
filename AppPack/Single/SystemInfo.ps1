###############################################################################################
###############################################################################################
###############################################################################################


# Description
# SystemInfo Script

# *(required)
# Input Parameters*
    param(
        [parameter(Mandatory)]
        [string]$runType,[string]$actionType,[string]$cn
    )
# App Variables (Updated)
    $Global:AppName = "Sysa"
    $Global:AppVer = "2.2"
    $Global:Copyright = [System.Net.WebUtility]::HtmlDecode("&#169;")
    $Global:CpDate = "Oct. 2024"
# Variables
    $Global:PreReqCheck_Type = $false
    $Global:PreReqCheck_Action = $false
    $Global:Override = $false
    $Global:ReturnErrMessage = "0"
    $Global:Type = "System"    
# Variables (local)
    $outfile = "cpdata.txt"
    $drive = $env:SystemDrive
    $path = "$drive\temp"
    $fullpath = "$path\$outfile"
    [string]$Global:info = $null
# Date and Log location
    $date = Get-Date -Format yyyy-MM-dd
    $loglocation = "$Drive\Sysa\AppPack\Single\logs\${date}_SystemInfo.log"
# LocalLogWrite Function*
    function localLogWrite{
        Param ([string]$LogString)
        Add-Content $loglocation -Value $LogString
    }

# Header
###############################################################################################
    Write-Host "RunType : $runType"
    Write-Host "Action  : $actionType"
    Write-Host "System    : $cn" 
    Write-Host "*---------------------*"
    Write-Host ""
###############################################################################################
###############################################################################################
###############################################################################################

# Check PreReqs
###############################################################################################

# Run Type Options
function checkType{
    if ($runType -eq "System"){
       $Global:PreReqCheck_Type = $true 
    }else{
        $Global:PreReqCheck_Type = $false
    }
    #Write-Host "    Completed Type Check"
}

# Action Options
function checkAction{
    if ($actionType -eq "Check"){
        $Global:PreReqCheck_Action = $true
    }else{
        $Global:PreReqCheck_Action = $false
    }
    #Write-Host "    Completed Action Check"
}

###############################################################################################
###############################################################################################
###############################################################################################

# Main Functions
###############################################################################################

# Get Info
function checkSysData{
    if ($cn -eq "local"){
        Write-Host "Checking Local PC"
        if (-not (Test-Path $path)){
            Write-Host "No Temp Directory Found"
            # Make TempFile Directory
            Write-Host "Creating temp Directory"
            $NEWDIR = New-Item -ItemType Directory -Path "$drive\" -Name "temp"
            Write-Host "Gathering Data..."
            $Global:info = Get-ComputerInfo -Property BiosBIOSVersion,BiosStatus,BiosCharacteristics,
                BiosSeralNumber,CsManufacturer,CsModel,CsDomain,CsName,OsRegisteredUser,
                OsName,OSDisplayVersion,OsVersion,OsHotFixes,OsLastBootUpTime,OsUptime,
                OsLocalDateTime
        }else{
            Write-Host "Temp Directory Found"
            Write-Host "Gathering Data..."
            $Global:info = Get-ComputerInfo -Property BiosBIOSVersion,BiosStatus,BiosCharacteristics,
                BiosSeralNumber,CsManufacturer,CsModel,CsDomain,CsName,OsRegisteredUser,
                OsName,OSDisplayVersion,OsVersion,OsHotFixes,OsLastBootUpTime,OsUptime,
                OsLocalDateTime
        }
    }else{
        Write-Host "Gathering Data from Remote System : $cn"
        $Global:info = Invoke-Command -ComputerName $cn -ScriptBlock {
            Get-ComputerInfo -Property BiosBIOSVersion,BiosStatus,BiosCharacteristics,
            BiosSeralNumber,CsManufacturer,CsModel,CsDomain,CsName,OsRegisteredUser,
            OsName,OSDisplayVersion,OsVersion,OsHotFixes,OsLastBootUpTime,OsUptime,
            OsLocalDateTime
        } -ErrorAction SilentlyContinue
        if ($Global:info -eq $null -or $Global:info -eq ""){
            Write-Error -Message "Failed to run on Remote system" -Category ConnectionError
            Pause
            Exit
        }
    }
}

function runScript{
    if ($Global:PreReqCheck_Type -eq $true -and $Global:PreReqCheck_Action -eq $true){
        Write-Host "**Testing Connection**"
        [bool]$pingCheck = Test-Connection -ComputerName $cn -ErrorAction SilentlyContinue
        #$p = ping $cn -n 1 

        if ($cn -eq "LOCAL"){
            $Global:Override = $true
        }

        if ($pingCheck -eq $false -and $cn -ne "LOCAL"){
            $Global:ReturnErrMessage = "Connection not found on $cn"
        }else{
            Write-Host "Connection Established"
            if ($PreReqCheck_Type -eq $true){
                if ($PreReqCheck_Action -eq $true){
                    # Call Function
                    checkSysData
                    #Write-Host "data checked"
                    #Pause
                    if (-not ([string]::IsNullOrEmpty($Global:info))){
                        if (-not ([string]::IsNullOrWhiteSpace($Global:info))){
                            if ($Global:info -ne ""){
                                #Write-Host "info checked"
                                #Pause
                                if (Test-Path $fullpath){
                                    Write-Host "Updating File"
                                    Remove-Item -Path $fullpath -Recurse -Force -Confirm:$false
                                    $NEWFILE = New-Item -ItemType File -Path $path -Name $outfile -Force -Confirm:$false
                                }else{
                                    Write-Host "Creating New File"
                                    $NEWFILE = New-Item -ItemType File -Path $path -Name $outfile -Force -Confirm:$false
                                }
                                Set-ItemProperty -Path $fullpath -Name "Attributes" -Value "Hidden"
                                if ($cn -eq "LOCAL"){
                                    $text = $Global:info.Substring(2)
                                    $text = $text.Substring(0, $text.Length - 2)
                                    localLogWrite $text
                                    $textGroup = $text -split '; ' # based on being delimited by '; '
                                    foreach ($g in $textGroup){
                                        Add-Content -Path $fullpath -Value $g -Force -Confirm:$false
                                    }                                    
                                    if (Test-Path $fullpath){
                                        Write-Host "File creation successful : $fullpath"
                                    }else{
                                        $Global:ReturnErrMessage = "File does not exist"
                                        localLogWrite = "File does not exist"
                                    }
                                }else{
                                    Write-Host $Global:info
                                }
                            }
                        }
                    }
                }else{
                    $Global:ReturnErrMessage = "ERR: Wrong ActionType"
                    localLogWrite "ERR: Wrong ActionType $actionType"
                }
            }else{
                $Global:ReturnErrMessage = "Processing $runType in $Global:Type Script"
                localLogWrite "ERR: Wrong RunType $runType"
            }
        }
    }else{
        $Global:ReturnErrMessage = "Failed PreReq Check" 
        Start-Sleep -Seconds 1
    }
}

###############################################################################################
###############################################################################################
###############################################################################################

# START
###############################################################################################

    checkType
    checkAction
    runScript
# Display Output*
    Write-Host "ErrorCode : ${Global:ReturnErrMessage}"
    Write-Host ""
    if ($Global:ReturnErrMessage -ne "0"){
        localLogWrite "ErrorCode : $Global:ReturnErrMessage"
        localLogWrite "*************************************"
        localLogWrite ""
    }
# Wait to Close
    Pause 
# End*
    Exit
###############################################################################################
###############################################################################################
###############################################################################################


# Remote System
#Invoke-Command -ComputerName $data -ScriptBlock {getSysData}


#if ($p -match "*Ping request could not find host*") {Write-Host "yessss"}