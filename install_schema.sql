/*
** Copyright (c) 2022 Bond & Pollard Ltd. All rights reserved.  
** NAME   : install_schema.sql
**
**    *****************************************************
**    ***                 W A R N I N G                 ***
**    *****************************************************
**
**   This script will DROP (permanently delete) all the database objects, data and code
**   in the target schema. 
**
** DESCRIPTION
** 
**   This script creates an Oracle database schema, based on Oracle's
**   demo schema.
**
**
** DATABASE SECURITY
**
**   The owning schema should be locked, with no authentication.
**   This will prevent malicious users from connecting to the database using
**   the schema that owns the database objects.
**
**   NB: The owning schema may be unlocked to facilitate development.
**
**   A separate user is created for applications to connect to the 
**   database with. This connection user does not own any objects, 
**   and has restricted privileges.
**
** THE DEMO SCHEMA
**
**   New tables have been created to provide additional functionality.
**
**   Changes to original Oracle schema objects:
**   
**     ORD Table
**       ORDID size increased from NUMBER(4,0) to NUMBER(5,0)
**       ORDREF column added to be used by CSV import process
**
**     ITEM Table
**       ORDID size increased from NUMBER(4,0) to NUMBER(5,0)
**
** INSTRUCTIONS
**
**   This script will be executed by auto_install.sql which passes the
**   required parameters.
**------------------------------------------------------------------------------------------------------------------------------
** MODIFICATION HISTORY
**
** Date         Name          Description
**------------------------------------------------------------------------------------------------------------------------------
** 30/06/2022   Ian Bond      Created script
** 21/07/2022   Ian Bond      Renamed script to remove schema name and put hard-coded paths into variables
** 28/08/2022   Ian Bond      Alter object names to comply with standards. Index name <table>_IDX, 
**                            Foreign key <table_from>_<table_to>_FK. Only for objects added to Oracle demo.
** 06/03/2023   Ian Bond      Add a connection user that will be used by all applications that connect to the database.
*/

/*
* Escape is ON so you must use the \ to prefix escape characters
*/
  SET ESCAPE ON
  SET TERMOUT ON
  SET ECHO OFF



/* 
** Assign the passed parameters 
*/

  DEFINE v_dbservice    = &1
  DEFINE v_dbconnect    = &2
  DEFINE v_app_owner    = &3
  DEFINE v_password     = &4
  DEFINE v_connect_user = &5
  DEFINE v_connect_pwd  = &6
  DEFINE v_app_home     = &7
  DEFINE v_data_home    = &8
  
/*
** Set the user data directory paths here. The paths apply globally to all schemas in the database.
** NB: The directory path must be in uppercase, or you get the error ORA-29280 Invalid Directory Path
*/

  DEFINE v_data_in_dir  = '&v_data_home\\DATA_IN'
  DEFINE v_data_out_dir = '&v_data_home\\DATA_OUT'
  
/*
** Installation process begins here
*/

  PROMPT The schema &v_app_owner will be dropped/created
  
  PROMPT Connect with SYS AS DBA, enter SYS password

  CONNECT SYS@&v_dbconnect AS SYSDBA
  
/*
 ******************************************************************
 * Create the connection user.                                    *
 * This user allow the applications to connect to the database,   *
 * has restricted privileges and does not own database objects.   *
 ******************************************************************
*/
  DROP USER &v_connect_user CASCADE;

  CREATE USER &v_connect_user IDENTIFIED BY &v_connect_pwd DEFAULT TABLESPACE users TEMPORARY TABLESPACE temp;

  GRANT CONNECT TO &v_connect_user;

