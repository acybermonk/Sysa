# Individual PS Script
# Category     : Active Directory
# Check ID     : System
# Discription  : Check NoPatchRestriction_10 & Windows10_Legacy

# *(required)
# Input Parameters*
    param ([string]$Process,[string]$Data)
# Log Path
    $Global:Drive = "C:"
    $Global:LocalLog = "$Global:Drive\MySysA\AppPack\ActiveDirectory\CheckNoPatch_System\logs\CheckNoPatch_System_LOG.log"
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
    localLogWrite "Chek ID      : User"
    localLogWrite "Discription  : Check NoPatchRestriction_10 & Windows10_Legacy"
    localLogWrite "*************************************"
    Write-Output($PSCommandPath)
# Set Local Variables*
    $Global:ReturnErrMessage = "0"
    $FoundMod_AD = $fal
    $Global:Groups = @("NoPatchRestriction","Win10_Legacy")
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
# User Script*
    function runSystemScript{
        localLogWrite "Running Script..."
            # *** Add User Script Here ***
            $Found = $false
            try{
                $list = (Get-ADComputer $Data –Properties MemberOf).MemberOf | Get-ADGroup | Select-Object name | Sort-Object Name
            }catch{
                $Global:ReturnErrMessage = "Unable to get list of user AD Groups"
                localLogWrite "    Unable to get list of user AD Groups"
            }
            foreach ($member in $list){
                # If found
                if ($member -like "*NoPatchRestriction*"){
                    $member = $member.Name
                    Write-Host -ForegroundColor Green "    $Data is apart of $member"
                    $Found = $true
                }elseif($member -like "*Windows10_Legacy*"){
                    $member = $member.Name
                    Write-Host -ForegroundColor Green "    $Data is apart of $member"
                    $Found = $true
                }
            }
            if (!$Found){
                localLogWrite "    Data has no memberships"
                $Global:ReturnErrMessage = "Data has no memberships"
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