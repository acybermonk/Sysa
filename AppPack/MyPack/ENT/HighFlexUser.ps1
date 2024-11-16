###############################################################################################
###############################################################################################
###############################################################################################


# Description  : High Flex User Script
# Single

# *(required)
# Input Parameters*
    param(
        [parameter(Mandatory)]
        [string]$runType,[string]$actionType,[string]$userName
    )
# Main Variables
	Add-Type -AssemblyName System.Windows.Forms, System.Drawing
    [System.Windows.Forms.Application]::EnableVisualStyles()
	$Drive = [System.Environment]::GetEnvironmentVariable('SysaDrive','User')
# Log Path
    $Global:LocalLog = "$Drive\Sysa\AppPack\MyPack\Pack\logs\HF_User_LOG.log"
# LocalLogWrite Function*
    function localLogWrite{
        Param ([string]$LogString)
        Add-Content $Global:LocalLog -Value $LogString
    }
# Set Local Variables*
    $Global:ReturnErrMessage = "0"
    $FoundMod_AD = $false
    $Global:Type = "User"    
# Import Active Directory Module*
    Import-Module ActiveDirectory -WarningAction SilentlyContinue -ErrorAction SilentlyContinue | Out-Null
    $Modules = Get-Module -ListAvailable
    foreach ($mod in $Modules){
        $mod = $mod.name
        if ($mod -eq "ActiveDirectory"){
            Write-Host "--Active Directory Module was found--"
            $FoundMod_AD = $true
            Break
        }
    }
# Header
###############################################################################################
Write-Host $PSCommandPath
Write-Host "RunType    : $runType"
Write-Host "ActionType : $actionType"
Write-Host "User       : $userName"
Write-Host "------------------------"
Write-Host ""
###############################################################################################
###############################################################################################
###############################################################################################

# Check Run Type
###############################################################################################

# Check runType*
    function checkRunType{
        if ($FoundMod_AD -eq $true){
            if ($runType -eq "System"){
                $Global:ReturnErrMessage = "Processing $runType in $Global:Type Script"
            }elseif ($runType -eq "User"){
                runScript
            }else{
                $Global:ReturnErrMessage = "Processing $runType in Individual Script"
            }
        }else{
            $Global:ReturnErrMessage = "Active Directory is not active on system. Please install RSAT and try again."
        }
    }

###############################################################################################
###############################################################################################
###############################################################################################

