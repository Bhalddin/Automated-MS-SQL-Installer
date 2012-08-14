RequestExecutionLevel admin
Var sapassword
Var sqlinstance
Var OSVersion
Var SQLFileLoc

# Update this to the location you have the nsi file currently.
!define LOCAL_SAVE "D:\Gits\sqlinstall"

!define /date MYTIMESTAMP "%Y-%m-%d %H:%M:%S"

Name "SQL Installer"
OutFile "SQLInstall.exe"
ShowInstDetails show

#Titles
	!define TITLE_SQL_2008R2 "Microsoft SQL 2008 R2 Express"
	!define DESC_SQL_2008R2 "Installs ${TITLE_SQL_2008R2}"

	!define TITLE_SQL_2012 "Microsoft SQL 2012 Express"
	!define DESC_SQL_2012 "Installs ${TITLE_SQL_2012}"

	# Mainly for the Windows update files. I have also packaged them into a zip
	# You can download it at http://files.rpdatasystems.ca/winupdates/winupdates.zip
	# Just upload to your own server and substitute your information below.
	# This works great for local server, saves you from downloading it from external sources
	# and allows for local network speeds.
	!define URL_BASE "http://files.rpdatasystems.ca/winupdates"

	#SQL 2008R2 with Advanced Services - SQLEXPRADV_X86 - http://go.microsoft.com/fwlink/?LinkId=186787
	#SQL 2008R2 with Advanced Services - SQLEXPRADV_X64 - http://go.microsoft.com/fwlink/?LinkId=186788

	/**
	 *
	 * Choose the location from which to download the main SQL installer file.
	 * X86 = 32-bit ; X64 = 64-bit
	 * Comment out the other DOWNLOAD_SQL_ lines with a ; or #
	 *
	**/
	!define DOWNLOAD_SQL2008R2_X86 "http://go.microsoft.com/fwlink/?LinkId=186785"	; 32-bit 2008 R2 Express
	!define DOWNLOAD_SQL2008R2_X64 "http://go.microsoft.com/fwlink/?LinkId=186786"	; 64-bit 2008 R2 Express
	
	!define DOWNLOAD_SQL2012_X86 ""	; 32-bit 2012 Express
	!define DOWNLOAD_SQL2012_X64 ""	; 64-bit 2012 Express

	# Example of local web server hosting SQL
	;!define DOWNLOAD_SQL2008R2_X86 "http://192.168.2.20/installers/SQLEXPRWT_x86_ENU.exe"	; 32-bit 2008 R2 Express
	;!define DOWNLOAD_SQL2008R2_X64 "http://192.168.2.20/installers/SQLEXPRWT_x64_ENU.exe"	; 64-bit 2008 R2 Express
	;!define DOWNLOAD_SQL2012_X86 "http://192.168.2.20/installers/"	; 32-bit 2012 R2 Express
	;!define DOWNLOAD_SQL2012_X64 "http://192.168.2.20/installers/"	; 64-bit 2012 R2 Express

	!define DOWNLOAD_INSTALLER45_2008_X64	"${URL_BASE}/winupdates/Windows6.0-KB942288-v2-x64.msu"
	!define DOWNLOAD_INSTALLER45_2003_X64	"${URL_BASE}/winupdates/WindowsServer2003-KB942288-v4-x64.exe"
	!define DOWNLOAD_INSTALLER45_XP64_X64	"${URL_BASE}/winupdates/WindowsServer2003-KB942288-v4-x64.exe"
	!define DOWNLOAD_INSTALLER45_Vista_X64	"${URL_BASE}/winupdates/Windows6.0-KB942288-v2-x64.msu"

	!define DOWNLOAD_INSTALLER45_2008_X86	"${URL_BASE}/winupdates/Windows6.0-KB942288-v2-x86.msu"
	!define DOWNLOAD_INSTALLER45_2003_X86	"${URL_BASE}/winupdates/WindowsServer2003-KB942288-v4-x86.exe"
	!define DOWNLOAD_INSTALLER45_XP32_X86	"${URL_BASE}/winupdates/WindowsXP-KB942288-v3-x86.exe"
	!define DOWNLOAD_INSTALLER45_Vista_X86	"${URL_BASE}/winupdates/Windows6.0-KB942288-v2-x86.msu"

	!define DOWNLOAD_POWERSHELL_2003_X64	"${URL_BASE}/winupdates/WindowsServer2003.WindowsXP-KB926139-v2-x64-ENU.exe"
	!define DOWNLOAD_POWERSHELL_XP64_X64	"${URL_BASE}/winupdates/WindowsServer2003.WindowsXP-KB926139-v2-x64-ENU.exe"
	!define DOWNLOAD_POWERSHELL_Vista_X64	"${URL_BASE}/winupdates/Windows6.0-KB928439-x64.msu"

	!define DOWNLOAD_POWERSHELL_XP32_X86	"${URL_BASE}/winupdates/WindowsXP-KB926139-v2-x86-ENU.exe"
	!define DOWNLOAD_POWERSHELL_2003_X86	"${URL_BASE}/winupdates/WindowsServer2003-KB926139-v2-x86-ENU.exe"
	!define DOWNLOAD_POWERSHELL_Vista_X86	"${URL_BASE}/winupdates/Windows6.0-KB928439-x86.msu"

	!define DOWNLOAD_DOTNET35 "http://www.microsoft.com/downloads/info.aspx?na=90&p=&SrcDisplayLang=en&SrcCategoryId=&SrcFamilyId=ab99342f-5d1a-413d-8319-81da479ab0d7&u=http%3a%2f%2fdownload.microsoft.com%2fdownload%2f0%2f6%2f1%2f061f001c-8752-4600-a198-53214c69b51f%2fdotnetfx35setup.exe"
	#!define DOWNLOAD_DOTNET35 "${URL_BASE}/winupdates/dotnetfx35setup.exe"
	
	!define LINK_UAC_HELP "http://windows.microsoft.com/en-CA/windows-vista/Turn-User-Account-Control-on-or-off"

	!define TITLE_INST45 "Windows Installer 4.5"
	!define TITLE_PS10 "Windows PowerShell 1.0"
	!define TITLE_DOTNET35 ".NET Framework 3.5"

