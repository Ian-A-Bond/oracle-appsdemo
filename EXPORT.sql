CREATE OR REPLACE PACKAGE export AS
  /*
  ** (c) Bond and Pollard Ltd 2022
  ** This software is free to use and modify at your own risk.
  ** 
  ** Module Name   : export
  ** Description   : Export data from database into CSV files
  ** 
  **------------------------------------------------------------------------
  ** Modification History
  **  
  ** Date            Name                 Description
  **------------------------------------------------------------------------
  ** 13/07/2022      Ian Bond           Program created
  **   
  */
  
 
  /*
  ** Global constants
  */
  gc_import_directory      CONSTANT plsql_constants.filenamelength_t    := plsql_constants.import_directory;
  gc_import_error_dir      CONSTANT plsql_constants.filenamelength_t    := plsql_constants.import_error_dir;
  gc_import_processed_dir  CONSTANT plsql_constants.filenamelength_t    := plsql_constants.import_processed_dir;
  gc_export_directory      CONSTANT plsql_constants.filenamelength_t    := plsql_constants.export_directory;
  gc_delim                 CONSTANT VARCHAR2(1)                         := ',';
  gc_quote                 CONSTANT VARCHAR2(1)                         := '"';
  gc_error                 CONSTANT plsql_constants.severity_error%TYPE := plsql_constants.severity_error;
  gc_info                  CONSTANT plsql_constants.severity_info%TYPE  := plsql_constants.severity_info;
  gc_warn                  CONSTANT plsql_constants.severity_warn%TYPE  := plsql_constants.severity_warn;

  /*
  ** Global exceptions
  */
  e_file_not_found EXCEPTION;
  PRAGMA EXCEPTION_INIT (e_file_not_found,-20000);


  /*
  ** Public functions and procedures
  */

  /*
  ** demo - export demo data to a CSV file
  **
  **
  ** IN
  ** RETURN
  **   BOOLEAN   TRUE if data exported OK, FALSE if failed
  ** EXCEPTIONS
  **   <exception_name1>      - <brief description>
  */
  FUNCTION demo RETURN BOOLEAN;

  /*
  ** orders - export order data to a CSV file
  **
  **
  ** IN
  ** RETURN
  **   BOOLEAN   TRUE if data exported OK, FALSE if failed
  ** EXCEPTIONS
  **   <exception_name1>      - <brief description>
  */
  FUNCTION orders RETURN BOOLEAN;

END export;
/


