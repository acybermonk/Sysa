# Individual PS Script
# Category     : Active Directory
# Check ID     : User
# Description  : Add High Flex User

# *(required)
# Input Parameters*
    Param ([string]$Process,[string]$Data)
# Log Path
    $Global:Drive = "C:"
    $Global:LocalLog = "$Global:Drive\MySysA\AppPack\ActiveDirectory\AddHF_User\logs\AddHF_User_LOG.log"
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
    localLogWrite "Description  : Add High Flex User"
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
                $Global:ReturnErrMessage = "Processing $Process in Individual Script"
            }
        }else{
            localLogWrite "Error : Active Directory is not active on system. Please install RSAT and try again."
            $Global:ReturnErrMessage = "Active Directory is not active on system. Please install RSAT and try again."
        }
    }
# User Script*
    function runUserScript{
        localLogWrite "** Running Script **"
            # *** Add User Script Here ***
            function chooseType{
                $Global:SelectedGroup = Read-Host "Selection: "
                $Global:SelectedGroup = $Global:SelectedGroup.ToUpper()
                $Global:MembershipGroup = ""
            }
            function checkSelection{
                if ($Global:SelectedGroup -eq "HF"){
                    $Global:MembershipGroup = "TIAvectoHighFlex"
                }elseif($Global:SelectedGroup -eq "THF"){
                    $Global:MembershipGroup = "TIAvectoTemporary"
                }elseif($Global:SelectedGroup -eq "IHF"){
                    $Global:MembershipGroup = "TIAvectoHighFlexInterns"
                }else{
                    $Global:ReturnErrMessage = "Invalid Selection; Exiting Script"
                    localLogWrite "    Invalid Selection; Exiting Script"
                }
            }
            chooseType
            checkSelection
            try{
                $GroupDist = Get-ADGroup -Identity $Global:MembershipGroup -Properties DistinguishedName | Select-Object -ExpandProperty DistinguishedName
                Write-Output("    Attempting to add $Global:MembershipGroup to $Data")
                $UserDist = Get-ADUser -Identity $Data -Properties DistinguishedName | Select-Object -ExpandProperty DistinguishedName
                Add-ADGroupMember -Identity $GroupDist -Members $UserDist -Confirm:$false
                Write-Host -ForegroundColor Green "    Added $Data to $Global:MembershipGroup"
            }catch{
                Write-Output "   No Actions taken"
                $Global:ReturnErrMessage = "Failed to add user to $Global:MembershipGroup Group"
                localLogWrite "    Failed to add user to AD Group"
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