; MUI 1.67 compatible ------
	!include "MUI.nsh"		; Required
	!include "LogicLib.nsh"		; Required
	!include "x64.nsh"		; Required for ability to check between 32 and 64 bit.
	!include "FileFunc.nsh"		; Check File Size functions.
	!include "CustomFunctions.nsh"	; Custom Functions

; MUI Settings
	!define MUI_COMPONENTSPAGE_SMALLDESC
	!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\modern-install.ico"

LangString UserData_TITLE ${LANG_ENGLISH} "Enter The Desired Password"
LangString UserData_SUBTITLE ${LANG_ENGLISH} "What password shall we asign to sa?"

# Pages
	!define MUI_CUSTOMFUNCTION_ABORT onUserAbort
	; Components page
	!insertmacro MUI_PAGE_COMPONENTS
	; Custom Page
	Page custom DemoUsername
	; Instfiles page
	!insertmacro MUI_PAGE_INSTFILES
	; Finish page
	;!insertmacro MUI_PAGE_FINISH

; Language files
!insertmacro MUI_LANGUAGE "English"

!macro Logs String
	Push '${MYTIMESTAMP}: ${String}$\r$\n'
	Push '$TEMP\AutoSQL\log.txt'
	Call Logs
!macroend
!define Logs '!insertmacro Logs'

; MUI end ------

Section "${TITLE_SQL_2008R2}" SEC_SQL_2008R2
	SetOutPath "$TEMP\AutoSQL"	; Temp output directory for files.
	SetOverwrite ifnewer		; Allows overwriting the existing file if need be.
	AddSize 2621440			; Displays the installation size.

	${Logs} 'SQL: Check if instance previously installed with our installer.'
	ReadRegDWORD $0 HKLM Software\AutoSQL "SQLInstalled"
	StrCmp $0 "1" SQLSkip
	${Logs} 'SQL: SQLInstall never used.'

	${Logs} 'SQL: Check if installer already exists in $TEMP\AutoSQL'
	StrCpy $SQLFileLoc "$TEMP\AutoSQL\sqlexpress.exe"
	IfFileExists "$SQLFileLoc" PastSQLInstallerCheck
	${Logs} 'SQL: No installer found.'

	PreSQLInstallerCheck:

	${If} ${RunningX64}
		${Logs} 'SQL: Downloading 64-bit version'
		inetc::get /caption "${TITLE_SQL_2008R2} 64-bit" /canceltext "Select File" ${DOWNLOAD_SQL2008R2_X64} "$SQLFileLoc" /END
	${Else}
		${Logs} 'SQL: Downloading 32-bit version'
		inetc::get /caption "${TITLE_SQL_2008R2} 32-bit" /canceltext "Select File" ${DOWNLOAD_SQL2008R2_X86} "$SQLFileLoc" /END
	${EndIf}
	Pop $0
	${Logs} 'SQL: Download status: $0'

	StrCmp $0 "OK" PastSQLInstallerCheck
	StrCmp $0 "Cancelled" 0
	StrCmp $0 "Terminated" 0
		DetailPrint "Download status: $0 - Check your internet connection and try again later"

		; Sometimes if the download goes too fast it doesnt return a code and errors out, this will check for the file first.
		IfFileExists "$SQLFileLoc" PastSQLInstallerCheck

		Dialogs::Open "SQL Installer (*.exe)|*.exe|" "1" "Select the SQL installation file." $EXEDIR ${VAR_9}

		# User just closed the Open File dialog, just quit now.
		StrCmp $9 "0" SQLFailed

		# User gave us a file, no way to check it so we'll just have to try and use it, and catch errors later.
		StrCpy $SQLFileLoc $9
		${Logs} 'SQL: Selected $SQLFileLoc as installer.'
	
	PastSQLInstallerCheck:

	Push "$SQLFileLoc"
	Call FileSizeNew
	Pop $0
	${Logs} 'SQL: File size - $0 bytes.'

	IntCmp $0 200000000 sqlmorethan sqllessthan sqlmorethan # equal lessthan morethan
	sqllessthan:
		${Logs} 'SQL: File size too small to be proper installer.'
		Goto SQLCorrupt
	sqlmorethan:

	File "${LOCAL_SAVE}\SQLConfig.ini"

	${Logs} 'SQL: Launch Installer'
	# If you go and change the password. Windows 7, Server 2008/2008R2 will error out with non-complex passwords. Which requires capitals, numbers, or special characters.
	# My suggestion would be to leave it be as PassWord123 works, and change the password in the dialog that asks for it during install.
	ExecWait '$SQLFileLoc /INSTANCENAME="$sqlinstance" /INSTANCEID="$sqlinstance" /SAPWD="PassWord123" /configurationfile="$TEMP\AutoSQL\SQLConfig.ini"' $1

	${Logs} 'SQL: Installer Exit Code: $1'
	StrCmp $1 "0" SQLCleared
	StrCmp $1 "2" SQLCorrupt
	StrCmp $1 "1223" SQLFailed

	SQLFailed:
		${Logs} 'SQL: Install Failed'
		Abort "SQL Installation Failure. Please Try Again. If problems persist contact us for support."
               # 1223 Means user aborted the SQL installer so we need to stop. More codes here: http://www.hiteksoftware.com/knowledge/articles/049.htm
	SQLCorrupt:
		ReadRegDWORD $0 HKLM Software\AutoSQL "SQLCorruptAttempt"
			StrCmp $0 "1" SQLFailed
		${Logs} 'SQL: Installer Corrupted, deleting current file and trying again.'
		WriteRegDWORD HKLM Software\AutoSQL "SQLCorruptAttempt" "1"
		Delete "$TEMP\AutoSQL\sqlexpress.exe"
		Sleep 500
		Goto PreSQLInstallerCheck
	SQLCleared:
	${Logs} 'SQL: Install Passed'

	# Wait 5 seconds before attempting to launch SQLCMD, during development of this program i found the quickness of the installer was bypassing this as SQLCMD wasn't ready.
	Sleep 5000

	# This is what sets the SA password. We need to check for MSSQLSERVER instance name because you cannot connect to (local)\MSSQLSERVER
	StrCmp $sqlinstance "MSSQLSERVER" 0 +3
	nsExec::Exec '"$PROGRAMFILES64\Microsoft SQL Server\100\Tools\Binn\sqlcmd.exe" -S (local) -U sa -P PassWord123 -Q "ALTER LOGIN sa WITH PASSWORD = $\'$sapassword$\' UNLOCK,CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF"'
	GoTo +2
	nsExec::Exec '"$PROGRAMFILES64\Microsoft SQL Server\100\Tools\Binn\sqlcmd.exe" -S (local)\$sqlinstance -U sa -P PassWord123 -Q "ALTER LOGIN sa WITH PASSWORD = $\'$sapassword$\' UNLOCK,CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF"'

	Delete "$TEMP\AutoSQL\SQLConfig.ini"
	WriteRegDWORD HKLM Software\AutoSQL "SQLInstalled" "1"
	${Logs} 'SQL: Successful'
	SQLSkip:
