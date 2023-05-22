CREATE OR REPLACE PACKAGE util_admin AS
  /*
  ** (c) Bond & Pollard Ltd 2022
  ** This software is free to use and modify at your own risk.
  ** 
  ** Module Name   : util_admin
  ** Description   : Database admin utilities -
  **                 Auditing, error handling
  ** 
  **------------------------------------------------------------------------
  ** Modification History
  **  
  ** Date            Name                 Description
  **------------------------------------------------------------------------
  ** 08/07/2022      Ian Bond             Program created
  **   
  */
 

  /*
  ** Global constants
  */

  /* 
  ** Global variables
  */

  /*
  ** Global exceptions
  */

  /* 
  ** Public functions
  */
  
  /*
  ** log_message - Record messages in the application log
  **
  ** Use this procedure to record messages in the application log.
  **
  ** IN
  **   p_message         - Message to display or write to the log
  **   p_sqlerrm         - SQL Error Message
  **   p_program_name    - Name of the program creating the log
  **   p_log_mode        - One of:
  **                         F = write message to log table
  **                         S = display message on screen (DEFAULT)
  **                         B = both display message and write to log
  **   p_severity        - Indicates the type of log entry, validate on table appseverity:
  **                         I = Information (DEFAULT)
  **                         W = Warning
  **                         E = Error
  ** OUT
  ** EXCEPTIONS
  **   <exception_name1>      - <brief description>
  */
  PROCEDURE log_message (
      p_message         IN VARCHAR2,
      p_sqlerrm         IN VARCHAR2 DEFAULT NULL,
      p_program_name    IN VARCHAR2 DEFAULT NULL,
      p_log_mode        IN VARCHAR2 DEFAULT 'S',
      p_severity        IN VARCHAR2 DEFAULT 'I'
    ); 
    
  /*
  ** severity_desc - Returns the description of application log severity level
  **
  **
  ** IN
  **   p_severity        - Severity code, e.g. I (info), W (warning), E (error)
  ** RETURN
  **   VARCHAR2  Description of the severity level
  ** EXCEPTIONS
  **   <exception_name1>      - <brief description>
  */
  FUNCTION severity_desc (
     p_severity         IN VARCHAR2
    ) 
    RETURN VARCHAR2;
    
  /*
  ** get_user - Returns the name of the current database user
  **
  **
  ** IN
  ** RETURN
  **   VARCHAR2  Database user name
  ** EXCEPTIONS
  **   <exception_name1>      - <brief description>
  */ 
  FUNCTION get_user RETURN VARCHAR2;
  PRAGMA RESTRICT_REFERENCES (get_user, WNDS, WNPS);


END util_admin;
/


