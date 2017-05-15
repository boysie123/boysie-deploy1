

#Axios env 
#Canada Site region Deployment info
$loc1 = 'Canada Central'
$loc2 = 'Canada East'
$OPSrgname = 'CAC-RSG-CORE-OPS'
$ADrgname = 'CAC-RSG-CORE-AD'
$tempADrgname = 'CAC2-RSG-CORE-AD'
$DBrgname = 'CAC-RSG-CORE-DB'
$VPNrgname = 'CAC-RSG-CORE-VPN'
$BASTrgname = 'CAC-RSG-CORE-RAX'
$MGMTrgname = 'CAC-RSG-CORE-MGT'
$OPSrgname2 = 'CAE-RSG-CORE-OPS'
$ADrgname2 = 'CAE-RSG-CORE-AD'
$tempADrgname2 = 'CAE2-RSG-CORE-AD'
$DBrgname2 = 'CAE-RSG-CORE-DB'
$VPNrgname2 = 'CAE-RSG-CORE-VPN'
$BASTrgname2 = 'CAE-RSG-CORE-RAX'
$MGMTrgname2 = 'CAE-RSG-CORE-MGT'


Login-AzureRmAccount

Get-AzureRmSubscription

Select-AzureRmSubscription -SubscriptionName 'Microsoft Azure - Aviator' ################ replace with subscription

# CREATE Resource Groups CAC
$rsgnames = @($OPSrgname, $ADrgname, $DBrgname, $VPNrgname, $BASTrgname, $MGMTrgname, $tempADrgname)

foreach ($rsg in $rsgnames){

   if ((Get-AzureRmResourceGroup $rsg -ErrorAction SilentlyContinue) -eq $null) {
       New-AzureRmResourceGroup -Name $rsg -Location $loc1
   }
}


# CREATE Resource Groups CAE
$rsgnames = @($OPSrgname2, $ADrgname2, $DBrgname2, $VPNrgname2, $BASTrgname2, $MGMTrgname2, $tempADrgname2)

