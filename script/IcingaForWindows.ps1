<#PSScriptInfo
.VERSION
    1.3
.GUID
    112e3823-c9ad-4d33-a92c-32c9db86a0d6
.DESCRIPTION
    Icinga for Windows installation script

    This script is designed and simple quick start, to fetch the following files from a provided repository:

    * icinga-powershell-kickstart
    * icinga-powershell-framework

    Both packages will be read from the the provided 'IcingaRepository' URL and installed from this location.
.AUTHOR
    Lord Hepipud
.COMPANYNAME
    Icinga GmbH
.COPYRIGHT
    (c) 2021 Icinga GmbH | GPLv2
.LICENSEURI
    https://github.com/Icinga/icinga-powershell-kickstart/blob/master/LICENSE
.PROJECTURI
    https://github.com/Icinga/icinga-powershell-kickstart
#>

<#
.SYNOPSIS
    Icinga for Windows installation script
.DESCRIPTION
    Icinga for Windows installation script

    This script is designed and simple quick start, to fetch the following files from a provided repository:

    * icinga-powershell-kickstart
    * icinga-powershell-framework

    Both packages will be read from the the provided 'IcingaRepository' URL and installed from this location.
.PARAMETER IcingaRepository
    The location (local, web or network share) of your Icinga for Windows repository. Defaults to 'https://packages.icinga.com/IcingaForWindows/stable/ifw.repo.json'
.PARAMETER ModuleDirectory
    Allows to specify in which PowerShell directory Icinga for Windows will be installed. If left empty, you will be prompted with a dialog, asking on where
    Icinga for Windows should be installed into. Defaults to empty
.PARAMETER AnswerFile
    Allows you to provide an answer file, starting with Icinga for Windows 1.6.0, which will apply the specified configuration after the Framework has been installed
.PARAMETER InstallCommand
    Allows you to provide an install command, starting with Icinga for Windows 1.6.0, which will apply the specified configuration after the Framework has been installed
.PARAMETER AllowUpdate
    Defines if the Icinga PowerShell Framework should be updated during the kickstart run, in case it is already installed
.PARAMETER SkipWizard
    Defines to only install the Icinga PowerShell Framework and/or update it if specified. Will skip the question for the installation wizard/Icinga Management Console
    afterwards and will ignore provided arguments -AnswerFile and -InstallCommand
.LINK
    https://icinga.com/docs/icinga-for-windows/latest/doc/02-Installation/
    https://github.com/Icinga/icinga-powershell-kickstart
    https://packages.icinga.com/IcingaForWindows/
#>

param (
    [string]$IcingaRepository = 'https://packages.icinga.com/IcingaForWindows/stable/ifw.repo.json',
    [string]$ModuleDirectory  = $null,
    [string]$AnswerFile       = '',
    [string]$InstallCommand   = '',
    [switch]$AllowUpdate      = $FALSE,
    [switch]$SkipWizard       = $FALSE
);

function Install-IcingaKickstart()
{
    param (
        [string]$IcingaRepository = 'https://packages.icinga.com/IcingaForWindows/stable/ifw.repo.json',
        [string]$ModuleDirectory  = $null,
        [string]$AnswerFile       = '',
        [string]$InstallCommand   = '',
        [switch]$AllowUpdate      = $null,
        [switch]$SkipWizard       = $FALSE
    );

    Add-Type -Assembly 'System.IO.Compression.FileSystem';

    [Net.ServicePointManager]::SecurityProtocol = "tls12, tls11";
    $ProgressPreference                         = "SilentlyContinue";

    try {
        $RepositoryFile = (Invoke-WebRequest -UseBasicParsing -Uri $IcingaRepository -ErrorAction Stop).Content;
    } catch {
        if ($IcingaRepository[-1] -eq '/') {
            $IcingaRepository = [string]::Format('{0}ifw.repo.json', $IcingaRepository);
        } else {
            $IcingaRepository = [string]::Format('{0}/ifw.repo.json', $IcingaRepository);
        }

        try {
            $RepositoryFile = (Invoke-WebRequest -UseBasicParsing -Uri $IcingaRepository -ErrorAction Stop).Content;
        } catch {
            Write-Host $_.Exception.Message;
            return;
        }
    }

    if ([string]::IsNullOrEmpty($RepositoryFile)) {
        Write-Host 'No repository file found';
        return;
    }

    $RepoData         = ConvertFrom-Json -InputObject $RepositoryFile;
    $KickstartPackage = $RepoData.Packages.Kickstart | Sort-Object Version -Descending | Select-Object -First 1;
    $FrameworkPackage = $RepoData.Packages.Framework | Sort-Object Version -Descending | Select-Object -First 1;
    $FrameworkUrl     = '';
    $KickstartUrl    = '';

    if ($null -eq $FrameworkPackage -Or $null -eq $KickstartPackage) {
        throw 'No Icinga PowerShell Framework or Icinga PowerShell Kickstart package found';
        return;
    }

    if ($FrameworkPackage.RelativePath) {
        $FrameworkUrl = [string]::Format('{0}/{1}', $RepoData.Info.RemoteSource, $FrameworkPackage.Location);
    } else {
        $FrameworkUrl = $FrameworkPackage.Location;
    }

    if ($KickstartPackage.RelativePath) {
        $KickstartUrl = [string]::Format('{0}/{1}', $RepoData.Info.RemoteSource, $KickstartPackage.Location);
    } else {
        $KickstartUrl = $KickstartPackage.Location;
    }

    try {
        Invoke-WebRequest -UseBasicParsing -Uri $KickstartUrl -OutFile (Join-Path -Path $ENV:TEMP -ChildPath 'icinga-powershell-kickstart.zip') -ErrorAction Stop;
    } catch {
        throw ([string]::Format('Unable to download kickstart package from "{0}"', $KickstartUrl));
    }

    $Kickstarter   = [System.IO.Compression.ZipFile]::OpenRead((Join-Path -Path $ENV:TEMP -ChildPath 'icinga-powershell-kickstart.zip'));
    $ScriptContent = $null;

    foreach ($entry in $Kickstarter.Entries) {
        if ($entry.Name -eq 'icinga-powershell-kickstart.ps1') {
            $FileStream    = $entry.Open();
            $FileReader    = New-Object 'System.IO.StreamReader' $FileStream;
            $ScriptContent = $FileReader.ReadToEnd();
            $FileReader.Dispose();
            break;
        }
    }

    $Kickstarter.Dispose();

    Remove-Item -Path (Join-Path -Path $ENV:TEMP -ChildPath 'icinga-powershell-kickstart.zip');

    $ScriptContent += "`r`n`r`n";
    $ScriptContent += '$KickStartArguments = $args[0];';
    $ScriptContent += "`r`n";

    [hashtable]$KickStartArguments = @{
        '-RepositoryUrl'   = $FrameworkUrl;
        '-ModuleDirectory' = $ModuleDirectory;
        '-AllowUpdate'     = $AllowUpdate;
        '-AnswerFile'      = $AnswerFile;
        '-InstallCommand'  = $InstallCommand;
        '-SkipWizard'      = $SkipWizard;
        '-IfW160'          = $TRUE;
    };

    $ScriptContent = [string]::Format('{0}Start-IcingaFrameworkWizard @KickStartArguments', $ScriptContent);

    Invoke-Command -ScriptBlock ([Scriptblock]::Create($ScriptContent)) -ArgumentList $KickStartArguments;
}

Install-IcingaKickstart @args;
