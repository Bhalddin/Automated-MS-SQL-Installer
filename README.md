# Automated SQL Installer.

Currently installs SQL 2008 R2 Express.

Current installers workflow:

1. As soon as you run the installer it starts working, there is no notification or wait period. Everything below happens without user interaction.
2. It will determine which OS it's running on, and then install the nessessary software required by SQL to install.
   * .NET 3.5
   * PowerShell 1.0
   * Windows Installer 4.5 (useful for fresh XP machines that have yet to install Windows Updates)
3. It will then automatically restart the computer and relaunch the installer.
4. At this point it will then present you with a screen, in the future i plan on having SQL 2005, and 2011 when it's ready.
5. It will then ask you for the instance name of SQL and the SA password.
   * MSSQLSERVER is the default instance by Microsoft's standards. Unless you know what you're doing i highly suggest leaving this alone
   * By default I enable the SA account and assign it this password. I highly suggest changing it to your own.
6. Install.
7. From here the installer will go and grab the SQL installer and save it to %temp%\AutoSQL\ folder.
   * If you wish you can also download it ahead of time, or from a usb stick and place it into the folder listed above before hand and name it "sqlexpress.exe" and the installer will bypass downloading and go straight to install.
8. It is configured with your instance name and chosen password.

* You can see the SQL options in SQLConfig.ini
* By default it installs with Connectivity, and SQL Server Management Studio(plus the advanced if it is included in the sql installer)
* As well as enabling Named Pipes and TCP/IP connections
* If something should fail and you find the SA Password you typed in doesn't work. The default password used is "PassWord123" (without quotes). Windows 7, Server 2008/2008R2 all require an advanced to install and users typically won't make one advanced enough. So we use the PassWord123 and then change it afterwards.

## Installing NSIS and Plugins

1. [Download and install NSIS](http://nsis.sourceforge.net/)
2. [Download logiclib2.3.zip](http://forums.winamp.com/showthread.php?s=&postid=1116241) from the forum post attachment.
3. [Download Modern UI](http://nsis.sourceforge.net/MUI)
4. [Download GetVersion(Windows)](http://nsis.sourceforge.net/GetVersion_(Windows)_plug-in)
5. [Download Inetc](http://nsis.sourceforge.net/Inetc_plug-in)
6. Extract everything into the NSIS installation folder.
7. By this point you should be able to right click on the MSSQLInstall.nsi file and choose Compile NSIS Script. If everything is ok it will compile and create SQLInstall.exe

You could also download a portable working NSIS that will compile the scripts. [Found here](http://files.rpdatasystems.ca/NSIS.rar)
And use makensisw.exe instead of NSIS.exe

## Using your own local server

* If you have to roll out a lot of installations, using a local server would be a better idea.
* It'll be faster, and save yourself the monthly download limit (if there is one).
* This is esecially true for the SQL installers themselves. If you use the standard installation, that is almost 300MB's, if you use the advanced services installer that is over 800MB.

1. Open MSSQLInstall.msi in your editor.
2. Read the instructions above line 25 to get the Windows updates download.
3. Change line 25 to your local web server to the Windows updates location.
4. I personally would comment out lines 37 and 38 in case i want to use Microsoft's servers again
5. Uncomment lines 41 and 42 and change it to point to your local web server.
   * You will need to download both 64 and 32 bit, unless you know for 100% sure that all machines are either 64 or 32-bit. Otherwise the installer will fail to download the file and then ask you to select it.
6. The Winupdate package does not include the dotnetfx35setup file, if you want to locally host that too go and download it and comment out line 62 and update line 63