/*
 ******************************************************************
 * Create the application owner schema.                           *
 *                                                                *
 * This user should be locked, and set to no authentication       *
 * to keep the database secure by preventing users connecting as  *
 * the owner schema.                                              *
 * Removing authentication prevents the error message             *
 * 'The account is locked' which would give away its existence    *
 * and importance.                                                *
 * Note that the schema objects must be created before the        *
 * account is locked. The locking is done at the end of the       *
 * installation process, see auto_install.sql                     *
 ******************************************************************
*/  
  DROP USER &v_app_owner CASCADE;

  CREATE USER &v_app_owner IDENTIFIED BY &v_password DEFAULT TABLESPACE users TEMPORARY TABLESPACE temp;
 
  ALTER USER &v_app_owner QUOTA UNLIMITED ON users;
  
  GRANT CONNECT, RESOURCE, CREATE VIEW, CREATE PUBLIC SYNONYM TO &v_app_owner;
  
/*
** Create the directories and grant access permissions to users.
**
** NB: 
** The directory path must be in uppercase, or you get the error ORA-29280 Invalid Directory Path.
** Directories are stored in a single namespace, and not owned by individual schemas.
** This means that the file system paths specified below are the same in all schemas in the database.
*/

  CREATE OR REPLACE DIRECTORY data_in AS '&v_data_in_dir';
  GRANT READ, WRITE ON DIRECTORY data_in TO &v_app_owner;
  GRANT READ, WRITE ON DIRECTORY data_in TO &v_connect_user;
  
  CREATE OR REPLACE DIRECTORY data_in_error AS '&v_data_in_dir\\error';
  GRANT READ, WRITE ON DIRECTORY data_in_error TO &v_app_owner;
  GRANT READ, WRITE ON DIRECTORY data_in_error TO &v_connect_user;
   
  CREATE OR REPLACE DIRECTORY data_in_processed AS '&v_data_in_dir\\processed';
  GRANT READ, WRITE ON DIRECTORY data_in_processed TO &v_app_owner;
  GRANT READ, WRITE ON DIRECTORY data_in_processed TO &v_connect_user;

  CREATE OR REPLACE DIRECTORY data_out AS '&v_data_out_dir';
  GRANT READ, WRITE ON DIRECTORY data_out TO &v_app_owner;
  GRANT READ, WRITE ON DIRECTORY data_out TO &v_connect_user;

/*
** Grant execute privilege to UTL package
** This will allow programs in the schema to run the utl_file package functions to handle 
** file I/O
*/
  GRANT EXECUTE ON sys.utl_file TO &v_app_owner;
  GRANT EXECUTE ON sys.utl_file TO &v_connect_user;

/*
** Public Package Synonyms
*/
  CREATE OR REPLACE PUBLIC SYNONYM utl_file FOR sys.utl_file;

/*
** Connect to the database as the schema owner, and create the schema objects:
** Tables, Indexes, Constraints, Triggers, Views
*/

  CONNECT &v_app_owner/&v_password@&v_dbconnect

  
/*
** Create Sequences first as they are required by the 
** table triggers.
** Start each sequence with the next value available
** after data has been inserted into the corresponding table.
**
** NB: You can create IDENTITY columns for your candidate primary keys, instead of using a SEQUENCE
**     and BEFORE INSERT ON trigger.
**
**     CREATE TABLE IF NOT EXISTS mytable (
**       recid INTEGER GENERATED ALWAYS AS IDENTITY,
**       column2 STRING,
**       PRIMARY KEY (recid) 
**     );
*/


/*
** Create sequence CUSTID_SEQ assigns sequential number to CUSTID, primary key of CUSTOMER table
*/
  CREATE SEQUENCE  CUSTID_SEQ  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 109 NOCACHE  NOORDER  NOCYCLE ;


/*
** Create sequence ORDID_SEQ assigns sequential number to ORDID, primary key of ORD table
*/
  CREATE SEQUENCE  ORDID_SEQ  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 622 NOCACHE  NOORDER  NOCYCLE ;


/*
** Create sequence PRODID_SEQ assigns sequential number to PRODID, primary key of PRODUCT table
*/
  CREATE SEQUENCE  PRODID_SEQ  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 200381 NOCACHE  NOORDER  NOCYCLE ;

/*
** DDL for Sequence IMPORTCSV_FILEID_SEQ, used to assign sequential number to IMPORTCSV.FILEID
** Identifies a single imported file and the group of records contained within it.
*/
  CREATE SEQUENCE  IMPORTCSV_FILEID_SEQ  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 NOCACHE  NOORDER  NOCYCLE ;

