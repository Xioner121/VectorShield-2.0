@echo off

color 0b

cd /D "%~dp0"

REM Clearing and starting log file
echo Starting...> CompletedActions.json
REM ==================================Imports Preliminary.json============================================
set "File2Read=Preliminary.json"
rem This will read a file into an array of variables and populate it 
setlocal EnableExtensions EnableDelayedExpansion
    set /a count = 0
for /f "delims=" %%a in ('Type "%File2Read%"') do (
    set /a count+=1
    set "Preliminary[!count!]=%%a"
)
rem Display array elements
For /L %%i in (1,1,%Count%) do (
    echo "Preliminary%%i" is assigned to ==^> "!Preliminary[%%i]!"
)
REM ==================================Imports SecPol.json============================================
set "File2Read=Secpol.json"
rem This will read a file into an array of variables and populate it 
setlocal EnableExtensions EnableDelayedExpansion
    set /a count = 0
for /f "delims=" %%a in ('Type "%File2Read%"') do (
    set /a count+=1
    set "Secpol[!count!]=%%a"
)
rem Display array elements
For /L %%i in (1,1,%Count%) do (
    echo "Secpol%%i" is assigned to ==^> "!Secpol[%%i]!"
)
REM ==================================Imports Services.json============================================
set "File2Read=Services.json"
rem This will read a file into an array of variables and populate it 
setlocal EnableExtensions EnableDelayedExpansion
    set /a count = 0
for /f "delims=" %%a in ('Type "%File2Read%"') do (
    set /a count+=1
    set "Services[!count!]=%%a"
)
rem Display array elements, cant due to issue with GUI.

REM ==================================Imports Password.json============================================
set "File2Read=Password.json"
rem This will read a file into an array of variables and populate it 
setlocal EnableExtensions EnableDelayedExpansion
    set /a count = 0
set /p Password=<Password.json
rem Display array elements
    echo "Password" is assigned to ==^> "!Password!"

REM ==================================Configures System Network Security Settings===============================================
if %Preliminary[1]%==true (
REG ADD HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa /v UseMachineId /t REG_DWORD /d 1 /f && echo 0:'Allow Local System to use computer identity for NTLM' is set to 'Enabled' >> CompletedActions.json || echo 0:'Allow Local System to use computer identity for NTLM' Unsuccessful >> CompletedActions.json
)
if %Preliminary[2]%==true (
REG ADD HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa\MSV1_0 /v AllowNullSessionFallback /t REG_DWORD /d 0 /f && echo 1:'Allow LocalSystem NULL session fallback' is set to 'Disabled' >> CompletedActions.json || echo 1:'Allow LocalSystem NULL session fallback' Unsuccessful >> CompletedActions.json
)
if %Preliminary[3]%==true (
REG ADD HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa\pku2u /v AllowOnlineID /t REG_DWORD /d 0 /f && echo 2:'Allow PKU2U authentication requests to this computer to use online identities' is set to 'Disabled' >> CompletedActions.json || echo 2:'Allow PKU2U authentication requests to this computer to use online identities' Unsuccessful >> CompletedActions.json
)
if %Preliminary[4]%==true (
REG ADD HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\Kerberos\Parameters /v SupportedEncryptionTypes /t REG_DWORD /d 2147483640 /f && echo 3:Successfully Configured encryption types allowed for Kerberos  >> CompletedActions.json || echo 3:Configuring encryption types allowed for Kerberos Unsuccessful >> CompletedActions.json
)
if %Preliminary[5]%==true (
REG ADD HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa /v NoLMHash /t REG_DWORD /d 1 /f && echo 4:'Do not store LAN Manager hash value on next password change' is set to 'Enabled' >> CompletedActions.json || echo 4:'Do not store LAN Manager hash value on next password change' Unsuccessful >> CompletedActions.json
)

if %Preliminary[6]%==true (
REG ADD HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa /v LmCompatibilityLevel /t REG_DWORD /d 5 /f && echo 5:'LAN Manager authentication level' is set to 'Send NTLMv2 response only. Refuse LM & NTLM' >> CompletedActions.json || echo 5:'LAN Manager authentication level' setting change Unsuccessful >> CompletedActions.json
)
if %Preliminary[7]%==true (
REG ADD HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LDAP /v LDAPClientIntegrity /t REG_DWORD /d 1 /f && echo 6:'LDAP client signing requirements' is set to 'Negotiate signing' >> CompletedActions.json || echo 6:'LDAP client signing requirements' setting change Unsuccessful >> CompletedActions.json
)
if %Preliminary[8]%==true (
REG ADD HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa\MSV1_0 /v NtlmMinClientSec /t REG_DWORD /d 536870912 /f & REG ADD HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa\MSV1_0 /v NtlmMinServerSec /t REG_DWORD /d 536870912 /f && echo 7:'Server and clients require SSP' >> CompletedActions.json || echo 7:'Server and clients require SSP' Unsuccessful >> CompletedActions.json
)
if %Preliminary[9]%==true (
DISM /online /Disable-feature /featurename:TelnetClient && echo 8:'Telnet Disabled' >> CompletedActions.json || echo 8:'Telnet disable' Unsuccessful >> CompletedActions.json
)
if %Preliminary[10]%==true (
DISM /online /Disable-Feature /FeatureName:TFTP && echo 9:'TFTP Disabled' >> CompletedActions.json || echo 9:'TFTP disable' Unsuccessful >> CompletedActions.json
)
if  %Preliminary[11]%==true (
sc stop Fax
sc config Fax start= disabled && echo 10:'Fax Scan Disabled' >> CompletedActions.json || echo 10:'Fax Scan disable' Unsuccessful >> CompletedActions.json
)
if  %Preliminary[12]%==true (
REG ADD HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters /v DisabledComponents /t REG_DWORD /d 0xff /f && echo 11:'IPv6' is set to 'Disabled' >> CompletedActions.json || echo 11:'IPv6 disable' Unsuccessful >> CompletedActions.json
)
if  %Preliminary[13]%==true (
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v SmartScreenEnabled /t REG_SZ /d "On" /f || goto failure
REG ADD "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\PhishingFilter" /v EnabledV9 /t REG_DWORD /d 1 /f || goto failure
REG ADD "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\AppHost" /v EnableWebContentEvaluation /t REG_DWORD /d 1 /f || goto failure
echo 12:'Windows Smartscreen' is set to 'Enabled' >> CompletedActions.json
goto exit
:failure
echo 12:'Windows Smartscreen enabling' Unsuccessful >> CompletedActions.json
)
:exit
if %Preliminary[14]%==true (
net user Guest /active no && echo 13:'Def. Guest Account Disabled' >> CompletedActions.json || echo 13:'Def. Guest Account Disabling' Unsuccessful >> CompletedActions.json
)
if %Preliminary[15]%==true (
net user Administrator /active no && echo 14:'Def. Admin Account Disabled' >> CompletedActions.json || echo 14:'Def. Admin Account Disabling' Unsuccessful >> CompletedActions.json
)
REM --Installing Needed Packages to edit User Rights Assighnment--
if not exist C:\WINDOWS\system32\WindowsPowerShell\v1.0\Modules\UserRights mkdir C:\WINDOWS\system32\WindowsPowerShell\v1.0\Modules\UserRights
if not exist C:\WINDOWS\system32\WindowsPowerShell\v1.0\Modules\UserRights\UserRights.psm1 copy /-Y "%~dp0UserRights.psm1" "C:\WINDOWS\system32\WindowsPowerShell\v1.0\Modules\UserRights"
echo Setting User rights(Array:Lusrmgr). This will take awhile. Ignore any errors.

Set "MyCmnd=Unblock-File -Path C:\WINDOWS\system32\WindowsPowerShell\v1.0\Modules\UserRights\UserRights.psm1;"
Set "MyCmnd=%MyCmnd% Import-Module  UserRights -Force;"
Set "MyCmnd=%MyCmnd% $Accounts=Get-AccountsWithUserRight -Right SeTrustedCredManAccessPrivilege;"
Set "MyCmnd=%MyCmnd% $Counter = $Counter = $($Accounts | measure).Count;"
Set "MyCmnd=%MyCmnd% For ($i=0; $i -lt $Counter; $i++)  {Revoke-UserRight -Account "$Accounts[$i].SID" -Right SeTrustedCredManAccessPrivilege};"
if %Preliminary[16]%==true (
powershell -ExecutionPolicy Unrestricted -Command "%MyCmnd%" && echo 15:'Access Credential Manager as a trusted caller' is set to 'No One' >> CompletedActions.json || echo 15:'Access Credential Manager as a trusted caller' policy change Unsuccessful >> CompletedActions.json
)


