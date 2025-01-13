##############################################
#
#    Functionality    : *****  MAIN APP  *****
#    -----------------------------------------
#    Application Name : Sysa - Universal 1.2.9
#    Created by       : Daniel Krysty
#    Date started     : September 2024
#    Current as of    : January 2024
#
##############################################
##############################################
# Variables
##############################################
Param ([string] $FoundDrive)
# App Variables (Updated)
	$Global:AppName = "Sysa"
	$Global:AppVer = "1.2.9"
    $Global:Copyright = [System.Net.WebUtility]::HtmlDecode("&#169;")
    $Global:CpDate = "Oct. 2024"
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
		$Combobox_Object = [System.Windows.Forms.ComboBox]
		$RichTextbox_Object = [System.Windows.Forms.RichTextBox]
		$ToolbarMenuStrip_Object = [System.Windows.Forms.MenuStrip]
		#$ToolbarMenuOption_Object = [System.Windows.Forms.ToolStripMenuItem]
		$Picturebox_Object = [System.Windows.Forms.PictureBox]
		#$ProgressBar_Object = [System.Windows.Forms.ProgressBar]
		#$Radio_Object = [System.Windows.Forms.RadioButton]
# Log Session Data *temp data storage while using app* SAVE BEFORE EXITING unless Session auto-save is enabled there is 
    $Global:ErrorCodeLogLocation =  "$Global:StartPath\Sysalogs\errorlogs\${Global:Date}-sysaERR.log"
    function utilErr{
        Param ([string]$LogString)
        Add-Content $Global:ErrorCodeLogLocation -Value $LogString
    }
# Drive
    [string]$Global:SelectDrivePath = $null
	$Drive = [System.Environment]::GetEnvironmentVariable('SysaDrive','User')
# Logo
    [System.Collections.ArrayList]$Alpha = @('A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z')
	foreach($d in $Alpha){
        $d = $d.ToString()
	    if (Test-Path "$d`:\Sysa\Imported\img"){
            $Global:ImgIcon = New-Object System.Drawing.Icon("$d`:\Sysa\Imported\img\logo64.ico")
            #$Global:LogImage = [System.Drawing.Image]::FromFile("$d`:\Sysa\Imported\img\logimg.png")
            break
	    }
	}
<# 
Uninstall
    if ($FoundDrive -eq "\uninst"){
        try{
            [System.Environment]::SetEnvironmentVariable('SysaDrive','','User')
        }catch{
            utilErr "ERR: Failed : Uninstall not successful; SysaDrive is not removed"
        }
        try{
            $RemovePack = Remove-Item -Path "$Drive\Sysa\AppPack\MyPack\Pack" -Recurse -Force -Confirm:$false | Out-Null
            $ReplacePack = New-Item -Name "Pack" -ItemType Directory -Path "$Drive\Sysa\AppPack\MyPack" -Force -Confirm:$false | Out-Null
        }catch{
            utilErr "ERR: Failed : Removing MyPack - Pack"
        }
	    Exit
    }
