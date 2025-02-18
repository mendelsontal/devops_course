<###################################################

  ,-.       _,---._ __  / \
 /  )    .-'       `./ /   \
(  (   ,'            `/    /|
 \  `-"             \'\   / |
  `.              ,  \ \ /  |
   /`.          ,'-`----Y   |
  [            ;        |   '
  |  ,-.    ,-'         |  /
  |  | (   |            | /
  )  |  \  `.___________|/
  `--'   `--'

############### By Tal Mendelson ##################
#Developed by: Tal Mendelson
#Purpose: Manage Oracle VirtualBox via powershell
#Date:14/02/2025
#Version: 0.0.1
###################################################>

# Loads the "gui" function
try {
    . .\virtualboxparam.ps1  # Load the parameters
} catch {
    Write-Host "Error occurred: $_" -ForegroundColor Red
}

# VirtualBox ENV variables
$envVarValue = "C:\Program Files\Oracle\VirtualBox\"
$envVarName = "VirtualBox"
$VBoxManage = "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe"

# Get system variables and check if VirtualBox exists and adds if it doesn't
$V = [System.Environment]::GetEnvironmentVariables("User")
if (!($V.VirtualBox -like $envVarValue)){
    # Add the VirtualBox system enviroment if missing
     [System.Environment]::SetEnvironmentVariable($envVarName, $envVarValue, "User")
}

# Sets global var
$global:VMs = @()

# Lists all current VMs
$VMmachines = & $VBoxManage list vms

# Array for keeping the VM names
foreach($VM in $VMmachines){
$global:VMs += [pscustomobject]@{
    HostName = $VM -split '"' | Select-Object -Index 1
    }
}


# Select action
$Options = @(
    "1. Create a new VM",
    "2. Create an OVA from an existing VM"
)

Clear-Host

# Menu
while ($true) {
    Write-Host "`nPlease select action from the menu below:`n*****************************************"
    foreach ($Option in $Options) {
        Write-Host $Option
    }
    write-host "`n*****************************************"

    $Selection = Read-Host "`nPlease enter your selection (Numbers) "

    # Check if input is valid
    if ($Selection -ne $null -and $Selection -gt 0 -and $Selection -le $Options.Count) {
        switch ($Selection) {
            1 {
                Write-Host "You selected: Create a new VM"
                # Call function to create a new VM
                select-param  # Call the 'gui 'function

                # Params
                $Global:diskSize = [int]$Global:diskSize * 1024 # converting to MB from GB
                $VMPath = "C:\Users\$env:USERNAME\VirtualBox VMs\$Global:HostName"

                if ($Global:allset -eq $true){
                # Create VM
                & $VBoxManage createvm --name $Global:HostName --ostype $Global:osType --register
                & $VBoxManage modifyvm "$Global:HostName" --memory $Global:ramSize --cpus $Global:cpuCount --vram 128 --boot1 dvd --nic1 nat --graphicscontroller vmsvga
                & $VBoxManage createhd --filename "$VMPath\$Global:HostName.vdi" --size $Global:diskSize --format VDI
                & $VBoxManage storagectl $Global:HostName --name "SATA Controller" --add sata --controller IntelAhci
                & $VBoxManage storageattach $Global:HostName --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "$VMPath\$Global:HostName.vdi"
                & $VBoxManage storagectl $Global:HostName --name "IDE Controller" --add ide
                & $VBoxManage storageattach $Global:HostName --storagectl "IDE Controller" --port 1 --device 0 --type dvddrive --medium "$Global:isoPath"
                }

                break
            }
            2 { Clear-Host
                while ($true){
                
                Write-Host "You selected: Create an OVA from an existing VM"
                # Call function to create OVA
                $n = 0
                $HostOVA = @()

                foreach($VmMachine in $global:VMs.Hostname){
                    $n+=1
                    $HostOVA+= "$n" + ". " + $VmMachine
                }
                    Write-Host "`nPlease select a machine from the options below:`n***********************************************"
                    foreach($one in $HostOVA){
                        Write-host $one
                    }

                    Write-Host "***********************************************"
                    $SelectionOVA = Read-Host "`nPlease enter your selection (Numbers) "
                        if ($SelectionOVA -ne $null -and $Selection -gt 0 -and $SelectionOVA -le $HostOVA.Count){
                            # Name
                            $SelVMName = $global:VMs.Hostname[$SelectionOVA-1]
                            $State = & $VBoxManage showvminfo $SelVMName --machinereadable | Select-String "VMState="
                            if ($State -like '*running*'){
                                & $VBoxManage controlvm "$SelVMName" poweroff
                                sleep -Seconds 15
                            }

                            & $VBoxManage export "$SelVMName" --output "C:\Users\$env:USERNAME\VirtualBox VMs\$SelVMName.ova"
                            break
                           } else {
                                    Clear-Host
                                    Write-Host "Invalid input. Please enter a valid number between 1 and " $HostOVA.Count  "`n"                            
                           }

                
            } }
        }
        break  # Exit the loop after a valid selection
    } else {
        Clear-Host
        Write-Host "Invalid input. Please enter a valid number between 1 and " $Options.Count
        
    }
}