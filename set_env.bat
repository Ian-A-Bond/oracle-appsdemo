REM NAME: set_env.bat
REM
REM DESCRIPTION
REM
REM   Set the environment variables for the Oracle application.
REM
REM   You must modify this script to match your application configuration.
REM
REM      Variable    Description
REM      =====================================================
REM      dbservice       Database service name, XEPDB1 is the first pluggable database
REM                      Note in a production environment this would be one of DEV, TEST, PROD
REM
REM      app_owner       Name of user/schema that owns the application 
REM
REM      connect_user    Applications connect to database via this user
REM
REM      connect_pwd     Password for connect_user. By default the user will
REM                      be prompted to enter this password. If this script is 
REM                      called with the first argument STARTORA, it will not prompt for
REM                      the password. See instructions below.
REM
REM      port            Oracle database listener port, default 1521
REM
REM      dbconnect       Database connection string, including hostname and port
REM
REM      app_home        Root installation directory for your application    
REM
REM      data_home       User data directory (data import/export) - must not contain spaces
REM                      or special characters
REM
REM INSTRUCTIONS
REM
REM   Call this batch file from your operating system scripts to set
REM   the required environment variables for the Oracle application.
REM
REM   Users and Applications must connect to the database as connect_user, and the user must be 
REM   prompted to enter the password. Call the set_env.bat script as follows:
REM
REM     CALL ..\config\SET_ENV
REM
REM   To call the script without prompting for the password, e.g. from startora.bat
REM   which starts the Oracle database, and does not need to connect to the database as the 
REM   connect_user, you may specify the first argument STARTORA as follows:
REM
REM     CALL ..\config\SET_ENV STARTORA
REM 
REM ---------------------------------------------------------------------------------------
REM MODIFICATION HISTORY
REM
REM Date         Name          Description
REM ---------------------------------------------------------------------------------------
REM 22/07/2022   Ian Bond      Created script.
REM 06/08/2022   Ian Bond      Rename APP_ENV to APP_OWNER and include DBSERVICE in directory
REM                            paths APP_HOME and DATA_HOME.
REM 06/03/2023   Ian Bond      Added new environment variables connect_user and connect_pwd
REM                            as database user that applictions connect to database with.
REM 16/04/2023   Ian Bond      Prompt user to enter password for connect_user.
REM 20/04/2023   Ian Bond      Don't prompt for connect_user password when called by startora.bat


REM
REM
REM Setting evironment variables
SET DBSERVICE=XEPDB1
SET APP_OWNER=APPSDEMO
SET CONNECT_USER=DEMO_CONNECT
SET PORT=1521
SET DBCONNECT=//LOCALHOST:%PORT%/%DBSERVICE%
SET APP_HOME="C:\USERS\IANBO\DROPBOX\ORACLE\%DBSERVICE%\%APP_OWNER%"

REM Don't include spaces or special characters in this directory name. We cannot enclose this variable in quotes
REM as we will need to add a filename later and enclose the whole path and filename in quotes.
SET DATA_HOME=D:\USER_DATA\%DBSERVICE%\%APP_OWNER%\data

REM Prompt user to enter the connect_user password, unless the script was called with the argument STARTORA,
REM e.g. when called by startora.bat 
IF "%1"=="STARTORA" GOTO END
SET /P CONNECT_PWD=Enter the password for %CONNECT_USER%:
:END
