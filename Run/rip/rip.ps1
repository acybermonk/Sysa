########################################

<#  ** Header **
    Application Name : Remotly Inserted Payload GUI (RIP)
    Created by       : Daniel Krysty
    Date started     : October 2024
    Current as of    : November 2024
#>

########################################
########################################
# Variables
########################################

# App Variables (Updated)
	$Global:AppName = "Sysa - RIP"
	$Global:AppVer = "1.0"
    $Global:Copyright = [System.Net.WebUtility]::HtmlDecode("&#169;")
    $Global:CpDate = "Oct. 2024"
    [string]$initUsr = hostname
# Main Variables
	Add-Type -AssemblyName System.Windows.Forms, System.Drawing
    [System.Windows.Forms.Application]::EnableVisualStyles()
	# Object Variables - Create objects used in Application
		$Form_Object = [System.Windows.Forms.Form]
		$Label_Object = [System.Windows.Forms.Label]
		$Checkbox_Object = [System.Windows.Forms.CheckBox]
		$Textbox_Object = [System.Windows.Forms.TextBox]
		$Groupbox_Object = [System.Windows.Forms.GroupBox]
		$Button_Object = [System.Windows.Forms.Button]
        $RichTextbox_Object = [System.Windows.Forms.RichTextBox]
# Drive
    [string]$Global:SelectDrivePath = $null
	$Drive = [System.Environment]::GetEnvironmentVariable('SysaDrive','User')
# Logo
    $Global:ImgIcon = New-Object System.Drawing.Icon("$Drive\Sysa\Imported\img\logo64.ico")
    $Global:LogImage = [System.Drawing.Image]::FromFile("$Drive\Sysa\Imported\img\logimg.png")
# Log Session Data *temp data storage while using app* SAVE BEFORE EXITING unless Session auto-save is enabled there is 
    $Global:ErrorCodeLogLocation =  "$Global:StartPath\Sysalogs\errorlogs\${Global:Date}_rip.erlog"
    function utilErr{
        Param ([string]$LogString)
        Add-Content $Global:ErrorCodeLogLocation -Value $LogString
    }
# Font
    $Global:DefaultFont22Bold = New-Object System.Drawing.Font("Arial", 22, [System.Drawing.FontStyle]::Bold)
    $Global:DefaultFont10Bold = New-Object System.Drawing.Font("Arial", 10, [System.Drawing.FontStyle]::Bold)
	$Global:DefaultFont10 = New-Object System.Drawing.Font("Arial", 10)

########################################
########################################
# Functions
########################################

function checkPing{
    param([string]$system)
    Test-Connection -ComputerName $system 
}


########################################
########################################
# GUI Form
########################################

# RIP Form GUI
    $RIP_Form = New-Object $Form_Object
    $RIP_Form.Text = $Global:AppName
	$RIP_Form.FormBorderStyle = "Fixed3D" #FixedDialog, Fixed3D
	$RIP_Form.ClientSize = "600,300"
	#$RIP_Form.StartPosition = "Center"
	$RIP_Form.Icon = $Global:ImgIcon
    $RIP_Form.Add_FormClosing({
        $RIP_Form.Dispose()
    })
# RIP Target Label
    $RIPTarget_Label = New-Object $Label_Object
    $RIPTarget_Label.Text = "RIP`nTarget System"
    $RIPTarget_Label.Font = $Global:DefaultFont10Bold
    $RIPTarget_Label.TextAlign = "MiddleCenter"
    $RIPTarget_Label.Size = New-Object System.Drawing.Point(100,50)
    $RIPTarget_Label.Location = New-Object System.Drawing.Point(25,50)
# RIP Target TextBox
    $RIPTarget_Textbox = New-Object $Textbox_Object
    $RIPTarget_Textbox.Text = "<Target>"
    $RIPTarget_Textbox.TabIndex = 1
    $RIPTarget_Textbox.Font = $Global:DefaultFont10
    $RIPTarget_Textbox.MaxLength = 15
    $RIPTarget_Textbox.CharacterCasing = "Upper"
    $RIPTarget_Textbox.Size = New-Object System.Drawing.Point(100,40)
    $RIPTarget_Textbox.Location = New-Object System.Drawing.Point(25,100)
    $RIPTarget_Textbox.Add_Click({
        if ($RIPTarget_Textbox.Text -eq "<Target>"){
            $RIPTarget_Textbox.Text = ""
        }
    })
