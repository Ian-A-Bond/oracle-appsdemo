/*
** Copyright (c) 2022 Bond & Pollard Ltd. All rights reserved.  
** NAME   : auto_install.sql
**
** DESCRIPTION
**   
**   Install the database schema automatically
**   1. Creates schema (tables, indexes, constraints, triggers etc)
**   2. Creates a connection user with restricted privileges
**   3. Load seed data into the database
**   4. Compile all packages
**
** INSTRUCTIONS
**
**   1. Amend the following scripts in the config directory to specify the database service, application owner, and directory paths:
**        set_env.bat
**        set_env.sql
**
**   2. Amend this script to specify the application home directory in v_app_root.
**
**   3. You must be connected to the database as SYS user, as SYSDBA (you will be prompted for the password)
**
**   4. Run this script ONCE to create the schema, load the seed data, and compile the packages
**
**   5. Create the user's operating system directories for data import and export. 
**   5.1. Each named directory applies to the entire database, so directory DATA_IN has the same file system path in 
**        all schemas.
**   5.2. You may wish to place the user data directories on a different disk to the application. On Windows systems where
**        the Operating System is on drive C, and the data on drive D, Oracle may not have the necessary permissions to access
**        directories on C.
** 
**------------------------------------------------------------------------------------------------------------------------------
** MODIFICATION HISTORY
**
** Date         Name          Description
**------------------------------------------------------------------------------------------------------------------------------
** 21/07/2022   Ian Bond      Created script
** 06/03/2023   Ian Bond      Include application connection user parameters
** 17/04/2023   Ian Bond      Lock the owning schema to keep database secure
*/

/*
** Handle special characters e.g. ampersand & in directory names and strings
** You must escape the directory delimiters so use \\ not \
*/
  SET ESCAPE ON

/*
 ***********************************************************
 *   IMPORTANT                                             *
 *   You must set v_app_root to the directory in which you *
 *   installed your application                            *
 ***********************************************************
*/
  DEFINE v_app_root = C:\\USERS\\IANBO\\DROPBOX\\ORACLE\\XEPDB1\\APPSDEMO



  @&v_app_root\\config\\set_env

  
-- Create the database schema
  @'&v_app_home\\install\\install_schema'     &v_dbservice &v_dbconnect &v_app_owner &v_pwd &v_connect_user &v_connect_pwd "&v_app_home" "&v_data_home"
  
-- Load the seed data
  @'&v_app_home\\install\\seed_data'          &v_dbservice &v_dbconnect &v_app_owner &v_pwd 
  
-- Compile all the packages
  @'&v_app_home\\install\\compile_packages'   &v_dbservice &v_dbconnect &v_app_owner &v_pwd "&v_app_home" &v_connect_user
  
-- Lock the owning schema
  @'&v_app_home\\install\\lock_schema'        &v_dbservice &v_dbconnect &v_app_owner