Set "MyCmnd=Unblock-File -Path C:\WINDOWS\system32\WindowsPowerShell\v1.0\Modules\UserRights\UserRights.psm1;"
Set "MyCmnd=%MyCmnd% Import-Module  UserRights -Force;"
Set "MyCmnd=%MyCmnd% $Accounts=Get-AccountsWithUserRight -Right SeNetworkLogonRight;"
Set "MyCmnd=%MyCmnd% $Counter = $Counter = $($Accounts | measure).Count;"
Set "MyCmnd=%MyCmnd% For ($i=0; $i -lt $Counter; $i++)  {Revoke-UserRight -Account "$Accounts[$i].SID" -Right SeNetworkLogonRight};"
Set "MyCmnd=%MyCmnd% Grant-UserRight -Account "Administrators" -Right SeNetworkLogonRight;"
Set "MyCmnd=%MyCmnd% Grant-UserRight -Account "S-1-5-32-555" -Right SeNetworkLogonRight;"
if %Preliminary[17]%==true (
powershell -ExecutionPolicy Unrestricted -Command "%MyCmnd%" && echo 16:'Access this computer from the network' is set to 'Administrators, Remote Desktop Users' >> CompletedActions.json || echo 16:'Access this computer from the network' policy change Unsuccessful >> CompletedActions.json
)

Set "MyCmnd=Unblock-File -Path C:\WINDOWS\system32\WindowsPowerShell\v1.0\Modules\UserRights\UserRights.psm1;"
Set "MyCmnd=%MyCmnd% Import-Module  UserRights -Force;"
Set "MyCmnd=%MyCmnd% $Accounts=Get-AccountsWithUserRight -Right SeTcbPrivilege;"
Set "MyCmnd=%MyCmnd% $Counter = $Counter = $($Accounts | measure).Count;"
Set "MyCmnd=%MyCmnd% For ($i=0; $i -lt $Counter; $i++)  {Revoke-UserRight -Account "$Accounts[$i].SID" -Right SeTcbPrivilege};"
if %Preliminary[18]%==true (
powershell -ExecutionPolicy Unrestricted -Command "%MyCmnd%" && echo 17:'Act as part of the operating system' is set to 'No One' >> CompletedActions.json || echo 17:'Act as part of the operating system' policy change Unsuccessful >> CompletedActions.json
)

Set "MyCmnd=Unblock-File -Path C:\WINDOWS\system32\WindowsPowerShell\v1.0\Modules\UserRights\UserRights.psm1;"
Set "MyCmnd=%MyCmnd% Import-Module  UserRights -Force;"
Set "MyCmnd=%MyCmnd% $Accounts=Get-AccountsWithUserRight -Right SeIncreaseQuotaPrivilege;"
Set "MyCmnd=%MyCmnd% $Counter = $Counter = $($Accounts | measure).Count;"
Set "MyCmnd=%MyCmnd% For ($i=0; $i -lt $Counter; $i++)  {Revoke-UserRight -Account "$Accounts[$i].SID" -Right SeIncreaseQuotaPrivilege};"
Set "MyCmnd=%MyCmnd% Grant-UserRight -Account "Administrators" -Right SeIncreaseQuotaPrivilege;"
Set "MyCmnd=%MyCmnd% Grant-UserRight -Account "S-1-5-19" -Right SeIncreaseQuotaPrivilege;"
Set "MyCmnd=%MyCmnd% Grant-UserRight -Account "S-1-5-20" -Right SeIncreaseQuotaPrivilege;"
if %Preliminary[19]%==true (
powershell -ExecutionPolicy Unrestricted -Command "%MyCmnd%" && echo 18:'Adjust memory quotas for a process' is set to 'Administrators, LOCAL SERVICE, NETWORK SERVICE' >> CompletedActions.json || echo 18:'Adjust memory quotas for a process' policy change Unsuccessful >> CompletedActions.json
)

Set "MyCmnd=Unblock-File -Path C:\WINDOWS\system32\WindowsPowerShell\v1.0\Modules\UserRights\UserRights.psm1;"
Set "MyCmnd=%MyCmnd% Import-Module  UserRights -Force;"
Set "MyCmnd=%MyCmnd% $Accounts=Get-AccountsWithUserRight -Right SeBackupPrivilege;"
Set "MyCmnd=%MyCmnd% $Counter = $Counter = $($Accounts | measure).Count;"
Set "MyCmnd=%MyCmnd% For ($i=0; $i -lt $Counter; $i++)  {Revoke-UserRight -Account "$Accounts[$i].SID" -Right SeBackupPrivilege};"
Set "MyCmnd=%MyCmnd% Grant-UserRight -Account "Administrators" -Right SeBackupPrivilege;"
if %Preliminary[20]%==true (
powershell -ExecutionPolicy Unrestricted -Command "%MyCmnd%" && echo 19:'Back up files and directories' is set to 'Administrators' >> CompletedActions.json || echo 19:'Back up files and directories' policy change Unsuccessful >> CompletedActions.json
)

Set "MyCmnd=Unblock-File -Path C:\WINDOWS\system32\WindowsPowerShell\v1.0\Modules\UserRights\UserRights.psm1;"
Set "MyCmnd=%MyCmnd% Import-Module  UserRights -Force;"
Set "MyCmnd=%MyCmnd% $Accounts=Get-AccountsWithUserRight -Right SeTimeZonePrivilege;"
Set "MyCmnd=%MyCmnd% $Counter = $Counter = $($Accounts | measure).Count;"
Set "MyCmnd=%MyCmnd% For ($i=0; $i -lt $Counter; $i++)  {Revoke-UserRight -Account "$Accounts[$i].SID" -Right SeTimeZonePrivilege};"
Set "MyCmnd=%MyCmnd% Grant-UserRight -Account "Administrators" -Right SeTimeZonePrivilege;"
Set "MyCmnd=%MyCmnd% Grant-UserRight -Account "S-1-5-19" -Right SeTimeZonePrivilege;"
Set "MyCmnd=%MyCmnd% Grant-UserRight -Account "Users" -Right SeTimeZonePrivilege;"
if %Preliminary[21]%==true (
powershell -ExecutionPolicy Unrestricted -Command "%MyCmnd%" && echo 20:'Change the time zone' is set to 'Administrators, LOCAL SERVICE, Users' >> CompletedActions.json || echo 20:'Change the time zone' policy change Unsuccessful >> CompletedActions.json
)

Set "MyCmnd=Unblock-File -Path C:\WINDOWS\system32\WindowsPowerShell\v1.0\Modules\UserRights\UserRights.psm1;"
Set "MyCmnd=%MyCmnd% Import-Module  UserRights -Force;"
Set "MyCmnd=%MyCmnd% $Accounts=Get-AccountsWithUserRight -Right SeCreatePagefilePrivilege;"
Set "MyCmnd=%MyCmnd% $Counter = $Counter = $($Accounts | measure).Count;"
Set "MyCmnd=%MyCmnd% For ($i=0; $i -lt $Counter; $i++)  {Revoke-UserRight -Account "$Accounts[$i].SID" -Right SeCreatePagefilePrivilege};"
Set "MyCmnd=%MyCmnd% Grant-UserRight -Account "Administrators" -Right SeCreatePagefilePrivilege;"

Set "MyCmnd=%MyCmnd% $Accounts=Get-AccountsWithUserRight -Right SeCreateTokenPrivilege;"
Set "MyCmnd=%MyCmnd% $Counter = $Counter = $($Accounts | measure).Count;"
Set "MyCmnd=%MyCmnd% For ($i=0; $i -lt $Counter; $i++)  {Revoke-UserRight -Account "$Accounts[$i].SID" -Right SeCreateTokenPrivilege};"