CREATE OR REPLACE PACKAGE BODY util_admin AS
  /*
  ** (c) Bond & Pollard Ltd 2022
  ** This software is free to use and modify at your own risk.
  ** 
  ** Module Name   : util_admin
  ** Description   : Database admin utilities -
  **                 Auditing, error handling
  ** 
  **------------------------------------------------------------------------
  ** Modification History
  **  
  ** Date            Name                 Description
  **------------------------------------------------------------------------
  ** 08/07/2022      Ian Bond             Program created
  **   
  */

  /*
  ** Private functions and procedures
  */

  /*
  ** severity_validate - Validate the severity code
  **
  **
  ** IN
  **   p_severity      - Severity code e.g. I (info), E (error), W (warning)
  ** RETURN
  **   BOOLEAN  TRUE if the severity code is valid, otherwise FALSE
  ** EXCEPTIONS
  **   <exception_name1>      - <brief description>
  */ 
  FUNCTION severity_validate (
      p_severity        IN VARCHAR2
    )
    RETURN BOOLEAN
  IS
    l_severity applog.severity%TYPE;
    l_valid BOOLEAN := FALSE;
  BEGIN
    SELECT S.severity INTO l_severity 
      FROM appseverity S
      WHERE S.severity = p_severity;
    IF SQL%FOUND THEN
      l_valid := TRUE;
    END IF;
    RETURN l_valid;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      dbms_output.put_line('UTIL_ADMIN.SEVERITY_VALIDATE Invalid Severity ' || p_severity);
      RETURN FALSE;
    WHEN OTHERS THEN
      dbms_output.put_line('UTIL_ADMIN.SEVERITY_VALIDATE Unexpected error for Severity ' || p_severity);
      RETURN FALSE;
  END severity_validate;
  
  /*
  ** Public functions and procedures
  */


  FUNCTION severity_desc (
     p_severity         IN VARCHAR2
    ) 
    RETURN VARCHAR2
  IS
    l_severity applog.severity%TYPE;
    l_severity_desc appseverity.severity_desc%TYPE;
  BEGIN
    SELECT S.severity_desc INTO l_severity_desc
      FROM appseverity S
      WHERE S.severity = p_severity;
    IF SQL%NOTFOUND THEN
      l_severity_desc := 'No description found';
    END IF;
    RETURN l_severity_desc;
  EXCEPTION
    WHEN OTHERS THEN
      dbms_output.put_line('No description found on APPSEVERITY for ' || p_severity);
      RETURN 'NOT FOUND';
  END severity_desc;
  
  PROCEDURE log_message (
      p_message         IN VARCHAR2,
      p_sqlerrm         IN VARCHAR2 DEFAULT NULL,
      p_program_name    IN VARCHAR2 DEFAULT NULL,
      p_log_mode        IN VARCHAR2 DEFAULT 'S',
      p_severity        IN VARCHAR2 DEFAULT 'I'
    ) 
  IS
    l_severity applog.severity%TYPE;
    l_mode VARCHAR2(1);
  BEGIN
    l_mode := nvl(substr(p_log_mode,1,1),'S');
    IF NOT l_mode IN ('B','F','S') THEN
      dbms_output.put_line('UTIL_ADMIN.LOG_MESSAGE Invalid Log Mode (' || l_mode || ') must be one of B (both), F (file) or S (screen - DEFAULT)');
      l_mode := 'S';
    END IF;
    l_severity := nvl(substr(p_severity,1,1),'I');
    IF NOT severity_validate(l_severity) THEN
      dbms_output.put_line('UTIL_ADMIN.LOG_MESSAGE Invalid Severity (' || l_severity || ') defaulted to I - Information');
      l_severity := 'I'; -- Default value for invalid severity
    END IF;
    IF l_mode IN ('F','B') THEN
      INSERT INTO applog (
          message,
          logged_at,
          user_name,
          applog_sqlerrm,
          program_name,
          severity
        )
        VALUES (
          p_message,
          LOCALTIMESTAMP,
          get_user,
          p_sqlerrm,
          p_program_name,
          l_severity
        );
    END IF;
    IF l_mode IN ('S','B') THEN
      dbms_output.put_line(severity_desc(l_severity) || 
          ' from program ' || p_program_name || 
          ' at ' || to_char(LOCALTIMESTAMP,'DD-MON-RR HH24:MM:SS.FF') ||
          ' Message: ' || p_message || 
          ' SQLERRM is ' || p_sqlerrm || 
          ' (Log mode is ' || l_mode || ')' 
        );
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
       dbms_output.put_line('UTIL_ADMIN.LOG_MESSAGE Unexpected error. Program ' || p_program_name || 
           ' at ' || to_char(LOCALTIMESTAMP,'DD-MON-RR HH24:MM:SS.FF') ||
           ' could not log message: ' || p_message || 
           ' SQLERRM is ' || SQLERRM ||
           ' (Log mode is ' || l_mode || ')' 
         );
  END log_message;
  
  FUNCTION get_user RETURN VARCHAR2 IS
   -- local variables
   l_username VARCHAR2(128);
  BEGIN
    SELECT sys_context('USERENV', 'CURRENT_USER')
      INTO l_username 
      FROM dual;
    RETURN l_username;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN NULL;
  END get_user;

END util_admin;
/
