# Individual PS Script
# Category     : Active Directory
# Check ID     : User
# Description  : Check High Flex Users

# *(required)
# Input Parameters*
    Param ([string]$Process,[string]$Data)
# Log Path
    $Global:Drive = "C:"
    $Global:LocalLog = "$Global:Drive\MySysA\AppPack\ActiveDirectory\CheckHF_User\logs\CheckHF_User_LOG.log"
# LocalLogWrite Function*
    function localLogWrite{
        Param ([string]$LogString)
        Add-Content $Global:LocalLog -Value $LogString
    }
# Log Header*
    localLogWrite "*************************************"
    localLogWrite "*************************************"
    localLogWrite "Individual PS Script"
    localLogWrite "Category     : Active Directory"
    localLogWrite "Chek ID      : User"
    localLogWrite "Check Group  : Check High Flex Groups"
    localLogWrite "*************************************"
    Write-Output($PSCommandPath)
# Set Local Variables*
    $Global:ReturnErrMessage = "0"
    $FoundMod_AD = $false    
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
                localLogWrite "Error : Processing $Process in User Script"
                $Global:ReturnErrMessage = "Processing $Process in User Script"
            }elseif ($Process -eq "user"){
                localLogWrite "Process : $Process"
                runUserScript
            }else{
                localLogWrite "Error : Processing $Process in Individual Script"
                $Global:ReturnErrMessage = "Error : Processing $Process in Individual Script"
            }
        }else{
            localLogWrite "Error : Active Directory is not active on system. Please install RSAT and try again."
            $Global:ReturnErrMessage = "Error : Active Directory is not active on system. Please install RSAT and try again."
        }
    }
# User Script*
    function runUserScript{
        localLogWrite "** Running Script **"
            # *** Add User Script Here ***
            $Found = $false
            try{
                $list = (Get-ADUser $Data -Properties MemberOf).MemberOf | Get-ADGroup | Select-Object Name | Sort-Object Name
            }catch{
                $Global:ReturnErrMessage = "Unable to get list of user AD Groups"
                localLogWrite "    Unable to get list of user AD Groups"
            }
            foreach ($member in $list){
                # If found
                if ($member -like "*TIAvecto*"){
                    $member = $member.Name
                    Write-Host -ForegroundColor Green "    $Data is apart of $member"
                    $Found = $true
                    localLogWrite "    Data has $member membership"
                }
            }
            if (!$Found){
                localLogWrite "    $Data has no memberships"
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