SectionEnd

Section "${TITLE_SQL_2012}" SEC_SQL_2012
	SetOutPath "$TEMP\AutoSQL"	; Temp output directory for files.
	SetOverwrite ifnewer		; Allows overwriting the existing file if need be.
	AddSize 2621440			; Displays the installation size.

	${Logs} 'SQL: Check if instance previously installed with our installer.'
	ReadRegDWORD $0 HKLM Software\AutoSQL "SQLInstalled"
	StrCmp $0 "1" SQLSkip
	${Logs} 'SQL: SQLInstall never used.'

	${Logs} 'SQL: Check if installer already exists in $TEMP\AutoSQL'
	StrCpy $SQLFileLoc "$TEMP\AutoSQL\sqlexpress.exe"
	IfFileExists "$SQLFileLoc" PastSQLInstallerCheck
	${Logs} 'SQL: No installer found.'

	PreSQLInstallerCheck:

	${If} ${RunningX64}
		${Logs} 'SQL: Downloading 64-bit version'
		inetc::get /caption "${TITLE_SQL_2012} 64-bit" /canceltext "Select File" ${DOWNLOAD_SQL2012_X64} "$SQLFileLoc" /END
	${Else}
		${Logs} 'SQL: Downloading 32-bit version'
		inetc::get /caption "${TITLE_SQL_2012} 32-bit" /canceltext "Select File" ${DOWNLOAD_SQL2012_X86} "$SQLFileLoc" /END
	${EndIf}
	Pop $0
	${Logs} 'SQL: Download status: $0'

	StrCmp $0 "OK" PastSQLInstallerCheck
	StrCmp $0 "Cancelled" 0
	StrCmp $0 "Terminated" 0
		DetailPrint "Download status: $0 - Check your internet connection and try again later"

		; Sometimes if the download goes too fast it doesnt return a code and errors out, this will check for the file first.
		IfFileExists "$SQLFileLoc" PastSQLInstallerCheck

		Dialogs::Open "SQL Installer (*.exe)|*.exe|" "1" "Select the SQL installation file." $EXEDIR ${VAR_9}

		# User just closed the Open File dialog, just quit now.
		StrCmp $9 "0" SQLFailed

		# User gave us a file, no way to check it so we'll just have to try and use it, and catch errors later.
		StrCpy $SQLFileLoc $9
		${Logs} 'SQL: Selected $SQLFileLoc as installer.'
	
	PastSQLInstallerCheck:

	Push "$SQLFileLoc"
	Call FileSizeNew
	Pop $0
	${Logs} 'SQL: File size - $0 bytes.'

	IntCmp $0 200000000 sqlmorethan sqllessthan sqlmorethan # equal lessthan morethan
	sqllessthan:
		${Logs} 'SQL: File size too small to be proper installer.'
		Goto SQLCorrupt
	sqlmorethan:

	File "${LOCAL_SAVE}\SQLConfig.ini"

	${Logs} 'SQL: Launch Installer'
	# If you go and change the password. Windows 7, Server 2008/2008R2 will error out with non-complex passwords. Which requires capitals, numbers, or special characters.
	# My suggestion would be to leave it be as PassWord123 works, and change the password in the dialog that asks for it during install.
	ExecWait '$SQLFileLoc /INSTANCENAME="$sqlinstance" /INSTANCEID="$sqlinstance" /SAPWD="PassWord123" /configurationfile="$TEMP\AutoSQL\SQLConfig.ini"' $1

	${Logs} 'SQL: Installer Exit Code: $1'
	StrCmp $1 "0" SQLCleared
	StrCmp $1 "2" SQLCorrupt
	StrCmp $1 "1223" SQLFailed

	SQLFailed:
		${Logs} 'SQL: Install Failed'
		Abort "SQL Installation Failure. Please Try Again. If problems persist contact us for support."
               # 1223 Means user aborted the SQL installer so we need to stop. More codes here: http://www.hiteksoftware.com/knowledge/articles/049.htm
	SQLCorrupt:
		ReadRegDWORD $0 HKLM Software\AutoSQL "SQLCorruptAttempt"
			StrCmp $0 "1" SQLFailed
		${Logs} 'SQL: Installer Corrupted, deleting current file and trying again.'
		WriteRegDWORD HKLM Software\AutoSQL "SQLCorruptAttempt" "1"
		Delete "$TEMP\AutoSQL\sqlexpress.exe"
		Sleep 500
		Goto PreSQLInstallerCheck
	SQLCleared:
	${Logs} 'SQL: Install Passed'

	# Wait 5 seconds before attempting to launch SQLCMD, during development of this program i found the quickness of the installer was bypassing this as SQLCMD wasn't ready.
	Sleep 5000

	# This is what sets the SA password. We need to check for MSSQLSERVER instance name because you cannot connect to (local)\MSSQLSERVER
	StrCmp $sqlinstance "MSSQLSERVER" 0 +3
	nsExec::Exec '"$PROGRAMFILES64\Microsoft SQL Server\100\Tools\Binn\sqlcmd.exe" -S (local) -U sa -P PassWord123 -Q "ALTER LOGIN sa WITH PASSWORD = $\'$sapassword$\' UNLOCK,CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF"'
	GoTo +2
	nsExec::Exec '"$PROGRAMFILES64\Microsoft SQL Server\100\Tools\Binn\sqlcmd.exe" -S (local)\$sqlinstance -U sa -P PassWord123 -Q "ALTER LOGIN sa WITH PASSWORD = $\'$sapassword$\' UNLOCK,CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF"'

	Delete "$TEMP\AutoSQL\SQLConfig.ini"
	WriteRegDWORD HKLM Software\AutoSQL "SQLInstalled" "1"
	${Logs} 'SQL: Successful'
	SQLSkip:
