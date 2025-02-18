function select-param {
# Load the required .NET assemblies for Windows Forms
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Set the default font size for all controls (e.g., 10pt for readability)
$font = New-Object System.Drawing.Font("Arial", 10)

# Create the form
$form = New-Object System.Windows.Forms.Form
$form.Text = 'Create VirtualBox VM'
$form.Width = 600
$form.Height = 400

# Create label for HostName
$labelHostName = New-Object System.Windows.Forms.Label
$labelHostName.Text = 'HostName:'
$labelHostName.Location = New-Object System.Drawing.Point(10, 20)
$labelHostName.Width = 100
$labelHostName.Font = $font
$form.Controls.Add($labelHostName)

# Create TextBox for HostName input
$textBoxHostName = New-Object System.Windows.Forms.TextBox
$textBoxHostName.Location = New-Object System.Drawing.Point(120, 20)
$textBoxHostName.Width = 350
$textBoxHostName.Font = $font
$form.Controls.Add($textBoxHostName)

# Create label for ISO
$labelIso = New-Object System.Windows.Forms.Label
$labelIso.Text = 'ISO Path:'
$labelIso.Location = New-Object System.Drawing.Point(10, 60)
$labelIso.Width = 100
$labelIso.Font = $font
$form.Controls.Add($labelIso)

# Create TextBox for displaying selected ISO path
$textBoxIso = New-Object System.Windows.Forms.TextBox
$textBoxIso.Location = New-Object System.Drawing.Point(120, 60)
$textBoxIso.Width = 350
$textBoxIso.Font = $font
$form.Controls.Add($textBoxIso)

# Create Browse button to open FileDialog
$buttonBrowse = New-Object System.Windows.Forms.Button
$buttonBrowse.Text = 'Browse'
$buttonBrowse.Location = New-Object System.Drawing.Point(480, 60)
$buttonBrowse.Width = 80
$form.Controls.Add($buttonBrowse)

# Define Browse button click event
$buttonBrowse.Add_Click({
    # Open FileDialog to select ISO file
    $fileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $fileDialog.Filter = 'ISO Files|*.iso'
    
    if ($fileDialog.ShowDialog() -eq 'OK') {
        # Set selected file path to TextBox
        $textBoxIso.Text = $fileDialog.FileName
    }
})

# Create label for OSType
$labelOSType = New-Object System.Windows.Forms.Label
$labelOSType.Text = 'OS Type'
$labelOSType.Location = New-Object System.Drawing.Point(10, 100)
$labelOSType.Width = 100
$labelOSType.Font = $font
$form.Controls.Add($labelOSType)

# OSType selection (ComboBox)
$comboBoxOSType = New-Object System.Windows.Forms.ComboBox
$comboBoxOSType.Location = New-Object System.Drawing.Point(120, 100)
$comboBoxOSType.Width = 350
$comboBoxOSType.Items.AddRange(("Ubuntu_64","Debian_64","Windows10_64","Windows11_64"))
$comboBoxOSType.Font = $font
$form.Controls.Add($comboBoxOSType)

# Create label for Disk Size
$labelDiskSize = New-Object System.Windows.Forms.Label
$labelDiskSize.Text = 'Disk Size (GB):'
$labelDiskSize.Location = New-Object System.Drawing.Point(10, 140)
$labelDiskSize.Width = 100
$labelDiskSize.Font = $font
$form.Controls.Add($labelDiskSize)

# Create TextBox for Disk Size input
$textBoxDiskSize = New-Object System.Windows.Forms.TextBox
$textBoxDiskSize.Location = New-Object System.Drawing.Point(120, 140)
$textBoxDiskSize.Width = 350
$textBoxDiskSize.Text = '25'  # Default size in GB
$textBoxDiskSize.Font = $font
$form.Controls.Add($textBoxDiskSize)

# Create label for RAM
$labelRam = New-Object System.Windows.Forms.Label
$labelRam.Text = 'RAM (MB):'
$labelRam.Location = New-Object System.Drawing.Point(10, 180)
$labelRam.Width = 100
$labelRam.Font = $font
$form.Controls.Add($labelRam)

# RAM selection (ComboBox)
$comboBoxRam = New-Object System.Windows.Forms.ComboBox
$comboBoxRam.Location = New-Object System.Drawing.Point(120, 180)
$comboBoxRam.Width = 350
$comboBoxRam.Items.AddRange((1,2,4,8,16 | ForEach-Object { $_ * 512 }))  # RAM options in MB
$comboBoxRam.SelectedIndex = 3  # Default: 4GB
$comboBoxRam.Font = $font
$form.Controls.Add($comboBoxRam)

# Create label for CPUs
$labelCpu = New-Object System.Windows.Forms.Label
$labelCpu.Text = 'CPUs:'
$labelCpu.Location = New-Object System.Drawing.Point(10, 220)
$labelCpu.Width = 100
$labelCpu.Font = $font
$form.Controls.Add($labelCpu)

# CPU selection (ComboBox)
$comboBoxCpu = New-Object System.Windows.Forms.ComboBox
$comboBoxCpu.Location = New-Object System.Drawing.Point(120, 220)
$comboBoxCpu.Width = 350
$comboBoxCpu.Items.AddRange(1..4)  # CPU options (1 to 4 CPUs)
$comboBoxCpu.SelectedIndex = 0  # Default: 2 CPUs
$comboBoxCpu.Font = $font
$form.Controls.Add($comboBoxCpu)

# Create button to start VM creation
$buttonSave = New-Object System.Windows.Forms.Button
$buttonSave.Text = 'Save VM parameters'
$buttonSave.Location = New-Object System.Drawing.Point(120, 260)
$buttonSave.Width = 200  # Adjusted width for better fit
$form.Controls.Add($buttonSave)

# Define the button click event
$buttonSave.Add_Click({
    # Get user inputs
    $Global:HostName = $textBoxHostName.Text
    $Global:isoPath  = $textBoxIso.Text
    $Global:osType   = $comboBoxOSType.SelectedItem
    $Global:diskSize = $textBoxDiskSize.Text
    $Global:ramSize  = $comboBoxRam.SelectedItem
    $Global:cpuCount = $comboBoxCpu.SelectedItem

    # Validate inputs
    $CheckEmpty = ($Global:isoPath -eq '' -or $Global:diskSize -eq '' -or $Global:ramSize -eq '' -or $Global:cpuCount -eq '' -or $Global:HostName -eq '' -or $Global:osType -eq '')
    $CheckPath = !(test-path $Global:isoPath)
    $CheckNameNotUsed = ($Global:HostName -in $global:VMs.HostName)

    if ($CheckEmpty -eq $true) {
        [System.Windows.Forms.MessageBox]::Show("All fields must be filled in!", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    }

    if ($CheckPath -eq $true){
        [System.Windows.Forms.MessageBox]::Show("Iso file not found in the path specified", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    }

    if ($CheckNameNotUsed -eq $true){
        [System.Windows.Forms.MessageBox]::Show("The machine name is already in use! Please provide a different name.", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    }

if ($CheckEmpty -eq $false -and $CheckPath -eq $false -and $CheckNameNotUsed -eq $false){
    $Global:allset = $true
    $form.Close()
}

})

# Show the form
$form.ShowDialog()
}





<# else {
        # Proceed to create the VM
        $diskPath = "C:\Users\$env:USERNAME\VirtualBox VMs\$vmName\$vmName.vdi"  # Change user path
        try {
            # Create and configure the VM
            VBoxManage.exe createvm --name $vmName --ostype "Debian_64" --register
            VBoxManage.exe modifyvm $vmName --memory $ramSize --cpus $cpuCount --vram 128 --boot1 dvd --nic1 nat
            VBoxManage.exe createhd --filename $diskPath --size $diskSize --format VDI
            VBoxManage.exe storagectl $vmName --name "SATA Controller" --add sata --controller IntelAhci
            VBoxManage.exe storageattach $vmName --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium $diskPath
            VBoxManage.exe storagectl $vmName --name "IDE Controller" --add ide
            VBoxManage.exe storageattach $vmName --storagectl "IDE Controller" --port 1 --device 0 --type dvddrive --medium $isoPath
            VBoxManage.exe startvm $vmName

            # Success message
            [System.Windows.Forms.MessageBox]::Show("VM '$vmName' created and started successfully!", "Success", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
        } catch {
            # Error message
            [System.Windows.Forms.MessageBox]::Show("Error creating the VM: $_", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        }
    } #>