Set "MyCmnd=%MyCmnd% $Accounts=Get-AccountsWithUserRight -Right SeCreateGlobalPrivilege;"
Set "MyCmnd=%MyCmnd% $Counter = $Counter = $($Accounts | measure).Count;"
Set "MyCmnd=%MyCmnd% For ($i=0; $i -lt $Counter; $i++)  {Revoke-UserRight -Account "$Accounts[$i].SID" -Right SeCreateGlobalPrivilege};"
Set "MyCmnd=%MyCmnd% Grant-UserRight -Account "Administrators" -Right SeCreateGlobalPrivilege;"
Set "MyCmnd=%MyCmnd% Grant-UserRight -Account "S-1-5-19" -Right SeCreateGlobalPrivilege;"
Set "MyCmnd=%MyCmnd% Grant-UserRight -Account "S-1-5-20" -Right SeCreateGlobalPrivilege;"
Set "MyCmnd=%MyCmnd% Grant-UserRight -Account "S-1-5-6" -Right SeCreateGlobalPrivilege;"

Set "MyCmnd=%MyCmnd% $Accounts=Get-AccountsWithUserRight -Right SeCreatePermanentPrivilege;"
Set "MyCmnd=%MyCmnd% $Counter = $Counter = $($Accounts | measure).Count;"
Set "MyCmnd=%MyCmnd% For ($i=0; $i -lt $Counter; $i++)  {Revoke-UserRight -Account "$Accounts[$i].SID" -Right SeCreatePermanentPrivilege};"
if %Preliminary[22]%==true (
powershell -ExecutionPolicy Unrestricted -Command "%MyCmnd%" && echo 21:'Restricted Object Creation' >> CompletedActions.json || echo 21:'Restrict Object Creation' policy change Unsuccessful >> CompletedActions.json
)

Set "MyCmnd=Unblock-File -Path C:\WINDOWS\system32\WindowsPowerShell\v1.0\Modules\UserRights\UserRights.psm1;"
Set "MyCmnd=%MyCmnd% Import-Module  UserRights -Force;"
Set "MyCmnd=%MyCmnd% $Accounts=Get-AccountsWithUserRight -Right SeCreateSymbolicLinkPrivilege;"
Set "MyCmnd=%MyCmnd% $Counter = $Counter = $($Accounts | measure).Count;"
Set "MyCmnd=%MyCmnd% For ($i=0; $i -lt $Counter; $i++)  {Revoke-UserRight -Account "$Accounts[$i].SID" -Right SeCreateSymbolicLinkPrivilege};"
Set "MyCmnd=%MyCmnd% Grant-UserRight -Account "Administrators" -Right SeCreateSymbolicLinkPrivilege;"
if %Preliminary[23]%==true (
powershell -ExecutionPolicy Unrestricted -Command "%MyCmnd%" && echo 22:'Create symbolic links configured' >> CompletedActions.json || echo 22:configuring 'Create symbolic links' Unsuccessful >> CompletedActions.json
)

Set "MyCmnd=Unblock-File -Path C:\WINDOWS\system32\WindowsPowerShell\v1.0\Modules\UserRights\UserRights.psm1;"
Set "MyCmnd=%MyCmnd% Import-Module  UserRights -Force;"
Set "MyCmnd=%MyCmnd% $Accounts=Get-AccountsWithUserRight -Right SeDebugPrivilege;"
Set "MyCmnd=%MyCmnd% $Counter = $Counter = $($Accounts | measure).Count;"
Set "MyCmnd=%MyCmnd% For ($i=0; $i -lt $Counter; $i++)  {Revoke-UserRight -Account "$Accounts[$i].SID" -Right SeDebugPrivilege};"
Set "MyCmnd=%MyCmnd% Grant-UserRight -Account "Administrators" -Right SeDebugPrivilege;"
if %Preliminary[24]%==true (
powershell -ExecutionPolicy Unrestricted -Command "%MyCmnd%" && echo 23:'Debug programs' is set to 'Administrators' >> CompletedActions.json || echo 23:'Debug programs' policy change Unsuccessful >> CompletedActions.json
)

Set "MyCmnd=Unblock-File -Path C:\WINDOWS\system32\WindowsPowerShell\v1.0\Modules\UserRights\UserRights.psm1;"
Set "MyCmnd=%MyCmnd% Import-Module  UserRights -Force;"
Set "MyCmnd=%MyCmnd% Grant-UserRight -Account "Guests" -Right SeDenyBatchLogonRight,SeDenyServiceLogonRight,SeDenyInteractiveLogonRight,SeDenyRemoteInteractiveLogonRight;"
if %Preliminary[25]%==true (
powershell -ExecutionPolicy Unrestricted -Command "%MyCmnd%" && echo 24:'Denied Logon to Guests' >> CompletedActions.json || echo 24:'Deny Logon to Guests' policy change Unsuccessful >> CompletedActions.json
)

Set "MyCmnd=Unblock-File -Path C:\WINDOWS\system32\WindowsPowerShell\v1.0\Modules\UserRights\UserRights.psm1;"
Set "MyCmnd=%MyCmnd% Import-Module  UserRights -Force;"
Set "MyCmnd=%MyCmnd% $Accounts=Get-AccountsWithUserRight -Right SeBatchLogonRight;"
Set "MyCmnd=%MyCmnd% $Counter = $Counter = $($Accounts | measure).Count;"
Set "MyCmnd=%MyCmnd% For ($i=0; $i -lt $Counter; $i++)  {Revoke-UserRight -Account "$Accounts[$i].SID" -Right SeBatchLogonRight};"
Set "MyCmnd=%MyCmnd% Grant-UserRight -Account "Administrators" -Right SeBatchLogonRight;"
if %Preliminary[26]%==true (
powershell -ExecutionPolicy Unrestricted -Command "%MyCmnd%" && echo 25:'Log on as a batch job' is set to 'Administrators'>> CompletedActions.json || echo 25:'Log on as a batch job' policy change Unsuccessful >> CompletedActions.json
)

Set "MyCmnd=Unblock-File -Path C:\WINDOWS\system32\WindowsPowerShell\v1.0\Modules\UserRights\UserRights.psm1;"
Set "MyCmnd=%MyCmnd% Import-Module  UserRights -Force;"
Set "MyCmnd=%MyCmnd% $Accounts=Get-AccountsWithUserRight -Right SeServiceLogonRight;"
Set "MyCmnd=%MyCmnd% $Counter = $Counter = $($Accounts | measure).Count;"
Set "MyCmnd=%MyCmnd% For ($i=0; $i -lt $Counter; $i++)  {Revoke-UserRight -Account "$Accounts[$i].SID" -Right SeServiceLogonRight};"
if %Preliminary[27]%==true (
powershell -ExecutionPolicy Unrestricted -Command "%MyCmnd%" && echo 26:'Log on as a service' configured >> CompletedActions.json || echo 26:'Log on as a service configure' Unsuccessful >> CompletedActions.json
)

Set "MyCmnd=Unblock-File -Path C:\WINDOWS\system32\WindowsPowerShell\v1.0\Modules\UserRights\UserRights.psm1;"
Set "MyCmnd=%MyCmnd% Import-Module  UserRights -Force;"
Set "MyCmnd=%MyCmnd% $Accounts=Get-AccountsWithUserRight -Right SeEnableDelegationPrivilege;"
Set "MyCmnd=%MyCmnd% $Counter = $Counter = $($Accounts | measure).Count;"
Set "MyCmnd=%MyCmnd% For ($i=0; $i -lt $Counter; $i++)  {Revoke-UserRight -Account "$Accounts[$i].SID" -Right SeEnableDelegationPrivilege};"
if %Preliminary[28]%==true (
powershell -ExecutionPolicy Unrestricted -Command "%MyCmnd%" && echo 27:'Enable computer and user accounts to be trusted for delegation' is set to 'No One' >> CompletedActions.json || echo 27:'Enable computer and user accounts to be trusted for delegation' policy change Unsuccessful >> CompletedActions.json
)