SectionEnd

LangString DESC_SEC_SQL_2008R2 ${LANG_ENGLISH} "${DESC_SQL_2008R2}"
LangString DESC_SEC_SQL_2012 ${LANG_ENGLISH} "${DESC_SQL_2012}"

!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
	!insertmacro MUI_DESCRIPTION_TEXT ${SEC_SQL_2008R2} $(DESC_SEC_SQL_2008R2)
	!insertmacro MUI_DESCRIPTION_TEXT ${SEC_SQL_2012} $(DESC_SEC_SQL_2012)
!insertmacro MUI_FUNCTION_DESCRIPTION_END

Function .onInstSuccess
	${Logs} 'Installation: Successful'
	Delete "$TEMP\AutoSQL\Windows-Installer45-x86.exe"
	Delete "$TEMP\AutoSQL\Windows-Installer45-x64.exe"
	Delete "$TEMP\AutoSQL\Windows-PowerShell-x86.exe"
	Delete "$TEMP\AutoSQL\Windows-PowerShell-x64.exe"
	Delete "$TEMP\AutoSQL\dotnetx35setup.exe"
	Delete "$TEMP\AutoSQL\SQLConfig.ini"
	Delete "$TEMP\AutoSQL\sqlexpress.exe"
	WriteRegDWORD HKLM Software\AutoSQL "Success" "1"
	ReadRegDWORD $0 HKLM Software\AutoSQL "UACStatus"
		StrCmp $0 "1" 0 UACOff
	MessageBox MB_YESNO "For security reasons shall we turn User Account Control (UAC) back on? (Will require another restart)" IDYES UACon IDNO UACOff
	UACOn:
		WriteRegDWORD HKLM Software\Microsoft\Windows\CurrentVersion\Policies\System "EnableLUA" "1"
		${Logs} 'END: UAC Turned On.'
	UACOff:
FunctionEnd