#>
	if ($Drive -eq $null){
        # Drive Selection

        ##############################################
        ##############################################

        $DriveSelection_Form = New-Object $Form_Object
        $DriveSelection_Form.Text = "Sysa Drive Selection"
        $DriveSelection_Form.Icon = $Global:imgIcon
        $DriveSelection_Form.ClientSize = New-Object System.Drawing.Point(400,150)
	    $DriveSelection_Form.FormBorderStyle = "Fixed3D" #FixedDialog, Fixed3D
	    $DriveSelection_Form.StartPosition = [Windows.Forms.FormStartPosition]::CenterScreen
        $DriveSelection_Form.Add_FormClosing({
            $DriveSelection_Form.Dispose()
        })
        $DriveSelection_Form.Add_Load({
            # Add Delay
            Start-Sleep -Seconds 2

		    #PS Script
		    [System.Collections.ArrayList]$Alpha = @('A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z')
		    $Found = $false
		    $Global:FoundDrive = $null
            $DriveSelectionChoice_Combo.Items.Clear()
		    foreach($d in $Alpha){
                $d = $d.ToString()
			    if (Test-Path "$d`:\Sysa"){
                    if ($Found -eq $false){
                        $Global:FoundDrive = $d
                        $Global:SelectDrivePath = "$Global:FoundDrive`:\Sysa\Imported\select\drive.ps1"
                    }
				    $Found = $true                    
                    $DriveSelectionMessage_Label.Text = "Drive Found at `: $Global:FoundDrive"
                    $DriveSelectionChoice_Combo.Items.Add($d)
			    }
		    }
		    if (-not($Found)){
                $DriveSelectionChoice_Combo.Enabled = $false
                $DriveSelectionChoice_Button.Enabled = $false
			    $DriveSelectionMessage_Label.Text = "ERR:: Not Found:: CHK PKG LOCA"
                $Path = $null
                $Found = $false
                $Global:FoundDrive = $null
                Start-Sleep -Seconds 2
                $DriveSelection_Form.Dispose()
		    }
        })

        $SysaLogo_PicBox = New-Object $Picturebox_Object
        $SysaLogo_PicBox.Image = $Global:ImgIcon
        $SysaLogo_PicBox.Size = New-Object System.Drawing.Point(100,100)
        $SysaLogo_PicBox.Location = New-Object System.Drawing.Point(25,25)
        $SysaLogo_PicBox.SizeMode = "StretchImage"

        $DriveSelectionTitle_Label = New-Object $Label_Object
        $DriveSelectionTitle_Label.Text = "Sysa Drive Selection"
        $DriveSelectionTitle_Label.Font = New-Object System.Drawing.Font("Calibri",11,[System.Drawing.FontStyle]::Bold)
        $DriveSelectionTitle_Label.TextAlign = "MiddleCenter"
        $DriveSelectionTitle_Label.Size = New-Object System.Drawing.Point(150,25)
        $DriveSelectionTitle_Label.Location = New-Object System.Drawing.Point(200,25)

        $DriveSelectionMessage_Label = New-Object $Label_Object
        $DriveSelectionMessage_Label.Text = "Starting Drive Search"
        #$DriveSelectionMessage_Label.Text = "Drive Found : $FoundDrive"
        $DriveSelectionMessage_Label.Font = New-Object System.Drawing.Font("Calibri",11)
        $DriveSelectionMessage_Label.TextAlign = "MiddleCenter"
        $DriveSelectionMessage_Label.Size = New-Object System.Drawing.Point(150,25)
        $DriveSelectionMessage_Label.Location = New-Object System.Drawing.Point(200,50)

        $DriveSelectioinChange_Label = New-Object $Label_Object
        $DriveSelectioinChange_Label.Text = "Change Option"#"$FoundDrive"
        $DriveSelectioinChange_Label.Font = New-Object System.Drawing.Font("Calibri",11)
        $DriveSelectioinChange_Label.TextAlign = "MiddleCenter"
        $DriveSelectioinChange_Label.Size = New-Object System.Drawing.Point(100,25)
        $DriveSelectioinChange_Label.Location = New-Object System.Drawing.Point(190,75)

        $DriveSelectionChoice_Combo = New-Object $Combobox_Object
        $DriveSelectionChoice_Combo.Text = "Selection"
        $DriveSelectionChoice_Combo.TabIndex = 2
        $DriveSelectionChoice_Combo.Font = New-Object System.Drawing.Font("Calibri",11)
        $DriveSelectionChoice_Combo.Size = New-Object System.Drawing.Point(80,26)
        $DriveSelectionChoice_Combo.Location = New-Object System.Drawing.Point(200,100)

        $DriveSelectionChoice_Button = New-Object $Button_Object
        $DriveSelectionChoice_Button.Text = "Set"
        $DriveSelectionChoice_Button.TabIndex = 1
        $DriveSelectionChoice_Button.Font = New-Object System.Drawing.Font("Calibri",11)
        $DriveSelectionChoice_Button.Size = New-Object System.Drawing.Point(75,25)
        $DriveSelectionChoice_Button.Location = New-Object System.Drawing.Point(300,100)
        $DriveSelectionChoice_Button.Add_Click({
            $SelectedDrive = $DriveSelectionChoice_Combo.SelectedItem
            if ($SelectedDrive -eq $null){
                if ($Global:FoundDrive -eq $null){
                    $DriveSelectionMessage_Label.Text = "Nothing Selected"
                    Start-Sleep -Seconds 2
                    $DriveSelection_Form.Dispose()
                }else{
                    #Write-Host "Path : $Global:SelectDrivePath"
                    #Write-Host "FoundDrive : $Global:FoundDrive"
                    if ($Global:SelectDrivePath -eq $null){
                        $DriveSelectionMessage_Label.Text = "No Path Found here"
                        Start-Sleep -Seconds 2
                        $DriveSelection_Form.Dispose()
                    }else{
                        # Disable functionality
                            $DriveSelectionChoice_Combo.Enabled = $false
                            $DriveSelectionChoice_Button.Enabled = $false
                        # Setting Drive
                            $DriveSelectionMessage_Label.Text = "Mounting : $Global:FoundDrive"
                            $ps = "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
			                Start-Process -FilePath $ps -Wait -WindowStyle Hidden -ArgumentList $Global:SelectDrivePath,$Global:FoundDrive
                            $shortcutPath = "$Global:FoundDrive`:\Sysa\Imported\select\shortcut.ps1"
                        # Create Shortcut Test
                            $DriveSelectionMessage_Label.Text = "*Creating Shortcuts*"
                            try{
                                Start-Process -FilePath $ps -Verb RunAs -WindowStyle Hidden -ArgumentList $shortcutPath,$Global:FoundDrive
                            }catch{
                                Write-Error -Message "Failed making shortcut" -ErrorAction Continue
                            }
                        # Check and Create Files directory and Starting Files
                            $DriveSelectionMessage_Label.Text = "*Creating File Directory*"
                            $StartDirPath = "$Global:FoundDrive`:\Sysa"
                            if (Test-Path -Path "$StartDirPath\Files"){
                                Remove-Item -Path "$StartDirPath\Files" -Recurse -Force -Confirm:$false -ErrorAction SilentlyContinue -WarningAction SilentlyContinue | Out-Null
                                New-Item -Path "$StartDirPath\Files" -ItemType File -Name "systems.s" -Force -Confirm:$false -ErrorAction SilentlyContinue -WarningAction SilentlyContinue | Out-Null
                                New-Item -Path "$StartDirPath\Files" -ItemType File -Name "users.u" -Force -Confirm:$false -ErrorAction SilentlyContinue -WarningAction SilentlyContinue | Out-Null
                                New-Item -Path "$StartDirPath\Files" -ItemType File -Name "combo.cb" -Force -Confirm:$false -ErrorAction SilentlyContinue -WarningAction SilentlyContinue | Out-Null
                                New-Item -Path "$StartDirPath\Files" -ItemType File -Name "comboAndGroup.cbg" -Force -Confirm:$false -ErrorAction SilentlyContinue -WarningAction SilentlyContinue | Out-Null
                            }else{
                                New-Item -Path "$StartDirPath\Files" -ItemType File -Name "systems.s" -Force -Confirm:$false -ErrorAction SilentlyContinue -WarningAction SilentlyContinue | Out-Null
                                New-Item -Path "$StartDirPath\Files" -ItemType File -Name "users.u" -Force -Confirm:$false -ErrorAction SilentlyContinue -WarningAction SilentlyContinue | Out-Null
                                New-Item -Path "$StartDirPath\Files" -ItemType File -Name "combo.cb" -Force -Confirm:$false -ErrorAction SilentlyContinue -WarningAction SilentlyContinue | Out-Null
                                New-Item -Path "$StartDirPath\Files" -ItemType File -Name "comboAndGroup.cbg" -Force -Confirm:$false -ErrorAction SilentlyContinue -WarningAction SilentlyContinue | Out-Null
                            }
                        # Display Completion
                            $DriveSelectionMessage_Label.Text = "*Process Complete*"
                            Start-Sleep -Seconds 1
                            $DriveSelectionMessage_Label.Text = "*Please re-open utility*"
                    }
                }
            }else{
                #Write-Host "Path : $Global:SelectDrivePath"
                #Write-Host "FoundDrive : $Global:FoundDrive"
                if ($Global:SelectDrivePath -eq $null){
                    $DriveSelectionMessage_Label.Text = "No Path Found here"
                    Start-Sleep -Seconds 2
                    $DriveSelection_Form.Dispose()
                }else{
                    # Disable functionality
                        $DriveSelectionChoice_Combo.Enabled = $false
                        $DriveSelectionChoice_Button.Enabled = $false
                    # Setting Drive
                        $DriveSelectionMessage_Label.Text = "Mounting : $Global:FoundDrive"
                        $ps = "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
			            Start-Process -FilePath $ps -Wait -WindowStyle Hidden -ArgumentList $Global:SelectDrivePath,$Global:FoundDrive
                        $shortcutPath = "$Global:FoundDrive`:\Sysa\Imported\select\shortcut.ps1"
                    # Create Shortcut Test
                        $DriveSelectionMessage_Label.Text = "*Creating Shortcuts*"
                        try{
                            Start-Process -FilePath $ps -Verb RunAs -WindowStyle Hidden -ArgumentList $shortcutPath,$Global:FoundDrive
                        }catch{
                            Write-Error -Message "Failed making shortcut" -ErrorAction Continue
                        }
                    # Check and Create Files directory and Starting Files
                        $DriveSelectionMessage_Label.Text = "*Creating File Directory*"
                        $StartDirPath = "$Global:FoundDrive`:\Sysa"
                        if (Test-Path -Path "$StartDirPath\Files"){
                            Remove-Item -Path "$StartDirPath\Files" -Recurse -Force -Confirm:$false -ErrorAction SilentlyContinue -WarningAction SilentlyContinue | Out-Null
                            New-Item -Path "$StartDirPath\Files" -ItemType File -Name "systems.s" -Force -Confirm:$false -ErrorAction SilentlyContinue -WarningAction SilentlyContinue | Out-Null
                            New-Item -Path "$StartDirPath\Files" -ItemType File -Name "users.u" -Force -Confirm:$false -ErrorAction SilentlyContinue -WarningAction SilentlyContinue | Out-Null
                            New-Item -Path "$StartDirPath\Files" -ItemType File -Name "combo.cb" -Force -Confirm:$false -ErrorAction SilentlyContinue -WarningAction SilentlyContinue | Out-Null
                            New-Item -Path "$StartDirPath\Files" -ItemType File -Name "comboAndGroup.cbg" -Force -Confirm:$false -ErrorAction SilentlyContinue -WarningAction SilentlyContinue | Out-Null
                        }else{
                            New-Item -Path "$StartDirPath\Files" -ItemType File -Name "systems.s" -Force -Confirm:$false -ErrorAction SilentlyContinue -WarningAction SilentlyContinue | Out-Null
                            New-Item -Path "$StartDirPath\Files" -ItemType File -Name "users.u" -Force -Confirm:$false -ErrorAction SilentlyContinue -WarningAction SilentlyContinue | Out-Null
                            New-Item -Path "$StartDirPath\Files" -ItemType File -Name "combo.cb" -Force -Confirm:$false -ErrorAction SilentlyContinue -WarningAction SilentlyContinue | Out-Null
                            New-Item -Path "$StartDirPath\Files" -ItemType File -Name "comboAndGroup.cbg" -Force -Confirm:$false -ErrorAction SilentlyContinue -WarningAction SilentlyContinue | Out-Null
                        }
                    # Display Completion
                        $DriveSelectionMessage_Label.Text = "*Process Complete*"
                        Start-Sleep -Seconds 1
                        $DriveSelectionMessage_Label.Text = "*Please re-open utility*"
                }
            }
        })

        $DriveSelection_Form.Controls.AddRange(@(
            $SysaLogo_PicBox
            $DriveSelectionTitle_Label
            $DriveSelectionMessage_Label
            $DriveSelectioinChange_Label
            $DriveSelectionChoice_Combo
            $DriveSelectionChoice_Button
        ))

        $DriveSelection_Form.ShowDialog() | Out-Null
		# test drive	
		$Path = "$Drive\Sysa"
		if ((Test-Path -Path "$Drive\Sysa") -and $Path -ne "\Sysa"){
			$Path = "$Drive\Sysa\$Global:AppName$Global:AppVer.ps1"
			Write-Host "*Process Complete*"
			Write-Host "------------------"
			Write-Host "Please re-open utility"
			$DriveSelection_Form.Dispose()
		}else{
			$DriveSelection_Form.Dispose()
		}
	}else{
        #Write-Host "SysaDrive $Drive"
		if (Test-Path -Path "$Drive\Sysa"){
			$Global:Title = ("$Global:AppName : $Global:AppVer").ToString()
			$Global:StartPath = "$Drive\Sysa"
			$Global:AppPackPath = "$Global:StartPath\AppPack"
			$Global:ImportedPath = "$Global:StartPath\Imported"
            $Global:LoopPath = "$Global:ImportedPath\loop\PingIt.ps1"
			Set-Location -Path $Global:StartPath
		# Fonts, and Colors
			$Global:DefaultTogleColorRed = [System.Drawing.Color]::DarkRed
			$Global:DefaultTogleColorGreen = [System.Drawing.Color]::Green
            $Global:DefaultColorWhite = [System.Drawing.Color]::White
            $Global:DefaultColorBlack = [System.Drawing.Color]::Black
            $Global:DefaultColor1_GroupFileLabel = "#bdeefd"
            $Global:DefaultColor2_GroupFileLabel = "#0026b3"
			$Global:DefaultFont9 = New-Object System.Drawing.Font("Arial", 9)
			$Global:DefaultFont10 = New-Object System.Drawing.Font("Arial", 10)
			$Global:DefaultFont10Bold = New-Object System.Drawing.Font("Arial", 10, [System.Drawing.FontStyle]::Bold)
			$Global:DefaultFont11 = New-Object System.Drawing.Font("Arial", 11)
			$Global:DefaultFont10Underline = New-Object System.Drawing.Font("Arial", 10, [System.Drawing.FontStyle]::Underline)
			$Global:DefaultFont12 = New-Object System.Drawing.Font("Arial", 12)
			$Global:DefaultColor1 = "#B70D0D" #Red
			$Global:DefaultColor2 = "#F0EAEA" #Gray
		# User and System Information
			$Global:SystemName = $env:COMPUTERNAME
			$Global:User = $env:USERNAME
		# Date Varibles
            function GetNewDateTime{
			    $Global:FullDateTime = Get-Date -DisplayHint Date -Format "MM/dd/yyyy HH:mm"
            }
            function GetNewDate{
			    $Global:Date = Get-Date -Format "yyyy_MM"
            }
		# Log Variables
            $Global:LogDate = Get-Date -Format "yyyy_MM"
			$Global:SavedLogLocation = "$Global:StartPath\Sysalogs\savedlogs\${Global:LogDate}_sysa.log"
            $Global:SessionLogLocation = "$Global:StartPath\Sysalogs\sessionlog\${Global:LogDate}-SysaSession.log"
			$Global:LogShow = $false
		# ErrorCode Value
			$Global:ErrorCodeVal = 0
			$Global:ErrorMsg = ""
		# Process Variables
			[string]$Global:ProccessName = ""
			$Global:ProcessCompleted = $false
			$Global:Started = $false
		# GroupFile Options
            $Global:MyFile = $null
            [string]$Global:GroupFile_Selected = $null    
			[string]$Global:GroupFile_SelectedPath = $null
			$Global:LoopOption = $false
			$Global:LoopLogPath = "$Global:ImportedPath\loop\PingIt\PingAutoLog.log"
		# MyPack Varaibles
            
        # Session Mode off
			$Global:SessionMode = $false
        # Import Codec
            Import-Module "$Drive\Sysa\Imported\select\codec.ps1" -PassThru -Force -Function extensionCodecCheck, isExt, listValues, checkFormat, getFormat, testConn | Out-Null
		# Functions 
			function ExitLogWrite{
				if ($Global:ErrorCodeVal -ne 0){
					if (Test-Path $Global:ErrorCodeLogLocation){
						Add-Content -Path $Global:ErrorCodeLogLocation -Value ((Get-Date -DisplayHint Date).ToString()+"   :::   U@$User   :::   ExitCode $Global:ErrorCodeVal")
						Write-Host "Exiting with Error Code $Global:ErrorCodeVal"
					}elseif (Test-Path "$Global:StartPath\Sysalogs\errorlogs"){
						Add-Content -Path $Global:ErrorCodeLogLocation -Value ((Get-Date -DisplayHint Date).ToString()+"   :::   U@$User   :::   ExitCode $Global:ErrorCodeVal")
						Write-Host "Exiting with Error Code $Global:ErrorCodeVal"
					}elseif (Test-Path "$Global:StartPath\Sysalogs"){
						New-Item -Path "$Global:StartPath\Sysalogs" -Name "errorlogs" -ItemType Directory -Force -Confirm:$false
						Add-Content -Path $Global:ErrorCodeLogLocation -Value ((Get-Date -DisplayHint Date).ToString()+"   :::   U@$User   :::   ExitCode $Global:ErrorCodeVal")
						Write-Host "Exiting with Error Code $Global:ErrorCodeVal"
					}else{
						New-Item -Path $Global:StartPath -Name "Sysalogs" -ItemType Directory -Force -Confirm:$false
						New-Item -Path "$Global:StartPath\Sysalogs" -Name "errorlogs" -ItemType Directory -Force -Confirm:$false
						Add-Content -Path $Global:ErrorCodeLogLocation -Value ((Get-Date -DisplayHint Date).ToString()+"   :::   U@$User   :::   ExitCode $Global:ErrorCodeVal")
						Write-Host "Exiting with Error Code $Global:ErrorCodeVal"
					}
				}
			}
            
            function checkFiles{
                $Global:GroupFileOptions = Get-ChildItem -Path "$Global:StartPath\Files" -File | Select -Property BaseName,Name,Extension
                if ($Global:GroupFileOptions -eq $null){
					$Global:ErrorCodeVal += "547;"
					ExitLogWrite
					LocalLogWrite "Failed to load GroupFile Options"
                    LocalLogWrite "*---------------------------------*"
                }else{
                    $GroupFileSelection_ComboBox.Items.Clear() | Out-Null
                    $Global:GroupFileCount = $Global:GroupFileOptions.Count
                    for ($i = 0; $i -lt $Global:GroupFileCount; $i++){
                        [string]$Type = $Global:GroupFileOptions[$i].Extension
                        if ($Type -eq ".u"){
                            $GroupFileSelection_ComboBox.Items.Add($Global:GroupFileOptions[$i].Name) | Out-Null
                        }elseif($Type -eq ".s"){
                            $GroupFileSelection_ComboBox.Items.Add($Global:GroupFileOptions[$i].Name) | Out-Null
                        }elseif($Type -eq ".cb"){
                            $GroupFileSelection_ComboBox.Items.Add($Global:GroupFileOptions[$i].Name) | Out-Null
                        }elseif($Type -eq ".cbg"){
                            $GroupFileSelection_ComboBox.Items.Add($Global:GroupFileOptions[$i].Name) | Out-Null
                        }else{
                            $t = $Global:GroupFileOptions[$i].Name
                            LocalLogWrite "ERR: Failed to Load : $t"
                            if (Test-Path "$Global:StartPath\Files\qt"){
                                if (Test-Path "$Global:StartPath\Files\qt\$t"){
                                    $n = 1
                                    function checkDuplicate{
                                        if (-not (Test-Path "$Global:StartPath\Files\qt\$t($n)")){
                                            Move-Item -Path "$Global:StartPath\Files\$t" -Destination "$Global:StartPath\Files\qt\$t($n)" -Force -Confirm:$false | Out-Null
                                            LocalLogWrite "I Moved file to quarantine '$Global:StartPath\Files\qt'"
                                            LocalLogWrite "*---------------------------------*"
                                        }else{
                                            $n++
                                            checkDuplicate
                                        }
                                    }
                                    checkDuplicate
                                    $n = $null
                                }else{
                                    Move-Item -Path "$Global:StartPath\Files\$t" -Destination "$Global:StartPath\Files\qt\$t" -Force -Confirm:$false | Out-Null
                                    LocalLogWrite "You Moved file to quarantine '$Global:StartPath\Files\qt'"
                                    LocalLogWrite "*---------------------------------*"
                                }
                            }else{
                                New-Item -Name "qt" -ItemType Directory -Path "$Global:StartPath\Files" -Force -Confirm:$false | Out-Null
                                Move-Item -Path "$Global:StartPath\Files\$t" -Destination "$Global:StartPath\Files\qt\$t" -Force -Confirm:$false | Out-Null
                                LocalLogWrite "You Moved file to quarantine '$Global:StartPath\Files\qt'"
                                LocalLogWrite "*---------------------------------*"
                            }
                        }
                    }
                }
            }
##############################################
##############################################
#    Create Form
##############################################

# Create Toolbar Menu
##############################################
        # Toolbar Srip
			$ToolbarStrip = New-Object $ToolbarMenuStrip_Object
            $ToolbarStrip.BackColor = "#E5E4E2"
            $ToolbarStrip.Font = New-Object System.Drawing.Font("Arial",10)
            # FILE Menu
            $ToolbarStrip_File = New-Object System.Windows.Forms.ToolStripMenuItem("File")
            # EDIT Menu
            $ToolbarStrip_Edit = New-Object System.Windows.Forms.ToolStripMenuItem("Edit")
            # ADD-ON Menu
            $ToolbarStrip_Run = New-Object System.Windows.Forms.ToolStripMenuItem("Run")
            # HELP Menu
            $ToolbarStrip_Help = New-Object System.Windows.Forms.ToolStripMenuItem("Help")

			# FILE Drop Down List
            $FileMenuItem_NewSession = New-Object System.Windows.Forms.ToolStripMenuItem("New Session")
            $FileMenuItem_NewSession.Enabled = $false
			$FileMenuItem_NewSession.Add_Click({
                # Single Clear
				$Username_Textbox.Text = $null
				$System_Textbox.Text = $null
				$Username_Checkbox.Checked = $false
				$System_Checkbox.Checked = $false
				$Combo_Checkbox.Checked = $false
				$Action_Combobox.Text = "Action"
				$ScriptSelect_Combobox.Text = "Script"
                # GroupFile Clear
                $Global:MyFile = $null
                $Extension =$null
                $Global:GroupFile_RunType = $null
				$GroupFileSelection_ComboBox.Text = $null
                $Global:GroupFile_Selected = $null
				$Global:GroupFile_SelectedPath = $null
                $GroupFileSelection_Label.Text = "<File Selected>"
                $GroupFileSelection_Label.BackColor = $Global:DefaultColor1_GroupFileLabel
                $GroupFileLoop_Checkbox.Checked = $false
                $GroupFileScriptSelection_Combobox.SelectedIndex = -1
                $GroupFileScriptSelection_Combobox.Text = ""
                $GroupFileFormat_Label.Text = "<Format>"
                # Start Session
				$FileMenuItem_SessionLog.Checked = $true
				$MainForm.ClientSize = "640,425"
				$DropLog_Label.Text = "hide"
                $DropLog_Label.Location = New-Object System.Drawing.Point(580,400)
                $DriveLetter_Label.Location = New-Object System.Drawing.Point(10,400)
				$Global:LogShow = $true
                GetNewDateTime
                $DisplayLog_RichTextBox.Text = "Session Started : $Global:FullDateTime`n---------------------------------------------------------"
                $Global:SessionStart = "Session Started : $Global:FullDateTime`n---------------------------------------------------------"
			})
			$FileMenuItem_SaveLog = New-Object System.Windows.Forms.ToolStripMenuItem("Save Log")
            $FileMenuItem_SaveLog.Enabled = $false
            $FileMenuItem_SaveLog.Add_Click({
                $t = 3
                if (-not ($Global:SessionMode)){
                    if ($DisplayLog_RichTextBox.Text -ne "" -and $DisplayLog_RichTextBox.Text -ne $null){
                        if ($Global:SessionStart -ne $DisplayLog_RichTextBox.Text){
                            [string]$LogPath = $Global:SavedLogLocation
                            if (Test-Path "$Global:StartPath\Sysalogs\savedlogs"){
                                Add-Content -Path $LogPath -Value $DisplayLog_RichTextBox.Text 
                                LocalLogWrite "**Log Saved"
                                LocalLogWrite "Location : $Global:SavedLogLocation"
                                LocalLogWrite "Clearing Log."
                                Start-Sleep -Seconds $t
                                $DisplayLog_RichTextBox.Text = ""
                            }else{
                                New-Item -Name "savedlogs" -ItemType Directory -Path "$Global:StartPath\Sysalogs" -Confirm:$false -Force | Out-Null
                                Add-Content -Path $LogPath -Value $DisplayLog_RichTextBox.Text 
                                LocalLogWrite "**Log Saved"
                                LocalLogWrite "Location : $Global:SavedLogLocation"
                                LocalLogWrite "Clearing Log."
                                Start-Sleep -Seconds $t
                                $DisplayLog_RichTextBox.Text = ""
                            }
                        }
                    }
                }else{
                LocalLogWrite "Session Logging in place. Saving and Closing the Session. A New Session will start afterwards."
                }
            })
			$FileMenuItem_SessionLog = New-Object System.Windows.Forms.ToolStripMenuItem("Session Log")
			$FileMenuItem_SessionLog.Checked = $false
			$FileMenuItem_SessionLog.Add_Click({
				if ($FileMenuItem_SessionLog.Checked -eq $true){
                    $Global:SessionMode = $false
                    $FileMenuItem_NewSession.Enabled = $false
					$FileMenuItem_SessionLog.Checked = $false
                    $DisplayLog_RichTextBox.Text = ""
                    # Single Clear
				    $Username_Textbox.Text = $null
				    $System_Textbox.Text = $null
				    $Username_Checkbox.Checked = $false
				    $System_Checkbox.Checked = $false
				    $Combo_Checkbox.Checked = $false
                    $Action_Combobox.SelectedIndex = -1
				    $Action_Combobox.Text = ""
                    $ScriptSelect_Combobox.SelectedIndex = -1
				    $ScriptSelect_Combobox.Text = ""
                    # GroupFile Clear
                    $Global:MyFile = $null
                    $Extension =$null
                    $Global:GroupFile_RunType = $null
				    $GroupFileSelection_ComboBox.Text = $null
                    $Global:GroupFile_Selected = $null
				    $Global:GroupFile_SelectedPath = $null
                    $GroupFileSelection_Label.Text = "<File Selected>"
                    $GroupFileSelection_Label.BackColor = $Global:DefaultColor1_GroupFileLabel
                    $GroupFileLoop_Checkbox.Checked = $false
                    $GroupFileScriptSelection_Combobox.SelectedItem = $null

                    $GroupFileScriptSelection_Combobox.Text = ""
                    $GroupFileFormat_Label.Text = "<Format>"
				}else{
                    # Single Clear
				    $Username_Textbox.Text = $null
				    $System_Textbox.Text = $null
				    $Username_Checkbox.Checked = $false
				    $System_Checkbox.Checked = $false
				    $Combo_Checkbox.Checked = $false
                    $Action_Combobox.SelectedIndex = -1
				    $Action_Combobox.Text = ""
                    $ScriptSelect_Combobox.SelectedIndex = -1
				    $ScriptSelect_Combobox.Text = ""
                    # GroupFile Clear
                    $Global:MyFile = $null
                    $Extension =$null
                    $Global:GroupFile_RunType = $null
				    $GroupFileSelection_ComboBox.Text = $null
                    $Global:GroupFile_Selected = $null
				    $Global:GroupFile_SelectedPath = $null
                    $GroupFileSelection_Label.Text = "<File Selected>"
                    $GroupFileSelection_Label.BackColor = $Global:DefaultColor1_GroupFileLabel
                    $GroupFileLoop_Checkbox.Checked = $false
                    $GroupFileScriptSelection_Combobox.SelectedItem = $null
                    $GroupFileScriptSelection_Combobox.Text = ""
                    $GroupFileFormat_Label.Text = "<Format>"
                    # Start Session
                    $Global:SessionMode = $true
                    $FileMenuItem_NewSession.Enabled = $true
					$FileMenuItem_SessionLog.Checked = $true
					$MainForm.ClientSize = "640,425"
					$DropLog_Label.Text = "hide"
                    $DropLog_Label.Location = New-Object System.Drawing.Point(580,400)
                    $DriveLetter_Label.Location = New-Object System.Drawing.Point(10,400)
					$Global:LogShow = $true
                    GetNewDateTime
                    $DisplayLog_RichTextBox.Text = "Session Started : $Global:FullDateTime`n---------------------------------------------------------"
                    $Global:SessionStart = "Session Started : $Global:FullDateTime`n---------------------------------------------------------"
				}
			})
            $FileMenuItem_SaveClose = New-Object System.Windows.Forms.ToolStripMenuItem("Save and Close Session")
            $FileMenuItem_SaveClose.Enabled = $false
            $FileMenuItem_SaveClose.Add_Click({
                $t = 3
                if ($Global:SessionMode){
                    if ($DisplayLog_RichTextBox.Text -ne "" -and $DisplayLog_RichTextBox.Text -ne $null){
                        if ($Global:SessionStart -ne $DisplayLog_RichTextBox.Text){
                            [string]$LogPath = $Global:SessionLogLocation
                            if (Test-Path "$Global:StartPath\Sysalogs\sessionlog"){
                                Add-Content -Path $LogPath -Value $DisplayLog_RichTextBox.Text 
                                LocalLogWrite "**Log Saved"
                                LocalLogWrite "Location : $Global:SessionLogLocation"
                                LocalLogWrite "Clearing Log Please wait..."
                                Start-Sleep -Seconds $t
                                GetNewDateTime
                                $DisplayLog_RichTextBox.Text = "Session Started : $Global:FullDateTime`n---------------------------------------------------------"
                                $Global:SessionStart = "Session Started : $Global:FullDateTime`n---------------------------------------------------------"
                            }else{
                                New-Item -Name "sessionlog" -ItemType Directory -Path "$Global:StartPath\Sysalogs" -Confirm:$false -Force | Out-Null
                                Add-Content -Path $LogPath -Value $DisplayLog_RichTextBox.Text 
                                LocalLogWrite "**Log Saved"
                                LocalLogWrite "Location : $Global:SessionLogLocation"
                                LocalLogWrite "Clearing Log"
                                Start-Sleep -Seconds $t
                                $Global:FullDateTime = Get-Date -DisplayHint Date
                                GetNewDateTime
                                $DisplayLog_RichTextBox.Text = "Session Started : $Global:FullDateTime`n---------------------------------------------------------"
                                $Global:SessionStart = "Session Started : $Global:FullDateTime`n---------------------------------------------------------"
                            }
                        }
                    }
                }else{
                    LocalLogWrite "No Session started"
                }
            })
			# EDIT Drop Down List
			$EditMenuItem_ClearSingleSelect = New-Object System.Windows.Forms.ToolStripMenuItem("Clear Single Selection")
			$EditMenuItem_ClearSingleSelect.Add_Click({
				$Username_Textbox.Text = $null
				$System_Textbox.Text = $null
				$Username_Checkbox.Checked = $false
				$System_Checkbox.Checked = $false
				$Combo_Checkbox.Checked = $false
                $Action_Combobox.SelectedIndex = -1
				$Action_Combobox.Text = ""
                $ScriptSelect_Combobox.SelectedIndex = -1
				$ScriptSelect_Combobox.Text = ""
			})
			
			$EditMenuItem_ClearGroupFileSelect = New-Object System.Windows.Forms.ToolStripMenuItem("Clear Group File Selection")
			$EditMenuItem_ClearGroupFileSelect.Add_Click({
                $Global:MyFile = $null
                $Extension =$null
                $Global:GroupFile_RunType = $null
				$GroupFileSelection_ComboBox.Text = $null
                $Global:GroupFile_Selected = $null
				$Global:GroupFile_SelectedPath = $null
                $GroupFileSelection_Label.Text = "<File Selected>"
                $GroupFileSelection_Label.BackColor = $Global:DefaultColor1_GroupFileLabel
                $GroupFileLoop_Checkbox.Checked = $false
                $GroupFileScriptSelection_Combobox.SelectedIndex = -1
                $GroupFileScriptSelection_Combobox.Text = ""
                $GroupFileFormat_Label.Text = "<Format>"         
			})
			$EditMenuItem_ClearAllSelect = New-Object System.Windows.Forms.ToolStripMenuItem("Clear All Selections")
            $EditMenuItem_ClearAllSelect.Add_Click({
                # Single Clear
				$Username_Textbox.Text = $null
				$System_Textbox.Text = $null
				$Username_Checkbox.Checked = $false
				$System_Checkbox.Checked = $false
				$Combo_Checkbox.Checked = $false
                $Action_Combobox.SelectedIndex = -1
				$Action_Combobox.Text = ""
                $ScriptSelect_Combobox.SelectedIndex = -1
				$ScriptSelect_Combobox.Text = ""
                # GroupFile Clear
				$GroupFileSelection_ComboBox.Text = $null
				$Global:GroupFile_SelectedPath = $null
                $GroupFileSelection_Label.Text = "<File Selected>"
                $GroupFileSelection_Label.BackColor = $Global:DefaultColor1_GroupFileLabel
                $GroupFileLoop_Checkbox.Checked = $false
                $GroupFileScriptSelection_Combobox.SelectedIndex = -1
                $GroupFileScriptSelection_Combobox.Text = ""
                $GroupFileFormat_Label.Text = "<Format>"
            })
            $EditMenuItem_ClearLog = New-Object System.Windows.Forms.ToolStripMenuItem("Clear Log")
            $EditMenuItem_ClearLog.Add_Click({
                # Import MyPack Confirmation Form

                ##############################################
                ##############################################

                    $ClearLogConfirmation_Form = New-Object $Form_Object
                    $ClearLogConfirmation_Form.Text = "Confirm Clear"
                    $ClearLogConfirmation_Form.ClientSize = New-Object System.Drawing.Point(250,125)
	                $ClearLogConfirmation_Form.FormBorderStyle = "Fixed3D" #FixedDialog, Fixed3D
	                $ClearLogConfirmation_Form.StartPosition = [Windows.Forms.FormStartPosition]::CenterScreen
	                $ClearLogConfirmation_Form.Icon = $Global:imgIcon
                    $ClearLogConfirmation_Form.Add_FormClosing({
                        $ClearLogConfirmation_Form.Dispose()
                    })

                    $ClearLogConfirmation_Label = New-Object $Label_Object
                    $ClearLogConfirmation_Label.Text = "Are you sure you want`nto clear the log?"
                    $ClearLogConfirmation_Label.Font = New-Object System.Drawing.Font("Calibri",11)
                    $ClearLogConfirmation_Label.TextAlign = "MiddleCenter"
                    $ClearLogConfirmation_Label.AutoSize = $true
                    $ClearLogConfirmation_Label.Location = New-Object System.Drawing.Point(55,20)

                    $ClearLogConfirmationConfirm_Button = New-Object $Button_Object
                    $ClearLogConfirmationConfirm_Button.Text = "Yes"
                    $ClearLogConfirmationConfirm_Button.Font = New-Object System.Drawing.Font("Calibri",11)
                    $ClearLogConfirmationConfirm_Button.Size = New-Object System.Drawing.Point(80,25)
                    $ClearLogConfirmationConfirm_Button.Location = New-Object System.Drawing.Point(15,80)
                    $ClearLogConfirmationConfirm_Button.Add_Click({
                        # Clear Logs
                        if ($FileMenuItem_SessionLog.Checked){
                            if (-not ($DisplayLog_RichTextBox.Text -eq $Global:SessionStart)){
                                if ($Global:Imported = $true){
                                    $DisplayLog_RichTextBox.Text = "$Global:SessionStart`n$Global:SessionImportedFile"
                                }else{
                                    $DisplayLog_RichTextBox.Text = $Global:SessionStart
                                }
                            }   
                        }else{
                            $DisplayLog_RichTextBox.Text = ""
                        }
                        $ClearLogConfirmation_Form.Dispose()
                    })

                    $ClearLogConfirmationCancel_Button = New-Object $Button_Object
                    $ClearLogConfirmationCancel_Button.Text = "Cancel"
                    $ClearLogConfirmationCancel_Button.Font = New-Object System.Drawing.Font("Calibri",11)
                    $ClearLogConfirmationCancel_Button.Size = New-Object System.Drawing.Point(80,25)
                    $ClearLogConfirmationCancel_Button.Location = New-Object System.Drawing.Point(155,80)
                    $ClearLogConfirmationCancel_Button.Add_Click({
                        $ClearLogConfirmation_Form.Dispose()
                    })

                    $ClearLogConfirmation_Form.Controls.AddRange(@(
                        $ClearLogConfirmation_Label
                        $ClearLogConfirmationConfirm_Button
                        $ClearLogConfirmationCancel_Button
                    ))

                    $ClearLogConfirmation_Form.ShowDialog() | Out-Null
            })

            # Run Drop Down List
            $RunMenuItem_ImportMyPack = New-Object System.Windows.Forms.ToolStripMenuItem("Import MyPack")
            $RunMenuItem_ImportMyPack.Enabled = $false
            $RunMenuItem_ImportMyPack.Add_Click({
                $Global:info = $null
                $Global:MyPackPath = "$Global:AppPackPath\MyPack"
                if (Test-Path "$Global:MyPackPath\Pack\MyPack.in"){
                    # Check Imported
                        $Global:info = Get-Content -Path "$Global:MyPackPath\Pack\MyPack.in" -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
                            # Shorten the MyPack info if over $foundIndex
                                $foundIndex = 100
                                if ($Global:info.Length -gt $foundIndex){
                                    #$foundIndex = $foundIndex - 1 
                                        $tempName = $Global:info.Substring(0,($foundIndex-1))
                                        $checkSpace = $Global:info.Substring($foundIndex,1)
                                        if ($checkSpace -eq " " -or $checkSpace -eq "" -or $checkSpace -eq $null){
                                            # Check
                                            # Done

                                        }else{
                                            # check if
                                                function loop{
                                                    if ($foundIndex -eq 0){
                                                        break
                                                    }
                                                    $checkSpace = $Global:info.Substring(($foundIndex-1),1)
                                                    if ($checkSpace -eq " " -or $checkSpace -eq "" -or $checkSpace -eq $null){
                                                        $foundIndex = $foundIndex - 1
                                                        loop
                                                    }else{
                                                        $tempName = $Global:info.Substring(0,$foundIndex)
                                                        if (($tempName.Length +3) -le 100){
                                                            $Global:info = "$tempName..."
                                                        }else{
                                                            $foundIndex = $foundIndex - 1
                                                            loop
                                                        }
                                                    }
                                                }
                                                loop
                                        }
                                }
                        if (-not ($Global:info -eq $null -or $Global:info -eq "")){
                            #$Global:MyPack = Get-Content -Path "$Global:MyPackPath\Pack\MyPack.in"
                            # Import MyPack Confirmation Form

                                ##############################################
                                ##############################################

                                    $ImportMyPackConfirmation_Form = New-Object $Form_Object
                                    $ImportMyPackConfirmation_Form.Text = "MyPack - Import"
                                    $ImportMyPackConfirmation_Form.ClientSize = New-Object System.Drawing.Point(250,155)
                                    $ImportMyPackConfirmation_Form.FormBorderStyle = "Fixed3D" #FixedDialog, Fixed3D
                                    $ImportMyPackConfirmation_Form.StartPosition = [Windows.Forms.FormStartPosition]::CenterScreen
                                    $ImportMyPackConfirmation_Form.Icon = $Global:imgIcon
                                    $ImportMyPackConfirmation_Form.Add_FormClosing({
                                        $ImportMyPackConfirmation_Form.Dispose()
                                    })

                                    $ImportMyPackConfirmation_Label = New-Object $Label_Object
                                    $ImportMyPackConfirmation_Label.Text = "Do you want to import`n${Global:info}?"
                                    $ImportMyPackConfirmation_Label.Font = New-Object System.Drawing.Font("Calibri",11)
                                    $ImportMyPackConfirmation_Label.TextAlign = "MiddleCenter"
                                    $ImportMyPackConfirmation_Label.Size = New-Object System.Drawing.Point(250,100)
                                    $ImportMyPackConfirmation_Label.Location = New-Object System.Drawing.Point(0,10)

                                    $ImportMyPackConfirmationConfirm_Button = New-Object $Button_Object
                                    $ImportMyPackConfirmationConfirm_Button.Text = "Yes"
                                    $ImportMyPackConfirmationConfirm_Button.Font = New-Object System.Drawing.Font("Calibri",11)
                                    $ImportMyPackConfirmationConfirm_Button.Size = New-Object System.Drawing.Point(80,25)
                                    $ImportMyPackConfirmationConfirm_Button.Location = New-Object System.Drawing.Point(20,120)
                                    $ImportMyPackConfirmationConfirm_Button.Add_Click({
                                        # Clear all ScriptS
                                        $ScriptSelect_Combobox.Items.Clear()
                                        # Import AppPack
			                            $Global:ScriptSelect = Get-ChildItem -Path "$Global:AppPackPath\Single" -File | Select -Property BaseName,Name,Extension
			                            if ($Global:ScriptSelect -eq $null){
				                            $Global:ErrorCodeVal += "204;"
				                            ExitLogWrite
                                            LocalLogWrite "ERR: Failed Importing Sysa AppPack (Single)"
				                            #LocalLogWrite "Failed to load Single Option Scripts"
			                            }else{
			                                $Global:ScriptSelectCount = $Global:ScriptSelect.Count
                                            if ($Global:ScriptSelectCount -eq $null){
                                                $Global:ScriptSelectCount = 1
                                            }
			                                for ($i = 0; $i -lt $Global:ScriptSelectCount; $i++){
				                                if ($Global:ScriptSelect[$i].Name -ne "AppPack.in"){
                                                    if ($Global:ScriptSelect[$i].Name -ne "README.txt"){
					                                    $FileName = $Global:ScriptSelect[$i].BaseName
					                                    $ScriptSelect_Combobox.Items.Add($FileName) | Out-Null
				                                    }
                                                }
			                                }
                                        }
                                        # Import MyPack
                                        $Global:MyPackSelect = Get-ChildItem -Path "$Global:MyPackPath\Pack" -File | Select -Property BaseName,Name,Extension
		                                if ($Global:MyPackSelect -eq $null){
			                                $Global:ErrorCodeVal = 673
			                                ExitLogWrite
                                            LocalLogWrite "ERR: Failed Importing Pack"
			                                #LocalLogWrite "Failed to load Single Option Scripts"
		                                }else{
                                            $Global:MyPackSelectCount = $Global:MyPackSelect.Count
                                            if ($Global:MyPackSelectCount -eq $null){
                                                $Global:MyPackSelectCount = 1
                                            }
		                                    for ($i = 0; $i -lt $Global:MyPackSelectCount; $i++){
			                                    if ($Global:MyPackSelect[$i].Name -ne "MyPack.in"){
                                                    if ($Global:MyPackSelect[$i].Name -ne "README.txt"){
				                                        $FileName = $Global:MyPackSelect[$i].BaseName
				                                        $ScriptSelect_Combobox.Items.Add($FileName) | Out-Null
			                                        }
                                                }
		                                    }
                                            $Global:Imported = $true
                                            $RunMenuItem_ImportMyPack.Enabled = $false
                                            LocalLogWrite "Imported MyPack : '$Global:info'"
                                        }
                                        LocalLogWrite "*---------------------------------*"
                                        $ImportMyPackConfirmation_Form.Dispose()
                                    })

                                    $ImportMyPackConfirmationCancel_Button = New-Object $Button_Object
                                    $ImportMyPackConfirmationCancel_Button.Text = "Cancel"
                                    $ImportMyPackConfirmationCancel_Button.Font = New-Object System.Drawing.Font("Calibri",11)
                                    $ImportMyPackConfirmationCancel_Button.Size = New-Object System.Drawing.Point(80,25)
                                    $ImportMyPackConfirmationCancel_Button.Location = New-Object System.Drawing.Point(150,120)
                                    $ImportMyPackConfirmationCancel_Button.Add_Click({
                                        $ImportMyPackConfirmation_Form.Dispose()
                                    })

                                    $ImportMyPackConfirmation_Form.Controls.AddRange(@(
                                        $ImportMyPackConfirmationConfirm_Button
                                        $ImportMyPackConfirmationCancel_Button
                                        $ImportMyPackConfirmation_Label
                                    ))

                                    $ImportMyPackConfirmation_Form.ShowDialog() | Out-Null
                        }else{
                            LocalLogWrite "MyPack.in file has no contents"
                            # check if there is contents
                            $contCheck = $null
                            $contCheck = Get-ChildItem -Path "$Global:MyPackPath\Pack"
                            if ($contCheck){
                                $qtdt = $null
                                $qtdt = Get-Date -Format MM.dd.yy_HH.mm.ss
                                LocalLogWrite "Bad info File. Found Pack Contents."
                                New-Item -Name "qt" -ItemType Directory -Path "$Global:MyPackPath" -Force -Confirm:$false | Out-Null
                                Compress-Archive -Path "$Global:MyPackPath\Pack" -DestinationPath "$Global:MyPackPath\qt\$qtdt`_qtp.zip" -Update -Confirm:$false | Out-Null
                                Remove-Item -Path "$Global:MyPackPath\Pack" -Recurse -Force -Confirm:$false | Out-Null
                                New-Item -Name "Pack" -ItemType Directory -Path "$Global:MyPackPath" -Force -Confirm:$false | Out-Null
                                LocalLogWrite "ERR: Pack invalid. Sent to quarantine. '$Global:MyPackPath\qt\$qtdt`_qtp'"
                            }
                            LocalLogWrite "*---------------------------------*"
                        }
                    $RunMenuItem_ImportMyPack.Enabled = $false
                }else{
                    LocalLogWrite "No MyPack.in file found"
                    # check if there is contents
                    $contCheck = $null
                    $contCheck = Get-ChildItem -Path "$Global:MyPackPath\Pack"
                    if ($contCheck){
                        $qtdt = $null
                        $qtdt = Get-Date -Format MM.dd.yy_HH.mm.ss
                        LocalLogWrite "Bad info File. Found Pack Contents."
                        New-Item -Name "qt" -ItemType Directory -Path "$Global:MyPackPath" -Force -Confirm:$false | Out-Null
                        Compress-Archive -Path "$Global:MyPackPath\Pack" -DestinationPath "$Global:MyPackPath\qt\$qtdt`_qtp.zip" -Update -Confirm:$false | Out-Null
                        Remove-Item -Path "$Global:MyPackPath\Pack" -Recurse -Force -Confirm:$false | Out-Null
                        New-Item -Name "Pack" -ItemType Directory -Path "$Global:MyPackPath" -Force -Confirm:$false | Out-Null
                        LocalLogWrite "ERR: Pack invalid. Sent to quarantine. '$Global:MyPackPath\qt\$qtdt`_qtp'"
                    }
                    LocalLogWrite "*---------------------------------*"
                }
                $RunMenuItem_ImportMyPack.Enabled = $false
            })
            $RunMenuItem_LoadMyPack = New-Object System.Windows.Forms.ToolStripMenuItem("Load MyPack")
            $RunMenuItem_LoadMyPack.Add_Click({
                $Global:MyPackPath = "$Global:AppPackPath\MyPack"
                $Global:MyPack_Packs = Get-ChildItem $Global:MyPackPath -Directory -Exclude "Pack","qt" | select -ExpandProperty Name 
                    # Load MyPack Form

                    ##############################################
                    ##############################################

                    $LoadMyPack_Form = New-Object $Form_Object
                    $LoadMyPack_Form.Text = "MyPack - Load"
                    $LoadMyPack_Form.ClientSize = New-Object System.Drawing.Point(250,125)
                    $LoadMyPack_Form.FormBorderStyle = "Fixed3D" #FixedDialog, Fixed3D
                    $LoadMyPack_Form.StartPosition = [Windows.Forms.FormStartPosition]::CenterScreen
                    $LoadMyPack_Form.Icon = $Global:imgIcon
                    $LoadMyPack_Form.Add_FormClosing({
                        $LoadMyPack_Form.Dispose()
                    })

                    $LoadMyPack_Label = New-Object $Label_Object
                    $LoadMyPack_Label.Text = "Select Pack to Load"
                    $LoadMyPack_Label.Font = New-Object System.Drawing.Font("Calibri",11)
                    $LoadMyPack_Label.TextAlign = "MiddleCenter"
                    $LoadMyPack_Label.Size = New-Object System.Drawing.Point(150,25)
                    $LoadMyPack_Label.Location = New-Object System.Drawing.Point(55,20)

                    $LoadMyPack_Combo = New-Object $Combobox_Object
                    $LoadMyPack_Combo.Text = ""
                    $LoadMyPack_Combo.Font = $Global:DefaultFont10
                    $LoadMyPack_Combo.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList   #DropDown
                    $LoadMyPack_Combo.Size = New-Object System.Drawing.Point(152,25)
                    $LoadMyPack_Combo.Location = New-Object System.Drawing.Point(55,60)
                    foreach ($pack in $Global:MyPack_Packs){
                        $LoadMyPack_Combo.Items.Add($pack)
                    }

                    $LoadMyPack_Button = New-Object $Button_Object
                    $LoadMyPack_Button.Text = "Load"
                    $LoadMyPack_Button.Font = $Global:DefaultFont10
                    $LoadMyPack_Button.AutoSize = $true
                    $LoadMyPack_Button.Location = New-Object System.Drawing.Point(95,90)
                    $LoadMyPack_Button.Add_Click({
                        $Global:MyPackLoad = $LoadMyPack_Combo.SelectedItem
                        if ($Global:MyPackLoad -ne $null){
                            # Import AppPack
				            $Global:ScriptSelect = Get-ChildItem -Path "$Global:AppPackPath\Single" -File | Select -Property BaseName,Name,Extension
				            if ($Global:ScriptSelect -eq $null){
					            $Global:ErrorCodeVal += "204;"
					            ExitLogWrite
					            LocalLogWrite "ERR: Failed Loading Pack"
				            }else{
                                # Clear all ScriptS
                                    $ScriptSelect_Combobox.Items.Clear()

                                    $Global:Imported = $false
				                    $Global:ScriptSelectCount = $Global:ScriptSelect.Count
                                    if ($Global:ScriptSelectCount -eq $null){
                                        $Global:ScriptSelectCount = 1
                                    }
				                    for ($i = 0; $i -lt $Global:ScriptSelectCount; $i++){
					                    if ($Global:ScriptSelect[$i].Name -ne "AppPack.in"){
                                            if ($Global:ScriptSelect[$i].Name -ne "README.txt"){
						                        $FileName = $Global:ScriptSelect[$i].BaseName
						                        $ScriptSelect_Combobox.Items.Add($FileName) | Out-Null
					                        }
                                        }
				                    }
                                # Remove MyPack\Pack contents
                                    Remove-Item -Path "$Global:AppPackPath\MyPack\Pack" -Recurse -Force -Confirm:$false | Out-Null
                                
                                # Load New Pack Selected
                                    Copy-Item -Path "$Global:AppPackPath\MyPack\$Global:MyPackLoad" -Destination "$Global:AppPackPath\MyPack\Pack" -Recurse  -Force -Confirm:$false | Out-Null
                                    LocalLogWrite "Loaded $Global:MyPackLoad Pack"
                                    $RunMenuItem_ImportMyPack.Enabled = $true
                            }
                            $tempName = $null
                            $foundIndex = $null
                            $checkSpace = $null
                            LocalLogWrite "*---------------------------------*"
                            $LoadMyPack_Form.Dispose()
                        } # else do nothing
                    })

                    $LoadMyPack_Form.Controls.AddRange(@(
                        $LoadMyPack_Label
                        $LoadMyPack_Combo
                        $LoadMyPack_Button
                    ))
                    $LoadMyPack_Form.ShowDialog() | Out-Null
            })
            $RunMenuItem_ClearMyPack = New-Object System.Windows.Forms.ToolStripMenuItem("Clear MyPack")
            $RunMenuItem_ClearMyPack.Add_Click({
                $Global:info = $null
                $Global:MyPackPath = "$Global:AppPackPath\MyPack"
                # Check Imported
                $Global:info = Get-Content -Path "$Global:MyPackPath\Pack\MyPack.in" -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
                        # Shorten the MyPack info if over $foundIndex
                            $foundIndex = 100
                            if ($Global:info.Length -gt $foundIndex){
                                #$foundIndex = $foundIndex - 1 
                                    $tempName = $Global:info.Substring(0,($foundIndex-1))
                                    $checkSpace = $Global:info.Substring($foundIndex,1)
                                    if ($checkSpace -eq " " -or $checkSpace -eq "" -or $checkSpace -eq $null){
                                        # Check
                                        # Done

                                    }else{
                                        # check if
                                            function loop{
                                               if ($foundIndex -eq 0){
                                                    break
                                                }
                                                $checkSpace = $Global:info.Substring(($foundIndex-1),1)
                                                if ($checkSpace -eq " " -or $checkSpace -eq "" -or $checkSpace -eq $null){
                                                    $foundIndex = $foundIndex - 1
                                                    loop
                                                }else{
                                                    $tempName = $Global:info.Substring(0,$foundIndex)
                                                    if (($tempName.Length +3) -le 100){
                                                        $Global:info = "$tempName..."
                                                    }else{
                                                        $foundIndex = $foundIndex - 1
                                                        loop
                                                    }
                                                }
                                            }
                                            loop
                                    }
                            }
                if ($Global:info -eq $null -or $Global:info -eq ""){
                    # Check for Pack Directory
                    if (Test-Path "$Global:MyPackPath\Pack"){
                        # check if there is contents
                        $contCheck = $null
                        $contCheck = Get-ChildItem -Path "$Global:MyPackPath\Pack"
                        if ($contCheck){
                            $qtdt = $null
                            $qtdt = Get-Date -Format MM.dd.yyy_HH.mm.ss
                            LocalLogWrite "Bad Pack File"
                            LocalLogWrite "Found Contents"
                            New-Item -Name "qt" -ItemType Directory -Path "$Global:MyPackPath" -Force -Confirm:$false | Out-Null
                            Compress-Archive -Path "$Global:MyPackPath\Pack" -DestinationPath "$Global:MyPackPath\qt\$qtdt`_qtp.zip" -Update -Confirm:$false | Out-Null
                            Remove-Item -Path "$Global:MyPackPath\Pack" -Recurse -Force -Confirm:$force | Out-Null
                            New-Item -Name "Pack" -ItemType Directory -Path "$Global:MyPackPath" -Force -Confirm:$false | Out-Null
                            LocalLogWrite "ERR: Pack invalid. Sent to quarantine. '$Global:MyPackPath\qt\$qtdt`_qtp'"
                            LocalLogWrite "*---------------------------------*"
                        }
                        <#else{
                            LocalLogWrite "ERR: No Pack Info Found"
                            LocalLogWrite "*---------------------------------*"
                        }#>
                    }else{
                        LocalLogWrite "No Pack Directory"
                        LocalLogWrite "Remaking Pack Directory"
                        New-Item -Name "Pack" -ItemType Directory -Path "$Global:MyPackPath" -Force -Confirm:$false | Out-Null
                        LocalLogWrite "*---------------------------------*"
                    }
                }else{
                    # Import MyPack Confirmation Form

                    ##############################################
                    ##############################################

                        $ClearMyPackConfirmation_Form = New-Object $Form_Object
                        $ClearMyPackConfirmation_Form.Text = "MyPack - Clear"
                        $ClearMyPackConfirmation_Form.ClientSize = New-Object System.Drawing.Point(250,155)
	                    $ClearMyPackConfirmation_Form.FormBorderStyle = "Fixed3D" #FixedDialog, Fixed3D
	                    $ClearMyPackConfirmation_Form.StartPosition = [Windows.Forms.FormStartPosition]::CenterScreen
	                    $ClearMyPackConfirmation_Form.Icon = $Global:imgIcon
                        $ClearMyPackConfirmation_Form.Add_FormClosing({
                            $ClearMyPackConfirmation_Form.Dispose()
                        })

                        $ClearMyPackConfirmation_Label = New-Object $Label_Object
                        $ClearMyPackConfirmation_Label.Text = "Do you want to Clear`n${Global:info}?"
                        $ClearMyPackConfirmation_Label.Font = New-Object System.Drawing.Font("Calibri",11)
                        $ClearMyPackConfirmation_Label.TextAlign = "MiddleCenter"
                        $ClearMyPackConfirmation_Label.Size = New-Object System.Drawing.Point(250,100)
                        $ClearMyPackConfirmation_Label.Location = New-Object System.Drawing.Point(0,10)

                        $ClearMyPackConfirmationConfirm_Button = New-Object $Button_Object
                        $ClearMyPackConfirmationConfirm_Button.Text = "Yes"
                        $ClearMyPackConfirmationConfirm_Button.Font = New-Object System.Drawing.Font("Calibri",11)
                        $ClearMyPackConfirmationConfirm_Button.Size = New-Object System.Drawing.Point(80,25)
                        $ClearMyPackConfirmationConfirm_Button.Location = New-Object System.Drawing.Point(20,120)
                        $ClearMyPackConfirmationConfirm_Button.Add_Click({
                            # Import AppPack
				            $Global:ScriptSelect = Get-ChildItem -Path "$Global:AppPackPath\Single" -File | Select -Property BaseName,Name,Extension
				            if ($Global:ScriptSelect -eq $null){
					            $Global:ErrorCodeVal += "204;"
					            ExitLogWrite
					            LocalLogWrite "ERR: Failed Clearing Pack"
				            }else{
                                # Clear all ScriptS
                                $ScriptSelect_Combobox.Items.Clear()
                                
                                $Global:Imported = $false
				                $Global:ScriptSelectCount = $Global:ScriptSelect.Count
                                if ($Global:ScriptSelectCount -eq $null){
                                    $Global:ScriptSelectCount = 1
                                }
				                for ($i = 0; $i -lt $Global:ScriptSelectCount; $i++){
					                if ($Global:ScriptSelect[$i].Name -ne "AppPack.in"){
                                        if ($Global:ScriptSelect[$i].Name -ne "README.txt"){
						                    $FileName = $Global:ScriptSelect[$i].BaseName
						                    $ScriptSelect_Combobox.Items.Add($FileName) | Out-Null
					                    }
                                    }
				                }
                                # Remove MyPack\Pack contents
                                $RunMenuItem_ImportMyPack.Enabled = $false
                                Remove-Item -Path "$Global:AppPackPath\MyPack\Pack" -Recurse -Force -Confirm:$false | Out-Null
                                New-Item -Name "Pack" -ItemType Directory -Path "$Global:AppPackPath\MyPack" -Force -Confirm:$false | Out-Null
                                LocalLogWrite "Clearing $Global:info Pack"
                            }
                            LocalLogWrite "*---------------------------------*"
                            $Global:info = $null
                            $ClearMyPackConfirmation_Form.Dispose()
                        })

                        $ClearMyPackConfirmationCancel_Button = New-Object $Button_Object
                        $ClearMyPackConfirmationCancel_Button.Text = "Cancel"
                        $ClearMyPackConfirmationCancel_Button.Font = New-Object System.Drawing.Font("Calibri",11)
                        $ClearMyPackConfirmationCancel_Button.Size = New-Object System.Drawing.Point(80,25)
                        $ClearMyPackConfirmationCancel_Button.Location = New-Object System.Drawing.Point(150,120)
                        $ClearMyPackConfirmationCancel_Button.Add_Click({
                            $ClearMyPackConfirmation_Form.Dispose()
                        })

                        $ClearMyPackConfirmation_Form.Controls.AddRange(@(
                            $ClearMyPackConfirmationConfirm_Button
                            $ClearMyPackConfirmationCancel_Button
                            $ClearMyPackConfirmation_Label
                        ))
                        $ClearMyPackConfirmation_Form.ShowDialog() | Out-Null
                }
            })
			$RunMenuItem_Script = New-Object System.Windows.Forms.ToolStripMenuItem("Script")
            $RunMenuItemSctipt_RIP = New-Object System.Windows.Forms.ToolStripMenuItem("RIP")
            $RunMenuItemSctipt_RIP.Add_Click({
                $Path = "$PSScriptRoot\Run\rip\rip.ps1"
                Start-Process -NoNewWindow -FilePath "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -ArgumentList $Path
            })
            $RunMenuItemSctipt_PSR = New-Object System.Windows.Forms.ToolStripMenuItem("PSRemoting")
            $RunMenuItem_Script.DropDownItems.AddRange(@(
                $RunMenuItemSctipt_RIP
                $RunMenuItemSctipt_PSR
            ))
            #$RunMenuItem_CreateScript = New-Object System.Windows.Forms.ToolStripMenuItem("Create Script")

			# HELP Drop Down List
			$HelpMenuItem_Help = New-Object System.Windows.Forms.ToolStripMenuItem("Help")
			$HelpMenuItem_Help.Add_Click({
				Start-Process -FilePath "$Drive\Sysa\README.txt"
			})
			$HelpMenuItem_Update = New-Object System.Windows.Forms.ToolStripMenuItem("Update")
            $HelpMenuItem_Update.Enabled = $false
			$HelpMenuItem_Update.Add_Click({

			})
			$HelpMenuItem_About = New-Object System.Windows.Forms.ToolStripMenuItem("About")
			$HelpMenuItem_About.Add_Click({
                # About Form

                ##############################################
                ##############################################

                    $AboutForm = New-Object $Form_Object
                    $AboutForm.ClientSize = New-Object System.Drawing.Point(250,100)
	                $AboutForm.Text = "Sysa - About"
	                $AboutForm.FormBorderStyle = "Fixed3D" #FixedDialog, Fixed3D
	                $AboutForm.StartPosition = [Windows.Forms.FormStartPosition]::CenterScreen
	                $AboutForm.Icon = $Global:imgIcon
                    $AboutForm.Add_FormClosing({
                        $AboutForm.Dispose()
                    })

                    $AboutForm_Label = New-Object $Label_Object
                    $AboutForm_Label.Text = "Sysa`n:the admin utility`nV$Global:AppVer`n$Global:Copyright $Global:CpDate"
                    $AboutForm_Label.Font = New-Object System.Drawing.Font("Calibri",11)
                    $AboutForm_Label.TextAlign = "MiddleCenter"
                    $AboutForm_Label.AutoSize = $true
                    $AboutForm_Label.Location = New-Object System.Drawing.Point(70,10)

                    $AboutForm.Controls.AddRange(@(
                        $AboutForm_Label
                    ))

                    $AboutForm.ShowDialog() | Out-Null
			})
			
			# Toolbar FILE addRange of dropdown items
            $ToolbarStrip_File.DropDownItems.AddRange(@(
				$FileMenuItem_NewSession,$FileMenuItem_SaveLog,$FileMenuItem_SessionLog,$FileMenuItem_SaveClose
			)) | Out-Null
			# Toolbar EDIT addRange of dropdown items
            $ToolbarStrip_Edit.DropDownItems.AddRange(@(
				$EditMenuItem_ClearSingleSelect,$EditMenuItem_ClearGroupFileSelect,$EditMenuItem_ClearAllSelect,$EditMenuItem_ClearLog
			)) | Out-Null
			# Toolbar RUN addRange of dropdown items
            $ToolbarStrip_Run.DropDownItems.AddRange(@(
				$RunMenuItem_ImportMyPack,$RunMenuItem_LoadMyPack,$RunMenuItem_ClearMyPack #,$RunMenuItem_Script
			)) | Out-Null
			# Toolbar HELP addRange of dropdown items
            $ToolbarStrip_Help.DropDownItems.AddRange(@(
				$HelpMenuItem_Help,$HelpMenuItem_Update,$HelpMenuItem_About
			)) | Out-Null
			
			# Add top menu to Toolbar
            $ToolbarStrip.Items.AddRange(@($ToolbarStrip_File,$ToolbarStrip_Edit,$ToolbarStrip_Run,$ToolbarStrip_Help)) | Out-Null
			
			
# Create Main GUI
##############################################
		# Create Main Form
			$MainForm = New-Object $Form_Object
			$MainForm.Text = $Global:AppName
			$MainForm.FormBorderStyle = "Fixed3D" #FixedDialog, Fixed3D
			$MainForm.ClientSize = "640,275"
			$MainForm.StartPosition = [Windows.Forms.FormStartPosition]::Manual
            $MainForm.Left = 100
            $MainForm.Top = 100
			$MainForm.Icon = $Global:ImgIcon
            $MainForm.MainMenuStrip = $ToolbarStrip
            $MainForm.Add_Load({
                checkFiles
<#
                $Global:GroupFileOptions = Get-ChildItem -Path "$Global:StartPath\Files" -File | Select -Property BaseName,Name,Extension
                if ($Global:GroupFileOptions -eq $null){
					$Global:ErrorCodeVal = 547
					ExitLogWrite
					LocalLogWrite "Failed to load GroupFile Options"
                }else{
                    $Global:GroupFileCount = $Global:GroupFileOptions.Count
                    for ($i = 0; $i -lt $Global:GroupFileCount; $i++){
                        [string]$Type = $Global:GroupFileOptions[$i].Extension
                        if ($Type -eq ".u"){
                            $GroupFileSelection_ComboBox.Items.Add($Global:GroupFileOptions[$i].Name) | Out-Null
                        }elseif($Type -eq ".s"){
                            $GroupFileSelection_ComboBox.Items.Add($Global:GroupFileOptions[$i].Name) | Out-Null
                        }elseif($Type -eq ".cb"){
                            $GroupFileSelection_ComboBox.Items.Add($Global:GroupFileOptions[$i].Name) | Out-Null
                        }elseif($Type -eq ".cbg"){
                            $GroupFileSelection_ComboBox.Items.Add($Global:GroupFileOptions[$i].Name) | Out-Null
                        }else{
                            $t = $Global:GroupFileOptions[$i].Name
                            LocalLogWrite "ERR: Failed to Load : $t"
                            if (Test-Path "$Global:StartPath\Files\qt"){
                                if (Test-Path "$Global:StartPath\Files\qt\$t"){
                                    $n = 1
                                    function checkDuplicate{
                                        if (-not (Test-Path "$Global:StartPath\Files\qt\$t($n)")){
                                            Move-Item -Path "$Global:StartPath\Files\$t" -Destination "$Global:StartPath\Files\qt\$t($n)" -Force -Confirm:$false |Out-Null
                                            LocalLogWrite "Moved file to quarantine '$Global:StartPath\Files\qt'"
                                        }else{
                                            $n++
                                            checkDuplicate
                                        }
                                    }
                                    checkDuplicate
                                    $n = $null
                                }else{
                                    Move-Item -Path "$Global:StartPath\Files\$t" -Destination "$Global:StartPath\Files\qt\$t" -Force -Confirm:$false | Out-Null
                                    LocalLogWrite "You Moved file to quarantine '$Global:StartPath\Files\qt'"
                                    LocalLogWrite "*---------------------------------*"
                                }
                            }else{
                                New-Item -Name "qt" -ItemType Directory -Path "$Global:StartPath\Files" -Force -Confirm:$false | Out-Null
                                Compress-Archive -Path "$Global:MyPackPath\Pack" -DestinationPath "$Global:MyPackPath\qt\$qtdt`_qtp.zip" -Update -Confirm:$false | Out-Null
                                Remove-Item -Path "$Global:MyPackPath\Pack" -Recurse -Force -Confirm:$force | Out-Null
                                New-Item -Name "Pack" -ItemType Directory -Path "$Global:MyPackPath" -Force -Confirm:$false | Out-Null
                            }
                        }
                    }
                }
#>
            })
			$MainForm.Add_FormClosing({
                $t = 1
				# To turn on/off session Mode 
				if ($Global:SessionMode){
                    [string]$LogPath = $Global:SessionLogLocation					
                    if (Test-Path "Gloabal:StartPath\Sysalogs"){
						if (Test-Path "$Global:StartPath\Sysalogs\sessionlog"){
							Add-Content -Path $sessionPath -Value $DisplayLog_RichTextBox.Text 
						}else{
							New-Item -Name "sessionlog" -ItemType Directory -Path "$Global:StartPath\Sysalogs" -Confirm:$false -Force
							Add-Content -Path $LogPath -Value $DisplayLog_RichTextBox.Text 
						}
					}else{
						New-Item -Name "Sysalogs" -ItemType Directory -Path "$Global:StartPath" -Confirm:$false -Force
						New-Item -Name "sessionlog" -ItemType Directory -Path "$Global:StartPath\Sysalogs" -Confirm:$false -Force
						Add-Content -Path $LogPath -Value $DisplayLog_RichTextBox.Text 
					}
				    $Global:FullDateTime = Get-Date -DisplayHint Date
				    LocalLogWrite "Session Ended $Global:FullDateTime`n***********************************"
                    LocalLogWrite "Session log saved at $LogPath"
                    $t = 3
				}
				$Global:FullDateTime = Get-Date -DisplayHint Date
                $Global:info= $null
                $Global:Imported = $false
                LocalLogWrite "--Closeing Utility--"
				ExitLogWrite
				Start-Sleep -Seconds $t | Out-Null
				$MainForm.Dispose() | Out-Null
			})

##############################################
##############################################
# Create Main Form Contents
##############################################

# Single Selection
##############################################

			# Single Selection Header
				$SingleSelectHeader_Label = New-Object $Label_Object
				$SingleSelectHeader_Label.Text = "Single Selection"
				$SingleSelectHeader_Label.Font = $Global:DefaultFont10Bold
				$SingleSelectHeader_Label.AutoSize = $true
				$SingleSelectHeader_Label.Location = New-Object System.Drawing.Point(20,30)
			# Username Label
				$Username_Label = New-Object $Label_Object
				$Username_Label.Text = "Username"
				$Username_Label.Font = $Global:DefaultFont10
				$Username_Label.Size = New-Object System.Drawing.Point(70,20)
				$Username_Label.Location = New-Object System.Drawing.Point(20,50)
			# Username Textbox
				$Username_Textbox = New-Object $TextBox_Object
				$Username_Textbox.Text = ""
				$Username_Textbox.Font = $Global:DefaultFont10
				$Username_Textbox.CharacterCasing = "Upper"
				$Username_Textbox.TabIndex = 1
				$Username_Textbox.Enabled = $true
                $Username_Textbox.MaxLength = 15
				$Username_Textbox.Size = New-Object System.Drawing.Point(180,40)
				$Username_Textbox.Location = New-Object System.Drawing.Point(60,70)
				$Username_Textbox.Add_Click({
					if ($Username_Checkbox.Checked -eq $false -and $System_Checkbox.Checked -eq $false ){
							$Username_Checkbox.Checked = $true
					}elseif ($System_Checkbox.Checked -eq $true){
						if (-not($Combo_Checkbox.Checked)){
							$Username_Checkbox.Checked = $true
						}
					}
				})
				$Username_Textbox.Add_TextChanged({
					$Username_Checkbox.Checked = $true
				})
			# Username Checkbox
				$Username_Checkbox = New-Object $Checkbox_Object
				$Username_Checkbox.Text = " "
				$Username_Checkbox.Font = $Global:DefaultFont10
				$Username_CheckBox.TabIndex = 7
				$Username_Checkbox.Size = New-Object System.Drawing.Point(10,10)
				$Username_Checkbox.Checked = $false
				$Username_Checkbox.Location = New-Object System.Drawing.Point(250,75)
				$Username_Checkbox.Add_CheckStateChanged({
					if (-not ($Combo_Checkbox.Checked)){
						if ($Username_Checkbox.Checked){
							$System_Checkbox.Checked = $false
							$Username_Textbox.Focus()
						}
					}
				})
			# System Label
				$System_Label = New-Object $Label_Object
				$System_Label.Text = "System"
				$System_Label.Font = $Global:DefaultFont10
				$System_Label.Size = New-Object System.Drawing.Point(55,20)
				$System_Label.Location = New-Object System.Drawing.Point(20,95)
			# System Textbox
				$System_Textbox = New-Object $Textbox_Object
				$System_Textbox.Text = ""
				$System_Textbox.Font = $Global:DefaultFont10
				$System_Textbox.CharacterCasing = "Upper"
				$System_Textbox.TabIndex = 2
                $System_Textbox.MaxLength = 15
				$System_Textbox.Enabled = $true
				$System_Textbox.Size = New-Object System.Drawing.Point(180,40)
				$System_Textbox.Location = New-Object System.Drawing.Point(60,115)
				$System_Textbox.Add_Click({
					if ($Username_Checkbox.Checked -eq $false -and $System_Checkbox.Checked -eq $false ){
						$System_Checkbox.Checked = $true
					}elseif ($Username_Checkbox.Checked -eq $true){
						if (-not($Combo_Checkbox.Checked)){
							$System_Checkbox.Checked = $true
						}
					}
				})
				$System_Textbox.Add_TextChanged({
					$System_Checkbox.Checked = $true
				})
			# System Checkbox
				$System_Checkbox = New-Object $Checkbox_Object
				$System_Checkbox.Text = " "
				$System_Checkbox.Font = $Global:DefaultFont12
				$System_CheckBox.TabIndex = 8
				$System_Checkbox.Size = New-Object System.Drawing.Point(10,10)
				$System_Checkbox.Checked = $false
				$System_Checkbox.Location = New-Object System.Drawing.Point(250,120)
				$System_Checkbox.Add_CheckStateChanged({
					if (-not ($Combo_Checkbox.Checked)){
						if ($System_Checkbox.Checked){
							$Username_Checkbox.Checked = $false
							$System_Textbox.Focus()
						}
					}
				})
			# Combination Checkbox
				$Combo_Checkbox = New-Object $Checkbox_Object
				$Combo_Checkbox.Text = "Combination"
				$Combo_Checkbox.Font = $Global:DefaultFont10
				$Combo_Checkbox.TabIndex = 3
				$Combo_Checkbox.Enabled = $true
				$Combo_Checkbox.Checked = $false
				$Combo_Checkbox.AutoSize = $true
				$Combo_Checkbox.Location = New-Object System.Drawing.Point(65,145)
				$Combo_Checkbox.Add_CheckStateChanged({
					if ($Combo_Checkbox.Checked){
						$System_Checkbox.Checked = $true
						$Username_Checkbox.Checked= $true
						$System_Checkbox.Enabled = $false
						$Username_Checkbox.Enabled = $false
					}else{
						$System_Checkbox.Checked = $false
						$Username_Checkbox.Checked = $false
						$System_Checkbox.Enabled = $true
						$Username_Checkbox.Enabled = $true
					}
				})
			# Action Combobox
				$Action_Combobox = New-Object $Combobox_Object
				$Action_Combobox.Text = "Action"
				$Action_Combobox.Font = $Global:DefaultFont10
				$Action_Combobox.TabIndex = 4
				$Action_Combobox.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList   #DropDown
				$Action_Combobox.Size = New-Object System.Drawing.Point(70,40)
				$Action_Combobox.Location = New-Object System.Drawing.Point(20,170)
				$Action_Combobox.Items.AddRange(@("Check","Add","Remove"))
			# Script Selection Combobox
				$ScriptSelect_Combobox = New-Object $Combobox_Object
				$ScriptSelect_Combobox.Text = "Script"
				$ScriptSelect_Combobox.Font = $Global:DefaultFont10
				$ScriptSelect_Combobox.TabIndex = 5
				$ScriptSelect_Combobox.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList   #DropDown
				$ScriptSelect_Combobox.Size = New-Object System.Drawing.Point(180,40)
				$ScriptSelect_Combobox.Location = New-Object System.Drawing.Point(100,170)
				$Global:ScriptSelect = Get-ChildItem -Path "$Global:AppPackPath\Single" -File | Select -Property BaseName,Name,Extension
				if ($Global:ScriptSelect -eq $null){
					$Global:ErrorCodeVal += "204;"
					ExitLogWrite
					#LocalLogWrite "Failed to load Single Option Scripts"
				}else{
				    $Global:ScriptSelectCount = $Global:ScriptSelect.Count
                    if ($Global:ScriptSelectCount -eq $null){
                        $Global:ScriptSelectCount = 1
                    }
				    for ($i = 0; $i -lt $Global:ScriptSelectCount; $i++){
					    if ($Global:ScriptSelect[$i].Name -ne "AppPack.in"){
                            if ($Global:ScriptSelect[$i].Name -ne "README.txt"){
						        $FileName = $Global:ScriptSelect[$i].BaseName
						        $ScriptSelect_Combobox.Items.Add($FileName) | Out-Null
					        }
                        }
				    }
                }
			# Run Button
				$SingleSelectRun_Button = New-Object $Button_Object
				$SingleSelectRun_Button.Text = "Single Run"
				$SingleSelectRun_Button.Font = $Global:DefaultFont10
				$SingleSelectRun_Button.TabIndex = 6
				$SingleSelectRun_Button.Size = New-Object System.Drawing.Point(90,25)
				$SingleSelectRun_Button.Location = New-Object System.Drawing.Point(110,230)
				$SingleSelectRun_Button.Add_Click({
                    # Get for checked options
                    # check for data in text boxes that are checked
                    # run script
                    $PreReq_Action = $false
                    $PreReq_Script = $false
                    $PreReq_Username = $false
                    $PreReq_System = $false
                    $CombinationRun = $false
                    
                    if ($Combo_Checkbox.Checked -eq $true -or $Username_Checkbox.Checked -eq $true -or $System_Checkbox.Checked -eq $true){
					    $Action = $Action_Combobox.SelectedItem
                        if (-not ([string]::IsNullOrEmpty($Action))){
                            if (-not ([string]::IsNullOrWhiteSpace($Action))){
                                if ($Action -ne ""){
                                # Action Passed
                                $PreReq_Action = $true
                                    
                                }
                            }
                        }
                        $Script = $ScriptSelect_Combobox.SelectedItem
                        if (-not ([string]::IsNullOrEmpty($Script))){
                            if (-not ([string]::IsNullOrWhiteSpace($Script))){
                                if ($Script -ne ""){
                                # Script Passed
                                $PreReq_Script = $true
                                $Script = "$Script.ps1"
                                }
                            }
                        }
                        $userchk = $Username_Textbox.text
                        if (-not ([string]::IsNullOrEmpty($userchk))){
                            if (-not ([string]::IsNullOrWhiteSpace($userchk))){
                                if ($userchk -ne ""){
                                # Username Passed
                                $PreReq_Username = $true

                                }
                            }
                        }
                        $syschk = $System_Textbox.text
                        if (-not ([string]::IsNullOrEmpty($syschk))){
                            if (-not ([string]::IsNullOrWhiteSpace($syschk))){
                                if ($syschk -ne ""){
                                # System Passed
                                $PreReq_System = $true

                                }
                            }
                        }

                        if ($Combo_Checkbox.Checked){
                            if ($PreReq_Username -eq $true -and $PreReq_System -eq $true){
                                if ($PreReq_Action){
                                    if ($PreReq_Script){
                                        $RunType = "Combo"
                                        LocalLogWrite "Passed Combo PreReq"
                                        $CombinationRun = $true
                                        $Username = $Username_Textbox.Text
                                        $System = $System_Textbox.Text
                                        LocalLogWrite "User: $Username"
                                        LocalLogWrite "System: $System"
                                        LocalLogWrite "* Running Combo Script($Action;$Script)"
                                        $ps = "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
                                        # Test Script location (Sysa Script or MyPack)
                                        if (Test-Path "$Global:AppPackPath\Single\$Script"){
                                            LocalLogWrite "Running Sysa Script"
                                            $scriptPath = "$Global:AppPackPath\Single\$Script"
                                            try{
                                                $comboRun = Start-Process -Wait -PassThru -FilePath $ps -Verb RunAs -ArgumentList $scriptPath,$RunType,$Action,$Username,$System
                                                $comboRunErr = $comboRun.ExitCode
                                                LocalLogWrite "Process Completed with Exit Code $comboRunErr"
                                            }catch{
                                                LocalLogWrite "Failed to run sysa $Script"
                                            }
                                            LocalLogWrite "*---------------------------------*"
                                        }elseif (Test-Path "$Global:AppPackPath\MyPack\Pack\$script"){
                                            if ($Global:Imported){
                                                LocalLogWrite "Running MyPack Script"
                                                $scriptPath = "$Global:AppPackPath\MyPack\Pack\$Script"
                                                try{
                                                    $comboRun = Start-Process -Wait -PassThru -FilePath $ps -Verb RunAs -ArgumentList $scriptPath,$RunType,$Action,$Username,$System
                                                    $comboRunErr = $comboRun.ExitCode
                                                    LocalLogWrite "Process Completed with Exit Code $comboRunErr"
                                                }catch{
                                                    LocalLogWrite "ERR: Failed to run MyPack $Script"
                                                }
                                                LocalLogWrite "*---------------------------------*"
                                            }else{
                                                LocalLogWrite "ERR: MyPack File not imported"
                                                LocalLogWrite "*---------------------------------*"
                                            }
                                        }else{
                                            LocalLogWrite "ERR: Bad Path"
                                            LocalLogWrite "*---------------------------------*"
                                        }
                                    }else{
                                        LocalLogWrite "ERR: No Script Selected"
                                        LocalLogWrite "*---------------------------------*"
                                    }
                                }else{
                                    LocalLogWrite "ERR: No Action Selected"
                                    LocalLogWrite "*---------------------------------*"
                                }
                            }else{
                                LocalLogWrite "ERR: Combo Selected : PreReqCombo Failed"
                                LocalLogWrite "*---------------------------------*"
                            }
                        }elseif($Username_Checkbox.Checked){
                            if ($PreReq_Username){
                                if ($PreReq_Action){
                                    if ($PreReq_Script){
                                        $RunType = "User"
                                        LocalLogWrite "Passed User PreReq"
                                        $Username = $Username_Textbox.Text
                                        LocalLogWrite "User: $Username"
                                        LocalLogWrite "* RunType : $RunType ($Action;$Script)"
                                        $ps = "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
                                        # Test Script location (Sysa Script or MyPack)
                                        if (Test-Path "$Global:AppPackPath\Single\$Script"){
                                            LocalLogWrite "Running Sysa Script"
                                            $scriptPath = "$Global:AppPackPath\Single\$Script"
                                            try{
                                                $userRun = Start-Process -Wait -PassThru -FilePath $ps -Verb RunAs -ArgumentList $scriptPath,$RunType,$Action,$Username
                                                $userRunErr = $userRun.ExitCode
                                                LocalLogWrite "Process Completed with Exit Code $userRunErr"
                                            }catch{
                                                LocalLogWrite "Failed to run sysa $Script"
                                            }
                                            LocalLogWrite "*---------------------------------*"
                                        }elseif (Test-Path "$Global:AppPackPath\MyPack\Pack\$script"){
                                            if ($Global:Imported){
                                                LocalLogWrite "Running MyPack Script"
                                                $scriptPath = "$Global:AppPackPath\MyPack\Pack\$Script"
                                                try{
                                                    $userRun = Start-Process -Wait -PassThru -FilePath $ps -Verb RunAs -ArgumentList $scriptPath,$RunType,$Action,$Username
                                                    $userRunErr = $userRun.ExitCode
                                                    LocalLogWrite "Process Completed with Exit Code $userRunErr"
                                                }catch{
                                                    LocalLogWrite "ERR: Failed to run MyPack $Script"
                                                }
                                                LocalLogWrite "*---------------------------------*"
                                            }else{
                                                LocalLogWrite "ERR: MyPack File not imported"
                                                LocalLogWrite "*---------------------------------*"
                                            }
                                        }else{
                                            LocalLogWrite "ERR: Bad Path"
                                            LocalLogWrite "*---------------------------------*"
                                        }
                                    }else{
                                        LocalLogWrite "ERR: No Script Selected"
                                        LocalLogWrite "*---------------------------------*"
                                    }
                                }else{
                                    LocalLogWrite "ERR: No Action Selected"
                                    LocalLogWrite "*---------------------------------*"
                                }
                            }else{
                                LocalLogWrite "ERR: No Usernamee Selected"
                                LocalLogWrite "*---------------------------------*"
                            }
                        }elseif($System_Checkbox.Checked){
                            if ($PreReq_System){
                                if ($PreReq_Action){
                                    if ($PreReq_Script){
                                        $RunType = "System"
                                        LocalLogWrite "Passed System PreReq"
                                        $system = $System_Textbox.Text
                                        LocalLogWrite "System: $System"
                                        LocalLogWrite "* RunType : $RunType ($Action;$Script)"
                                        $ps = "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
                                        # Test script location
                                        if (Test-Path "$Global:AppPackPath\Single\$Script"){
                                            LocalLogWrite "Running Sysa Script"
                                            $scriptPath = "$Global:AppPackPath\Single\$Script"
                                            try{
                                                $systemRun = Start-Process -Wait -PassThru -FilePath $ps -Verb RunAs -ArgumentList $scriptPath,$RunType,$Action,$System
                                                $systemRunErr = $systemRun.ExitCode
                                                LocalLogWrite "Process Completed with Exit Code $systemRunErr"
                                            }catch{
                                                LocalLogWrite "Failed to run Sysa Script"
                                            }
                                            LocalLogWrite "*---------------------------------*"
                                        }elseif (Test-Path "$Global:AppPackPath\MyPack\Pack\$script"){
                                            if ($Global:Imported){
                                                LocalLogWrite "Running MyPack Script"
                                                $scriptPath = "$Global:AppPackPath\MyPack\Pack\$Script"
                                                try{
                                                    $systemRun = Start-Process -Wait -PassThru -FilePath $ps -Verb RunAs -ArgumentList $scriptPath,$RunType,$Action,$System
                                                    $systemRunErr = $systemRun.ExitCode
                                                    LocalLogWrite "Process Completed with Exit Code $systemRunErr"
                                                }catch{
                                                    LocalLogWrite "Failed to run MyPack Script"
                                                }
                                                LocalLogWrite "*---------------------------------*"
                                            }else{
                                                LocalLogWrite "ERR: MyPack File not imported"
                                                LocalLogWrite "*---------------------------------*"
                                            }
                                        }else{
                                            LocalLogWrite "ERR: Bad path"
                                            LocalLogWrite "*---------------------------------*"
                                        }
                                    }else{
                                        LocalLogWrite "ERR: No Script Selected"
                                        LocalLogWrite "*---------------------------------*"
                                    }
                                }else{
                                    LocalLogWrite "ERR: No Action Selected"
                                    LocalLogWrite "*---------------------------------*"
                                }
                            }else{
                                LocalLogWrite "ERR: System Selected : PreReqSystem Failed"
                                LocalLogWrite "*---------------------------------*"
                            }
                        }else{
                            LocalLogWrite "ERR: No process selected(1)"
                            LocalLogWrite "*---------------------------------*"
                        }    
                    }else{
                        LocalLogWrite "ERR: No process selected(2)"
                        LocalLogWrite "*---------------------------------*"
                    }
                })
				$SingleOption_Groupbox = New-Object $Groupbox_Object
				$SingleOption_Groupbox.Size = New-Object System.Drawing.Point(300,180)
				$SingleOption_Groupbox.Controls.AddRange(@($Username_Label,$Username_Textbox,$Username_Checkbox,$System_Label,$System_Textbox,$System_Checkbox,$Combo_Checkbox,$Action_Combobox,$ScriptSelect_Combobox,$SingleSelectRun_Button))
				$SingleOption_Groupbox.Location = New-Object System.Drawing.Point(10,35)

# Group Selection
##############################################

			# Single Selection Header
				$GroupFileSelectHeader_Label = New-Object $Label_Object
				$GroupFileSelectHeader_Label.Text = "GroupFile Selection"
				$GroupFileSelectHeader_Label.Font = $Global:DefaultFont10Bold
				$GroupFileSelectHeader_Label.AutoSize = $true
				$GroupFileSelectHeader_Label.Location = New-Object System.Drawing.Point(340,30)
			# GroupFile Select Combobox
				$GroupFileSelection_ComboBox = New-Object $Combobox_Object
                $GroupFileSelection_ComboBox.Font = $Global:DefaultFont10
                $GroupFileSelection_ComboBox.TabIndex = 9
                $GroupFileSelection_ComboBox.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList   #DropDown
                $GroupFileSelection_ComboBox.Size = New-Object System.Drawing.Point(150,25)
                $GroupFileSelection_ComboBox.Location = New-Object System.Drawing.Point(350,70)
		    # GroupFile Import Button
                $GroupFileImport_Button = New-Object $Button_Object
                $GroupFileImport_Button.Text = "Import"
                $GroupFileImport_Button.Font = $Global:DefaultFont10
                $GroupFileImport_Button.TabIndex = 10
                $GroupFileImport_Button.Size = New-Object System.Drawing.Point(80,25)
                $GroupFileImport_Button.Location = New-Object System.Drawing.Point(520,69)
                $Global:Imported = $false
                $GroupFileImport_Button.Add_Click({
                    # Import File path of group file
                    # checkFiles
                    $Global:GroupFileFormat = $null
                    $Global:GroupFile_Selected = $GroupFileSelection_ComboBox.SelectedItem
                    $Global:GroupFile_SelectedPath = "$Global:StartPath\Files\$Global:GroupFile_Selected"
                    if (-not ([string]::IsNullOrEmpty($Global:GroupFile_Selected))){
                        if (-not([string]::IsNullOrWhiteSpace($Global:GroupFile_Selected))){
                            if (-not ($Global:GroupFile_Selected -eq "")){
                                # Test Path
                                LocalLogWrite "Testing Path  : $Global:GroupFile_SelectedPath"
                                LocalLogWrite "*---------------------------------*"
                                if (Test-Path($Global:GroupFile_SelectedPath)){
                                    $Global:MyFile = Get-Item -Path $Global:GroupFile_SelectedPath | select -Property Basename,Name,Extension
                                    $Extension = $Global:MyFile.Extension
                                    if (isExt($Extension)){
                                        $Global:GroupFile_RunType = extensionCodecCheck($Extension)
                                        if (checkFormat($Extension)){
                                            $Global:GroupFileFormat = getformat($Extension)
                                            $GroupFileFormat_Label.Text = $Global:GroupFileFormat
                                        }
                                    }else{
                                        LocalLogWrite "Extenstion not found. Moving to quarantine."
                                    }
                                    $MyFileName = $MyFile.Basename
                                    LocalLogWrite "Path Valid"
                                    LocalLogWrite "Imported File   : $MyFileName"
                                    LocalLogWrite "Format : $Global:GroupFileFormat"
                                    $Global:SessionImportedFile = "Imported File : $Global:GroupFile_SelectedPath`n*---------------------------------*"
                                    LocalLogWrite "*---------------------------------*"

                                    $GroupFileSelection_ComboBox.SelectedIndex = -1
                                    $GroupFileSelection_ComboBox.Text = ""
                                    $GroupFileSelection_Label.Text = $MyFile.Name
                                    $Global:Imported = $true
                                    $GroupFileImport_Button.Text = "Clear"
                                }else{
                                    LocalLogWrite "Path : Invalid"
                                    LocalLogWrite "*---------------------------------*"
                                }
                            }else{
                                if ($Global:Imported){
                                    LocalLogWrite "Clearing Imported File"
                                    LocalLogWrite "*---------------------------------*"
                                    $Global:MyFile = $null
                                    $Extension =$null
                                    $Global:GroupFile_RunType = $null
                                    $Global:SessionImportedFile = $null
                                    $Global:GroupFile_Selected = $null
                                    $Global:GroupFile_SelectedPath = $null
                                    $GroupFileSelection_ComboBox.SelectedIndex = -1
                                    $GroupFileSelection_ComboBox.Text = ""
                                    $Global:GroupFileFormat = $null
                                    $GroupFileSelection_Label.Text = "<File Selected>"
                                    $GroupFileFormat_Label.Text = "<Format>"
                                    $Global:Imported = $false
                                    $GroupFileImport_Button.Text = "Import"
                                }else{
                                    LocalLogWrite "GroupFile is invalid"
                                    LocalLogWrite "*---------------------------------*"
                                }
                            }
                        }else{
                            if ($Global:Imported){
                                LocalLogWrite "Clearing Imported File"
                                LocalLogWrite "*---------------------------------*"
                                $Global:MyFile = $null
                                $Extension = $null
                                $Global:GroupFile_RunType = $null
                                $Global:SessionImportedFile = $null
                                $Global:GroupFile_Selected = $null
                                $Global:GroupFile_SelectedPath = $null
                                $GroupFileSelection_ComboBox.SelectedIndex = -1
                                $GroupFileSelection_ComboBox.Text = ""
                                $Global:GroupFileFormat = $null
                                $GroupFileSelection_Label.Text = "<File Selected>"
                                $GroupFileFormat_Label.Text = "<Format>"
                                $Global:Imported = $false
                                $GroupFileImport_Button.Text = "Import"
                            }else{
                                LocalLogWrite "GroupFile is invalid"
                                LocalLogWrite "*---------------------------------*"
                            }
                        }
                    }else{
                        if ($Global:Imported){
                            if ($GroupFileFormat_Label.Text -ne "<Format>"){
                                LocalLogWrite "Clearing Imported File"
                                LocalLogWrite "*---------------------------------*"
                                $Global:MyFile = $null
                                $Extension =$null
                                $Global:GroupFile_RunType = $null
                                $Global:SessionImportedFile = $null
                                $Global:GroupFile_Selected = $null
                                $Global:GroupFile_SelectedPath = $null
                                $GroupFileSelection_ComboBox.SelectedIndex = -1
                                $GroupFileSelection_ComboBox.Text = ""
                                $Global:GroupFileFormat = $null
                                $GroupFileSelection_Label.Text = "<File Selected>"
                                $GroupFileFormat_Label.Text = "<Format>"
                                $Global:Imported = $false
                                $GroupFileImport_Button.Text = "Import"
                            }
                        }else{
                            LocalLogWrite "GroupFile is invalid"
                            LocalLogWrite "*---------------------------------*"
                        }
                        
                    }
                })
            # GroupFile Selected File Label
                $GroupFileSelection_Label = New-Object $Label_Object
                $GroupFileSelection_Label.Text = "<File Selected>"
                $GroupFileSelection_Label.Font = $Global:DefaultFont11
                $GroupFileSelection_Label.TextAlign = "MiddleLeft"
                $GroupFileSelection_Label.ForeColor = $Global:DefaultColor2_GroupFileLabel
                $GroupFileSelection_Label.BackColor = $Global:DefaultColor1_GroupFileLabel
                $GroupFileSelection_Label.Size = New-Object System.Drawing.Point(150,25)
                $GroupFileSelection_Label.Location = New-Object System.Drawing.Point(350,105)
                $GroupFileSelection_Label.Add_Click({
                    [string]$GroupFileEdit = $GroupFileSelection_Label.Text
                    if (-not ($GroupFileEdit -eq "<File Selected>")){
                        if (Test-Path "$Global:StartPath\Files\$GroupFileEdit"){
                            Start-Process -FilePath "$Global:StartPath\Files\$GroupFileEdit"
                            $GroupFileEdit = $null
                        }else{
                            LocalLogWrite "Cannot edit file; Bad Path"
                            LocalLogWrite "*---------------------------------*"
                        }
                    }else{
                        LocalLogWrite "No File Imported"
                        LocalLogWrite "*---------------------------------*"
                    }
                })
		    # GroupFile Loop Checkbox
                $GroupFileLoop_Checkbox = New-Object $Checkbox_Object
                $GroupFileLoop_Checkbox.Text = "Loop"
                $GroupFileLoop_Checkbox.Font = $Global:DefaultFont10
                $GroupFileLoop_Checkbox.TabIndex = 11
                $GroupFileLoop_Checkbox.Checked = $false
                $GroupFileLoop_Checkbox.Enabled = $true
                $GroupFileLoop_Checkbox.Size = New-Object System.Drawing.Point(60,25)
                $GroupFileLoop_Checkbox.Location = New-Object System.Drawing.Point(535,105)
            # GroupFile Script Selection Combobox
                $GroupFileScriptSelection_Combobox = New-Object $Combobox_Object
                $GroupFileScriptSelection_Combobox.Text = "Script"
                $GroupFileScriptSelection_Combobox.Font = $Global:DefaultFont10
                $GroupFileScriptSelection_Combobox.TabIndex = 12
                $GroupFileScriptSelection_Combobox.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList   #DropDown
                $GroupFileScriptSelection_Combobox.Size = New-Object System.Drawing.Point(255,25)
                $GroupFileScriptSelection_Combobox.Location = New-Object System.Drawing.Point(350,145)
                $Global:GroupFileScriptOptions = Get-ChildItem -Path "$Global:AppPackPath\GroupPack" -File | Select -Property BaseName,Name,Extension
                if ($Global:GroupFileScriptOptions -eq $null){
					$Global:ErrorCodeVal += "618;"
					ExitLogWrite
					LocalLogWrite "Failed to load GroupFile Script Options"
                    LocalLogWrite "*---------------------------------*"
                }else{
                    $Global:GroupFileScriptCount = $Global:GroupFileScriptOptions.Count
                    $FileList = @{}
                    for ($i = 0; $i -lt $Global:GroupFileScriptCount; $i++){
                        if ($Global:GroupFileScriptOptions[$i].Name -ne "GrpPack.in"){
                            $GroupScriptBN = $Global:GroupFileScriptOptions[$i].BaseName
                            $GroupScriptEXT = $Global:GroupFileScriptOptions[$i].Extension
                            $FileList.Add($GroupScriptBN,$GroupScriptEXT)
                            $GroupFileScriptSelection_Combobox.Items.Add($GroupScriptBN) | Out-Null
                        }
                    }
                    $GroupFileScriptSelection_Combobox.Add_SelectedIndexChanged({
                        $GroupFileScriptSelection_Combobox.Text = $GroupFileScriptSelection_Combobox.SelectedItem
                    })
                }
            # GroupFile Script File Format Label Name
                $GroupFileFormatName_Label = New-Object $Label_Object
                $GroupFileFormatName_Label.Text = "Format: "
                $GroupFileFormatName_Label.Font = $Global:DefaultFont10
                $GroupFileFormatName_Label.TextAlign = "MiddleLeft"
                $GroupFileFormatName_Label.Size = New-Object System.Drawing.Point(60,25)
                $GroupFileFormatName_Label.Location = New-Object System.Drawing.Point(350,180)
            # GroupFile Script File Format Label Box
                $GroupFileFormat_Label = New-Object $Label_Object
                $GroupFileFormat_Label.Text = "<Format>"
                $GroupFileFormat_Label.Font = $Global:DefaultFont11
                $GroupFileFormat_Label.TextAlign = "MiddleCenter"
                $GroupFileFormat_Label.ForeColor = $Global:DefaultColor2_GroupFileLabel
                $GroupFileFormat_Label.BackColor = $Global:DefaultColor1_GroupFileLabel
                $GroupFileFormat_Label.Size = New-Object System.Drawing.Point(190,25)
                $GroupFileFormat_Label.Location = New-Object System.Drawing.Point(415,180)
            # Run GroupFile
                $GroupFileSelectRun_Button = New-Object $Button_Object
                $GroupFileSelectRun_Button.Text = "GroupFile Run"
                $GroupFileSelectRun_Button.Font = $Global:DefaultFont10
                $GroupFileSelectRun_Button.TabIndex = 13
                $GroupFileSelectRun_Button.Size = New-Object System.Drawing.Point(110,25)
                $GroupFileSelectRun_Button.Location = New-Object System.Drawing.Point(430,230)
                $GroupFileSelectRun_Button.Add_Click({
                    # Get for checked options
                    # check for data in text boxes that are checked
                    # run script
                    checkFiles
                    #Write-Host "$Global:GroupFile_SelectedPath"
                    #Test-Path "$Global:GroupFile_SelectedPath"
                    $PreReq_Script = $false
                    $PreReq_FileImported = $false
                    $PreReq_LoopCheck = $false
                    # PreReqs
                    LocalLogWrite "*-- Group Run Check --*"
                    # File Check
                    #if ($Global:GroupFile_Selected -ne $null -and $Global:GroupFile_Selected -ne ""){
                    if (-not ([string]::IsNullOrEmpty($Global:GroupFile_Selected))){
                        if (-not ([string]::IsNullOrWhiteSpace($Global:GroupFile_Selected))){
                            if ($Global:GroupFile_Selected -ne ""){
                                if (Test-Path -Path "$Global:GroupFile_SelectedPath"){
                                    #LocalLogWrite "File Path is valid"
                                    $PreReq_FileImported = $true
                                }else{
                                    [string]$GroupFile = $GroupFileSelection_Label.Text
                                    if (-not ($GroupFile -eq "<File Selected>")){
                                        LocalLogWrite "File Path is not valid '$Global:GroupFile_SelectedPath'"
                                        $PreReq_FileImported = $false
                                    }else{
                                        LocalLogWrite "No Imported File"
                                        $PreReq_FileImported = $false
                                    }
                                }
                            }else{
                                LocalLogWrite "File Path is empty"
                                $PreReq_FileImported = $false
                            }
                        }else{
                            LocalLogWrite "File Path is white space"
                            $PreReq_FileImported = $false
                        }
                    }else{
                        LocalLogWrite "File Path is null"
                        $PreReq_FileImported = $false
                    }

                    # Script Check
                    $GroupScript_Selected = $GroupFileScriptSelection_Combobox.SelectedItem
                    if (-not ([string]::IsNullOrEmpty($GroupScript_Selected))){
                        if (-not ([string]::IsNullOrWhiteSpace($GroupScript_Selected))){
                            if ($GroupScript_Selected -ne ""){
                                #LocalLogWrite "Script Path is valid"
                                $PreReq_Script = $true
                            }else{
                                LocalLogWrite "Script Path is empty"
                                $PreReq_Script = $false
                            }
                        }else{
                            LocalLogWrite "Script Path is white space"
                            $PreReq_Script = $false
                        }
                    }else{
                        LocalLogWrite "Script Path is null"
                        $PreReq_Script = $false
                    }
                    LocalLogWrite "*---------------------------------*" 

                    # Loop Check
                    if ($GroupFileLoop_Checkbox.Checked){
                        $PreReq_LoopCheck = $true
                        LocalLogWrite "Loop: True"
                        LocalLogWrite "*---------------------------------*`n"
                        LocalLogWrite "*-- Looping Group Run --*"
                    }else{
                        $PreReq_LoopCheck = $false
                        LocalLogWrite "Loop: False"
                        LocalLogWrite "*---------------------------------*`n"
                        LocalLogWrite "*-- Group Run --*"
                    }

                    # PreReq Processing
                    # -------------------------------------------
                    if ($PreReq_FileImported -eq $true){
                        if ($PreReq_Script -eq $true){
                            # Pass PreReq
                            LocalLogWrite "Passed System PreReq"
                            LocalLogWrite "File : $Global:GroupFile_Selected"
                            LocalLogWrite "Format        : $Global:GroupFileFormat"
                            $SubScriptPath = "$Global:AppPackPath\GroupPack\$GroupScript_Selected`.ps1"
                            $FileExt = $Global:MyFile.Extension
                            #$MyFileName = $Global:MyFile.Name
                            if ($PreReq_LoopCheck){
                                LocalLogWrite "Running GroupFile Script($GroupScript_Selected)/Looped"
                                #LocalLogWrite "$Global:LoopPath"
                                Start-Process -FilePath "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -Verb RunAs -PassThru -ArgumentList $Global:LoopPath,$SubScriptPath,$GroupFile_SelectedPath,$GroupFile_Selected,$Global:GroupFile_RunType,"loop"
                                LocalLogWrite "*---------------------------------*"
                            }else{
                                LocalLogWrite "Running GroupFile Script($GroupScript_Selected)/Single Pass"
                                #LocalLogWrite "$Global:LoopPath"
                                Start-Process -FilePath "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -Verb RunAs -PassThru -ArgumentList $Global:LoopPath,$SubScriptPath,$GroupFile_SelectedPath,$GroupFile_Selected,$Global:GroupFile_RunType,"noloop"
                                LocalLogWrite "*---------------------------------*"
                            }
                        }else{
                            LocalLogWrite "ERR: No Group Script Imported"
                            LocalLogWrite "*---------------------------------*"
                        }
                    }else{
                        if (-not ($PreReq_Script -eq $true)){
                            LocalLogWrite "ERR: No Group File Imported"
                        }
                        LocalLogWrite "*---------------------------------*"
                    }

                    # Clear Selected File
                })
			# GroupFile Groupbox Container
				$GroupFileOption_Groupbox = New-Object $Groupbox_Object
				$GroupFileOption_Groupbox.Size = New-Object System.Drawing.Point(300,180)
				$GroupFileOption_Groupbox.Controls.AddRange(@($GroupFileSelectHeader_Label))
				$GroupFileOption_Groupbox.Location = New-Object System.Drawing.Point(330,35)
		

# Display Log
##############################################
			# Log Extension (Extend to Right)
            <#	# Extend Label
				$ExtendLog_Label = New-Object $Label_Object
				$ExtendLog_Label.Text = ">"
				$ExtendLog_Label.Font = $Global:DefaultFont12
				$ExtendLog_Label.BackColor = "LightGray"
				$ExtendLog_Label.TextAlign = "MiddleCenter"
				$ExtendLog_Label.Size = New-Object System.Drawing.Point(20,50)
				$ExtendLog_Label.Location = New-Object System.Drawing.Point(620,110)
				$ExtendLog_Label.Add_Click({
					if ($Global:LogShow -eq $false){
						#Write-Host "Open Log"
						$MainForm.ClientSize = "900,275"
						$ExtendLog_Label.Text = "<"
						$Global:LogShow = $true
					}else{
						#Write-Host "Close Log"
						$MainForm.ClientSize = "640,275"
						$ExtendLog_Label.Text = ">"
						$Global:LogShow = $false
					}
				})
            #>
            # Drop Label
				$DropLog_Label = New-Object $Label_Object
				$DropLog_Label.Text = "show"
				$DropLog_Label.Font = $Global:DefaultFont10Bold
				$DropLog_Label.BackColor = "LightGray"
				$DropLog_Label.TextAlign = "MiddleCenter"
				$DropLog_Label.Size = New-Object System.Drawing.Point(60,25)
				$DropLog_Label.Location = New-Object System.Drawing.Point(580,250)
				$DropLog_Label.Add_Click({
					if ($Global:LogShow -eq $false){
						$MainForm.ClientSize = "640,425"
						$DropLog_Label.Text = "hide"
                        $DropLog_Label.Location = New-Object System.Drawing.Point(580,400)
                        $DriveLetter_Label.Location = New-Object System.Drawing.Point(10,400)
						$Global:LogShow = $true
					}else{
						$MainForm.ClientSize = "640,275"
						$DropLog_Label.Text = "show"
                        $DropLog_Label.Location = New-Object System.Drawing.Point(580,250)
                        $DriveLetter_Label.Location = New-Object System.Drawing.Point(10,250)
						$Global:LogShow = $false
					}
				})
		    # Display Log Rich Textbox
                $DisplayLog_RichTextBox = New-Object $RichTextBox_Object
                $DisplayLog_RichTextBox.Font = $Global:DefaultFont9
                $DisplayLog_RichTextBox.ReadOnly = $true
                $DisplayLog_RichTextBox.ForeColor = $Global:DefaultColorWhite
                $DisplayLog_RichTextBox.BackColor = "#012456"
                $DisplayLog_RichTextBox.Text = ""
                $DisplayLog_RichTextBox.TabIndex = $null
                $DisplayLog_RichTextBox.Size = New-Object System.Drawing.Point(575,115)
                $DisplayLog_RichTextBox.Location = New-Object System.Drawing.Point(30,275)
                $DisplayLog_RichTextBox.Add_TextChanged({
                    <#
                    Write-Host "$Global:SessionStart"
                    Write-Host $DisplayLog_RichTextBox.Text
                    #>
                    #Write-Host "changed"
                    if ($Global:SessionStart -eq $DisplayLog_RichTextBox.Text){
                        $EditMenuItem_ClearLog.Enabled = $false
                        $FileMenuItem_SaveLog.Enabled = $false
                        $FileMenuItem_SaveClose.Enabled = $false
                    }elseif($DisplayLog_RichTextBox.Text -eq "" -or $DisplayLog_RichTextBox.Text -eq $null){
                        $EditMenuItem_ClearLog.Enabled = $false
                        $FileMenuItem_SaveLog.Enabled = $false
                        $FileMenuItem_SaveClose.Enabled = $false
                    }else{
                        $EditMenuItem_ClearLog.Enabled = $true
                        $FileMenuItem_SaveLog.Enabled = $true
                        $FileMenuItem_SaveClose.Enabled = $true
                    }
                })

# Drive Letter
##############################################

		# Drive Letter Label
			$DriveLetter_Label = New-Object $Label_Object
			$DriveLetter_Label.Text = "Drive( $Drive )"
			$DriveLetter_Label.Font = $Global:DefaultFont9
			$DriveLetter_Label.Size = New-Object System.Drawing.Point(90,30)
			$DriveLetter_Label.Location = New-Object System.Drawing.Point(10,250)
			$DriveLetter_Label.Add_Click({
				#start drive selection powershell or gui
				#Write-Host "Changing Drive Selection"
                [System.Environment]::SetEnvironmentVariable('SysaDrive','','User')
                $MainForm.Close()
<#
				$Path = "$Drive\Sysa\Imported\select\drive.ps1"
                $ogDrive = $Drive
				Start-Process -Wait -FilePath powershell.exe -ArgumentList $Path,$
				$Drive = [System.Environment]::GetEnvironmentVariable('SysaDrive','User')
                if ($ogDrive -ne $Drive){
					$MainForm.Close()
                }
#>
			})
##############################################
##############################################

		# MainForm Contents
			# Single Selection
				$MainForm.Controls.AddRange(@(
				$ToolbarStrip
				$SingleSelectHeader_Label
				$Username_Label
				$Username_Textbox
				$Username_Checkbox
				$System_Label
				$System_Textbox
				$System_CheckBox
				$Combo_Checkbox
				$Action_Combobox
				$ScriptSelect_Combobox
				$SingleSelectRun_Button
				$SingleOption_Groupbox
			# GroupFile Selection
				$GroupFileSelectHeader_Label
                $GroupFileSelection_ComboBox
                $GroupFileImport_Button
                $GroupFileSelection_Label
                $GroupFileLoop_Checkbox
                $GroupFileScriptSelection_Combobox
                $GroupFileFormatName_Label
                $GroupFileFormat_Label
                $GroupFileSelectRun_Button
				$GroupFileOption_Groupbox
            # Drive Selection Label
				$DriveLetter_Label
			# Log Extension
				$ExtendLog_Label
                $DropLog_Label
                $DisplayLog_RichTextBox
			))
		# Log Session Data *temp data storage while using app* SAVE BEFORE EXITING unless Session auto-save is enabled there is 
			function LocalLogWrite{
				Param ([string]$logString)
				[string]$log = (${DisplayLog_RichTextBox}.Text).ToString()
				if ($log -ne ""){
					$DisplayLog_RichTextBox.AppendText("`n$logString")
					$DisplayLog_RichTextBox.ScrollToCaret()
				}else{
					$DisplayLog_RichTextBox.AppendText($logString)
					$DisplayLog_RichTextBox.ScrollToCaret()
				}
			}
		# Show MainForm
			$MainForm.ShowDialog() | Out-Null
		}else{
            # Drive Selection

            ##############################################
            ##############################################

            $DriveSelection_Form = New-Object $Form_Object
            $DriveSelection_Form.Text = "Sysa Drive Selection"
            $DriveSelection_Form.ClientSize = New-Object System.Drawing.Point(400,150)
	        $DriveSelection_Form.FormBorderStyle = "Fixed3D" #FixedDialog, Fixed3D
	        $DriveSelection_Form.StartPosition = [Windows.Forms.FormStartPosition]::CenterScreen
	        $DriveSelection_Form.Icon = $Global:imgIcon
            $DriveSelection_Form.Add_FormClosing({
                $DriveSelection_Form.Dispose()
            })
            $DriveSelection_Form.Add_Load({
                # Add Delay
                Start-Sleep -Seconds 1

		        #PS Script
		        [System.Collections.ArrayList]$Alpha = @('A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z')
		        $Found = $false
		        $Global:FoundDrive = $null
                $DriveSelectionChoice_Combo.Controls.Add($null)
		        foreach($d in $Alpha){
                    $d = $d.ToString()
			        if (Test-Path "$d`:\Sysa"){
                        if ($Found -eq $false){
                            $Global:FoundDrive = $d
                            $Global:SelectDrivePath = "$Global:FoundDrive`:\Sysa\Imported\select\drive.ps1"
                        }
				        $Found = $true                    
                        $DriveSelectionMessage_Label.Text = "Drive Found at `: $Global:FoundDrive"
                        $DriveSelectionChoice_Combo.Controls.Add($d) | Out-Null
			        }
		        }
		        if (-not($Found)){
                    $DriveSelectionChoice_Combo.Enabled = $false
                    $DriveSelectionChoice_Button.Enabled = $false
			        $DriveSelectionMessage_Label.Text = "ERR:: Not Found:: CHK PKG LOCA"
                    $Path = $null
                    $Found = $false
                    $Global:FoundDrive = $null
                    Start-Sleep -Seconds 1
                    $DriveSelection_Form.Dispose()
		        }
            })

            $SysaLogo_PicBox = New-Object $Picturebox_Object
            $SysaLogo_PicBox.Image = $Global:ImgIcon
            $SysaLogo_PicBox.Size = New-Object System.Drawing.Point(100,100)
            $SysaLogo_PicBox.Location = New-Object System.Drawing.Point(25,25)
            $SysaLogo_PicBox.SizeMode = "StretchImage"

            $DriveSelectionTitle_Label = New-Object $Label_Object
            $DriveSelectionTitle_Label.Text = "Sysa Drive Selection"
            $DriveSelectionTitle_Label.Font = New-Object System.Drawing.Font("Calibri",11,[System.Drawing.FontStyle]::Bold)
            $DriveSelectionTitle_Label.TextAlign = "MiddleCenter"
            $DriveSelectionTitle_Label.Size = New-Object System.Drawing.Point(150,25)
            $DriveSelectionTitle_Label.Location = New-Object System.Drawing.Point(200,25)

            $DriveSelectionMessage_Label = New-Object $Label_Object
            $DriveSelectionMessage_Label.Text = "Starting Drive Search"
            #$DriveSelectionMessage_Label.Text = "Drive Found : $FoundDrive"
            $DriveSelectionMessage_Label.Font = New-Object System.Drawing.Font("Calibri",11)
            $DriveSelectionMessage_Label.TextAlign = "MiddleCenter"
            $DriveSelectionMessage_Label.Size = New-Object System.Drawing.Point(150,25)
            $DriveSelectionMessage_Label.Location = New-Object System.Drawing.Point(200,50)

            $DriveSelectioinChange_Label = New-Object $Label_Object
            $DriveSelectioinChange_Label.Text = "Change Option"#"$FoundDrive"
            $DriveSelectioinChange_Label.Font = New-Object System.Drawing.Font("Calibri",11)
            $DriveSelectioinChange_Label.TextAlign = "MiddleCenter"
            $DriveSelectioinChange_Label.Size = New-Object System.Drawing.Point(100,25)
            $DriveSelectioinChange_Label.Location = New-Object System.Drawing.Point(190,75)

            $DriveSelectionChoice_Combo = New-Object $Combobox_Object
            $DriveSelectionChoice_Combo.Text = "Selection"
            $DriveSelectionChoice_Combo.TabIndex = 2
            $DriveSelectionChoice_Combo.Font = New-Object System.Drawing.Font("Calibri",11)
            $DriveSelectionChoice_Combo.Size = New-Object System.Drawing.Point(80,26)
            $DriveSelectionChoice_Combo.Location = New-Object System.Drawing.Point(200,100)

            $DriveSelectionChoice_Button = New-Object $Button_Object
            $DriveSelectionChoice_Button.Text = "Set"
            $DriveSelectionChoice_Button.TabIndex = 1
            $DriveSelectionChoice_Button.Font = New-Object System.Drawing.Font("Calibri",11)
            $DriveSelectionChoice_Button.Size = New-Object System.Drawing.Point(75,25)
            $DriveSelectionChoice_Button.Location = New-Object System.Drawing.Point(300,100)
            $DriveSelectionChoice_Button.Add_Click({
                $SelectedDrive = $DriveSelectionChoice_Combo.SelectedItem
                if ($SelectedDrive -eq $null){
                    if ($Global:FoundDrive -eq $null){
                        $DriveSelectionMessage_Label.Text = "Nothing Selected"
                        Start-Sleep -Seconds 2
                        $DriveSelection_Form.Dispose()
                    }else{
                        #Write-Host "Path : $Global:SelectDrivePath"
                        #Write-Host "FoundDrive : $Global:FoundDrive"
                        if ($Global:SelectDrivePath -eq $null){
                            $DriveSelectionMessage_Label.Text = "No Path Found here"
                            Start-Sleep -Seconds 2
                            $DriveSelection_Form.Dispose()
                        }else{
                            #Write-Host "Path : $Global:SelectDrivePath"
                            #Write-Host "FoundDrive : $Global:FoundDrive"
                            if ($Global:SelectDrivePath -eq $null){
                                $DriveSelectionMessage_Label.Text = "No Path Found here"
                                Start-Sleep -Seconds 2
                                $DriveSelection_Form.Dispose()
                            }else{
                                # Disable functionality
                                    $DriveSelectionChoice_Combo.Enabled = $false
                                    $DriveSelectionChoice_Button.Enabled = $false
                                # Setting Drive
                                    $DriveSelectionMessage_Label.Text = "Mounting : $Global:FoundDrive"
                                    $ps = "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
			                        Start-Process -FilePath $ps -Wait -WindowStyle Hidden -ArgumentList $Global:SelectDrivePath,$Global:FoundDrive
                                    $shortcutPath = "$Global:FoundDrive`:\Sysa\Imported\select\shortcut.ps1"
                                # Create Shortcut Test
                                    $DriveSelectionMessage_Label.Text = "*Creating Shortcuts*"
                                    try{
                                        Start-Process -FilePath $ps -Verb RunAs -WindowStyle Hidden -ArgumentList $shortcutPath,$Global:FoundDrive
                                    }catch{
                                        Write-Error -Message "Failed making shortcut" -ErrorAction Continue
                                    }
                                # Check and Create Files directory and Starting Files
                                    $DriveSelectionMessage_Label.Text = "*Creating File Directory*"
                                    $StartDirPath = "$Global:FoundDrive`:\Sysa"
                                    if (Test-Path -Path "$StartDirPath\Files"){
                                        Remove-Item -Path "$StartDirPath\Files" -Recurse -Force -Confirm:$false -ErrorAction SilentlyContinue -WarningAction SilentlyContinue | Out-Null
                                        New-Item -Path "$StartDirPath\Files" -ItemType File -Name "systems.s" -Force -Confirm:$false -ErrorAction SilentlyContinue -WarningAction SilentlyContinue | Out-Null
                                        New-Item -Path "$StartDirPath\Files" -ItemType File -Name "users.u" -Force -Confirm:$false -ErrorAction SilentlyContinue -WarningAction SilentlyContinue | Out-Null
                                        New-Item -Path "$StartDirPath\Files" -ItemType File -Name "combo.cb" -Force -Confirm:$false -ErrorAction SilentlyContinue -WarningAction SilentlyContinue | Out-Null
                                        New-Item -Path "$StartDirPath\Files" -ItemType File -Name "comboAndGroup.cbg" -Force -Confirm:$false -ErrorAction SilentlyContinue -WarningAction SilentlyContinue | Out-Null
                                    }else{
                                        New-Item -Path "$StartDirPath\Files" -ItemType File -Name "systems.s" -Force -Confirm:$false -ErrorAction SilentlyContinue -WarningAction SilentlyContinue | Out-Null
                                        New-Item -Path "$StartDirPath\Files" -ItemType File -Name "users.u" -Force -Confirm:$false -ErrorAction SilentlyContinue -WarningAction SilentlyContinue | Out-Null
                                        New-Item -Path "$StartDirPath\Files" -ItemType File -Name "combo.cb" -Force -Confirm:$false -ErrorAction SilentlyContinue -WarningAction SilentlyContinue | Out-Null
                                        New-Item -Path "$StartDirPath\Files" -ItemType File -Name "comboAndGroup.cbg" -Force -Confirm:$false -ErrorAction SilentlyContinue -WarningAction SilentlyContinue | Out-Null
                                    }
                                # Display Completion
                                    $DriveSelectionMessage_Label.Text = "*Process Complete*"
                                    Start-Sleep -Seconds 1
                                    $DriveSelectionMessage_Label.Text = "*Please re-open utility*"
                            }
                        }
                    }
                }else{
                    #Write-Host "Path : $Global:SelectDrivePath"
                    #Write-Host "FoundDrive : $Global:FoundDrive"
                    if ($Global:SelectDrivePath -eq $null){
                        $DriveSelectionMessage_Label.Text = "No Path Found here"
                        Start-Sleep -Seconds 2
                        $DriveSelection_Form.Dispose()
                    }else{
                        # Disable functionality
                            $DriveSelectionChoice_Combo.Enabled = $false
                            $DriveSelectionChoice_Button.Enabled = $false
                        # Setting Drive
                            $DriveSelectionMessage_Label.Text = "Mounting : $Global:FoundDrive"
                            $ps = "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
			                Start-Process -FilePath $ps -Wait -WindowStyle Hidden -ArgumentList $Global:SelectDrivePath,$Global:FoundDrive
                            $shortcutPath = "$Global:FoundDrive`:\Sysa\Imported\select\shortcut.ps1"
                        # Create Shortcut Test
                            $DriveSelectionMessage_Label.Text = "*Creating Shortcuts*"
                            try{
                                Start-Process -FilePath $ps -Verb RunAs -WindowStyle Hidden -ArgumentList $shortcutPath,$Global:FoundDrive
                            }catch{
                                Write-Error -Message "Failed making shortcut" -ErrorAction Continue
                            }
                        # Check and Create Files directory and Starting Files
                            $DriveSelectionMessage_Label.Text = "*Creating File Directory*"
                            $StartDirPath = "$Global:FoundDrive`:\Sysa"
                            if (Test-Path -Path "$StartDirPath\Files"){
                                Remove-Item -Path "$StartDirPath\Files" -Recurse -Force -Confirm:$false -ErrorAction SilentlyContinue -WarningAction SilentlyContinue | Out-Null
                                New-Item -Path "$StartDirPath\Files" -ItemType File -Name "systems.s" -Force -Confirm:$false -ErrorAction SilentlyContinue -WarningAction SilentlyContinue | Out-Null
                                New-Item -Path "$StartDirPath\Files" -ItemType File -Name "users.u" -Force -Confirm:$false -ErrorAction SilentlyContinue -WarningAction SilentlyContinue | Out-Null
                                New-Item -Path "$StartDirPath\Files" -ItemType File -Name "combo.cb" -Force -Confirm:$false -ErrorAction SilentlyContinue -WarningAction SilentlyContinue | Out-Null
                                New-Item -Path "$StartDirPath\Files" -ItemType File -Name "comboAndGroup.cbg" -Force -Confirm:$false -ErrorAction SilentlyContinue -WarningAction SilentlyContinue | Out-Null
                            }else{
                                New-Item -Path "$StartDirPath\Files" -ItemType File -Name "systems.s" -Force -Confirm:$false -ErrorAction SilentlyContinue -WarningAction SilentlyContinue | Out-Null
                                New-Item -Path "$StartDirPath\Files" -ItemType File -Name "users.u" -Force -Confirm:$false -ErrorAction SilentlyContinue -WarningAction SilentlyContinue | Out-Null
                                New-Item -Path "$StartDirPath\Files" -ItemType File -Name "combo.cb" -Force -Confirm:$false -ErrorAction SilentlyContinue -WarningAction SilentlyContinue | Out-Null
                                New-Item -Path "$StartDirPath\Files" -ItemType File -Name "comboAndGroup.cbg" -Force -Confirm:$false -ErrorAction SilentlyContinue -WarningAction SilentlyContinue | Out-Null
                            }
                        # Display Completion
                            $DriveSelectionMessage_Label.Text = "*Process Complete*"
                            Start-Sleep -Seconds 1
                            $DriveSelectionMessage_Label.Text = "*Please re-open utility*"
                    }
                }
            })

            $DriveSelection_Form.Controls.AddRange(@(
                $SysaLogo_PicBox
                $DriveSelectionTitle_Label
                $DriveSelectionMessage_Label
                $DriveSelectioinChange_Label
                $DriveSelectionChoice_Combo
                $DriveSelectionChoice_Button
            ))

            $DriveSelection_Form.ShowDialog() | Out-Null
		    # test drive	
		    $Path = "$Drive\Sysa"
		    if ((Test-Path -Path "$Drive\Sysa") -and $Path -ne "\Sysa"){
			    $Path = "$Drive\Sysa\$Global:AppName$Global:AppVer.ps1"
			    Write-Host "*Process Complete*"
			    Write-Host "------------------"
			    Write-Host "Please re-open utility"
			    $DriveSelection_Form.Dispose()
		    }else{
			    $DriveSelection_Form.Dispose()
		    }
        }
}
##############################################
##############################################
##############################################
##############################################