CREATE OR REPLACE PACKAGE BODY export AS
  /*
  ** (c) Bond and Pollard Ltd 2022
  ** This software is free to use and modify at your own risk.
  ** 
  ** Module Name   : export
  ** Description   : Export data from database into CSV files
  ** 
  **------------------------------------------------------------------------
  ** Modification History
  **  
  ** Date            Name                 Description
  **------------------------------------------------------------------------
  ** 13/07/2022      Ian Bond           Program created
  **   
  */


  /*
  ** Private functions and procedures
  */


  /*
  ** Public functions and procedures
  */


  FUNCTION demo
    RETURN BOOLEAN 
  IS
    --
    CURSOR demo_cur IS
      SELECT to_char(D.entry_date,'DD/MM/YYYY') entry_date,
             D.memorandum
      FROM   demo D;
    --
    rec_demo demo_cur%ROWTYPE;
    l_file_id utl_file.file_type;
    l_filename plsql_constants.filenamelength_t;
    l_rec plsql_constants.maxvarchar2_t;
  BEGIN
    -- Create the CSV file named: demo_YYYMMDD.csv
    l_filename := 'demo_'||to_char(SYSDATE,'YYMMDD')||'.csv';
    l_file_id := utl_file.fopen(gc_export_directory, l_filename, 'W');

    -- Write CSV Header
    l_rec := '"Entry Date","Memorandum"';
    utl_file.put_line(l_file_id,l_rec);

    -- Write data to CSV file
    -- Separate each field with a delimiter
    -- Enclose strings in double quotes
    --
    OPEN demo_cur;
    LOOP
      FETCH demo_cur INTO rec_demo;
      EXIT WHEN demo_cur%NOTFOUND;
      l_rec :=                            rec_demo.entry_date
               || gc_delim || gc_quote || rec_demo.memorandum     || gc_quote 
               ;
      utl_file.put_line(l_file_id,l_rec);
    END LOOP;
    CLOSE demo_cur;
    utl_file.fclose(l_file_id);
    RETURN TRUE;
  EXCEPTION
    WHEN OTHERS THEN
      util_admin.log_message('Unexpected Error',SQLERRM,'EXPORT.DEMO','B',gc_error);
      RETURN FALSE;
  END demo;

  FUNCTION orders 
    RETURN BOOLEAN 
  IS
    --
    CURSOR ord_cur IS
      SELECT O.ordid,
             NVL(O.ordref,'No ref') ordref,
             to_char(O.orderdate,'DD/MM/YYYY') orderdate,
             to_char(O.shipdate,'DD/MM/YYYY') shipdate,
             O.commplan,
             ltrim(to_char(O.total,'99999999.99')) ordtot,
             O.custid,
             C.name,
             E.ename,
             I.itemid,
             I.prodid,
             util_string.get_field(P.descrip,1,',') descrip,
             ltrim(to_char(I.actualprice,'9999999.99')) actprice,
             I.qty,
             ltrim(to_char(I.itemtot,'99999999.99')) itemtot 
      FROM   ord O,
             customer C,
             emp E,
             item I,
             product P
      WHERE  C.custid = O.custid
      AND    E.empno = C.repid
      AND    I.ordid (+) = O.ordid
      AND    P.prodid (+) = I.prodid
      ORDER BY O.ordid, I.itemid;
    --
    rec_ord ord_cur%ROWTYPE;
    l_file_id utl_file.file_type;
    l_filename plsql_constants.filenamelength_t;
    l_rec plsql_constants.maxvarchar2_t;
  BEGIN
    -- Create the CSV file named: orders_YYYMMDD.csv
    l_filename := 'orders_'||to_char(SYSDATE,'YYMMDD')||'.csv';
    l_file_id := utl_file.fopen(gc_export_directory, l_filename, 'W');

    -- Write CSV Header
    l_rec := '"Order ID","Order Ref","Order Date","Ship Date","Comm Plan","Total","Customer ID","Customer Name","Sales Rep","Item","Product ID","Description","Price","Qty","Item Total"';
    utl_file.put_line(l_file_id,l_rec);

    -- Write data to CSV file
    -- Separate each field with a delimiter
    -- Enclose strings in double quotes
    --
    OPEN ord_cur;
    LOOP
      FETCH ord_cur INTO rec_ord;
      EXIT WHEN ord_cur%NOTFOUND;
      l_rec :=                            rec_ord.ordid 
               || gc_delim || gc_quote || rec_ord.ordref      || gc_quote 
               || gc_delim ||             rec_ord.orderdate         
               || gc_delim ||             rec_ord.shipdate          
               || gc_delim || gc_quote || rec_ord.commplan    || gc_quote         
               || gc_delim ||             rec_ord.ordtot  
               || gc_delim ||             rec_ord.custid            
               || gc_delim || gc_quote || rec_ord.name        || gc_quote          
               || gc_delim || gc_quote || rec_ord.ename       || gc_quote       
               || gc_delim ||             rec_ord.itemid            
               || gc_delim ||             rec_ord.prodid            
               || gc_delim ||             rec_ord.descrip    
               || gc_delim ||             rec_ord.actprice 
               || gc_delim ||             rec_ord.qty               
               || gc_delim ||             rec_ord.itemtot
               ;
      utl_file.put_line(l_file_id,l_rec);
    END LOOP;
    CLOSE ord_cur;
    utl_file.fclose(l_file_id);
    RETURN TRUE;
  EXCEPTION
    WHEN OTHERS THEN
      util_admin.log_message('Unexpected Error',SQLERRM,'EXPORT.ORDERS','B',gc_error);
      RETURN FALSE;
  END orders;

END export;
/