# Send Button
    $RIPSend_Button = New-Object $Button_Object
    $RIPSend_Button.Text = "Send"
    $RIPSend_Button.Font = $Global:DefaultFont10
    $RIPSend_Button.Size = New-Object System.Drawing.Point(100,25)
    $RIPSend_Button.Location = New-Object System.Drawing.Point(25,140)
    $RIPSend_Button.Add_Click({
        if (-not ($Drive -eq $null)){
            if (-not ($RIPTarget_Textbox.Text -eq "<Target>" -or $RIPTarget_Textbox.Text -eq $null -or $RIPTarget_Textbox.Text -eq "" -or $RIPScriptBlock_RichTextbox.Text -eq $null -or $RIPScriptBlock_RichTextbox.Text -eq "")){
                $Target = $RIPTarget_Textbox.Text
                $Block = $RIPScriptBlock_RichTextbox.Text
                $PingSuccess = $false
                $ADMSuccess = $false
                $admAcc = $false
                $admloca = $false
                # Check Rights to Proceed
                    if (([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)){
                        $admAcc = $true
                    }
                    [string]$initUsr = "$env:COMPUTERNAME\$env:USERNAME"
                    $group = 'Administrators'
                    $isInGroup = (Get-LocalGroupMember $group).Name -contains $initUsr
                    if ($isInGroup){
                        $admloca = $true
                    }
                # Test Connection
                    if (Test-Connection -ComputerName $Target){
                        $PingSuccess = $true
                    }
                # Attempt Payload
                    Write-Host "Runnging on $Target`nScript:`n{`n$Block`n}`n"
                    if ($PingSuccess){ # -and $admAcc
                        if ($admAcc -and $admloca){
                            Write-Host "Ping was successful."
                            Write-Host "Admin : $admAcc"
                            try{
                                #Start-Process -FilePath "C:\Windows\System32\cmd.exe" -Credential "" -NoNewWindow -ArgumentList "$PSCommandPath\PSTools\PSExec.exe \\$target cmd /c $Block"
                                Invoke-Command -RunAsAdministrator -ComputerName $Target -ScriptBlock { $Block }
                                Write-Host "Completed Successfully" -ForegroundColor Green
                            }catch{
                                Write-Error -Message "Unable to send payload" -Category InvalidArgument
                            }
                        }else{
                            Write-Host "ADM Check Failed"
                        }
                    }else{
                        Write-Host "Ping Check Failed"
                    }
            }else{
                Write-Host "Failed PreReqs"
            }
        }else{
            Write-Host "Drive is null"
        }
    })
    $RIPErrorMessage
# Open Braket Label
    $RIPOpenBraket_Label = New-Object $Label_Object
    $RIPOpenBraket_Label.Text = "{"
    $RIPOpenBraket_Label.Font = $Global:DefaultFont22Bold
    $RIPOpenBraket_Label.TextAlign = "MiddleCenter"
    $RIPOpenBraket_Label.Size = New-Object System.Drawing.Point(20,50)
    $RIPOpenBraket_Label.Location = New-Object System.Drawing.Point(175,50)
# ScriptBlock Rich Textbox
    $RIPScriptBlock_RichTextbox = New-Object $RichTextbox_Object
    $RIPScriptBlock_RichTextbox.Font = $Global:DefaultFont10
    $RIPScriptBlock_RichTextbox.Size = New-Object System.Drawing.Point(330,215)
    $RIPScriptBlock_RichTextbox.Location = New-Object System.Drawing.Point(210,60)
# Close Braket Label
    $RIPCloseBraket_Label = New-Object $Label_Object
    $RIPCloseBraket_Label.Text = "}"
    $RIPCloseBraket_Label.Font = $Global:DefaultFont22Bold
    $RIPCloseBraket_Label.TextAlign = "MiddleCenter"
    $RIPCloseBraket_Label.Size = New-Object System.Drawing.Point(20,50)
    $RIPCloseBraket_Label.Location = New-Object System.Drawing.Point(555,225)
# Add Form Elements
    $RIP_Form.Controls.AddRange(@(
        $RIPTarget_Label
        $RIPTarget_Textbox
        $RIPSend_Button
        $RIPOpenBraket_Label
        $RIPScriptBlock_RichTextbox
        $RIPCloseBraket_Label
    ))
# Show PSExec Form
    $RIP_Form.ShowDialog()