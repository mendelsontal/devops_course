## Name
Linux Setup Task

## Task Description
As part of junior devops team, there are tedious task of getting ready development and testing environments for POC's.
Some times it is done by IT or Ops teams, yet in other cases it falls on your shoulders.
As part of this task you need to manually setup virtual machine with all basic tools for your usage, backup the all the configuration files for future use, setup text editors and IDE of your choice.

## Usage
1.  On your Windows machine, run "OracleVM.ps1" with powershell (REQUIRES VirtualBox)or create one manualy (skip to step #4)
2.  Select Option 1# to create a new VM machine
3.  Fill all the requirements and click "Save VM parameters"
4.  Power the machine & complete the iso installation
5.  Copy "InstallScript.sh" to the newly created machine
6.  Change "InstallScript.sh" to be executable # chmod +x InstallScript.sh
7.  Run the script # sudo ./InstallScript.sh
8.  After finishing, you can use "OracleVM.ps1" to create an OVA from this machine
9.  ???
10. Profit

## Project status
Working on it