Set "MyCmnd=Unblock-File -Path C:\WINDOWS\system32\WindowsPowerShell\v1.0\Modules\UserRights\UserRights.psm1;"
Set "MyCmnd=%MyCmnd% Import-Module  UserRights -Force;"
Set "MyCmnd=%MyCmnd% $Accounts=Get-AccountsWithUserRight -Right SeRemoteShutdownPrivilege;"
Set "MyCmnd=%MyCmnd% $Counter = $Counter = $($Accounts | measure).Count;"
Set "MyCmnd=%MyCmnd% For ($i=0; $i -lt $Counter; $i++)  {Revoke-UserRight -Account "$Accounts[$i].SID" -Right SeRemoteShutdownPrivilege};"
Set "MyCmnd=%MyCmnd% Grant-UserRight -Account "Administrators" -Right SeRemoteShutdownPrivilege;"
if %Preliminary[29]%==true (
powershell -ExecutionPolicy Unrestricted -Command "%MyCmnd%" && echo 28:'Force shutdown from a remote system' is set to 'Administrators' >> CompletedActions.json || echo 28:'Force shutdown from a remote system' policy change Unsuccessful >> CompletedActions.json
)

Set "MyCmnd=Unblock-File -Path C:\WINDOWS\system32\WindowsPowerShell\v1.0\Modules\UserRights\UserRights.psm1;"
Set "MyCmnd=%MyCmnd% Import-Module  UserRights -Force;"
Set "MyCmnd=%MyCmnd% $Accounts=Get-AccountsWithUserRight -Right SeAuditPrivilege;"
Set "MyCmnd=%MyCmnd% $Counter = $Counter = $($Accounts | measure).Count;"
Set "MyCmnd=%MyCmnd% For ($i=0; $i -lt $Counter; $i++)  {Revoke-UserRight -Account "$Accounts[$i].SID" -Right SeAuditPrivilege};"
Set "MyCmnd=%MyCmnd% Grant-UserRight -Account "S-1-5-19" -Right SeAuditPrivilege;"
Set "MyCmnd=%MyCmnd% Grant-UserRight -Account "S-1-5-20" -Right SeAuditPrivilege;"
if %Preliminary[30]%==true (
powershell -ExecutionPolicy Unrestricted -Command "%MyCmnd%" && echo 29:'Generate security audits' is set to 'LOCAL SERVICE, NETWORK SERVICE' >> CompletedActions.json || echo 29:'Generate security audits' policy change Unsuccessful >> CompletedActions.json
)

Set "MyCmnd=Unblock-File -Path C:\WINDOWS\system32\WindowsPowerShell\v1.0\Modules\UserRights\UserRights.psm1;"
Set "MyCmnd=%MyCmnd% Import-Module  UserRights -Force;"
Set "MyCmnd=%MyCmnd% $Accounts=Get-AccountsWithUserRight -Right SeImpersonatePrivilege;"
Set "MyCmnd=%MyCmnd% $Counter = $Counter = $($Accounts | measure).Count;"
Set "MyCmnd=%MyCmnd% For ($i=0; $i -lt $Counter; $i++)  {Revoke-UserRight -Account "$Accounts[$i].SID" -Right SeImpersonatePrivilege};"
Set "MyCmnd=%MyCmnd% Grant-UserRight -Account "Administrators" -Right SeImpersonatePrivilege;"
Set "MyCmnd=%MyCmnd% Grant-UserRight -Account "S-1-5-20" -Right SeImpersonatePrivilege;"
Set "MyCmnd=%MyCmnd% Grant-UserRight -Account "S-1-5-19" -Right SeImpersonatePrivilege;"
Set "MyCmnd=%MyCmnd% Grant-UserRight -Account "S-1-5-6" -Right SeImpersonatePrivilege;"
if %Preliminary[31]%==true (
powershell -ExecutionPolicy Unrestricted -Command "%MyCmnd%" && echo 30:'Impersonate a client after authentication' is set to 'Administrators, LOCAL SERVICE, NETWORK SERVICE, SERVICE' >> CompletedActions.json || echo 30:'Impersonate a client after authentication' policy change Unsuccessful >> CompletedActions.json
)

Set "MyCmnd=Unblock-File -Path C:\WINDOWS\system32\WindowsPowerShell\v1.0\Modules\UserRights\UserRights.psm1;"
Set "MyCmnd=%MyCmnd% Import-Module  UserRights -Force;"
Set "MyCmnd=%MyCmnd% $Accounts=Get-AccountsWithUserRight -Right SeIncreaseBasePriorityPrivilege;"
Set "MyCmnd=%MyCmnd% $Counter = $Counter = $($Accounts | measure).Count;"
Set "MyCmnd=%MyCmnd% For ($i=0; $i -lt $Counter; $i++)  {Revoke-UserRight -Account "$Accounts[$i].SID" -Right SeIncreaseBasePriorityPrivilege};"
Set "MyCmnd=%MyCmnd% Grant-UserRight -Account "Administrators" -Right SeIncreaseBasePriorityPrivilege;"
Set "MyCmnd=%MyCmnd% Grant-UserRight -Account "S-1-5-90-0" -Right SeIncreaseBasePriorityPrivilege;"
if %Preliminary[32]%==true (
powershell -ExecutionPolicy Unrestricted -Command "%MyCmnd%" && echo 31:'Increase scheduling priority' is set to 'Administrators, Window Manager\Window Manager Group' >> CompletedActions.json || echo 31:'Increase scheduling priority' policy change Unsuccessful >> CompletedActions.json
)

Set "MyCmnd=Unblock-File -Path C:\WINDOWS\system32\WindowsPowerShell\v1.0\Modules\UserRights\UserRights.psm1;"
Set "MyCmnd=%MyCmnd% Import-Module  UserRights -Force;"
Set "MyCmnd=%MyCmnd% $Accounts=Get-AccountsWithUserRight -Right SeLoadDriverPrivilege;"
Set "MyCmnd=%MyCmnd% $Counter = $Counter = $($Accounts | measure).Count;"
Set "MyCmnd=%MyCmnd% For ($i=0; $i -lt $Counter; $i++)  {Revoke-UserRight -Account "$Accounts[$i].SID" -Right SeLoadDriverPrivilege};"
Set "MyCmnd=%MyCmnd% Grant-UserRight -Account "Administrators" -Right SeLoadDriverPrivilege;"
if %Preliminary[33]%==true (
powershell -ExecutionPolicy Unrestricted -Command "%MyCmnd%" && echo 32:'Load and unload device drivers' is set to 'Administrators' >> CompletedActions.json || echo 32:'Load and unload device drivers' policy change Unsuccessful >> CompletedActions.json
)

Set "MyCmnd=Unblock-File -Path C:\WINDOWS\system32\WindowsPowerShell\v1.0\Modules\UserRights\UserRights.psm1;"
Set "MyCmnd=%MyCmnd% Import-Module  UserRights -Force;"
Set "MyCmnd=%MyCmnd% $Accounts=Get-AccountsWithUserRight -Right SeLockMemoryPrivilege;"
Set "MyCmnd=%MyCmnd% $Counter = $Counter = $($Accounts | measure).Count;"
Set "MyCmnd=%MyCmnd% For ($i=0; $i -lt $Counter; $i++)  {Revoke-UserRight -Account "$Accounts[$i].SID" -Right SeLockMemoryPrivilege};"
if %Preliminary[34]%==true (
powershell -ExecutionPolicy Unrestricted -Command "%MyCmnd%" && echo 33:'Lock pages in memory' is set to 'No One' >> CompletedActions.json || echo 33:'Lock pages in memory' policy change Unsuccessful >> CompletedActions.json
)

Set "MyCmnd=Unblock-File -Path C:\WINDOWS\system32\WindowsPowerShell\v1.0\Modules\UserRights\UserRights.psm1;"
Set "MyCmnd=%MyCmnd% Import-Module  UserRights -Force;"
Set "MyCmnd=%MyCmnd% $Accounts=Get-AccountsWithUserRight -Right SeRelabelPrivilege;"
Set "MyCmnd=%MyCmnd% $Counter = $Counter = $($Accounts | measure).Count;"
Set "MyCmnd=%MyCmnd% For ($i=0; $i -lt $Counter; $i++)  {Revoke-UserRight -Account "$Accounts[$i].SID" -Right SeRelabelPrivilege};"
if %Preliminary[35]%==true (
powershell -ExecutionPolicy Unrestricted -Command "%MyCmnd%" && echo 34:'Modify an object label' is set to 'No One' >> CompletedActions.json || echo 34:'Modify an object label' policy change Unsuccessful >> CompletedActions.json
)

