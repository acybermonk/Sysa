#$GetEV = [System.Environment]::GetEnvironmentVariables([System.EnvironmentVariableTarget]::User) 
# Main Variables
Param ([string]$FoundDrive)
Add-Type -AssemblyName System.Windows.Forms, System.Drawing
#$ImgIcon = New-Object System.Drawing.Icon (".\Imported\img\logo64.ico")
# Log Session Data *temp data storage while using app* SAVE BEFORE EXITING unless Session auto-save is enabled there is
$locallog = ".\logdata.log"
$ovr = $false
function LocalLogWrite{
    Param ([string]$logString)
    Add-Content $localLog -Value $logString
}
$Drive = [System.Environment]::GetEnvironmentVariable('SysaDrive','User')
if (Test-Path "$Drive\Sysa"){
    if (!$FoundDrive){
        Write-Host "Found SysaDrive"
        $FoundDrive = $Drive.Remove(1,1)
        $ovr = $true
    }

    if ($Drive -eq $null){
        Write-Host "Drive is not defined"
    }else{
        Write-Host "Drive not found"
    }
}

if ($Drive -eq $null -or (-not (Test-Path -Path "$Drive\Sysa")) -or $ovr){
    $FoundDriveText = $FoundDrive + ":"
    Write-Host "Mounting New Drive ( $FoundDriveText\~ )"
    if ($Drive -eq $null -or (-not (Test-Path -Path "$Drive\Sysa"))){
        Write-Host "Setting Variable"
        [System.Environment]::SetEnvironmentVariable('SysaDrive',$FoundDriveText,'User')
        $Drive = [System.Environment]::GetEnvironmentVariable('SysaDrive','User')
        #Write-Host "Drive : $Drive"
        #Write-Host "FoundDrive : $FoundDrive"
        if ($Drive.ToString() -eq "${FoundDrive}:"){
            Write-Host "Success"
        }else{
            Write-Host "Failed"
        }
    }
}
    <#elseif($ovr){
        $Lettertemp = $Drive.Remove(1,1)
        [System.Windows.Forms.SendKeys]::SendWait($Lettertemp)
        $UserInputDrive = Read-Host "Please select the drive in which the Application is Nested ___:\~  "
        $UserInputDrive = $UserInputDrive.ToUpper() + ":"
        Write-Host "Drive $UserInputDrive Selected"
        Write-Host "Setting Variable"
        [System.Environment]::SetEnvironmentVariable('SysaDrive',$UserInputDrive,'User')
        $Drive = [System.Environment]::GetEnvironmentVariable('SysaDrive','User')
        if ($Drive -eq $UserInputDrive){
            Write-Host "Success"
        }else{
            Write-Host "Failed"
            Write-Host "Drive : $Drive"
            Write-Host "UserInput : $UserInputDrive"
        }
    }#>

<#
    Start-Sleep -Seconds 3

    # Add message GUI Form
        $Form_Object = [System.Windows.Forms.Form]
        $Label_Object = [System.Windows.Forms.Label]
        $Button_Object = [System.Windows.Forms.Button]
		
        $DefaultFont1 = New-Object System.Drawing.Font("Arial", 10)
		
        $MessageBox_Form = New-Object $Form_Object
        $MessageBox_Form.Text = "Sysa 2.1 - Message"
        $MessageBox_Form.ClientSize = "280,100"
        $MessageBox_Form.StartPosition = "CenterScreen"
        $MessageBox_Form.Icon = $ImgIcon
        $MessageBox_Form.FormBorderStyle = "Fixed3D" #FixedDialog, Fixed3D
        $MessageBox_Form.Topmost = $true
        $MessageBox_Form.Add_FormClosing({
            $MessageBox_Form.Dispose()
        })
    # Message Label
        $Message_Label = New-Object $Label_Object
        $Message_Label.Text = "Program must close to complete."
        $Message_Label.AutoSize = $true
        $Message_Label.Font = $DefaultFont1
        $Message_Label.Location = New-Object System.Drawing.Point(40,20)
    # Close Button
        $Ok_Button = New-Object $Button_Object
        $Ok_Button.Text = "Ok"
        $Ok_Button.AutoSize = $true
        $Ok_Button.Font = $DefaultFont1
        $Ok_Button.TabIndex = 0
        $Ok_Button.Location = New-Object System.Drawing.Point(105,60)
        $Ok_Button.Add_Click({
            $MessageBox_Form.Close()
        })
    # Display Form
        $MessageBox_Form.Controls.AddRange(@($Message_Label,$Ok_Button))
		$MessageBox_Form.ShowDialog()
#>

    # Add Var C:
    #[System.Environment]::SetEnvironmentVariable('SysaDrive','C:','User')
    # CLear Vars
    #[System.Environment]::SetEnvironmentVariable('SysaDrive','','User')