/*
** Create Tables, Indexes, Triggers and Constraints
*/

/*
 *****************
 * BONUS table   *
 *****************
*/ 
  CREATE TABLE BONUS 
   (	
    ENAME             VARCHAR2(10 BYTE), 
    JOB               VARCHAR2(9 BYTE), 
    SAL               NUMBER, 
    COMM              NUMBER
   ) ;

  
/*
 ********************
 * CUSTOMER table   *
 ********************
*/  
  CREATE TABLE CUSTOMER 
   (	
    CUSTID            NUMBER(6,0), 
    NAME              VARCHAR2(45 BYTE), 
    ADDRESS           VARCHAR2(40 BYTE), 
    CITY              VARCHAR2(30 BYTE), 
    STATE             VARCHAR2(2 BYTE), 
    ZIP               VARCHAR2(9 BYTE), 
    AREA              NUMBER(3,0), 
    PHONE             VARCHAR2(9 BYTE), 
    REPID             NUMBER(4,0), 
    CREDITLIMIT       NUMBER(9,2), 
    COMMENTS          LONG
   ) ;
   
  CREATE UNIQUE INDEX CUSTOMER_PK ON CUSTOMER (CUSTID) ;
  
  ALTER TABLE CUSTOMER ADD CONSTRAINT CUSTOMER_CUSTID_CHK CHECK (CUSTID > 0) ENABLE;
  ALTER TABLE CUSTOMER ADD CONSTRAINT CUSTOMER_PK PRIMARY KEY (CUSTID) ENABLE;
  ALTER TABLE CUSTOMER MODIFY (REPID NOT NULL ENABLE);
  ALTER TABLE CUSTOMER MODIFY (CUSTID NOT NULL ENABLE);

  CREATE OR REPLACE TRIGGER INSERT_CUSTOMER 
   BEFORE INSERT ON CUSTOMER 
   FOR EACH ROW 
   BEGIN  
     IF inserting THEN 
        IF :NEW.custid IS NULL THEN 
           SELECT custid_seq.NEXTVAL INTO :NEW.custid FROM dual; 
        END IF; 
     END IF; 
   END;
   
  /

  ALTER TRIGGER INSERT_CUSTOMER ENABLE;

/*
 *****************
 * DEPT table    *
 *****************
*/ 
  CREATE TABLE DEPT 
   (	
    DEPTNO            NUMBER(2,0), 
    DNAME             VARCHAR2(14 BYTE), 
    LOC               VARCHAR2(13 BYTE)
   ) ;
   
  CREATE UNIQUE INDEX DEPT_PK ON DEPT (DEPTNO) ;

  ALTER TABLE DEPT ADD CONSTRAINT DEPT_PK PRIMARY KEY (DEPTNO) ENABLE;

  

/*
 *****************
 * DUMMY table   *
 *****************
*/ 
  CREATE TABLE DUMMY 
   (	
    DUMMY             NUMBER
   ) ;

/*
 *****************
 * EMP table     *
 *****************
*/ 
  CREATE TABLE EMP 
   (	
    EMPNO             NUMBER(4,0), 
    ENAME             VARCHAR2(10 BYTE), 
    JOB               VARCHAR2(9 BYTE), 
    MGR               NUMBER(4,0), 
    HIREDATE          DATE, 
    SAL               NUMBER(7,2), 
    COMM              NUMBER(7,2), 
    DEPTNO            NUMBER(2,0)
   ) ;

  CREATE UNIQUE INDEX EMP_PK ON EMP (EMPNO) ;
  
  ALTER TABLE EMP ADD CONSTRAINT EMP_PK PRIMARY KEY (EMPNO) ENABLE;
  ALTER TABLE EMP ADD CONSTRAINT EMP_MGR_FK FOREIGN KEY (MGR) REFERENCES EMP (EMPNO) ENABLE;
  ALTER TABLE EMP ADD CONSTRAINT EMP_DEPTNO_FK FOREIGN KEY (DEPTNO) REFERENCES DEPT (DEPTNO) ENABLE;

