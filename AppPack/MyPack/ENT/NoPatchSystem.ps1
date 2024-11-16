###############################################################################################
# Description  : High Flex User Script
###############################################################################################
# Single

# *(required)
# Input Parameters*
    param(
        [parameter(Mandatory)]
        [string]$runType,[string]$actionType,[string]$systemName
    )
# Main Variables
	Add-Type -AssemblyName System.Windows.Forms, System.Drawing
    [System.Windows.Forms.Application]::EnableVisualStyles()
	$Drive = [System.Environment]::GetEnvironmentVariable('SysaDrive','User')
# Log Path
    $Global:LocalLog = "$Drive\Sysa\AppPack\MyPack\Pack\logs\NoPatchSystem_LOG.log"
# LocalLogWrite Function*
    function localLogWrite{
        Param ([string]$LogString)
        Add-Content $Global:LocalLog -Value $LogString
    }
# Set Local Variables*
    $Global:ReturnErrMessage = "0"
    $FoundMod_AD = $false
    $Global:Groups = @("NoPatchRestricted","Windows10","Legacy")
    $addGroup = "NoPatchRestricted"
    $Global:Type = "System"    
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
Write-Host "System       : $systemName"
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
            if ($runType -eq "User"){
                $Global:ReturnErrMessage = "Processing $runType in $Global:Type Script"
            }elseif ($runType -eq "System"){
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
    function runScript{
        function checkIt{
            $Found = $false
            Write-Host "Attempting to check if $systemName memberships"
            # Try and get system group list
            try{
                $list = (Get-ADComputer $systemName –Properties MemberOf).MemberOf | Get-ADGroup | Select-Object name | Sort-Object Name
            }catch{
                $Global:ReturnErrMessage = "Unable to get list of $systemName`'s AD Groups"
                localLogWrite "Unable to get list of $Global:Type AD Groups"
            }
            # Check if system group list is null
            if ($list -eq $null){
                Write-Host "    Retreiving $systemName`'s group list Failed " -ForegroundColor Red
                $Global:ReturnErrMessage = "Unable to get list of $Global:Type`'s AD Groups"
                localLogWrite "ERR: Unable to get list of $Global:Type AD Groups"
            }else{
                # Check each member for groups
                foreach ($checkGroup in $Global:Groups){
                    $checkGroup = $checkGroup.ToString()
                    Write-Host "Attempting to check if $systemName is a member of $checkGroup group"
                    foreach ($member in $list){
                        $member = $member.Name
                        # If found
                        if ($member -like "*$checkGroup*"){
                            Write-Host -ForegroundColor Green "$systemName is apart of $checkGroup"
                            $Found = $true
                        }else{
                            Write-Host -ForegroundColor Red "$systemName is not apart of of $checkGroup"
                        }
                    }
                    <#
                    elseif($member -like "*Windows10_Legacy*"){
                        $member = $member.Name
                        Write-Host -ForegroundColor Green "$systemName is apart of $member"
                        $Found = $true
                    }
                    #>
                }
                # If not found
                if (!$Found){
                    Write-Host "    Failed to find group(s)" -ForegroundColor Red
                    localLogWrite "ERR: Data has no memberships"
                    $Global:ReturnErrMessage = "$systemName has no memberships"
                }
            }
        }
        function RemoveIt{
            foreach ($group in $Global:Groups){
                Write-Host "Attempting to remove $systemName from $group"
                # Try to get group obj
                    try{
                        $GroupDist = Get-ADGroup -Identity $group -Properties DistinguishedName | Select-Object -ExpandProperty DistinguishedName
                    }catch{
                        localLogWrite "ERR: Failed to get DistGroup of group"
                    }
                # Try to get System obj
                    try{
                        $SystemDist = Get-ADComputer -Identity $systemName -Properties DistinguishedName | Select-Object -ExcludeProperty DistinguishedName
                    }catch{
                        localLogWrite "ERR: Failed to get DistGroup of system"
                    }
                # Try to Add system to group
                    try{
                        Remove-ADGroupMember -Identity $GroupDist -Members $SystemDist -Confirm:$false
                        Write-Host -ForegroundColor Green "    Removed $systemName from $group"
                        localLogWrite "ERR: System removed from $group"
                    }catch{
                        Write-Host "    $group group removal Failed" -ForegroundColor Red
                        $Global:ReturnErrMessage = "Failed to remove $systemName from group(s)"
                        localLogWrite "ERR: Failed to remove user from AD Group"
                    }
            }
        }
        function AddIt{
            #Write-Host "ADD SYSTEM TO AD GROUP"
            Write-Host "Attempting to add $systemName to $addGroup"
                # Try to get group obj
                    try{
                        $GroupDist = Get-ADGroup -Identity $addGroup -Properties DistinguishedName | Select-Object -ExpandProperty DistinguishedName
                    }catch{
                        localLogWrite "ERR: Failed to get DistGroup of group"
                    }
                # Try to get System obj
                    try{
                        $SystemDist = Get-ADComputer -Identity $systemName -Properties DistinguishedName | Select-Object -ExcludeProperty DistinguishedName
                    }catch{
                        localLogWrite "ERR: Failed to get $Global:Type of addGroup"
                    }
                # Try to Add system to group
                    try{
                        Add-ADGroupMember -Identity $GroupDist -Members $SystemDist -Confirm:$false
                        Write-Host -ForegroundColor Green "   Added $systemName to $addGroup"
                    }catch{
                        Write-Host "    Adding $addGroup group Failed" -ForegroundColor Red
                        $Global:ReturnErrMessage = "Failed to Add $systemName from $addGroup`'s Group"
                        localLogWrite "ERR: Failed to remove $Global:Type from AD Group"
                    }
        }

        function checkAction{
            if ($actionType -eq "Check"){
                checkIt
            }elseif ($actionType -eq "Remove"){
                RemoveIt
            }elseif ($actionType -eq "Add"){
                AddIt
            }
        }

        checkAction
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
