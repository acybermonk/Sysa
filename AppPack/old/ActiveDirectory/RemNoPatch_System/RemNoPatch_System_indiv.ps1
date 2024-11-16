# Individual PS Script
# Category     : Active Directory
# Check ID     : System
# Discription  : Remove NoPatchRestriction_Win10 & Windows10_Legacy

# *(required)
# Input Parameters*
    param ([string]$Process,[string]$Data)
# Log Path
    $Global:Drive = "C:"
    $Global:LocalLog = "$Global:Drive\MySysA\AppPack\ActiveDirectory\RemNoPatch_System\logs\RemNoPatch_System.log"
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
    localLogWrite "Chek ID      : System"
    localLogWrite "Discription  : Remove NoPatchRestriction_Win10 & Windows10_Legacy"
    localLogWrite "*************************************"
    Write-Output($PSCommandPath)
# Set Local Variables*
    $Global:ReturnErrVal = $false
    $FoundMod_AD = $fal
    $Global:Groups = @("NoPatchRestriction_Win10","Windows10_Legacy")
# Import Active Directory Module*
    Import-Module ActiveDirectory -WarningAction SilentlyContinue -ErrorAction SilentlyContinue
    $Modules = Get-Module -ListAvailable
    foreach ($mod in $Modules){
        $mod = $mod.name
        if ($mod -eq "ActiveDirectory"){
            Write-Host "--Active Directory Module was found--"
            $FoundMod_AD = $true
            localLogWrite "--Active Directory Module was found--"
            Break
        }
    }
# Check Process*
    function checkProcess{
        if ($FoundMod_AD -eq $true){
            Write-Output("Process : $Process")
            if ($Process -eq "system"){
                localLogWrite "Process : $Process"
                runSystemScript
            }elseif ($Process -eq "user"){
                localLogWrite "Process : $Process"
                localLogWrite "Error : Processing $Process in System Script"
                $Global:ReturnErrMessage = "Processing $Process in System Script"
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
    function runSystemScript{
        localLogWrite "Running Script..."
            # *** Add User Script Here ***
            $Global:RemoveSuccess = 0
            foreach ($group in $Global:Groups){
                Write-Output("    Attempting to remove ${Data} from ${group}")
                try{
                    $GroupDist = Get-ADGroup -Identity $group -Properties DistinguishedName | Select-Object -ExpandProperty DistinguishedName
                    $SystemDist = Get-ADComputer -Identity $Data -Properties DistinguishedName | Select-Object -ExcludeProperty DistinguishedName
                    Remove-ADGroupMember -Identity $GroupDist -Members $SystemDist -Confirm:$false
                    Write-Host -ForegroundColor Green "    Successfully Removed $Data from $group"
                    localLogWrite "    System removed from $group"
                    $Global:RemoveSuccess += 1
                }catch{
                    Write-Output "    No Actions taken"
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
    Write-Output("ErrorCode : ${Global:ReturnErrMessage}")
    localLogWrite "ErrorCode : $Global:ReturnErrMessage"
    localLogWrite "*************************************"
    localLogWrite ""
# Wait to Close
    Pause 
# End*