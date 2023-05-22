/*
** Copyright (c) 2022 Bond & Pollard Ltd. All rights reserved.  
** NAME   : compile_packages.sql
**
** DESCRIPTION
**   Compile all PL/SQL packages
** 
**------------------------------------------------------------------------------------------------------------------------------
** MODIFICATION HISTORY
**
** Date         Name          Description
**------------------------------------------------------------------------------------------------------------------------------
** 21/07/2022   Ian Bond      Created script
** 06/03/2023   Ian Bond      Include synonyms and grants for application connection user
*/

  SET ESCAPE ON
  
  DEFINE v_dbservice    = &1
  DEFINE v_dbconnect    = &2
  DEFINE v_app_owner    = &3
  DEFINE v_password     = &4
  DEFINE v_app_home     = &5
  DEFINE v_connect_user = &6
  
  CONNECT &v_app_owner/&v_password@&v_dbconnect
  
  @'&v_app_home\\plsql\\demo_string.sql'
  @'&v_app_home\\plsql\\plsql_constants'
  @'&v_app_home\\plsql\\util_string'
  @'&v_app_home\\plsql\\util_numeric'
  @'&v_app_home\\plsql\\util_date'
  @'&v_app_home\\plsql\\util_admin'
  @'&v_app_home\\plsql\\util_file'
  @'&v_app_home\\plsql\\orderrp'
  @'&v_app_home\\plsql\\export'
  @'&v_app_home\\plsql\\import'
  
  
/*
** Public synonyms for Packages
** NB: Escape is on so you need to use \ to prefix the dot separator.
*/
 
  CREATE OR REPLACE PUBLIC SYNONYM demo_string     FOR &v_app_owner\.demo_string;
  CREATE OR REPLACE PUBLIC SYNONYM export          FOR &v_app_owner\.export;
  CREATE OR REPLACE PUBLIC SYNONYM import          FOR &v_app_owner\.import;
  CREATE OR REPLACE PUBLIC SYNONYM orderrp         FOR &v_app_owner\.orderrp;
  CREATE OR REPLACE PUBLIC SYNONYM plsql_constants FOR &v_app_owner\.plsql_constants;
  CREATE OR REPLACE PUBLIC SYNONYM util_admin      FOR &v_app_owner\.util_admin;
  CREATE OR REPLACE PUBLIC SYNONYM util_date       FOR &v_app_owner\.util_date;
  CREATE OR REPLACE PUBLIC SYNONYM util_file       FOR &v_app_owner\.util_file;
  CREATE OR REPLACE PUBLIC SYNONYM util_numeric    FOR &v_app_owner\.util_numeric;
  CREATE OR REPLACE PUBLIC SYNONYM util_string     FOR &v_app_owner\.util_string;
  
  
/*
** Grant execute privilege to connection user
*/
  GRANT EXECUTE ON demo_string     TO &v_connect_user;
  GRANT EXECUTE ON export          TO &v_connect_user;
  GRANT EXECUTE ON import          TO &v_connect_user;
  GRANT EXECUTE ON orderrp         TO &v_connect_user;
  GRANT EXECUTE ON plsql_constants TO &v_connect_user;
  GRANT EXECUTE ON util_admin      TO &v_connect_user;
  GRANT EXECUTE ON util_date       TO &v_connect_user;
  GRANT EXECUTE ON util_file       TO &v_connect_user;
  GRANT EXECUTE ON util_numeric    TO &v_connect_user;
  GRANT EXECUTE ON util_string     TO &v_connect_user;
  