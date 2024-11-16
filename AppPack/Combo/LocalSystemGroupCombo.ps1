# Combination PS Script
# Check ID     : Combo
# Description  : Add user group from prompt

# *(required)
# Input Parameters*
    param ([string]$SystemName,[string]$UserName,[string]$Process)
# Log Path
    $Global:Drive = "C:"
    $Global:LocalLog = "$Global:Drive\MySysA\AppPack\SystemMgmt\AddADM_Combo\"
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
    localLogWrite "Chek ID      : Combo"
    localLogWrite "Description  : Add user Admin group"
    localLogWrite "*************************************"
    Write-Output($PSCommandPath)
# Set Local Variables*
    $Global:ReturnErrMessage = "0"
    $FoundMod_AD = $false    
    $Global:GroupName = "Administrators"
# Check Process (required)
    function checkProcess{
        if ($Process -eq "system" -or $Process -eq "user"){
            localLogWrite "Error : Processing $Process in Combination/Group Script"
            $Global:ReturnErrMessage = "Error : Processing $Process in Combination/Group Script"
        }else{
            runScript
        }
    }
# Run Script
    function runScript{
        Write-Host "** Runing $Process Script **"
        localLogWrite "** Runing $Process Script **"
        # *** Add Combination/group Script Here ***
            #Start
            Write-Host "** Adding $UserName to $Global:GroupName on $SystemName **"
            localLogWrite "** Adding $UserName to $Global:GroupName on $SystemName **"
            # Intiate Command
            Invoke-Command -ComputerName $SystemName -ScriptBlock{
                Add-LocalGroupMember -Group $Global:GroupName -Member $UserName
            }
            Write-Host "** Process Completed **"
            localLogWrite "** Process Completed **"
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
    if ($Process -ne "group" -and $Process -ne "system" -and $Process -ne "user"){
        Pause 
    }
# End*