foreach ($rsg in $rsgnames){

   if ((Get-AzureRmResourceGroup $rsg -ErrorAction SilentlyContinue) -eq $null) {
       New-AzureRmResourceGroup -Name $rsg -Location $loc2
   }
}



    ##############################
    #NETWORK
    ##############################

    New-AzureRmResourceGroupDeployment -Mode Incremental -Name ('NEU-Axios-Netsmall-Canada-central' + '-' + ((Get-Date).ToUniversalTime()).ToString('MMdd-HHmm')) `
   -ResourceGroupName $MGMTrgname `
   -TemplateFile 'H:\Azure\Axios\Axios\network-small.json' `
   -TemplateParameterFile 'H:\Azure\Axios\Axios\CAC-network-small.parameters.json' `
   -Force -Verbose

    New-AzureRmResourceGroupDeployment -Mode Incremental -Name ('NEU-Axios-Netsmall-Canada-east' + '-' + ((Get-Date).ToUniversalTime()).ToString('MMdd-HHmm')) `
   -ResourceGroupName $MGMTrgname2 `
   -TemplateFile 'H:\Azure\Axios\Axios\network-small.json' `
   -TemplateParameterFile 'H:\Azure\Axios\Axios\CAE-network-small.parameters.json' `
   -Force -Verbose

   #TEMP Network

    New-AzureRmResourceGroupDeployment -Mode Incremental -Name ('NEU-Axios-Netsmall-Canada-central2' + '-' + ((Get-Date).ToUniversalTime()).ToString('MMdd-HHmm')) `
   -ResourceGroupName $tempADrgname `
   -TemplateFile 'H:\Azure\Axios\Axios\network-small.json' `
   -TemplateParameterFile 'H:\Azure\Axios\Axios\TEMP\CAC2-network-small.parameters.json' `
   -Force -Verbose

    New-AzureRmResourceGroupDeployment -Mode Incremental -Name ('NEU-Axios-Netsmall-Canada-east2' + '-' + ((Get-Date).ToUniversalTime()).ToString('MMdd-HHmm')) `
   -ResourceGroupName $tempADrgname2 `
   -TemplateFile 'H:\Azure\Axios\Axios\network-small.json' `
   -TemplateParameterFile 'H:\Azure\Axios\Axios\TEMP\CAE2-network-small.parameters.json' `
   -Force -Verbose




   #########################################
   #OMS
   #####################################


    New-AzureRmResourceGroupDeployment -Mode Incremental -Name ('WEU-OMS' + '-' + ((Get-Date).ToUniversalTime()).ToString('MMdd-HHmm')) `
   -ResourceGroupName $MGMTrgname `
   -TemplateFile 'H:\Azure\Axios\Axios\oms-workspace.json' `
   -TemplateParameterFile 'H:\Azure\Axios\Axios\oms-workspace.parameters.json' `
   -Force -Verbose


   ##########################
   
   #GET Workspace ID and workspaceKey fill in AD templates



   ###### ad

    New-AzureRmResourceGroupDeployment -Mode Incremental -Name ('NEU-Axios-ad-CAC' + '-' + ((Get-Date).ToUniversalTime()).ToString('MMdd-HHmm')) `
   -ResourceGroupName $ADrgname `
   -TemplateFile 'H:\Azure\Axios\Axios\virtual-machine-multiple.json' `
   -TemplateParameterFile 'H:\Azure\Axios\Axios\CAC-AD-virtual-machine-multiple.parameters.json' `
   -Force -Verbose

       New-AzureRmResourceGroupDeployment -Mode Incremental -Name ('NEU-Axios-ad-CAE' + '-' + ((Get-Date).ToUniversalTime()).ToString('MMdd-HHmm')) `
   -ResourceGroupName $ADrgname2 `
   -TemplateFile 'H:\Azure\Axios\Axios\virtual-machine-multiple.json' `
   -TemplateParameterFile 'H:\Azure\Axios\Axios\CAE-AD-virtual-machine-multiple.parameters.json' `
   -Force -Verbose


   ###TEMP AD

    New-AzureRmResourceGroupDeployment -Mode Incremental -Name ('NEU-Axios-ad-CAC' + '-' + ((Get-Date).ToUniversalTime()).ToString('MMdd-HHmm')) `
   -ResourceGroupName $tempADrgname `
   -TemplateFile 'H:\Azure\Axios\Axios\virtual-machine-multiple.json' `
   -TemplateParameterFile 'H:\Azure\Axios\Axios\TEMP\CAC2-AD-virtual-machine-multiple.parameters.json' `
   -Force -Verbose

    New-AzureRmResourceGroupDeployment -Mode Incremental -Name ('NEU-Axios-ad-CAE' + '-' + ((Get-Date).ToUniversalTime()).ToString('MMdd-HHmm')) `
   -ResourceGroupName $tempADrgname2 `
   -TemplateFile 'H:\Azure\Axios\Axios\virtual-machine-multiple.json' `
   -TemplateParameterFile 'H:\Azure\Axios\Axios\TEMP\CAE2-AD-virtual-machine-multiple.parameters.json' `
   -Force -Verbose



      ######## BASTION RAX

          New-AzureRmResourceGroupDeployment -Mode Incremental -Name ('NEU-Axios-bast-CAC' + '-' + ((Get-Date).ToUniversalTime()).ToString('MMdd-HHmm')) `
   -ResourceGroupName $BASTrgname `
   -TemplateFile 'H:\Azure\Axios\Axios\scaleft-bastion.json' `
   -TemplateParameterFile 'H:\Azure\Axios\Axios\CAC-scaleft-bastion.parameters.json' `
   -Force -Verbose

       New-AzureRmResourceGroupDeployment -Mode Incremental -Name ('NEU-Axios-bast-CAE' + '-' + ((Get-Date).ToUniversalTime()).ToString('MMdd-HHmm')) `
   -ResourceGroupName $BASTrgname2 `
   -TemplateFile 'H:\Azure\Axios\Axios\scaleft-bastion.json' `
   -TemplateParameterFile 'H:\Azure\Axios\Axios\CAE-scaleft-bastion.parameters.json' `
   -Force -Verbose



   ###################################
   ## DEV #################
   ###################################

    New-AzureRmResourceGroupDeployment -Mode Incremental -Name ('NEU-cd-CMS-DEV-01' + '-' + ((Get-Date).ToUniversalTime()).ToString('MMdd-HHmm')) `
   -ResourceGroupName $DEVrgname `
   -TemplateFile 'H:\Azure\Linklaters\Linklaters\DEV\CD-CMS-virtual-machine-standalone.json' `
   -TemplateParameterFile 'H:\Azure\Linklaters\Linklaters\DEV\CD-CMS-virtual-machine-standalone.parameters.json' `
   -Force -Verbose

    New-AzureRmResourceGroupDeployment -Mode Incremental -Name ('NEU-SQL-DEV-01' + '-' + ((Get-Date).ToUniversalTime()).ToString('MMdd-HHmm')) `
   -ResourceGroupName $DEVrgname `
   -TemplateFile 'H:\Azure\Linklaters\Linklaters\DEV\DEV-mssql-standalone.json' `
   -TemplateParameterFile 'H:\Azure\Linklaters\Linklaters\DEV\DEV-mssql-standalone.parameters.json' `
   -Force -Verbose

   ###################################
   ## Q/A #################
   ###################################

    New-AzureRmResourceGroupDeployment -Mode Incremental -Name ('NEU-CD-QA-01' + '-' + ((Get-Date).ToUniversalTime()).ToString('MMdd-HHmm')) `
   -ResourceGroupName $QArgname `
   -TemplateFile 'H:\Azure\Linklaters\Linklaters\QA\CD-virtual-machine-standalone.json' `
   -TemplateParameterFile 'H:\Azure\Linklaters\Linklaters\QA\CD-virtual-machine-standalone.parameters.json' `
   -Force -Verbose

    New-AzureRmResourceGroupDeployment -Mode Incremental -Name ('NEU-CMS-QA-01' + '-' + ((Get-Date).ToUniversalTime()).ToString('MMdd-HHmm')) `
   -ResourceGroupName $QArgname `
   -TemplateFile 'H:\Azure\Linklaters\Linklaters\QA\CMS-virtual-machine-standalone.json' `
   -TemplateParameterFile 'H:\Azure\Linklaters\Linklaters\QA\CMS-virtual-machine-standalone.parameters.json' `
   -Force -Verbose


    New-AzureRmResourceGroupDeployment -Mode Incremental -Name ('NEU-SQL-QA-01' + '-' + ((Get-Date).ToUniversalTime()).ToString('MMdd-HHmm')) `
   -ResourceGroupName $QArgname `
   -TemplateFile 'H:\Azure\Linklaters\Linklaters\QA\QA-mssql-standalone.json' `
   -TemplateParameterFile 'H:\Azure\Linklaters\Linklaters\QA\QA-mssql-standalone.parameters.json' `
   -Force -Verbose

   ###################################
   ## PROD #################
   ###################################



    New-AzureRmResourceGroupDeployment -Mode Incremental -Name ('NEU-CD-PRD-01' + '-' + ((Get-Date).ToUniversalTime()).ToString('MMdd-HHmm')) `
   -ResourceGroupName $PRODrgname `
   -TemplateFile 'H:\Azure\Linklaters\Linklaters\virtual-machine-standalone.json' `
   -TemplateParameterFile 'H:\Azure\Linklaters\Linklaters\Production\CD01-virtual-machine-standalone.parameters.json' `
   -Force -Verbose

    New-AzureRmResourceGroupDeployment -Mode Incremental -Name ('NEU-CD-PRD-02' + '-' + ((Get-Date).ToUniversalTime()).ToString('MMdd-HHmm')) `
   -ResourceGroupName $PRODrgname `
   -TemplateFile 'H:\Azure\Linklaters\Linklaters\virtual-machine-standalone.json' `
   -TemplateParameterFile 'H:\Azure\Linklaters\Linklaters\Production\CD02-virtual-machine-standalone.parameters.json' `
   -Force -Verbose

    New-AzureRmResourceGroupDeployment -Mode Incremental -Name ('NEU-CMS-PRD-01' + '-' + ((Get-Date).ToUniversalTime()).ToString('MMdd-HHmm')) `
   -ResourceGroupName $PRODrgname `
   -TemplateFile 'H:\Azure\Linklaters\Linklaters\virtual-machine-standalone.json' `
   -TemplateParameterFile 'H:\Azure\Linklaters\Linklaters\Production\CMS-virtual-machine-standalone.parameters.json' `
   -Force -Verbose


   ######## SQL (dependant on order)

    New-AzureRmResourceGroupDeployment -Mode Incremental -Name ('NEU-SQL01-PRD' + '-' + ((Get-Date).ToUniversalTime()).ToString('MMdd-HHmm')) `
   -ResourceGroupName $PRODrgname `
   -TemplateFile 'H:\Azure\Linklaters\Linklaters\Production\PRD-mssql-standalone.json' `
   -TemplateParameterFile 'H:\Azure\Linklaters\Linklaters\Production\SQL01-mssql-standalone.parameters.json' `
   -Force -Verbose

    New-AzureRmResourceGroupDeployment -Mode Incremental -Name ('NEU-SQL02-PRD' + '-' + ((Get-Date).ToUniversalTime()).ToString('MMdd-HHmm')) `
   -ResourceGroupName $PRODrgname `
   -TemplateFile 'H:\Azure\Linklaters\Linklaters\Production\PRD-mssql-standalone.json' `
   -TemplateParameterFile 'H:\Azure\Linklaters\Linklaters\Production\SQL02-mssql-standalone.parameters.json' `
   -Force -Verbose

    New-AzureRmResourceGroupDeployment -Mode Incremental -Name ('NEU-WIT-PRD' + '-' + ((Get-Date).ToUniversalTime()).ToString('MMdd-HHmm')) `
   -ResourceGroupName $PRODrgname `
   -TemplateFile 'H:\Azure\Linklaters\Linklaters\virtual-machine-standalone.json' `
   -TemplateParameterFile 'H:\Azure\Linklaters\Linklaters\Production\SQLWIT-virtual-machine-standalone.parameters.json' `
   -Force -Verbose

   ########  