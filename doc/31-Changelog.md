# Icinga PowerShell REST-Api CHANGELOG

**The latest release announcements are available on [https://icinga.com/blog/](https://icinga.com/blog/).**

Please read the [upgrading](https://icinga.com/docs/windows/latest/kickstart/doc/30-Upgrading-Kickstart)
documentation before upgrading to a new release.

Released closed milestones can be found on [GitHub](https://github.com/Icinga/icinga-powershell-kickstart/milestones?state=closed).

## 1.4.0 (2022-02-09)

[Issue and PRs](https://github.com/Icinga/icinga-powershell-framework/milestone/3?closed=1)

### Bugfixes

* [#12](https://github.com/Icinga/icinga-powershell-kickstart/pull/12) Fixes kickstart exception on Framework installation on PowerShell 7
* [#15](https://github.com/Icinga/icinga-powershell-kickstart/pull/15) Fixes installation error for Icinga PowerShell Framework caused by a folder lock for virus scanners as example

## 1.3.0 (2021-09-07)

[Issue and PRs](https://github.com/Icinga/icinga-powershell-framework/milestone/2?closed=1)

### General

* Adds `IcingaForWindows.ps1` just for change tracking, as this script is hosted on [packages.icinga.com](https://packages.icinga.com/IcingaForWindows/) for easier accessibility

### Enhancement

* [#9](https://github.com/Icinga/icinga-powershell-kickstart/pull/9) Prepares Kickstart script for Icinga for Windows v1.6.0 and the new repository management

## 1.2.0 (2020-12-01)

### Enhancement

* Adds check for current configured PowerShell execution policies
* [#6](https://github.com/Icinga/icinga-powershell-kickstart/pull/6) Updates Kickstart wizard to use the Icinga PowerShell Framework updating tools in case the Framework is already installed on systems

### Bugfixes

* [#7](https://github.com/Icinga/icinga-powershell-kickstart/pull/7) Fixes crash with Icinga PowerShell Framework v1.3.0

## 1.1.0 (2020-06-02)

### Enhancements

* Updated asked questions to fit the current Icinga PowerShell Framework format
* Improved visualisation for console prints to match the current Icinga PowerShell Framework version

## 1.0.0 (2020-02-26)

### Notes

Initial release