Function .onInit
	 ReadRegDWORD $0 HKLM Software\AutoSQL "Success"
		StrCmp $0 "1" 0 Cont
		MessageBox MB_OK "It seems like you've already installed the system.$\r$\nYou need to remove it before retrying."
		Abort
	Cont:

	SetOutPath "$TEMP\AutoSQL"
	SetOverwrite ifnewer

	${Logs} ''
	${Logs} ''
	${Logs} ''
	${Logs} ''
	${Logs} 'Automated SQL Installer'
	${Logs} ''
	${Logs} ''
	${Logs} ''
	${Logs} ''

        Delete "$SMSTARTUP\AutoSQL Installation.lnk"

        !insertmacro MUI_INSTALLOPTIONS_EXTRACT_AS "UserData.ini" "UserData"

	WriteRegStr HKLM Software\AutoSQL "InstallDate" "${MYTIMESTAMP}"
	WriteRegDWORD HKLM Software\AutoSQL "SQLCorruptAttempt" "0"
	WriteRegDWORD HKLM Software\AutoSQL "UACStatus" "0"

	${Logs} 'INIT: Begin OS Check'
	 ReadRegDWORD $0 HKLM Software\AutoSQL "ComponentsDone"
		StrCmp $0 "1" OSPass

	GetVersion::WindowsName
		Pop $R0
		StrCpy $OSVersion $R0
		StrCmp $R0 "Win32s"		OSFail
		StrCmp $R0 "95 OSR2"		OSFail
		StrCmp $R0 "95"			OSFail
		StrCmp $R0 "98 SE"		OSFail
		StrCmp $R0 "98"			OSFail
		StrCmp $R0 "ME"			OSFail
		StrCmp $R0 "NT"			OSFail
		StrCmp $R0 "CE"			OSFail
		StrCmp $R0 "2000"		OSFail
		StrCmp $R0 "XP"			XP32Check
		StrCmp $R0 "XP x64"		XP64Check
		StrCmp $R0 "Server 2003"	S2003Check
		StrCmp $R0 "Server 2003 R2"	S2003R2Check
		StrCmp $R0 "Server 2008"	S2008Check
		StrCmp $R0 "Server 2008 R2"	S2008R2Check
		StrCmp $R0 "Vista"		VistaCheck
		StrCmp $R0 "7"			W7Check
		
		${Logs} 'OS: Check failed pre-req-checks'
		Abort

	S2008R2Check:
		${If} ${RunningX64}
			${Logs} 'INIT: OS - Server 2008 R2 64-bit'
		${Else}
			${Logs} 'INIT: OS - Server 2008 R2 32-bit'
		${EndIf}
		${DisableX64FSRedirection}
			${Logs} 'INIT: Enabling server features .NET and PowerShell'
			nsExec::Exec '$WINDIR\system32\servermanagercmd.exe -i NET-Framework-Core -a'
			Pop $0
			StrCmp $0 "0" 0 nextNET
				${Logs} 'INIT: $0 - .NET Feature successfully enabled.'
				Goto beyondNET
			nextNET:
			StrCmp $0 "1003" 0 next2NET
				${Logs} 'INIT: $0 - .NET feature already enabled.'
				Goto beyondNET
			next2NET:
				${Logs} 'INIT: $0 - .NET feature installation failure.'
				MessageBox MB_OK|MB_ICONSTOP "Installation Failed. See log in $TEMP\AutoSQL for details"
				Abort
			beyondNET:

			nsExec::Exec '$WINDIR\system32\servermanagercmd.exe -i Powershell-ISE -a'
			Pop $0
			StrCmp $0 "0" 0 nextPS
				${Logs} 'INIT: $0 - Powershell Feature successfully enabled.'
				Goto beyondPS
			nextPS:
			StrCmp $0 "1003" 0 next2PS
				${Logs} 'INIT: $0 - Powershell Feature already enabled.'
				Goto beyondPS
			next2PS:
				${Logs} 'INIT: $0 - Powershell feature installation failure.'
				MessageBox MB_OK|MB_ICONSTOP "Installation Failed. See log in $TEMP\AutoSQL for details"
				Abort
			beyondPS:
		${EnableX64FSRedirection}
		; PowerShell and .NET 3.5 both considered Feature installs for this OS so must request user enable those features
		; Installer 5.0 default installed for R2
		Goto UACCheck
	S2008Check:
		${If} ${RunningX64}
			${Logs} 'INIT: OS - Server 2008 64-bit'
			inetc::get /POPUP "${TITLE_INST45}" /caption "${TITLE_INST45}" /nocancel ${DOWNLOAD_INSTALLER45_2008_X64} "$TEMP\AutoSQL\Windows-Installer45-x64.exe" /END
			ExecWait "$TEMP\AutoSQL\Windows-Installer45-x64.exe /passive /norestart" $0
		${Else}
			${Logs} 'INIT: OS - Server 2008 32-bit'
			inetc::get /POPUP "${TITLE_INST45}" /caption "${TITLE_INST45}" /nocancel ${DOWNLOAD_INSTALLER45_2008_X86} "$TEMP\AutoSQL\Windows-Installer45-x86.exe" /END
			ExecWait "$TEMP\AutoSQL\Windows-Installer45-x86.exe /passive /norestart" $0
		${EndIf}
		${DisableX64FSRedirection}
			${Logs} 'INIT: Enabling server features .NET and PowerShell'
			nsExec::Exec '$WINDIR\system32\servermanagercmd.exe -i NET-Framework-Core -a'
			Pop $0
			StrCmp $0 "0" 0 nextNET2
				${Logs} 'INIT: $0 - .NET Feature successfully enabled.'
				Goto beyondNET2
			nextNET2:
			StrCmp $0 "1003" 0 next2NET2
				${Logs} 'INIT: $0 - .NET feature already enabled.'
				Goto beyondNET2
			next2NET2:
				${Logs} 'INIT: $0 - .NET feature installation failure.'
				MessageBox MB_OK|MB_ICONSTOP "Installation Failed. See log in $TEMP\AutoSQL for details"
				Abort
			beyondNET2:

			nsExec::Exec '$WINDIR\system32\servermanagercmd.exe -i Powershell-ISE -a'
			Pop $0
			StrCmp $0 "0" 0 nextPS2
				${Logs} 'INIT: $0 - Powershell Feature successfully enabled.'
				Goto beyondPS
			nextPS2:
			StrCmp $0 "1003" 0 next2PS2
				${Logs} 'INIT: $0 - Powershell Feature already enabled.'
				Goto beyondPS2
			next2PS2:
				${Logs} 'INIT: $0 - Powershell feature installation failure.'
				MessageBox MB_OK|MB_ICONSTOP "Installation Failed. See log in $TEMP\AutoSQL for details"
				Abort
			beyondPS2:
		${EnableX64FSRedirection}
		; PowerShell and .NET 3.5 both considered Feature installs for this OS so must request user enable those features
		; Installer 5.0 default installed for R2
		Goto UACCheck
	S2003Check:
		${If} ${RunningX64}
			${Logs} 'INIT: OS - Server 2003 64-bit'
			inetc::get /POPUP "${TITLE_INST45}" /caption "${TITLE_INST45}" /nocancel ${DOWNLOAD_INSTALLER45_2003_X64} "$TEMP\AutoSQL\Windows2003-Installer45-x64.exe" /END
			ExecWait "$TEMP\AutoSQL\Windows2003-Installer45-x64.exe /passive /norestart" $0
			${Logs} '$0 - Windows Installer 4.5'

			inetc::get /POPUP "${TITLE_PS10}" /caption "${TITLE_PS10}" /nocancel ${DOWNLOAD_POWERSHELL_2003_X64} "$TEMP\AutoSQL\Windows-PowerShell-x64.exe" /END
			ExecWait "$TEMP\AutoSQL\Windows-PowerShell-x64.exe /passive /norestart" $0
			${Logs} '$0 - PowerShell Install'
		${Else}
			${Logs} 'INIT: OS - Server 2003 32-bit'
			inetc::get /POPUP "${TITLE_INST45}" /caption "${TITLE_INST45}" /nocancel ${DOWNLOAD_INSTALLER45_2003_X86} "$TEMP\AutoSQL\Windows-Installer45-x86.exe" /END
			ExecWait "$TEMP\AutoSQL\Windows-Installer45-x86.exe /passive /norestart" $0
			${Logs} '$0 - Windows Installer 4.5'

			inetc::get /POPUP "${TITLE_PS10}" /caption "${TITLE_PS10}" /nocancel ${DOWNLOAD_POWERSHELL_2003_X86} "$TEMP\AutoSQL\Windows-PowerShell-x86.exe" /END
			ExecWait "$TEMP\AutoSQL\Windows-PowerShell-x86.exe /passive /norestart" $0
			${Logs} '$0 - PowerShell Install'

		${EndIf}
		inetc::get /POPUP "${TITLE_DOTNET35}" /caption "${TITLE_DOTNET35}" /nocancel ${DOWNLOAD_DOTNET35} "$TEMP\AutoSQL\dotnetx35setup.exe" /END
		ExecWait "$TEMP\AutoSQL\dotnetx35setup.exe /passive /norestart" $0
		${Logs} '$0 - .NET 3.5 Install'
		Goto UACCheck
	S2003R2Check:
		${If} ${RunningX64}
			${Logs} 'INIT: OS - Server 2003 R2 64-bit'
			inetc::get /POPUP "${TITLE_INST45}" /caption "${TITLE_INST45}" /nocancel ${DOWNLOAD_INSTALLER45_2003_X64} "$TEMP\AutoSQL\Windows-Installer45-x64.exe" /END
			ExecWait "$TEMP\AutoSQL\Windows-Installer45-x64.exe /passive /norestart" $0
			${Logs} '$0 - Windows Installer 4.5'

			inetc::get /POPUP "${TITLE_PS10}" /caption "${TITLE_PS10}" /nocancel ${DOWNLOAD_POWERSHELL_2003_X64} "$TEMP\AutoSQL\Windows-PowerShell-x64.exe" /END
			ExecWait "$TEMP\AutoSQL\Windows-PowerShell-x64.exe /passive /norestart" $0
			${Logs} '$0 - PowerShell Install'
		${Else}
			${Logs} 'INIT: OS - Server 2003 R2 32-bit'
			inetc::get /POPUP "${TITLE_INST45}" /caption "${TITLE_INST45}" /nocancel ${DOWNLOAD_INSTALLER45_2003_X86} "$TEMP\AutoSQL\Windows-Installer45-x86.exe" /END
			ExecWait "$TEMP\AutoSQL\Windows-Installer45-x86.exe /passive /norestart" $0
			${Logs} '$0 - Windows Installer 4.5'

			inetc::get /POPUP "${TITLE_PS10}" /caption "${TITLE_PS10}" /nocancel ${DOWNLOAD_POWERSHELL_2003_X86} "$TEMP\AutoSQL\Windows-PowerShell-x86.exe" /END
			ExecWait "$TEMP\AutoSQL\Windows-PowerShell-x86.exe /passive /norestart" $0
			${Logs} '$0 - PowerShell Install'
		${EndIf}
		inetc::get /POPUP "${TITLE_DOTNET35}" /caption "${TITLE_DOTNET35}" /nocancel ${DOWNLOAD_DOTNET35} "$TEMP\AutoSQL\dotnetx35setup.exe" /END
		ExecWait "$TEMP\AutoSQL\dotnetx35setup.exe /passive /norestart" $0
		${Logs} '$0 - .NET 3.5 Install'
		Goto UACCheck
	XP32Check:
		${Logs} 'INIT: OS - XP 32-bit'
		inetc::get /POPUP "${TITLE_INST45}" /caption "${TITLE_INST45}" /nocancel ${DOWNLOAD_INSTALLER45_XP32_X86} "$TEMP\AutoSQL\Windows-Installer45-x86.exe" /END
		ExecWait "$TEMP\AutoSQL\Windows-Installer45-x86.exe /passive /norestart" $0
		${Logs} '$0 - Windows Installer 4.5'

		inetc::get /POPUP "${TITLE_PS10}" /caption "${TITLE_PS10}" /nocancel ${DOWNLOAD_POWERSHELL_XP32_X86} "$TEMP\AutoSQL\Windows-PowerShell-x86.exe" /END
		ExecWait "$TEMP\AutoSQL\Windows-PowerShell-x86.exe /passive /norestart" $0
		${Logs} '$0 - PowerShell Install'

		inetc::get /POPUP "${TITLE_DOTNET35}" /caption "${TITLE_DOTNET35}" /nocancel ${DOWNLOAD_DOTNET35} "$TEMP\AutoSQL\dotnetx35setup.exe" /END
		ExecWait "$TEMP\AutoSQL\dotnetx35setup.exe /passive /norestart" $0
		${Logs} '$0 - .NET 3.5 Install'
		Goto OSPass
	XP64Check:
		${Logs} 'INIT: OS - XP 64-bit'
		inetc::get /POPUP "${TITLE_INST45}" /caption "${TITLE_INST45}" /nocancel ${DOWNLOAD_INSTALLER45_XP64_X64} "$TEMP\AutoSQL\Windows-Installer45-x64.exe" /END
		ExecWait "$TEMP\AutoSQL\Windows-Installer45-x64.exe /passive /norestart" $0
		${Logs} '$0 - Windows Installer 4.5'

		inetc::get /POPUP "${TITLE_DOTNET35}" /caption "${TITLE_DOTNET35}" /nocancel ${DOWNLOAD_DOTNET35} "$TEMP\AutoSQL\dotnetx35setup.exe" /END
		ExecWait "$TEMP\AutoSQL\dotnetx35setup.exe /passive /norestart" $0
		${Logs} '$0 - .NET 3.5 Install'

		inetc::get /POPUP "${TITLE_PS10}" /caption "${TITLE_PS10}" /nocancel ${DOWNLOAD_POWERSHELL_XP64_X64} "$TEMP\AutoSQL\Windows-PowerShell-x64.exe" /END
		ExecWait "$TEMP\AutoSQL\Windows-PowerShell-x64.exe /passive /norestart" $0
		${Logs} '$0 - PowerShell Install'

		WriteRegDWORD HKLM Software\AutoSQL "RebootRequired" "1"
		Goto OSPass
	VistaCheck:
		GetVersion::WindowsServicePack
		Pop $R0
		StrCmp $R0 "" SPRequirements
		StrCmp $R0 "Service Pack 1" SPRequirements

		${If} ${RunningX64}
			${Logs} 'INIT: OS - Vista 64-bit'
			inetc::get /POPUP "${TITLE_INST45}" /caption "${TITLE_INST45}" /nocancel ${DOWNLOAD_INSTALLER45_VISTA_X64} "$TEMP\AutoSQL\Windows-Installer45-x64.exe" /END
			ExecWait "$TEMP\AutoSQL\Windows-Installer45-x64.exe /passive /norestart" $0
			${Logs} '$0 - Windows Installer 4.5'

			inetc::get /POPUP "${TITLE_PS10}" /caption "${TITLE_PS10}" /nocancel ${DOWNLOAD_POWERSHELL_VISTA_X64} "$TEMP\AutoSQL\Windows-PowerShell-x64.exe" /END
			ExecWait "$TEMP\AutoSQL\Windows-PowerShell-x64.exe /passive /norestart" $0
			${Logs} '$0 - PowerShell Install'
		${Else}
			${Logs} 'INIT: OS - Vista 32-bit'
			inetc::get /POPUP "${TITLE_INST45}" /caption "${TITLE_INST45}" /nocancel ${DOWNLOAD_INSTALLER45_VISTA_X86} "$TEMP\AutoSQL\Windows-Installer45-x86.exe" /END
			ExecWait "$TEMP\AutoSQL\Windows-Installer45-x86.exe /passive /norestart" $0
			${Logs} '$0 - Windows Installer 4.5'

			inetc::get /POPUP "${TITLE_PS10}" /caption "${TITLE_PS10}" /nocancel ${DOWNLOAD_POWERSHELL_VISTA_X86} "$TEMP\AutoSQL\Windows-PowerShell-x86.exe" /END
			ExecWait "$TEMP\AutoSQL\Windows-PowerShell-x86.exe /passive /norestart" $0
			${Logs} '$0 - PowerShell Install'
		${EndIf}
		inetc::get /POPUP "${TITLE_DOTNET35}" /caption "${TITLE_DOTNET35}" /nocancel ${DOWNLOAD_DOTNET35} "$TEMP\AutoSQL\dotnetx35setup.exe" /END
		ExecWait "$TEMP\AutoSQL\dotnetx35setup.exe /passive /norestart" $0
		${Logs} '$0 - .NET 3.5 Install'
		Goto UACCheck
	W7Check:
		${If} ${RunningX64}
			${Logs} 'INIT: OS - 7 64-bit'
		${Else}
			${Logs} 'INIT: OS - 7 32-bit'
		${EndIf}

		GetVersion::WindowsServicePack
		Pop $R0
		StrCmp $R0 "" SPRequirements

		; No .NET 3.5 needed.
		; No install 4.5 needed.
		; No powershell needed.
		Goto UACCheck
	SPRequirements:
		MessageBox MB_OK "Minimum Service Pack 1 is required for Windows 7$\r$\nMinimum Service Pack 2 for Vista."
		${Logs} 'OS: Failed, not on at least SP1 for Win7 or SP2 for Vista'
		${Logs} 'UAC Check'
		ReadRegDWORD $0 HKLM Software\Microsoft\Windows\CurrentVersion\Policies\System "EnableLUA"
		StrCmp $0 "1" 0 abrt
			${Logs} 'UAC Check: Failed - Status: Enabled'
			MessageBox MB_YESNO|MB_ICONEXCLAMATION "User Account Control is enabled and needs to be disabled.$\r$\nSelect No to see what needs to be done.$\r$\n$\r$\nDo you want us to fix this for you, this will force reboot?" IDYES yes2 IDNO no2
			yes2:
				WriteRegDWORD HKLM Software\Microsoft\Windows\CurrentVersion\Policies\System "EnableLUA" "0"
				${Logs} 'UAC Check: Success - UAC Now Disabled, Requires Reboot'
				CreateShortCut "$SMSTARTUP\AutoSQL Installation.lnk" "$EXEPATH"
				Reboot
			no2:
				ExecShell "open" "${LINK_UAC_HELP}"
				${Logs} 'UAC Check: Failed - User Aborted'
				Abort
		abrt:
			Abort
		
	UACCheck:
		${Logs} 'UAC Check'
		ReadRegDWORD $0 HKLM Software\Microsoft\Windows\CurrentVersion\Policies\System "EnableLUA"
		StrCmp $0 "1" 0 OSPass
			${Logs} 'UAC Check: Failed - Status: Enabled'
			MessageBox MB_YESNO|MB_ICONEXCLAMATION "User Account Control is enabled and needs to be disabled.$\r$\nSelect No to see what needs to be done.$\r$\n$\r$\nDo you want us to fix this for you?" IDYES yes IDNO no
			yes:
				WriteRegDWORD HKLM Software\Microsoft\Windows\CurrentVersion\Policies\System "EnableLUA" "0"
				WriteRegDWORD HKLM Software\AutoSQL "UACStatus" "1"
				WriteRegDWORD HKLM Software\AutoSQL "RebootRequired" "1"
				${Logs} 'UAC Check: Success - UAC Now Disabled, Requires Reboot'
				Goto FoundRestart
			no:
				ExecShell "open" "${LINK_UAC_HELP}"
				${Logs} 'UAC Check: Failed - User Aborted'
				Abort

	/** OS Fails to meet requirements. **/
	OSFail:
		MessageBox MB_OK|MB_ICONSTOP "Supported Operating Systems:$\r$\nWindows XP$\r$\nWindows Vista$\r$\nWindows 7$\r$\nWindows Server 2003 / 2003 R2$\r$\nWindows Server 2008 / 2008 R2"
		${Logs} 'OS: Version Failed, $OSVersion is not compatible.'
		Abort
	OSPass:
		WriteRegDWORD HKLM Software\AutoSQL "ComponentsDone" "1"
		${Logs} 'OS: Passed'

	${Logs} 'Reboot: Checking if we need to reboot.'
	 ReadRegDWORD $0 HKLM Software\AutoSQL "RebootRequired"
		StrCmp $0 "1" FoundRestart

	NextValue:
	EnumRegValue $R2 HKLM "SYSTEM\CurrentControlSet\Control\Session Manager" $R3
		StrCmp $R2 "" PostRebootCheck 0
		StrCmp $R2 "PendingFileRenameOperations" FoundRestart 0
		IntOp $R3 $R3 + 1
		Goto NextValue

	FoundRestart:
		${Logs} 'Reboot: System needs a restart.'
		;MessageBox MB_YESNO|MB_ICONSTOP "Your machine must be restarted before we can continue.$\r$\nDo you wish to do so now?" IDNO noreboot
		;	ReadRegDWORD $0 HKLM Software\AutoSQL "SkipReboot"
		;		StrCmp $0 "1" PostRebootCheck
			WriteRegDWORD HKLM Software\AutoSQL "RebootRequired" "0"
			${Logs} 'Reboot Check: Passed, creating startup shortcut to restart installer.'
			CreateShortCut "$SMSTARTUP\AutoSQL Installation.lnk" "$EXEPATH"
			Reboot
		;noreboot:
		;	${Logs} 'Reboot: Failed, user selected No to restart.'
		;	Abort
	PostRebootCheck:
		${Logs} 'Reboot: Passed.'