# Script*
###############################################################################################
    function runScript{
        # Choose Type
        function chooseType{
            Write-Host "[HF, THF, IHF]" # SHPW ABREVIATION OPTIONS
            $Global:SelectedGroup = Read-Host "Selection "
            $Global:SelectedGroup = $Global:SelectedGroup.ToUpper()
            $Global:MembershipGroup = ""
        }
        # Check Selection
        function checkSelection{
            # CHECK FOR INPUT OF THE ABBREVIATED OPTIONS
            if ($Global:SelectedGroup -eq "HF"){
                ### Enter AD GROUP NAME - $Global:MembershipGroup = "GROUPNAME"
                $Global:MembershipGroup = "AvectoHighFlex"
            }elseif($Global:SelectedGroup -eq "THF"){
                ### Enter AD GROUP NAME - $Global:MembershipGroup = "GROUPNAME"
                $Global:MembershipGroup = "AvectoTemporary"
            }elseif($Global:SelectedGroup -eq "IHF"){
                ### Enter AD GROUP NAME - $Global:MembershipGroup = "GROUPNAME"
                $Global:MembershipGroup = "AvectoHighFlexInterns"
            }else{
                ### Enter AD GROUP NAME - $Global:MembershipGroup = "GROUPNAME"
                $Global:ReturnErrMessage = "Invalid Selection; Exiting Script"
                localLogWrite "Invalid Selection; Exiting Script"
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
            }
        }

        chooseType
        checkSelection

        if ($actionType -eq "Check"){
            $Found = $false
            Write-Host "Attempting to check if $userName is a member of $Global:MembershipGroup group"
            # Try and get system group list
                try{
                    $list = (Get-ADUser $userName -Properties MemberOf).MemberOf | Get-ADGroup | Select-Object Name | Sort-Object Name 
                }catch{
                    $Global:ReturnErrMessage = "Unable to get list of $userName`'s AD Groups"
                    localLogWrite "ERR: Unable to get list of $Global:Type AD Groups"
                }
            # Check if system group list is null
            if ($list -eq $null){
                Write-Host "    Retreiving $userName`'s group list Failed " -ForegroundColor Red
                $Global:ReturnErrMessage = "Unable to get list of $userName`'s AD Groups"
                localLogWrite "ERR: Unable to get list of $Global:Type AD Groups"
            }else{
                # Check each member for groups
                foreach ($member in $list){
                    # If found
                    # CHECK FOR ALIKE BASE NAME
                    if ($member -like "*TIAvecto*"){
                        $member = $member.Name
                        Write-Host "    $userName is apart of $member" -ForegroundColor Green
                        $Found = $true
                    }
                }
                # If not found
                if (!$Found){
                    Write-Host "    ERR: Failed to complete. No Actions taken" -ForegroundColor Red
                    localLogWrite "ERR: $Global:Type has no memberships"
                    $Global:ReturnErrMessage = "$userName has no memberships"
                }
            }
        }elseif ($actionType -eq "Remove"){
            Write-Host "Attempting to remove $Global:MembershipGroup from $userName"
            # Try to get Group obj
                try{
                    $GroupDist = Get-ADGroup -Identity $Global:MembershipGroup -Properties DistinguishedName | Select-Object -ExpandProperty DistinguishedName
                }catch{
                    localLogWrite "ERR: Failed to get DistGroup of group"
                }
            # Try to get User obj
                try{
                    $UserDist = Get-ADUser -Identity $userName -Properties DistinguishedName | Select-Object -ExpandProperty DistinguishedName
                }catch{
                    localLogWrite "ERR: Failed to get DistGroup of user"
                }
            # Try to remove group from user
                try{
                    Remove-ADGroupMember -Identity $GroupDist -Members $UserDist -Confirm:$false
                    Write-Host "    Removed $userName from $Global:MembershipGroup" -ForegroundColor Green 
                }catch{
                    Write-Host "    ERR: Failed to complete. No Actions taken" -ForegroundColor Red
                    $Global:ReturnErrMessage = "Failed to add $userName to $Global:MembershipGroup Group"
                    localLogWrite "ERR: Failed to remove $Global:Type from AD Group"
                }
        }elseif ($actionType -eq "Add"){
            Write-Host "Attempting to add $Global:MembershipGroup to $userName"
            # Try to get Group obj
                try{
                    $GroupDist = Get-ADGroup -Identity $Global:MembershipGroup -Properties DistinguishedName | Select-Object -ExpandProperty DistinguishedName
                }catch{
                    localLogWrite "ERR: Failed to get DistGroup of group"
                }
            # Try to get User obj
                try{
                    $UserDist = Get-ADUser -Identity $userName -Properties DistinguishedName | Select-Object -ExpandProperty DistinguishedName
                }catch{
                    localLogWrite "ERR: Failed to get DistGroup of user"
                }
            # Try to add group to user
                try{
                    Add-ADGroupMember -Identity $GroupDist -Members $UserDist -Confirm:$false
                    Write-Host "    Added $userName to $Global:MembershipGroup" -ForegroundColor Green 
                }catch{
                    Write-Host "    ERR: Adding $group group Failed" -ForegroundColor Red
                    $Global:ReturnErrMessage = "Failed to add $userName to $Global:MembershipGroup Group"
                    localLogWrite "ERR: Failed to add $Global:Type to AD Group"
                }
        }else{
            Write-Host "    ERR: Invalid Action Type" -ForegroundColor Red
            localLogWrite "Invalid Action Type : $actionType"
        }
        localLogWrite "** Script Complete **"
    }

###############################################################################################
###############################################################################################
###############################################################################################

# Start*
###############################################################################################
    checkRunType
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
