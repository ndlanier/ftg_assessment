$inMenu = 1
$PSScriptRoot
$buildScript = $PSScriptRoot+"\build.ps1"
do {
Write-Output @"
############################################################
##----------- Docker Image Deployment Tool ---------------##
##                                                        ##
## Author: Nathan Lanier                                  ##
## Description:                                           ##
##  Selection of scripts used to deploy a test            ##
##  aplication for a skills assessment.                   ##
##                                                        ##
## Options:                                               ##
##      1 - Validate Secret Settings                      ##
##      2 - Build Docker Image                            ##
##      3 - Deploy Docker Image                           ##
##      4 - Build and Deploy                              ##
##      5 - Exit                                          ##
############################################################
"@
$choice = Read-Host "Enter Choice "
switch ($choice) {
    '1' {
        Write-Host "Secret Settings:"
        Write-Host "    AccountID: $(Get-Content -Path .\secret.txt -TotalCount 1)"
        Write-Host "    Region: $((Get-Content -Path .\secret.txt -TotalCount 2)[-1])"
        Read-Host "Hit enter to return to menu..."
        Clear-Host
    }
    '2' {
        Write-Host "Running Build Script..."
        Start-Job -Name buildJob -ScriptBlock {$buildScript}
        Wait-Job -Name buildJob
    }
    '5' {
        Write-Host "Exiting..."
        $inMenu = 0
        Clear-Host
    }
    Default {}
}
}until (($inMenu -eq 0))