Set "MyCmnd=Unblock-File -Path C:\WINDOWS\system32\WindowsPowerShell\v1.0\Modules\UserRights\UserRights.psm1;"
Set "MyCmnd=%MyCmnd% Import-Module  UserRights -Force;"
Set "MyCmnd=%MyCmnd% $Accounts=Get-AccountsWithUserRight -Right SeSystemEnvironmentPrivilege;"
Set "MyCmnd=%MyCmnd% $Counter = $Counter = $($Accounts | measure).Count;"
Set "MyCmnd=%MyCmnd% For ($i=0; $i -lt $Counter; $i++)  {Revoke-UserRight -Account "$Accounts[$i].SID" -Right SeSystemEnvironmentPrivilege};"
Set "MyCmnd=%MyCmnd% Grant-UserRight -Account "Administrators" -Right SeSystemEnvironmentPrivilege;"
if %Preliminary[36]%==true (
powershell -ExecutionPolicy Unrestricted -Command "%MyCmnd%" && echo 35:'Modify firmware environment values' is set to 'Administrators' >> CompletedActions.json || echo 35:'Modify firmware environment values' policy change Unsuccessful >> CompletedActions.json
)

Set "MyCmnd=Unblock-File -Path C:\WINDOWS\system32\WindowsPowerShell\v1.0\Modules\UserRights\UserRights.psm1;"
Set "MyCmnd=%MyCmnd% Import-Module  UserRights -Force;"
Set "MyCmnd=%MyCmnd% $Accounts=Get-AccountsWithUserRight -Right SeManageVolumePrivilege;"
Set "MyCmnd=%MyCmnd% $Counter = $Counter = $($Accounts | measure).Count;"
Set "MyCmnd=%MyCmnd% For ($i=0; $i -lt $Counter; $i++)  {Revoke-UserRight -Account "$Accounts[$i].SID" -Right SeManageVolumePrivilege};"
Set "MyCmnd=%MyCmnd% Grant-UserRight -Account "Administrators" -Right SeManageVolumePrivilege;"
if %Preliminary[37]%==true (
powershell -ExecutionPolicy Unrestricted -Command "%MyCmnd%" && echo 36:'Perform volume maintenance tasks' is set to 'Administrators' >> CompletedActions.json || echo 36:'Perform volume maintenance tasks' policy change Unsuccessful >> CompletedActions.json
)

Set "MyCmnd=Unblock-File -Path C:\WINDOWS\system32\WindowsPowerShell\v1.0\Modules\UserRights\UserRights.psm1;"
Set "MyCmnd=%MyCmnd% Import-Module  UserRights -Force;"
Set "MyCmnd=%MyCmnd% $Accounts=Get-AccountsWithUserRight -Right SeProfileSingleProcessPrivilege;"
Set "MyCmnd=%MyCmnd% $Counter = $Counter = $($Accounts | measure).Count;"
Set "MyCmnd=%MyCmnd% For ($i=0; $i -lt $Counter; $i++)  {Revoke-UserRight -Account "$Accounts[$i].SID" -Right SeProfileSingleProcessPrivilege};"
Set "MyCmnd=%MyCmnd% Grant-UserRight -Account "Administrators" -Right SeProfileSingleProcessPrivilege;"

Set "MyCmnd=%MyCmnd% $Accounts=Get-AccountsWithUserRight -Right SeSystemProfilePrivilege;"
Set "MyCmnd=%MyCmnd% $Counter = $Counter = $($Accounts | measure).Count;"
Set "MyCmnd=%MyCmnd% For ($i=0; $i -lt $Counter; $i++)  {Revoke-UserRight -Account "$Accounts[$i].SID" -Right SeSystemProfilePrivilege};"
Set "MyCmnd=%MyCmnd% Grant-UserRight -Account "Administrators" -Right SeSystemProfilePrivilege;"
Set "MyCmnd=%MyCmnd% Grant-UserRight -Account "S-1-5-80" -Right SeSystemProfilePrivilege;"
if %Preliminary[38]%==true (
powershell -ExecutionPolicy Unrestricted -Command "%MyCmnd%" && echo 37:'Restricted profiling' >> CompletedActions.json || echo 37:'Restrict profiling' Unsuccessful >> CompletedActions.json
)

Set "MyCmnd=Unblock-File -Path C:\WINDOWS\system32\WindowsPowerShell\v1.0\Modules\UserRights\UserRights.psm1;"
Set "MyCmnd=%MyCmnd% Import-Module  UserRights -Force;"
Set "MyCmnd=%MyCmnd% $Accounts=Get-AccountsWithUserRight -Right SeAssignPrimaryTokenPrivilege;"
Set "MyCmnd=%MyCmnd% $Counter = $Counter = $($Accounts | measure).Count;"
Set "MyCmnd=%MyCmnd% For ($i=0; $i -lt $Counter; $i++)  {Revoke-UserRight -Account "$Accounts[$i].SID" -Right SeAssignPrimaryTokenPrivilege};"
Set "MyCmnd=%MyCmnd% Grant-UserRight -Account "S-1-5-19" -Right SeAssignPrimaryTokenPrivilege;"
Set "MyCmnd=%MyCmnd% Grant-UserRight -Account "S-1-5-20" -Right SeAssignPrimaryTokenPrivilege;"
if %Preliminary[39]%==true (
powershell -ExecutionPolicy Unrestricted -Command "%MyCmnd%" && echo 38:'Replace a process level token' is set to 'LOCAL SERVICE, NETWORK SERVICE' >> CompletedActions.json || echo 38:'Replace a process level token' policy change Unsuccessful >> CompletedActions.json
)

Set "MyCmnd=Unblock-File -Path C:\WINDOWS\system32\WindowsPowerShell\v1.0\Modules\UserRights\UserRights.psm1;"
Set "MyCmnd=%MyCmnd% Import-Module  UserRights -Force;"
Set "MyCmnd=%MyCmnd% $Accounts=Get-AccountsWithUserRight -Right SeRestorePrivilege;"
Set "MyCmnd=%MyCmnd% $Counter = $Counter = $($Accounts | measure).Count;"
Set "MyCmnd=%MyCmnd% For ($i=0; $i -lt $Counter; $i++)  {Revoke-UserRight -Account "$Accounts[$i].SID" -Right SeRestorePrivilege};"
Set "MyCmnd=%MyCmnd% Grant-UserRight -Account "Administrators" -Right SeRestorePrivilege;"
if %Preliminary[40]%==true (
powershell -ExecutionPolicy Unrestricted -Command "%MyCmnd%" && echo 39:'Restore files and directories' is set to 'Administrators' >> CompletedActions.json || echo 39:'Restore files and directories' policy change Unsuccessful >> CompletedActions.json
)

Set "MyCmnd=Unblock-File -Path C:\WINDOWS\system32\WindowsPowerShell\v1.0\Modules\UserRights\UserRights.psm1;"
Set "MyCmnd=%MyCmnd% Import-Module  UserRights -Force;"
Set "MyCmnd=%MyCmnd% $Accounts=Get-AccountsWithUserRight -Right SeShutdownPrivilege;"
Set "MyCmnd=%MyCmnd% $Counter = $Counter = $($Accounts | measure).Count;"
Set "MyCmnd=%MyCmnd% For ($i=0; $i -lt $Counter; $i++)  {Revoke-UserRight -Account "$Accounts[$i].SID" -Right SeShutdownPrivilege};"
Set "MyCmnd=%MyCmnd% Grant-UserRight -Account "Administrators" -Right SeShutdownPrivilege;"
Set "MyCmnd=%MyCmnd% Grant-UserRight -Account "Users" -Right SeShutdownPrivilege;"
if %Preliminary[41]%==true (
powershell -ExecutionPolicy Unrestricted -Command "%MyCmnd%" && echo 40:'Shut down the system' is set to 'Administrators, Users' >> CompletedActions.json || echo 40:'Shut down the system' policy change Unsuccessful >> CompletedActions.json
)

