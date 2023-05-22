/*
** Copyright (c) 2022 Bond & Pollard Ltd. All rights reserved.  
** NAME   : set_env.sql
**
** DESCRIPTION
**   Configure the Oracle application environent.
**
** SECURITY WARNING
**   
**   You must keep the application owner/schema password secure. Do not allow any users
**   or applications to connect to the database as the application owner.
**
**   A separate connection user has been created for applications to
**   connect to the database with.
**
** INSTRUCTIONS
**
**   1. You must amend this script to set up your Oracle application environment.
**      Set the following:
**
**       V_DBSERVICE    Database Service name, e.g. XEPDB1, or XEDEV, XEPROD etc
**       V_APP_OWNER    Application owner/schema e.g. APPSDEMO
**       V_PWD          Password for the application owner schema.
**                      See security warning above.
**       V_CONNECT_USER Users and applications connect to the database as this user, e.g. DEMO_CONNECT. 
**                      This user does not own the application's schema objects, and has limited privileges.
**       V_CONNECT_PWD  Password for V_CONNECT_USER.
**                      NB: This currently must be hardcoded in the script set_env.bat.
**       V_PORT         Oracle database listener port, default 1521
**       V_DBCONNECT    Connect to DB Service
**       V_APP_HOME     Application home directory path
**       V_DATA_HOME    Data home directory path (import / export, user files etc)
**
**   2. You must also amend set_env.bat to configure the above for the scripts that run from the command
**      line.  
** 
**------------------------------------------------------------------------------------------------------------------------------
** MODIFICATION HISTORY
**
** Date         Name          Description
**------------------------------------------------------------------------------------------------------------------------------
** 06/08/2022   Ian Bond      Created script.
** 06/03/2023   Ian Bond      Add V_CONNECT_USER as database user for applications.
*/

/*
 ********************************************************************
 * The following parameters must be checked and amended as required *
 ********************************************************************
*/

-- Set the database service name here
-- Note that in a production environment, this would be one of DEV, TEST, PROD (or XEDEV, XETEST, XEPROD)
  DEFINE v_dbservice = XEPDB1
  
-- Set the application owner schema name here
  DEFINE v_app_owner = appsdemo
  
-- Set the default password for the schema that owns the application 
  ACCEPT v_pwd PROMPT "Enter the password for &v_app_owner"
  
-- Set the name of the user that applications connect to the database with. 
  DEFINE v_connect_user = demo_connect
  
-- Set the password for the connection user
  ACCEPT v_connect_pwd PROMPT "Enter the password for the database connection user &v_connect_user"
  
-- Oracle database listener port, default is 1521
  DEFINE v_port = 1521

-- Connect to Database service
  DEFINE v_dbconnect = //localhost:&v_port/&v_dbservice

-- Application Home directory
-- Note that where directory names contain a special character such as '&', you must precede it with the \ escape character.
-- You will need to SET ESCAPE ON first.
-- The directory name separator \ will also need to be preceded by a \ escape character.
  DEFINE v_app_home = "C:\\USERS\\IANBO\\DROPBOX\\ORACLE\\&v_dbservice\\&v_app_owner"

-- Data Home directory
-- This is the location of the user data directories
-- Do not include spaces or special characters in the directory name
  DEFINE v_data_home = "D:\\USER_DATA\\&v_dbservice\\&v_app_owner\\data"