FunctionEnd

# CUSTOM PAGE.
# =========================================================================
# Get the SQL Instance and SA Password.
Function DemoUsername
	;SectionGetFlags ${SEC_SQL_2008R2} $0
	;IntCmp $0 ${SF_SELECTED} ShowForm SkipForm
	;ShowForm:
		Call UserDataPage
	;SkipForm:
FunctionEnd

Function UserDataPage
   !insertmacro MUI_HEADER_TEXT "$(UserData_TITLE)" "$(UserData_SUBTITLE)"

   # Display the page.
   !insertmacro MUI_INSTALLOPTIONS_DISPLAY "UserData"

   # Get the user entered values.
   !insertmacro MUI_INSTALLOPTIONS_READ $sapassword "UserData" "Field 2" "State"
   !insertmacro MUI_INSTALLOPTIONS_READ $sqlinstance "UserData" "Field 4" "State"
FunctionEnd

Function .onInstFailed
         Delete "$TEMP\AutoSQL\SQLConfig.ini"
         Delete "$TEMP\AutoSQL\icon.ico"
	${Logs} 'Installation Failed.'
FunctionEnd

Function onUserAbort
	${Logs} 'User Aborted Installation.'
FunctionEnd

/** Nothing Below Here. **/

Function Logs
	Exch $0 ;file to write to
	Exch
	Exch $1 ;text to write

	FileOpen $0 $0 a #open file
	FileSeek $0 0 END #go to end
	FileWrite $0 $1 #write to file
	FileClose $0

	Pop $1
	Pop $0
FunctionEnd