Set "MyCmnd=Unblock-File -Path C:\WINDOWS\system32\WindowsPowerShell\v1.0\Modules\UserRights\UserRights.psm1;"
Set "MyCmnd=%MyCmnd% Import-Module  UserRights -Force;"
Set "MyCmnd=%MyCmnd% $Accounts=Get-AccountsWithUserRight -Right SeTakeOwnershipPrivilege;"
Set "MyCmnd=%MyCmnd% $Counter = $Counter = $($Accounts | measure).Count;"
Set "MyCmnd=%MyCmnd% For ($i=0; $i -lt $Counter; $i++)  {Revoke-UserRight -Account "$Accounts[$i].SID" -Right SeTakeOwnershipPrivilege};"
Set "MyCmnd=%MyCmnd% Grant-UserRight -Account "Administrators" -Right SeTakeOwnershipPrivilege;"
if %Preliminary[42]%==true (
powershell -ExecutionPolicy Unrestricted -Command "%MyCmnd%" && echo 41:'Take ownership of files or other objects' is set to 'Administrators' >> CompletedActions.json || echo 41:'Take ownership of files or other objects' policy change Unsuccessful >> CompletedActions.json
)
REM -Uninstalling packages-
echo Powershell req. part finished.
if exist C:\WINDOWS\system32\WindowsPowerShell\v1.0\Modules\UserRights @RD /S /Q "C:\WINDOWS\system32\WindowsPowerShell\v1.0\Modules\UserRights"

if %Preliminary[43]%==true (
FOR /F %%F IN ('wmic useraccount get name') DO (Echo "%%F" | FIND /I "Name" 1>NUL) || (Echo "%%F" | FIND /I "DefaultAccount" 1>NUL) || (NET USER %%F "!Password!")
echo 42:'All user passwords' set to 'Password.Json' >> CompletedActions.json
)
cd /D "C:\Users"
if %Preliminary[44]%==true (
call del /S /Q *.mp3 || goto fail
cd /D "%~dp0"
echo 43:'All user mp3 files deleted' >> CompletedActions.json
goto ex
:fail
cd /D "%~dp0"
echo 43:'All user mp3 files deletion' Unsuccessful >> CompletedActions.json
)
:ex
if %Preliminary[45]%==true (
wmic useraccount where name='Administrator' rename 'VS1' && echo 44:'Def. Admin Account renamed to VS1' >> CompletedActions.json || echo 44:'Def. Admin Account renaming' Unsuccessful >> CompletedActions.json
)
if %Preliminary[46]%==true (
wmic useraccount where name='Guest' rename 'VS2' && echo 45:'Def. Guest Account renamed to VS2' >> CompletedActions.json || echo 45:'Def. Guest Account renaming' Unsuccessful >> CompletedActions.json
)

REM ==================================Configures System Local Security Policy Settings==========================================
if %SecPol[1]%==true (
netsh advfirewall set allprofiles state on && echo Sec0:'Windows Firewall set as Enabled' >> CompletedActions.json || echo Sec0:'Windows Firewall enabling' Unsuccessful >> CompletedActions.json
)
if %SecPol[2]%==true (
Auditpol /set /category:"Account Logon" /success:enable /failure:enable || goto failure1
Auditpol /set /category:"Account Management" /success:enable /failure:enable || goto failure1
Auditpol /set /category:"Detailed Tracking" /success:enable /failure:enable || goto failure1
Auditpol /set /category:"DS Access" /success:enable /failure:enable || goto failure1
Auditpol /set /category:"Logon/Logoff" /Success:enable /failure:enable || goto failure1
Auditpol /set /category:"Object Access" /success:enable /failure:enable || goto failure1
Auditpol /set /category:"Policy Change" /success:enable /failure:enable || goto failure1
Auditpol /set /category:"Privilege Use" /success:enable /failure:enable || goto failure1
Auditpol /set /category:"System" /success:enable /failure:enable || goto failure1
echo Sec1:'All auditing' is set to 'success/failure' >> CompletedActions.json
goto exit1
:failure1
echo Sec1:'enabling All auditing' Unsuccessful >> CompletedActions.json
)
:exit1
if %SecPol[3]%==true (
REG ADD HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v NoConnectedUser /t REG_DWORD /d 3 /f && echo Sec2:'Blocked Microsoft accounts' >> CompletedActions.json || echo Sec2:'Blocking Microsoft accounts' Unsuccessful >> CompletedActions.json
)
if %SecPol[4]%==true (
REG ADD HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa /v RestrictAnonymous /t REG_DWORD /d 1 /f && echo Sec3:'Do not allow enumeration of SAM accounts and shares' set to 'Enabled' >> CompletedActions.json || echo Sec3:'Do not allow enumeration of SAM accounts and shares' policy change Unsuccessful >> CompletedActions.json
)
if %SecPol[5]%==true (
REG ADD HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters /v requiresecuritysignature /t REG_DWORD /d 1 /f && echo Sec4:'Digitally sign server communication' set to 'Enabled' >> CompletedActions.json || echo Sec4:'Digitally sign server communication' policy change Unsuccessful >> CompletedActions.json
)
if %SecPol[6]%==true (
secedit.exe /export /cfg C:\secconfig.cfg
powershell -Command "(gc C:\secconfig.cfg) -replace 'DontDisplayLastUserName=4,0', 'DontDisplayLastUserName=4,1' | Out-File -encoding ASCII C:\secconfigupdated.cfg"
secedit.exe /configure /db %windir%\securitynew.sdb /cfg C:\secconfigupdated.cfg /areas SECURITYPOLICY && echo Sec5:'Do not display last username in logon screen' set to 'Enabled' >> CompletedActions.json || echo Sec5:'Do not display last username in logon screen' policy change Unsuccessful >> CompletedActions.json
del c:\secconfig.cfg
del c:\secconfigupdated.cfg
)

if %SecPol[8]%==true (
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v CachedLogonsCount /t REG_SZ /d 0 /f && echo Sec7:'Number of previous logons to cache' set to '0 logons' >> CompletedActions.json || echo Sec7:'Number of previous logons to cache' policy change Unsuccessful >> CompletedActions.json
)
if %SecPol[9]%==true (
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v AllocateCDRoms /t REG_SZ /d 1 /f || goto failure2
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v AllocateFloppies /t REG_SZ /d 1 /f || goto failure2
echo Sec8:'Restrict CD-ROM/floppy access to locally logged on user' is set to 'Enabled' >> CompletedActions.json
goto exit2 
:failure2
echo Sec8:'Restrict CD-ROM/floppy access to locally logged on user' policy change Unsuccessful >> CompletedActions.json
)
:exit2
if %SecPol[10]%==true (
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v ScRemoveOption /t REG_SZ /d 1 /f && echo Sec9:'Smart card removal behavior' is set to 'Lock Workstation' >> CompletedActions.json || echo Sec9:'Smart card removal behavior' policy change Unsuccessful >> CompletedActions.json
)
if %SecPol[11]%==true (
REG ADD "HKEY_LOCAL_MACHINE\Software\Microsoft\Driver Signing" /v Policy /t REG_BINARY /d 02 /f || goto failure3
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Non-Driver Signing" /v Policy /t REG_BINARY /d 02 /f || goto failure3
echo Sec10:'Driver installation behavior' is set to 'Warn' >> CompletedActions.json
goto exit3 
:failure3
echo Sec10:'Driver installation behavior' policy change Unsuccessful >> CompletedActions.json
)
:exit3
if %SecPol[12]%==true (
REG ADD "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v ClearPageFileAtShutdown /t REG_DWORD /d 1 /f && echo Sec11:'Clear virtual memory pagefile' is set to 'Enabled' >> CompletedActions.json || echo Sec11:'Clear virtual memory pagefile' policy change Unsuccessful >> CompletedActions.json
)
if %SecPol[13]%==true (
REG ADD "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v UserAuthentication /t REG_DWORD /d 1 /f && echo Sec12:'RDP network level authentication' is set to 'Enabled' >> CompletedActions.json || echo Sec12:'RDP network level authentication' policy change Unsuccessful >> CompletedActions.json
)
if %SecPol[14]%==true (
echo Limit Local Use of Blank Passwords to Console Only
secedit.exe /export /cfg C:\secconfig.cfg
powershell -Command "(gc C:\secconfig.cfg) -replace 'LimitBlankPasswordUse=4,0', 'LimitBlankPasswordUse=4,1' | Out-File -encoding ASCII C:\secconfigupdated.cfg"
secedit.exe /configure /db %windir%\securitynew.sdb /cfg C:\secconfigupdated.cfg /areas SECURITYPOLICY && echo Sec13:'Limit local use of blank passwords to local console only' is set to 'Enabled' >> CompletedActions.json || echo Sec13:'Limit local use of blank passwords to local console only' policy change Unsuccessful >> CompletedActions.json
del c:\secconfig.cfg
del c:\secconfigupdated.cfg
)

