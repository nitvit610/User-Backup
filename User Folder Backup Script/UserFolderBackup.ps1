<#
.SYNOPSIS 
Copy user folder to network backup folder.

.DESCRIPTION
GUI-based script will copy a designated (based on input in a GUI) local user folder to the \\RFSERLIV01\IT\Leaver backups folder.

.EXAMPLE
Putting in woodso into username box will copy the user folder woodso to the network backup folder.

.NOTES
The GUI will have a box asking for username input, you should put in the desired user that you want to backup into this box and then hit enter or click backup.
This will then copy the user folder to the network backup folder.
#>

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

#region begin GUI{ 

$Form                            = New-Object system.Windows.Forms.Form
$Form.ClientSize                 = '350,200'
$Form.text                       = "Form"
$Form.TopMost                    = $false
$Form.FormBorderStyle            = 'Fixed3D'
$Form.MaximizeBox                = $false 

$UsernameLabel                   = New-Object system.Windows.Forms.Label
$UsernameLabel.text              = "Username:"
$UsernameLabel.AutoSize          = $true
$UsernameLabel.width             = 25
$UsernameLabel.height            = 10
$UsernameLabel.location          = New-Object System.Drawing.Point(5,10)
$UsernameLabel.Font              = 'Microsoft Sans Serif,10'

$UsernameTextbox                 = New-Object system.Windows.Forms.TextBox
$UsernameTextbox.multiline       = $false
$UsernameTextbox.text            = ""
$UsernameTextbox.width           = 164
$UsernameTextbox.height          = 20
$UsernameTextbox.location        = New-Object System.Drawing.Point(77,9)
$UsernameTextbox.Font            = 'Microsoft Sans Serif,10'

$BackupButton                    = New-Object system.Windows.Forms.Button
$BackupButton.text               = "Backup"
$BackupButton.width              = 60
$BackupButton.height             = 30
$BackupButton.location           = New-Object System.Drawing.Point(265,6)
$BackupButton.Font               = 'Microsoft Sans Serif,10'

$ResultsTextBox                  = New-Object system.Windows.Forms.TextBox
$ResultsTextBox.multiline        = $true
$ResultsTextBox.width            = 340
$ResultsTextBox.height           = 145
$ResultsTextBox.location         = New-Object System.Drawing.Point(5,50)
$ResultsTextBox.Font             = 'Microsoft Sans Serif,10'

$Form.controls.AddRange(@($UsernameLabel,$UsernameTextbox,$BackupButton,$ResultsTextBox))

#region gui events {
$BackupButton.Add_Click({

    backupFolder    

  })

  $usernameTextbox.Add_KeyDown({
    if ($_.KeyCode -eq 'Enter')
    {
        $backupButton.PerformClick()

    }
})

#endregion events }

#endregion GUI }


#Write your logic code here

$serverPath = "filesystem::\\rfserliv01\IT\Leaver backups"

function backupFolder{

    $username = $usernameTextbox.Text
    $userPath = Join-Path C:\Users $username
    $serverPathFolderCheck = $serverPath + "\" + $username

    $userPathCheck = Test-Path -Path $userPath
    $serverPathCheck = Test-Path -Path $serverPathFolderCheck

    if ($userPathCheck -eq $true)
    {
        if ($serverPathCheck -eq $false){

            $resultsTextBox.text = "Copying $userPath to $serverPath" + ".`n"

            Copy-Item $userPath -Destination $serverPath -Recurse -Force

            $resultsTextBox.AppendText("Complete.")
        }

        else {
            $resultsTextBox.AppendText("That user already exists in backup location. Please remove or rename existing folder and try again.`n")
        }

    }

    else {
        $resultsTextBox.AppendText("That user does not exist. Please try again.`n")
    }

}


[void]$Form.ShowDialog()