/*
 *******************
 * PRODUCT table   *
 *******************
*/ 
  CREATE TABLE PRODUCT 
   (	
    PRODID            NUMBER(6,0), 
    DESCRIP           VARCHAR2(30 BYTE)
   ) ;

  CREATE UNIQUE INDEX PRODUCT_PK ON PRODUCT (PRODID) ;
  
  ALTER TABLE PRODUCT ADD CONSTRAINT PRODUCT_PK PRIMARY KEY (PRODID) ENABLE;
  ALTER TABLE PRODUCT MODIFY (PRODID NOT NULL ENABLE);

  CREATE OR REPLACE TRIGGER INSERT_PRODUCT
   BEFORE INSERT ON PRODUCT
   FOR EACH ROW 
   BEGIN  
     IF inserting THEN 
        IF :NEW.prodid IS NULL THEN 
           SELECT prodid_seq.NEXTVAL INTO :NEW.prodid FROM dual; 
        END IF; 
     END IF; 
   END;
   
   /

   ALTER TRIGGER INSERT_PRODUCT ENABLE;
  
/*
 *****************
 * ORD table     *
 *****************
*/ 
  CREATE TABLE ORD 
   (	
    ORDID             NUMBER(5,0), 
    ORDERDATE         DATE, 
    ORDREF            VARCHAR2(10),
    COMMPLAN          VARCHAR2(1 BYTE), 
    CUSTID            NUMBER(6,0), 
    SHIPDATE          DATE, 
    TOTAL             NUMBER(8,2)
   ) ;

  COMMENT ON COLUMN ORD.ORDID IS 'Primary key uniquely identifies each sales order';
  COMMENT ON COLUMN ORD.ORDREF IS 'Identifies each order in the CSV data import files';
  COMMENT ON TABLE ORD IS 'Sales Order table. Associated details in the ITEMS table';

  CREATE UNIQUE INDEX ORD_PK ON ORD (ORDID) ;
  
  ALTER TABLE ORD MODIFY (ORDID NOT NULL ENABLE);
  ALTER TABLE ORD MODIFY (CUSTID NOT NULL ENABLE);
  ALTER TABLE ORD ADD CONSTRAINT ORD_PK PRIMARY KEY (ORDID) ENABLE;
  ALTER TABLE ORD ADD CONSTRAINT ORD_CUSTID_FK FOREIGN KEY (CUSTID) REFERENCES CUSTOMER (CUSTID) ENABLE;
   
  CREATE OR REPLACE TRIGGER INSERT_ORD
  BEFORE INSERT ON ORD
  FOR EACH ROW 
  BEGIN  
    IF inserting THEN 
       IF :NEW.ordid IS NULL THEN 
          SELECT ordid_seq.NEXTVAL INTO :NEW.ordid FROM dual; 
       END IF; 
    END IF; 
  END;
  
  /

  ALTER TRIGGER INSERT_ORD ENABLE;
  
/*
 *****************
 * ITEM table    * 
 *****************
*/ 
  CREATE TABLE ITEM 
   (	
    ORDID             NUMBER(5,0), 
    ITEMID            NUMBER(4,0), 
    PRODID            NUMBER(6,0), 
    ACTUALPRICE       NUMBER(8,2), 
    QTY               NUMBER(8,0), 
    ITEMTOT           NUMBER(8,2)
   ) ;

  CREATE UNIQUE INDEX ITEM_PK ON ITEM (ORDID, ITEMID) ;
  
  ALTER TABLE ITEM ADD CONSTRAINT ITEM_PK PRIMARY KEY (ORDID, ITEMID) ENABLE;
  ALTER TABLE ITEM MODIFY (ITEMID NOT NULL ENABLE);
  ALTER TABLE ITEM MODIFY (ORDID NOT NULL ENABLE);
  ALTER TABLE ITEM ADD CONSTRAINT ITEM_ORDID_FK FOREIGN KEY (ORDID) REFERENCES ORD (ORDID) ENABLE;
  ALTER TABLE ITEM ADD CONSTRAINT ITEM_PRODID_FK FOREIGN KEY (PRODID) REFERENCES PRODUCT (PRODID) ENABLE;
  