if not exist %SystemRoot%\script-logs\ (
  mkdir %SystemRoot%\script-logs\
    )
echo (new-object -c "microsoft.update.servicemanager").addservice2("7971f918-a847-4430-9279-4a52d1efe18d",7,"") > %TEMP%\tempscript.ps1

if %SecPol[15]%==true (
sc config wuauserv start= auto
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v AUOptions /t REG_DWORD /d 3 /f || goto failure4
powershell -ExecutionPolicy Unrestricted %TEMP%\tempscript.ps1 >> %SystemRoot%\script-logs\Computer-Turn-On-Application-Updates.log.txt || goto failure4
echo Sec14:'Updates for other Microsoft products' is set to 'Enabled' >> CompletedActions.json
goto exit4
:failure4
echo Sec14:'Updates for other Microsoft products' policy change Unsuccessful >> CompletedActions.json
)
:exit4
if %SecPol[17]%==true (
REG ADD HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System /v DisableCAD /t REG_DWORD /d 0 /f && echo Sec16:'Enforced Ctrl-Alt-Delete' >> CompletedActions.json || echo Sec16:'Enforcing Ctrl-Alt-Delete' Unsuccessful >> CompletedActions.json
)
if %SecPol[18]%==true (
REG ADD HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters /v RestrictNullSessAccess /t REG_DWORD /d 1 /f && echo Sec17:'Network access: Restrict anonymous access to Named Pipes and Shares' is set to 'Enabled' >> CompletedActions.json || echo Sec17:'Network access: Restrict anonymous access to Named Pipes and Shares' Unsuccessful >> CompletedActions.json
)
if %SecPol[19]%==true (
REG ADD HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v EnableUIADesktopToggle /t REG_DWORD /d 0 /f || goto failure5
REG ADD HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v PromptOnSecureDesktop /t REG_DWORD /d 1 /f || goto failure5
echo Sec18:'User Account Control: Enforced secure desktop' >> CompletedActions.json
goto exit5
:failure5
echo Sec18:'User Account Control: Enforcing secure desktop' Unsuccessful >> CompletedActions.json
)
:exit5

if %SecPol[20]%==true (
REG ADD "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\Setup\RecoveryConsole" /v SecurityLevel /t REG_DWORD /d 0 /f && echo Sec19:'Allow automatic administrative logon' is set to 'Disabled' >> CompletedActions.json || echo Sec19:'Allow automatic administrative logon' policy change Unsuccessful >> CompletedActions.json
)


if %SecPol[22]%==true (
REG ADD HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\LanmanWorkstation\Parameters /v EnablePlainTextPassword /t REG_DWORD /d 0 /f && echo Sec21:'Send unencrypted password to third-party SMB servers' is set to 'Disabled' >> CompletedActions.json || echo Sec21:'Send unencrypted password to third-party SMB servers' policy change Unsuccessful >> CompletedActions.json
)
if %SecPol[23]%==true (
 REG ADD "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Print\Providers\LanMan Print Services\Servers" /v AddPrinterDrivers /t REG_DWORD /d 1 /f && echo Sec22:'Prevent users from installing printer drivers' is set to 'Enabled' >> CompletedActions.json || echo Sec22:'Prevent users from installing printer drivers' policy change Unsuccessful >> CompletedActions.json
)

REM ==================================Configures System Services Security Settings==============================================

