# Individual PS Script
# Category     : Active Directory
# Check ID     : Group
# Discription  : Remove NoPatchRestriction & Win10_Legacy

# *(required)
# Input Parameters*
    param ([string]$System,[string]$User,[string]$Process)
    $Global:Drive = "C:"
    $Global:LocalLog = "$Global:Drive\MySysA\AppPack\ActiveDirectory\RemNoPatch_Group\logs\RemNoPatch_Group.log"
# LocalLogWrite Function*
    function localLogWrite{
        Param ([string]$LogString)
        Add-Content $Global:LocalLog -Value $LogString
    }
# Log Header
    localLogWrite "*************************************"
    localLogWrite "*************************************"
    localLogWrite "Individual PS Script"
    localLogWrite "Category     : Active Directory"
    localLogWrite "Chek ID      : Group"
    localLogWrite "Discription  : Rem NoPatchRestriction_Win10 & Windows10_Legacy"
    localLogWrite "*************************************"
# Set Local Variables*
    $Loop
    $Global:ReturnErrVal = $false
    $FoundMod_AD = $fal
    $Global:Groups = @("NoPatchRestriction_Win10","Windows10_Legacy")
# Import Active Directory Module*
    Import-Module ActiveDirectory -WarningAction SilentlyContinue -ErrorAction SilentlyContinue
    $Modules = Get-Module -ListAvailable
    foreach ($mod in $Modules){
        $mod = $mod.name
        if ($mod -eq "ActiveDirectory"){
            $FoundMod_AD = $true
            localLogWrite "--Active Directory Module was found--"
            Break
        }
    }
# Check for Group
    function checkGroup{
        if ($Process -eq "group"
    }
# Check Process*
    function checkProcess{
        if ($FoundMod_AD -eq $true){
            if ($Process -eq "system"){
                localLogWrite "Process : $Process"
                localLogWrite "Error : Processing $Process in Group Script"
                $Global:ReturnErrMessage = "Processing $Process in System Script"
            }elseif ($Process -eq "user"){
                localLogWrite "Process : $Process"
                localLogWrite "Error : Processing $Process in Group Script"
                $Global:ReturnErrMessage = "Processing $Process in System Script"
            }elseif ($Process -eq "group"){
                localLogWrite "Process : $Process"
                runGroupScript
            }else{
                localLogWrite "Error : Processing $Process in Individual Script"
                $Global:ReturnErrMessage = "Processing $Process in Individual Script"
            }
        }else{
            localLogWrite "Error : Active Directory is not active on system. Please install RSAT and try again."
            $Global:ReturnErrMessage = "Active Directory is not active on system. Please install RSAT and try again."
        }
    }
# Script*
    function runGroupScript{
        localLogWrite "Running Script..."
            # *** Add User Script Here ***
            $Global:RemoveSuccess = 0
            foreach ($group in $Global:Groups){
                try{
                    $GroupDist = Get-ADGroup -Identity $group -Properties DistinguishedName | Select-Object -ExpandProperty DistinguishedName
                    $SystemDist = Get-ADComputer -Identity $System -Properties DistinguishedName | Select-Object -ExcludeProperty DistinguishedName
                    Remove-ADGroupMember -Identity $GroupDist -Members $SystemDist -Confirm:$false
                    localLogWrite "    System removed from $group"
                    $Global:RemoveSuccess += 1
                }catch{
                    $Global:ReturnErrMessage = "Failed to remove user from $group Group"
                    localLogWrite "    Failed to remove user from AD Group"
                }
            }
            if ($Global:RemoveSuccess -eq 2){
                localLogWrite "    Removed from both groups"
                $Global:ReturnErrMessage = "Removed from both groups"
            }elseif ($Global:RemoveSuccess -eq 1){
                localLogWrite "    Only Removed from one group"
                $Global:ReturnErrMessage = "Only Removed from one group"
            }else{
                localLogWrite "    Not removed from either group"
                $Global:ReturnErrMessage = "Not removed from either group"
            }
        localLogWrite "** Script Complete **"
    }
# Start*
    checkProcess
# Display Output*
    localLogWrite "ErrorCode : $Global:ReturnErrMessage"
    localLogWrite "*************************************"
    localLogWrite ""
# Wait to Close
    Pause 
# End*