/*
 *****************
 * PRICE table   *
 *****************
*/ 
  CREATE TABLE PRICE 
   (	
    PRODID            NUMBER(6,0), 
    STDPRICE          NUMBER(8,2), 
    MINPRICE          NUMBER(8,2), 
    STARTDATE         DATE, 
    ENDDATE           DATE
   ) ;

  CREATE UNIQUE INDEX PRICE_PK ON PRICE (PRODID, STARTDATE);
  
  ALTER TABLE PRICE ADD CONSTRAINT PRICE_PK PRIMARY KEY (PRODID, STARTDATE) ENABLE;
  ALTER TABLE PRICE MODIFY (STARTDATE NOT NULL ENABLE);
  ALTER TABLE PRICE MODIFY (PRODID NOT NULL ENABLE);
  ALTER TABLE PRICE ADD CONSTRAINT PRICE_PRODID_FK FOREIGN KEY (PRODID) REFERENCES PRODUCT (PRODID) ENABLE;

/*
 ********************
 * SALGRADE table   *
 ********************
*/ 
  CREATE TABLE SALGRADE 
   (	
    GRADE             NUMBER, 
    LOSAL             NUMBER, 
    HISAL             NUMBER
   ) ;



/*************************************************************************************
**************************************************************************************
**                                                                                  **
** The following database objects were developed as extensions of the Oracle demo   **
**                                                                                  **
**************************************************************************************
**************************************************************************************/

/*
 *******************
 * COUNTRY table   *
 *******************
*/ 
  CREATE TABLE COUNTRY
    ( COUNTRY_ID      VARCHAR2(2)
          CONSTRAINT COUNTRY_ID_NN_DEMO NOT NULL,
      COUNTRY_NAME    VARCHAR2(60)
     );

  CREATE UNIQUE INDEX COUNTRY_IDX ON COUNTRY (COUNTRY_ID);
  ALTER TABLE COUNTRY ADD CONSTRAINT COUNTRY_PK PRIMARY KEY (COUNTRY_ID);

/*
 ***************************
 * COUNTRY_HOLIDAY table   *
 ***************************
*/ 
  CREATE TABLE COUNTRY_HOLIDAY
    ( COUNTRY_ID      VARCHAR2(2),
      YEAR_NO         NUMBER(4),
      HOLIDAY_DATE    DATE
    );
  
  CREATE UNIQUE INDEX COUNTRY_HOLIDAY_IDX ON COUNTRY_HOLIDAY (COUNTRY_ID, YEAR_NO, HOLIDAY_DATE);
  ALTER TABLE COUNTRY_HOLIDAY ADD CONSTRAINT COUNTRY_HOLIDAY_PK PRIMARY KEY (COUNTRY_ID, YEAR_NO, HOLIDAY_DATE);
  ALTER TABLE COUNTRY_HOLIDAY ADD CONSTRAINT COUNTRY_HOLIDAY_COUNTRY_FK FOREIGN KEY (COUNTRY_ID) REFERENCES COUNTRY (COUNTRY_ID) ENABLE;
  ALTER TABLE COUNTRY_HOLIDAY MODIFY (COUNTRY_ID NOT NULL ENABLE);
  ALTER TABLE COUNTRY_HOLIDAY MODIFY (YEAR_NO NOT NULL ENABLE);
  ALTER TABLE COUNTRY_HOLIDAY MODIFY (HOLIDAY_DATE NOT NULL ENABLE);