if %Services[1]%==true (
echo Bluetooth service stopped and disabled from startup.
sc stop BTAGService
sc stop bthserv
sc config BTAGService start= disabled
sc config bthserv start= disabled && echo S0:'Bluetooth Audio Gateway Service' is set to 'Disabled' >> CompletedActions.json || echo S0:'Bluetooth Audio Gateway Service disabling' Unsuccessful >> CompletedActions.json
)
if %Services[2]%==true (
sc stop MapsBroker
sc config MapsBroker start= disabled && echo S1:'Downloaded Maps Manager MapsBroker' is set to 'Disabled' >> CompletedActions.json || echo S1:'Downloaded Maps Manager MapsBroker' Unsuccessful >> CompletedActions.json
)
if %Services[3]%==true (
sc stop lfsvc
sc config lfsvc start= disabled && echo S2:'Geolocation Service lfsvc' is set to 'Disabled' >> CompletedActions.json || echo S2:'Geolocation Service lfsvc disabling' Unsuccessful >> CompletedActions.json
)
if %Services[4]%==true (
sc stop IISADMIN
sc config IISADMIN start= disabled && echo S3:'IIS Admin Service IISADMIN' is set to 'Disabled' >> CompletedActions.json || echo S3:'IIS Admin Service IISADMIN disabling' Unsuccessful >> CompletedActions.json
)
if %Services[5]%==true (
sc stop irmon
sc config irmon start= disabled && echo S4:'Infrared monitor service irmon' is set to 'Disabled' >> CompletedActions.json || echo S4:'Infrared monitor service irmon disabling' Unsuccessful >> CompletedActions.json
)
if %Services[6]%==true (
sc stop SharedAccess
sc config "SharedAccess" start= disabled && echo S5:'Internet Connection Sharing ICS SharedAccess' is set to 'Disabled' >> CompletedActions.json || echo S5:'Internet Connection Sharing ICS SharedAccess disabling' Unsuccessful >> CompletedActions.json
)
if %Services[7]%==true (
sc stop lltdsvc
sc config lltdsvc start= disabled && echo S6:'Link-Layer Topology Discovery Mapper lltdsvc' is set to 'Disabled' >> CompletedActions.json || echo S6:'Link-Layer Topology Discovery Mapper lltdsvc disabling' Unsuccessful >> CompletedActions.json
)
if %Services[8]%==true (
sc stop LxssManager
sc config LxssManager start= disabled && echo S7:'LxssManager LxssManager' is set to 'Disabled' >> CompletedActions.json || echo S7:'LxssManager LxssManager disabling' Unsuccessful >> CompletedActions.json
)
if %Services[9]%==true (
sc stop FTPSVC
sc config FTPSVC start= disabled && echo S8:'Microsoft FTP Service FTPSVC' is set to 'Disabled' >> CompletedActions.json || echo S8:'Microsoft FTP Service FTPSVC disabling' Unsuccessful >> CompletedActions.json
)
if %Services[10]%==true (
sc stop MSiSCSI
sc config MSiSCSI start= disabled && echo S9:'Microsoft iSCSI Initiator Service MSiSCSI' is set to 'Disabled' >> CompletedActions.json || echo S9:'Microsoft iSCSI Initiator Service MSiSCSI disabling' Unsuccessful >> CompletedActions.json
)
if %Services[11]%==true (
sc stop InstallService
sc config InstallService start= disabled && echo S10:'Microsoft Store Install Service InstallService' is set to 'Disabled' >> CompletedActions.json || echo S10:'Microsoft Store Install Service InstallService disabling' Unsuccessful >> CompletedActions.json
)
if %Services[12]%==true (
sc stop sshd
sc config sshd start= disabled && echo S11:'OpenSSH SSH Server sshd' is set to 'Disabled' >> CompletedActions.json || echo S11:'OpenSSH SSH Server sshd disabling' Unsuccessful >> CompletedActions.json
)
if %Services[13]%==true (
sc stop PNRPsvc
sc config PNRPsvc start= disabled || goto failure6
sc stop p2psvc
sc config p2psvc start= disabled || goto failure6
sc stop p2pimsvc
sc config p2pimsvc start= disabled || goto failure6
sc stop PNRPAutoReg
sc config PNRPAutoReg start= disabled || goto failure6
echo S12:'Peer networking services Disabled' >> CompletedActions.json
goto exit6
:failure6
echo S12:'Peer networking services disabling' Unsuccessful >> CompletedActions.json
)
:exit6
if %Services[14]%==true (
sc stop wercplsupport
sc config wercplsupport start= disabled && echo S13:'Problem Reports and Solutions Control Panel Support wercplsupport' is set to 'Disabled' >> CompletedActions.json || echo S13:'Problem Reports and Solutions Control Panel Support wercplsupport disabling' Unsuccessful >> CompletedActions.json
)
if %Services[15]%==true (
sc stop RasAuto
sc config RasAuto start= disabled && echo S14:'Remote Access Auto Connection Manager RasAuto' is set to 'Disabled' >> CompletedActions.json || echo S14:'Remote Access Auto Connection Manager RasAuto disabling' Unsuccessful >> CompletedActions.json
)
if %Services[16]%==true (
sc stop SessionEnv
sc config SessionEnv start= disabled || goto failure7
sc stop TermService
sc config TermService start= disabled || goto failure7
sc stop UmRdpService
sc config UmRdpService start= disabled || goto failure7
echo S15:'All of RDP services disabled' >> CompletedActions.json 
goto exit7
:failure7
echo S15:'All of RDP services disabling' Unsuccessful >> CompletedActions.json
)
:exit7
if %Services[17]%==true (
sc stop RpcLocator
sc config RpcLocator start= disabled && echo S16:'Remote Procedure Call RPC Locator RpcLocator' is set to 'Disabled' >> CompletedActions.json || echo S16:'Remote Procedure Call RPC Locator RpcLocator disabling' Unsuccessful >> CompletedActions.json
)
if %Services[18]%==true (
sc stop RemoteRegistry
sc config "RemoteRegistry" start= disabled && echo S17:'Remote Registry RemoteRegistry' is set to 'Disabled' >> CompletedActions.json || echo S17:'Remote Registry RemoteRegistry disabling' Unsuccessful >> CompletedActions.json
)
if %Services[19]%==true (
sc stop RemoteAccess
sc config RemoteAccess start= disabled && echo S18:'Routing and Remote Access RemoteAccess' is set to 'Disabled' >> CompletedActions.json || echo S18:'Routing and Remote Access RemoteAccess disabling' Unsuccessful >> CompletedActions.json
)
if %Services[20]%==true (
sc stop LanmanServer
sc config LanmanServer start= disabled && echo S19:'Server LanmanServer' is set to 'Disabled' >> CompletedActions.json || echo S19:'Server LanmanServer' disabling' Unsuccessful >> CompletedActions.json
)
if %Services[21]%==true (
sc stop simptcp
sc config simptcp start= disabled && echo S20:'Simple TCP/IP Services simptcp' is set to 'Disabled' >> CompletedActions.json || echo S20:'Simple TCP/IP Services simptcp disabling' Unsuccessful >> CompletedActions.json
)
if %Services[22]%==true (
sc stop SNMP
sc config SNMP start= disabled && echo S21:'SNMP Service SNMP' is set to 'Disabled' >> CompletedActions.json || echo S21:'SNMP Service SNMP disabling' Unsuccessful >> CompletedActions.json
)
if %Services[23]%==true (
sc stop SSDPSRV
sc config "SSDPSRV" start= disabled && echo S22:'SSDP Discovery SSDPSRV' is set to 'Disabled' >> CompletedActions.json || echo S22:'SSDP Discovery SSDPSRV disabling' Unsuccessful >> CompletedActions.json
)
if %Services[24]%==true (
sc stop upnphost
sc config "upnphost" start= disabled && echo S23:'UPnP Device Host upnphost' is set to 'Disabled' >> CompletedActions.json || echo S23:'UPnP Device Host upnphost disabling' Unsuccessful >> CompletedActions.json
)
if %Services[25]%==true (
sc stop WMSvc
sc config WMSvc start= disabled && echo S24:'Web Management Service WMSvc' is set to 'Disabled' >> CompletedActions.json || echo S24:'Web Management Service WMSvc disabling' Unsuccessful >> CompletedActions.json
)
if %Services[26]%==true (
sc stop WerSvc
sc config WerSvc start= disabled && echo S25:'Windows Error Reporting Service WerSvc' is set to 'Disabled' >> CompletedActions.json || echo S25:'Windows Error Reporting Service WerSvc disabling' Unsuccessful >> CompletedActions.json
)
if %Services[27]%==true (
sc stop Wecsvc
sc config Wecsvc start= disabled && echo S26:'Windows Event Collector Wecsvc' is set to 'Disabled' >> CompletedActions.json || echo S26:'Windows Event Collector Wecsvc disabling' Unsuccessful >> CompletedActions.json
)
if %Services[28]%==true (
sc stop WMPNetworkSvc
sc config WMPNetworkSvc start= disabled && echo S27:'Windows Media Player Network Sharing Service WMPNetworkSvc' is set to 'Disabled' >> CompletedActions.json || echo S27:'Windows Media Player Network Sharing Service WMPNetworkSvc disabling' Unsuccessful >> CompletedActions.json
)
if %Services[29]%==true (
sc stop icssvc
sc config icssvc start= disabled && echo S28:'Windows Mobile Hotspot Service icssvc' is set to 'Disabled' >> CompletedActions.json || echo S28:'Windows Mobile Hotspot Service icssvc disabling' Unsuccessful >> CompletedActions.json
)
if %Services[30]%==true (
sc stop WpnService
sc config WpnService start= disabled && echo S29:'Windows Push Notifications System Service WpnService' is set to 'Disabled' >> CompletedActions.json || echo S29:'Windows Push Notifications System Service WpnService disabling' Unsuccessful >> CompletedActions.json
)
if %Services[31]%==true (
sc stop PushToInstall
sc config PushToInstall start= disabled && echo S30:'Windows PushToInstall Service PushToInstall' is set to 'Disabled' >> CompletedActions.json || echo S30:'Windows PushToInstall Service PushToInstall disabling' Unsuccessful >> CompletedActions.json
)
if %Services[32]%==true (
sc stop WinRM
sc config WinRM start= disabled && echo S31:'Windows Remote Management WS-Management WinRM' is set to 'Disabled' >> CompletedActions.json || echo S31:'Windows Remote Management WS-Management WinRM disabling' Unsuccessful >> CompletedActions.json
)
if %Services[33]%==true (
sc stop XboxGipSvc
sc config XboxGipSvc start= disabled || goto failure8
sc stop XblAuthManager
sc config XblAuthManager start= disabled || goto failure8
sc stop XblGameSave
sc config XblGameSave start= disabled || goto failure8
sc stop XboxNetApiSvc
sc config XboxNetApiSvc start= disabled || goto failure8
echo S32:'Disabled Xbox services' >> CompletedActions.json
goto exit8
:failure8
echo S32:'Disabling Xbox services' Unsuccessful >> CompletedActions.json
)
:exit8
if %Services[34]%==true (
sc config wuauserv start= auto
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v AUOptions /t REG_DWORD /d 3 /f && echo S33:'Windows Updates are enabled as automatic on startup' >> CompletedActions.json || echo S33:'Windows Updates are enabled as automatic on startup' Unsuccessful >> CompletedActions.json
)
if %Services[35]%==true (
sc stop Spooler
sc config Spooler start= disabled && echo S34:'Printer Spooler' is set to 'Disabled' >> CompletedActions.json || echo S34:'Disabling Printer Spooler' Unsuccessful >> CompletedActions.json
)
if %Services[36]%==true (
sc stop NetTcpPortSharing
sc config NetTcpPortSharing start= disabled && echo S35:'Net.Tcp port sharing service' is set to 'Disabled' >> CompletedActions.json || echo S35:'Net.Tcp port sharing service disabling' Unsuccessful >> CompletedActions.json
)
if %Services[37]%==true (
sc stop WebClient
sc config WebClient start= disabled && echo S36:‘WebClient' is set to 'Disabled’ >> CompletedActions.json || echo S36:‘WebClient disabling' Unsuccessful >> CompletedActions.json
)