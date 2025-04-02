REM Program   : set_env.bat
REM Decription: Generated by setup to set the environment variables for the Oracle application.
REM Parameters:
REM             dbservice       Database service name, XEPDB1 is the first pluggable database.
REM                             Note in a production environment this would be e.g. DEV, TEST, PROD.
REM             app_owner       Name of user/schema that owns the application.
REM             connect_user    Applications connect to database via this user
REM             connect_pwd     Password for connect_user. By default the user will be prompted to
REM                             enter this password. If this script is called with the first argument STARTORA,
REM                             it will not prompt for the password.
REM             port            Oracle database listener port, default 1521.
REM             dbconnect       Database connection string, including hostname and port.
REM             app_home        Root installation directory for your application.
REM             data_home       User data directory (data import/export) - must not contain spaces.
REM                             or special characters.
REM INSTRUCTIONS:
REM             Call this batch file from your operating system scripts to set
REM             the required environment variables for the Oracle application.
REM             Users and Applications must connect to the database as connect_user, and the user must be
REM             prompted to enter the password. Call the set_env.bat script as follows:
REM                 CALL ..\config\SET_ENV
REM             To call the script without prompting for the password, e.g. from startora.bat
REM             which starts the Oracle database, and does not need to connect to the database as the
REM             connect_user, you may specify the first argument STARTORA as follows:
REM                 CALL ..\config\SET_ENV STARTORA
SET DBSERVICE=XEPDB1
SET APP_OWNER=APPSDEMO
SET CONNECT_USER=DEMO_CONNECT
SET PORT=1521
SET DBCONNECT=//localhost:1521/XEPDB1
SET APP_HOME="d:\users\ianbo\documents\business\bond & pollard ltd\admin\it\applications\oracle\demo\XEPDB1\APPSDEMO"
REM Do NOT include spaces or special characters in this directory name. We cannot enclose this variable in quotes
REM as we will need to add a filename later and enclose the whole path and filename in quotes.
SET DATA_HOME=d:\user_data\XEPDB1\APPSDEMO\data
IF "%1"=="STARTORA" GOTO END
SET /P CONNECT_PWD=Enter the password for DEMO_CONNECT: 
:END