/*
 *********************
 * IMPORTCSV table   *
 *********************
*/ 
  CREATE TABLE IMPORTCSV
   (	
    RECID             NUMBER(28,0) GENERATED ALWAYS AS IDENTITY, 
    FILEID            NUMBER(28,0), 
    FILENAME          VARCHAR2(255),
    CSV_REC           VARCHAR2(4000),
    KEY_VALUE         VARCHAR2(30)
   ) ;

  CREATE UNIQUE INDEX IMPORTCSV_IDX ON IMPORTCSV (RECID) ;
  ALTER TABLE IMPORTCSV ADD CONSTRAINT IMPORTCSV_PK PRIMARY KEY (RECID) ENABLE;
  

/*
 ***********************
 * IMPORTERROR table   *
 ***********************
*/ 
  CREATE TABLE IMPORTERROR
   (	
    RECID             NUMBER(28,0) GENERATED ALWAYS AS IDENTITY, 
    FILENAME          VARCHAR2(255),
    ERROR_DATA        VARCHAR2(4000),
    ERROR_MESSAGE     VARCHAR2(1000),
    ERROR_TIME        TIMESTAMP,
    USER_NAME         VARCHAR2(128),
    KEY_VALUE         VARCHAR2(30),
    IMPORT_SQLERRM    VARCHAR2(1000)
   ) ;

  CREATE UNIQUE INDEX IMPORTERROR_IDX ON IMPORTERROR (RECID) ;
  ALTER TABLE IMPORTERROR ADD CONSTRAINT IMPORTERROR_PK PRIMARY KEY (RECID) ENABLE;

  
/*
 *****************
 * DEMO table    *
 *****************
*/ 
  CREATE TABLE DEMO
   (
    ENTRY_DATE        DATE,
    MEMORANDUM        VARCHAR2(4000)
   ) ;


/*
 ****************************************************************
 *  APPSEVERITY table                                           *
 *  Used to hold valid severity codes and descriptions for the  *
 *  APPLOG.SEVERITY column                                      *
 ****************************************************************
*/

  CREATE TABLE APPSEVERITY
   (
    SEVERITY          VARCHAR2(1),
    SEVERITY_DESC     VARCHAR2(30)
   ) ;
   
  CREATE UNIQUE INDEX APPSEVERITY_IDX ON APPSEVERITY (SEVERITY) ;
  ALTER TABLE APPSEVERITY ADD CONSTRAINT APPSEVERITY_PK PRIMARY KEY (SEVERITY) ENABLE;
  

/*
 ******************
 * APPLOG table   * 
 ******************
*/ 
  CREATE TABLE APPLOG
   (
    RECID             NUMBER GENERATED ALWAYS AS IDENTITY,
    MESSAGE           VARCHAR2(4000),
    LOGGED_AT         TIMESTAMP,
    USER_NAME         VARCHAR2(128),
    APPLOG_SQLERRM    VARCHAR2(1000),
    PROGRAM_NAME      VARCHAR2(100),
    SEVERITY          VARCHAR2(1)
   ) ;
 
  CREATE UNIQUE INDEX APPLOG_IDX ON APPLOG (RECID) ;
  ALTER TABLE APPLOG ADD CONSTRAINT APPLOG_PK PRIMARY KEY (RECID) ENABLE;
  ALTER TABLE APPLOG ADD CONSTRAINT APPLOG_APPSEVERITY_FK FOREIGN KEY (SEVERITY) REFERENCES APPSEVERITY (SEVERITY) ENABLE;
  

  
/*
** Create Views
*/

/*
 ***************
 * SALES VIEW  *
 ***************
*/
  CREATE OR REPLACE FORCE VIEW SALES (repid, custid, custname, prodid, prodname, amount) AS 
    SELECT repid, ord.custid, customer.NAME custname, product.prodid,
           descrip prodname, SUM(itemtot) amount
    FROM ord, item, customer, product
    WHERE ord.ordid = item.ordid
      AND ord.custid = customer.custid
      AND item.prodid = product.prodid
    GROUP BY repid, ord.custid, NAME, product.prodid, descrip;

/*
 **************************************
 * Create Public synonyms for Tables  *
 **************************************
*/
  CREATE OR REPLACE PUBLIC SYNONYM applog          FOR &v_app_owner\.applog;
  CREATE OR REPLACE PUBLIC SYNONYM appseverity     FOR &v_app_owner\.appseverity;
  CREATE OR REPLACE PUBLIC SYNONYM bonus           FOR &v_app_owner\.bonus;
  CREATE OR REPLACE PUBLIC SYNONYM country         FOR &v_app_owner\.country;
  CREATE OR REPLACE PUBLIC SYNONYM country_holiday FOR &v_app_owner\.country_holiday;
  CREATE OR REPLACE PUBLIC SYNONYM customer        FOR &v_app_owner\.customer;
  CREATE OR REPLACE PUBLIC SYNONYM demo            FOR &v_app_owner\.demo;
  CREATE OR REPLACE PUBLIC SYNONYM dept            FOR &v_app_owner\.dept;
  CREATE OR REPLACE PUBLIC SYNONYM dummy           FOR &v_app_owner\.dummy;
  CREATE OR REPLACE PUBLIC SYNONYM emp             FOR &v_app_owner\.emp;
  CREATE OR REPLACE PUBLIC SYNONYM importcsv       FOR &v_app_owner\.importcsv;
  CREATE OR REPLACE PUBLIC SYNONYM importerror     FOR &v_app_owner\.importerror;
  CREATE OR REPLACE PUBLIC SYNONYM item            FOR &v_app_owner\.item;
  CREATE OR REPLACE PUBLIC SYNONYM ord             FOR &v_app_owner\.ord;
  CREATE OR REPLACE PUBLIC SYNONYM price           FOR &v_app_owner\.price;
  CREATE OR REPLACE PUBLIC SYNONYM product         FOR &v_app_owner\.product;
  CREATE OR REPLACE PUBLIC SYNONYM salgrade        FOR &v_app_owner\.salgrade;

/*
 **************************************
 * Create Public synonyms for Views   *
 **************************************
*/
  CREATE OR REPLACE PUBLIC SYNONYM sales FOR v_app_owner\.sales;

/*
 ****************************************************
 * Grant connection user access to the application  *
 * owner's tables.                                  *
 ****************************************************
*/
  GRANT DELETE, INSERT, SELECT, UPDATE ON applog           TO &v_connect_user;
  GRANT DELETE, INSERT, SELECT, UPDATE ON appseverity      TO &v_connect_user;
  GRANT DELETE, INSERT, SELECT, UPDATE ON bonus            TO &v_connect_user;
  GRANT DELETE, INSERT, SELECT, UPDATE ON appsdemo.country TO &v_connect_user;
  GRANT DELETE, INSERT, SELECT, UPDATE ON country_holiday  TO &v_connect_user;
  GRANT DELETE, INSERT, SELECT, UPDATE ON customer         TO &v_connect_user;
  GRANT DELETE, INSERT, SELECT, UPDATE ON demo             TO &v_connect_user;
  GRANT DELETE, INSERT, SELECT, UPDATE ON dept             TO &v_connect_user;
  GRANT DELETE, INSERT, SELECT, UPDATE ON dummy            TO &v_connect_user;
  GRANT DELETE, INSERT, SELECT, UPDATE ON emp              TO &v_connect_user;
  GRANT DELETE, INSERT, SELECT, UPDATE ON importcsv        TO &v_connect_user;
  GRANT DELETE, INSERT, SELECT, UPDATE ON importerror      TO &v_connect_user;
  GRANT DELETE, INSERT, SELECT, UPDATE ON item             TO &v_connect_user;
  GRANT DELETE, INSERT, SELECT, UPDATE ON ord              TO &v_connect_user;
  GRANT DELETE, INSERT, SELECT, UPDATE ON price            TO &v_connect_user;
  GRANT DELETE, INSERT, SELECT, UPDATE ON product          TO &v_connect_user;
  GRANT DELETE, INSERT, SELECT, UPDATE ON salgrade         TO &v_connect_user;

/*
 ****************************************************
 * Grant connection user access to the application  *
 * owner's views.                                   *
 ****************************************************
*/
  GRANT SELECT ON sales TO &v_connect_user;

/*
** Finished.
*/
  PROMPT Goodbye!