CREATE OR REPLACE PACKAGE import AS
  /*
  ** (c) Bond & Pollard Ltd 2022
  ** This software is free to use and modify at your own risk.
  ** 
  ** Module Name   : import
  ** Description   : Import CSV data
  ** 
  **------------------------------------------------------------------------
  ** Modification History
  **  
  ** Date            Name                 Description
  **------------------------------------------------------------------------
  ** 24/06/2022      Ian Bond             Program created
  **   
  */
  

  /*
  **Global constants
  */
  gc_import_directory      CONSTANT plsql_constants.filenamelength_t    := plsql_constants.import_directory;
  gc_import_error_dir      CONSTANT plsql_constants.filenamelength_t    := plsql_constants.import_error_dir;
  gc_import_processed_dir  CONSTANT plsql_constants.filenamelength_t    := plsql_constants.import_processed_dir;
  gc_export_directory      CONSTANT plsql_constants.filenamelength_t    := plsql_constants.export_directory;
  gc_error                 CONSTANT plsql_constants.severity_error%TYPE := plsql_constants.severity_error;
  gc_info                  CONSTANT plsql_constants.severity_info%TYPE  := plsql_constants.severity_info;
  gc_warn                  CONSTANT plsql_constants.severity_warn%TYPE  := plsql_constants.severity_warn;

  /*
  ** Global exceptions
  */
  e_file_not_found EXCEPTION;
  PRAGMA EXCEPTION_INIT (e_file_not_found,-20000);

  e_invalid_data EXCEPTION;
  PRAGMA EXCEPTION_INIT (e_invalid_data,-20001);

  e_duplicate_ordref EXCEPTION;
  PRAGMA EXCEPTION_INIT (e_duplicate_ordref,-20002);

  e_ordid_value_error EXCEPTION;
  PRAGMA EXCEPTION_INIT (e_ordid_value_error,-20003);

 
  /*
  ** Public functions and procedures
  */
  
  /*
  ** demo_imp - Import data from a CSV file into the Demo table.
  **
  **
  ** The csv file containing the data must be in the import directory DATA_IN.
  **
  ** This function:
  **  1. Calls the package function UTIL_FILE.LOAD_CSV to load data from a CSV file into the 
  **     IMPORTCSV staging table. 
  **  2. The load_csv function returns an integer FILEID, which identifies the group of records loaded
  **     from the CSV file into the staging table.
  **  2.1. If the file was not found, report error and stop processing.
  **  3. Validate the data in IMPORTCSV matching FILEID.
  **  3.1. Set field KEY_VALUE in IMPORTCSV to a unique value, that identifies the data, in this 
  **       case it  will be the first field in the CSV file, ENTRY_DATE.
  **  3.2. Record all validation errors found in the IMPORTERROR table, including the KEY_VALUE field.
  **  4. If data fails validation:
  **  4.1. Delete the data from the IMPORTCSV staging table.
  **  4.2. Move the CSV file to the error directory.
  **  4.3. Stop processing, exit with an error status.
  **  5. If data passes validation:
  **  5.1. Insert data into the Demo table.
  **  5.2. Delete old error messages from the IMPORTERROR table for the data successfully imported,
  **       using the KEY_VALUE column of IMPORTCSV.
  **  5.3. Delete the data from the IMPORTCSV staging table.
  **  5.4. Move the CSV to the processed directory.
  **  5.5. Exit with a success status.
  **
  **
  ** IN
  **   p_filename      - Name of file being imported
  ** RETURN
  **   BOOLEAN   Returns TRUE if all data imported successfully, otherwise FALSE
  ** EXCEPTIONS
  **   <exception_name1>      - <brief description>
  */
  FUNCTION demo_imp (
    p_filename IN VARCHAR2
  ) RETURN BOOLEAN;

   
  /*
  ** ord_imp - Import order data from a CSV file into the ORD and ITEM tables
  **
  ** The csv file containing the order data must be in the import directory DATA_IN.
  **
  ** This function:
  **  1. Calls the package function UTIL_FILE.LOAD_CSV to load order data from a CSV file into the 
  **     IMPORTCSV staging table. 
  **  2. The load_csv function returns an integer FILEID, which identifies the group of records loaded
  **     from the CSV file into the staging table.
  **  2.1. If the file was not found, report error and stop processing.
  **  3. Validate the data in IMPORTCSV matching FILEID.
  **  3.1. Set field KEY_VALUE in IMPORTCSV to a unique value, that identifies the order, in this 
  **       case it  will be the first field in the CSV file, ORDREF
  **  3.2. Record all validation errors found in the IMPORTERROR table, including the KEY_VALUE field.
  **  4. If data fails validation:
  **  4.1. Delete the data from the IMPORTCSV staging table.
  **  4.2. Move the CSV file to the error directory.
  **  4.3. Stop processing, exit with an error status.
  **  5. If data passes validation:
  **  5.1. Insert data into the ORD and ITEM tables.
  **  5.2. Delete old error messages from the IMPORTERROR table for the orders successfully imported,
  **       using the KEY_VALUE column of IMPORTCSV.
  **  5.3. Delete the data from the IMPORTCSV staging table.
  **  5.4. Move the CSV to the processed directory.
  **  5.5. Exit with a success status.
  **
  ** Input data: IMPORTCSV 
  **  4. The IMPORTCSV table may contain data for 1 or more orders,each with 1 or more
  **     associated items.
  **  5. The ORD header data is duplicated for each item
  **  6. Each order in the import file is uniquely identified by the first field
  **     "Order Ref". 
  **
  ** ORD Table 
  **  7. The trigger INSERT_ORD uses sequence ORDID_SEQ to generate a value for ORDID for each new order
  **  8. CUSTID must reference a row on the CUSTOMER table 
  **  9. TOTAL must be calculated as a sum of ITEM.ITEM_TOT
  ** 10. Store the original order reference from the CSV file in the column ORDREF
  **
  ** ITEM table
  **  11. The primary key is ORDID from ORD plus ITEMID
  **  12. Generate the ITEMID as a sequential number starting at 1 for each order
  **  13. PRODID must reference a row on the PRODUCT table
  **  14. Lookup the current price on the PRICE table. Find the correct value of STDPRICE for the product,
  **      it must have a start date on or after the current date, and an end date after today's date.
  **  15. ITEMTOT is calculated as STDPRICE * QTY. Note that this contravenes 3rd normal form.
  **
  **
  ** IN
  **   p_filename      - Name of file being imported
  ** RETURN
  **   BOOLEAN   Returns TRUE if all data imported successfully, otherwise FALSE
  ** EXCEPTIONS
  **   <exception_name1>      - <brief description>
  */
  FUNCTION ord_imp (
    p_filename IN VARCHAR2
  ) RETURN BOOLEAN;

END import;
/


CREATE OR REPLACE PACKAGE BODY import AS
  /*
  ** (c) Bond & Pollard Ltd 2022
  ** This software is free to use and modify at your own risk.
  ** 
  ** Module Name   : import
  ** Description   : Import CSV data
  ** 
  **------------------------------------------------------------------------
  ** Modification History
  **  
  ** Date            Name                 Description
  **------------------------------------------------------------------------
  ** 24/06/2022      Ian Bond             Program created
  **   
  */


  /*
  ** Private functions and procedures
  */
  
   
  /*
  ** delete_error - Delete old error messages from the IMPORTERROR table
  **
  ** Delete old error messages from the IMPORTERROR table
  ** where the KEY_VALUE of the successfully imported data on IMPORTCSV
  ** matches the KEY_VALUE on IMPORTERROR
  **
  ** IN
  **   p_fileid         - Identifies CSV file being imported
  ** EXCEPTIONS
  **   <exception_name1>      - <brief description>
  */
  PROCEDURE delete_error (
      p_fileid       IN importcsv.fileid%TYPE
  )
  IS
    -- Cursors
    --
    CURSOR csv_cur (p_fileid importcsv.fileid%TYPE) IS
      SELECT recid,
             fileid,
             filename,
             csv_rec,
             key_value
      FROM   importcsv
      WHERE  fileid = p_fileid;
  BEGIN
    FOR r_csv IN csv_cur(p_fileid) LOOP
      DELETE FROM IMPORTERROR
      WHERE KEY_VALUE = r_csv.key_value;
    END LOOP;
  EXCEPTION
    WHEN OTHERS THEN
      util_admin.log_message('Error deleting from IMPORTCSV FileID is ' || to_char(p_fileid),SQLERRM,'IMPORT.DELETE_ERROR','B',gc_error);
  END delete_error;

  /*
  ** import_error - record data import validation errors
  **
  ** Write error messages to the IMPORTERROR table.
  ** This table is used to record all data import validation 
  ** errors.
  ** KEY_VALUE is used to delete old error messages when the 
  ** associated data has been successfully imported.
  **
  ** IN
  **   p_filename    - Name of file being imported
  **   p_rec         - Data that failed validation
  **   p_message     - Validation error message
  **   p_key_value   - Identifies the data being imported e.g. ORDREF for orders
  **   p_sqlerrm     - SQLERRM error message  
  ** OUT
  **   <p2>         - <describe use of p2>
  ** EXCEPTIONS
  **   <exception_name1>      - <brief description>
  */
  PROCEDURE import_error (
      p_filename      IN VARCHAR2, 
      p_rec           IN VARCHAR2, 
      p_message       IN VARCHAR2,
      p_key_value     IN VARCHAR2 DEFAULT NULL,
      p_sqlerrm       IN VARCHAR2 DEFAULT NULL
  )
  IS
    l_username importerror.user_name%TYPE;
  BEGIN
   l_username := NVL(util_admin.get_user,'UNKNOWN');
   INSERT INTO importerror ( 
       filename, 
       error_data, 
       error_message, 
       error_time,
       user_name,
       key_value,
       import_sqlerrm
     ) 
     VALUES (
       p_filename, 
       p_rec, 
       p_message,
       LOCALTIMESTAMP,
       l_username,
       p_key_value,
       p_sqlerrm
     );
  EXCEPTION
    WHEN OTHERS THEN
      util_admin.log_message('Error inserting row into IMPORTERROR',SQLERRM,'IMPORT.IMPORT_ERROR','B',gc_error);
  END import_error;


  /*
  ** demo_valid - validate demo data 
  **
  ** Validate demo CSV data in staging table
  ** Record all errors found in IMPORTERROR table.
  **
  ** IN
  **   p_fileid      - Identifies file being imported
  ** RETURN
  **   BOOLEAN   Returns TRUE if all validated OK, otherwise FALSE
  ** EXCEPTIONS
  **   <exception_name1>      - <brief description>
  */
  FUNCTION demo_valid (
    p_fileid IN importcsv.fileid%TYPE
  ) 
  RETURN BOOLEAN 
  IS
    -- Cursors
    --
    CURSOR csv_cur (p_fileid importcsv.fileid%TYPE) IS
      SELECT recid,
             fileid,
             filename,
             csv_rec,
             key_value
      FROM   importcsv
      WHERE  fileid = p_fileid
      AND    UPPER(substr(csv_rec,1,12)) <> '"ENTRY DATE"' -- Ignore header
      FOR UPDATE;
    --
    -- Local Constants
    --
    lc_delim CONSTANT VARCHAR2(1) := ',';
    --
    -- Local Variables
    --
    l_current_csv     importcsv.csv_rec%TYPE;
    l_filename        importcsv.filename%TYPE;
    l_key_value       importcsv.key_value%TYPE;

    l_valid BOOLEAN;
    -- CSV field values
    l_f_entry_date plsql_constants.csvfieldlength_t;
    l_f_memorandum plsql_constants.csvfieldlength_t;

    -- Validate field values
    l_entry_date  demo.entry_date%TYPE;
    l_memorandum  demo.memorandum%TYPE;
  BEGIN
    l_valid := TRUE;
    FOR r_csv IN csv_cur(p_fileid) LOOP

      l_current_csv := r_csv.csv_rec; -- Current csv_rec for error reporting
      l_filename := r_csv.filename;

      -- Extract fields from CSV record
      l_f_entry_date := util_string.get_field(r_csv.csv_rec,1,lc_delim);
      l_f_memorandum := util_string.get_field(r_csv.csv_rec,2,lc_delim);

      -- Update the KEY_VALUE field of IMPORTCSV with the value of ENTRY_DATE. 
      -- The KEY_VALUE field will also be recorded on the IMPORTERROR table,
      -- so that it can be used to find and delete old error messages when data with the matching value are successfully imported.
      -- Note that the error messages for duplicate or invalid ENTRY_DATE will remain in the IMPORTERROR table,
      -- as there cannot be a successful import. These error messages will need to be deleted manually.
      BEGIN
        l_key_value := l_f_entry_date;

        UPDATE importcsv
          SET KEY_VALUE = l_key_value
          WHERE recid = r_csv.recid;
      EXCEPTION
        WHEN VALUE_ERROR THEN
          l_valid := FALSE;
          import_error (r_csv.filename, r_csv.csv_rec, 'IMPORTCSV.KEY_VALUE '||l_f_entry_date||' too long.',l_f_entry_date);
        WHEN OTHERS THEN
          l_valid := FALSE;
          import_error (r_csv.filename, r_csv.csv_rec, 'IMPORTCSV.KEY_VALUE '||l_f_entry_date||' invalid',l_f_entry_date);
      END;

      -- Validate fields
      -- If an error is found, record it on IMPORTERROR, flag an error
      -- and continue checking.

      -- ENTRY_DATE validation
      BEGIN
        l_entry_date := to_date(l_f_entry_date,'DD/MM/YYYY');
      EXCEPTION
        WHEN OTHERS THEN
          l_valid := FALSE;
          import_error (r_csv.filename, r_csv.csv_rec, 'Entry Date '||l_f_entry_date||' invalid, format must be DD/MM/YYYY',l_key_value);
      END;


      -- MEMORANDUM validation
      BEGIN
        l_memorandum := l_f_memorandum;
      EXCEPTION
        WHEN VALUE_ERROR THEN
          l_valid := FALSE;
          import_error (r_csv.filename, r_csv.csv_rec, 'Memorandum '||l_f_memorandum||' invalid. Maximum length exceeded.',l_key_value);
        WHEN OTHERS THEN
          l_valid := FALSE;
          import_error (r_csv.filename, r_csv.csv_rec, 'CommPlan '||l_f_memorandum||' invalid',l_key_value);
      END;

    END LOOP;

    RETURN l_valid;
  EXCEPTION
    WHEN OTHERS THEN
      import_error (l_filename, l_current_csv, 'Unexpected error. Validation failed.',l_key_value, SQLERRM);
      util_admin.log_message('Unexpected error importing file ' || l_filename,SQLERRM,'IMPORT.DEMO_VALID','B',gc_error);
      RETURN FALSE;
  END demo_valid;

  /*
  ** ord_valid - validate order data 
  **
  ** Validate order CSV data in staging table
  ** Record all errors found in IMPORTERROR table.
  **
  ** IN
  **   p_fileid      - Identifies file being imported
  ** RETURN
  **   BOOLEAN   Returns TRUE if all validated OK, otherwise FALSE
  ** EXCEPTIONS
  **   <exception_name1>      - <brief description>
  */
  FUNCTION ord_valid (
    p_fileid IN importcsv.fileid%TYPE
  ) 
  RETURN BOOLEAN 
  IS
    -- Cursors
    --
    CURSOR csv_cur (p_fileid importcsv.fileid%TYPE) IS
      SELECT recid,
             fileid,
             filename,
             csv_rec,
             key_value
      FROM   importcsv
      WHERE  fileid = p_fileid
      AND    substr(csv_rec,1,9) <> '"Ord Ref"' -- Ignore header
      FOR UPDATE;
    --
    -- Local Constants
    --
    lc_delim CONSTANT VARCHAR2(1) := ',';
    --
    -- Local Variables
    --
    l_current_csv     importcsv.csv_rec%TYPE;
    l_filename        importcsv.filename%TYPE;
    l_existing_ordref ord.ordref%TYPE;
    l_key_value       importcsv.key_value%TYPE; -- Identify errors with order

    l_valid BOOLEAN;
    -- CSV field values
    l_f_ordref    plsql_constants.csvfieldlength_t;
    l_f_orderdate plsql_constants.csvfieldlength_t;
    l_f_commplan  plsql_constants.csvfieldlength_t;
    l_f_custid    plsql_constants.csvfieldlength_t;
    l_f_shipdate  plsql_constants.csvfieldlength_t;
    l_f_prodid    plsql_constants.csvfieldlength_t;
    l_f_qty       plsql_constants.csvfieldlength_t;
    -- Validate field values
    l_ordref     ord.ordref%TYPE;
    l_orderdate  ord.orderdate%TYPE;
    l_commplan   ord.commplan%TYPE;
    l_custid     customer.custid%TYPE;
    l_shipdate   ord.shipdate%TYPE;
    l_prodid     item.prodid%TYPE;
    l_qty        item.qty%TYPE;
    --
  BEGIN
    l_valid := TRUE;
    FOR r_csv IN csv_cur(p_fileid) LOOP

      l_current_csv := r_csv.csv_rec; -- Current csv_rec for error reporting
      l_filename := r_csv.filename;

      -- Extract ORD header fields from CSV record
      l_f_ordref     := util_string.get_field(r_csv.csv_rec,1,lc_delim);
      l_f_orderdate  := util_string.get_field(r_csv.csv_rec,2,lc_delim);
      l_f_commplan   := util_string.get_field(r_csv.csv_rec,3,lc_delim);
      l_f_custid     := util_string.get_field(r_csv.csv_rec,4,lc_delim);
      l_f_shipdate   := util_string.get_field(r_csv.csv_rec,5,lc_delim);

      -- Extract ITEM fields from CSV record
      l_f_prodid     := util_string.get_field(r_csv.csv_rec,6,lc_delim);
      l_f_qty        := util_string.get_field(r_csv.csv_rec,7,lc_delim);


      -- Update the KEY_VALUE field of IMPORTCSV with the value of ORDREF. 
      -- The KEY_VALUE field will also be recorded on the IMPORTERROR table,
      -- so that it can be used to find and delete old error messages when orders with the matching ORDREF are successfully imported.
      -- Note that the error messages for duplicate ORDREF or invalid ORDREF will remain in the IMPORTERROR table,
      -- as there cannot be a successful import. These error messages will need to be deleted manually.
      BEGIN
        l_key_value := l_f_ordref;

        UPDATE importcsv
          SET KEY_VALUE = l_key_value
          WHERE recid = r_csv.recid;
      EXCEPTION
        WHEN VALUE_ERROR THEN
          l_valid := FALSE;
          import_error (r_csv.filename, r_csv.csv_rec, 'IMPORTCSV.KEY_VALUE '||l_f_ordref||' too long.',l_f_ordref);
        WHEN OTHERS THEN
          l_valid := FALSE;
          import_error (r_csv.filename, r_csv.csv_rec, 'IMPORTCSV.KEY_VALUE '||l_f_ordref||' invalid',l_f_ordref);
      END;

      -- Validate fields
      -- If an error is found, record it on IMPORTERROR, flag an error
      -- and continue checking.

      -- ORDREF validation
      BEGIN
        l_ordref := l_f_ordref;
      EXCEPTION
        WHEN VALUE_ERROR THEN
          l_valid := FALSE;
          import_error (r_csv.filename, r_csv.csv_rec, 'OrdRef '||l_f_ordref||' invalid. Must not be longer than 10 characters',l_key_value);
        WHEN OTHERS THEN
          l_valid := FALSE;
          import_error (r_csv.filename, r_csv.csv_rec, 'OrdRef '||l_f_ordref||' invalid',l_key_value);
      END;

      -- ORDREF check that an order with this reference does not already exist.
      -- Use the full CSV ORDREF field value, as if it's too long it will be truncated and give a false duplicate error.
      -- NB: This should be a table constraint on ORD.
      BEGIN
        SELECT DISTINCT(O.ordref) INTO l_existing_ordref FROM ord O WHERE O.ordref = l_f_ordref;
        IF SQL%FOUND THEN
          RAISE e_duplicate_ordref;
        END IF;
      EXCEPTION
        WHEN e_duplicate_ordref THEN
          l_valid := FALSE;
          import_error (r_csv.filename, r_csv.csv_rec, 'OrdRef '||l_f_ordref||' already exists on ORD, duplicate value',l_key_value);
        WHEN NO_DATA_FOUND THEN
          NULL;
        WHEN OTHERS THEN
          l_valid := FALSE;
          import_error (r_csv.filename, r_csv.csv_rec, 'Unexpected error checking OrdRef '||l_f_ordref||' is unique',l_key_value);
      END; 

      -- ORDERDATE validation: Order Date must be a valid date in format DD/MM/YYYY
      BEGIN
        l_orderdate := to_date(l_f_orderdate,'DD/MM/YYYY');
      EXCEPTION
        WHEN OTHERS THEN
          l_valid := FALSE;
          import_error (r_csv.filename, r_csv.csv_rec, 'Order Date '||l_f_orderdate||' invalid, format must be DD/MM/YYYY',l_key_value);
      END;

      -- COMMPLAN validation (single char)
      BEGIN
        l_commplan := l_f_commplan;
      EXCEPTION
        WHEN VALUE_ERROR THEN
          l_valid := FALSE;
          import_error (r_csv.filename, r_csv.csv_rec, 'CommPlan '||l_f_commplan||' invalid. Must be a single character',l_key_value);
        WHEN OTHERS THEN
          l_valid := FALSE;
          import_error (r_csv.filename, r_csv.csv_rec, 'CommPlan '||l_f_commplan||' invalid',l_key_value);
      END;

      -- CUSTID validation: Check customer exists
      BEGIN
         SELECT C.custid INTO l_custid FROM customer C WHERE C.custid = l_f_custid;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          l_valid := FALSE;
          import_error (r_csv.filename, r_csv.csv_rec, 'Customer ID '||l_f_custid||' not found on Customer',l_key_value);
        WHEN OTHERS THEN
          l_valid := FALSE;
          import_error (r_csv.filename, r_csv.csv_rec, 'Customer ID '||l_f_custid||' invalid',l_key_value);
      END;

      -- SHIPDATE validation: Ship Date must be a valid date in format DD/MM/YYYY
      BEGIN
        l_shipdate := to_date(l_f_shipdate,'DD/MM/YYYY');
      EXCEPTION
        WHEN OTHERS THEN
          l_valid := FALSE;
          import_error (r_csv.filename, r_csv.csv_rec, 'Ship Date '||l_f_shipdate||' invalid, format must be DD/MM/YYYY',l_key_value);
      END;
      
      -- SHIPDATE validation: Ship Date must be on or after the Order Date
      IF l_shipdate < l_orderdate THEN
        l_valid := FALSE;
        import_error (r_csv.filename, r_csv.csv_rec, 'Ship Date '||l_f_shipdate||
          ' must be on or later than the order date '||to_char(l_orderdate,'DD/MM/YYYY'),l_key_value);
      END IF;
      
      -- PRODID validation: Check product exists
      BEGIN
         SELECT P.prodid INTO l_prodid FROM product P WHERE P.prodid = l_f_prodid;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          l_valid := FALSE;
          import_error (r_csv.filename, r_csv.csv_rec, 'Product ID '||l_f_prodid||' not found on Product',l_key_value);
        WHEN OTHERS THEN
          l_valid := FALSE;
          import_error (r_csv.filename, r_csv.csv_rec, 'Product ID '||l_f_prodid||' invalid',l_key_value);
      END;

      -- QTY validation
      BEGIN
        l_qty := TO_NUMBER(l_f_qty);
      EXCEPTION
        WHEN INVALID_NUMBER THEN
          l_valid := FALSE;
          import_error (r_csv.filename, r_csv.csv_rec, 'Qty '||l_f_qty||' invalid. Must be a number',l_key_value);
        WHEN OTHERS THEN
          l_valid := FALSE;
          import_error (r_csv.filename, r_csv.csv_rec, 'Qty '||l_f_qty||' invalid',l_key_value);
      END;

    END LOOP;
    RETURN l_valid;
  EXCEPTION
    WHEN OTHERS THEN
      import_error (l_filename, l_current_csv, 'Unexpected error. Validation failed.',l_key_value, SQLERRM);
    util_admin.log_message('Unexpected error importing file ' || l_filename,SQLERRM,'IMPORT.ORD_VALID','B',gc_error);
      RETURN FALSE;
  END ord_valid;



  /*
  ** Public functions and procedures
  */


  FUNCTION demo_imp (
    p_filename IN VARCHAR2
  ) 
  RETURN BOOLEAN 
  IS
    --
    CURSOR csv_cur (p_fileid importcsv.fileid%TYPE) IS
      SELECT recid,
             fileid,
             filename,
             csv_rec,
             key_value
      FROM   importcsv
      WHERE  fileid = p_fileid
      AND    UPPER(substr(csv_rec,1,12)) <> '"ENTRY DATE"'; -- Ignore header 
    --
    rec_current_csv importcsv.csv_rec%TYPE; -- Current CSV record value used for error reporting
    --
    lc_delim CONSTANT VARCHAR2(1) := ',';
    --
    -- DEMO table fields
    l_entry_date demo.entry_date%TYPE;
    l_memorandum demo.memorandum%TYPE;
    --
    l_result BOOLEAN := FALSE;
    l_fileid importcsv.fileid%TYPE;
    l_recid importcsv.recid%TYPE;
    l_rec_count NUMBER;
  BEGIN
  
    SAVEPOINT before_load_csv;
    
    -- Load the CSV data into the staging table IMPORTCSV
    l_fileid := util_file.load_csv(p_filename);

    IF l_fileid = -1 THEN
      RAISE e_file_not_found;
    END IF;
    --
    SAVEPOINT csv_data_loaded;

    -- Validate the data in the staging table, recording all errors found. 
    -- If no errors, proceed, otherwise delete IMPORTCSV data
    -- and exit.
    IF NOT demo_valid(l_fileid) THEN
      -- Invalid data found
      -- Delete data from staging table. CSV file will need to be fixed and re-processed.
      -- NB: Cannot ROLLBACK to before_load_csv as you would lose the recorded invalid data messages
      -- in the table importerror.
      l_rec_count := util_file.delete_csv(l_fileid);
      RAISE e_invalid_data;
    END IF;

    SAVEPOINT data_validated;
    
    -- CSV data validated OK. 
    -- Process the CSV data in the staging table
    --

    FOR r_csv IN csv_cur(l_fileid) LOOP

      -- Store the current CSV record for error reporting  
      rec_current_csv := r_csv.csv_rec;

      -- Extract the fields from the CSV record
      l_entry_date  := TO_DATE(
                        util_string.get_field(r_csv.csv_rec,1,lc_delim)
                        ,'DD/MM/YYYY');
      l_memorandum  :=  util_string.get_field(r_csv.csv_rec,2,lc_delim);


      -- Create DEMO row
      INSERT INTO demo (
                         entry_date,
                         memorandum
                       )
                VALUES (
                         l_entry_date,
                         l_memorandum
                       );
    END LOOP;

    -- Tidy up

    -- Delete old error messages with KEY_VALUE matching that of the data successfully imported
    delete_error(l_fileid);

    -- Delete data from staging table. 
    l_rec_count := util_file.delete_csv(l_fileid);

    -- Move CSV file to processed directory
    util_file.rename_file(gc_import_directory,p_filename,gc_import_processed_dir,p_filename);

    -- Import completed without errors
    l_result := TRUE;
    RETURN l_result;
  EXCEPTION
    WHEN E_FILE_NOT_FOUND THEN
      -- CSV file not found, so report the error
      import_error(p_filename, rec_current_csv, 'IMPORT.DEMO_IMP File not found, import failed.',NULL,SQLERRM);
      util_admin.log_message('File not found importing file ' || p_filename,SQLERRM,'IMPORT.DEMO_IMP','B',gc_error);
      RETURN FALSE;
    WHEN E_INVALID_DATA THEN
      -- CSV data failed validation
      -- Log the error but do not rollback because we need to keep the validation error messages inserted into IMPORTERROR
      util_admin.log_message('Invalid data importing file ' || p_filename,SQLERRM,'IMPORT.DEMO_IMP','B',gc_error);
      -- Move CSV file to error directory
      util_file.rename_file(gc_import_directory,p_filename,gc_import_error_dir,p_filename);
      RETURN FALSE;
    WHEN OTHERS THEN
      -- Unexpected error so rollback to before the CSV data was loaded into the staging table
      ROLLBACK TO before_load_csv;
      -- Report the error
      import_error(p_filename, rec_current_csv, 'IMPORT.DEMO_IMP Unexpected error. Import failed.',NULL,SQLERRM);
      util_admin.log_message('Unexpected error importing file ' || p_filename,SQLERRM,'IMPORT.DEMO_IMP','B',gc_error);
      -- Move CSV file to error directory
      util_file.rename_file(gc_import_directory,p_filename,gc_import_error_dir,p_filename);
      RETURN FALSE;
  END demo_imp;


  FUNCTION ord_imp (
    p_filename IN VARCHAR2
  ) 
  RETURN BOOLEAN 
  IS
    --
    CURSOR csv_cur (p_fileid importcsv.fileid%TYPE) IS
      SELECT recid,
             fileid,
             filename,
             csv_rec,
             key_value
      FROM   importcsv
      WHERE  fileid = p_fileid
      AND    substr(csv_rec,1,9) <> '"Ord Ref"'; -- Ignore header 
    --
    /* replaced with call to orderrp.currentprice
    CURSOR price_cur (p_prodid product.prodid%TYPE) IS
      SELECT MAX(stdprice)
      FROM   price
      WHERE  prodid = p_prodid
      AND    startdate <= SYSDATE
      AND    NVL(enddate,SYSDATE+1) >= SYSDATE;
    */
    --
    rec_current_csv importcsv.csv_rec%TYPE; -- Current CSV record value used for error reporting
    --
    lc_delim CONSTANT VARCHAR2(1) := ',';
    --
    -- ORD table fields
    l_ordid item.ordid%TYPE;
    l_ordref ord.ordref%TYPE;
    l_orderdate ord.orderdate%TYPE;
    l_commplan ord.commplan%TYPE;
    l_custid ord.custid%TYPE;
    l_shipdate ord.shipdate%TYPE;
    l_total ord.total%TYPE;
    --
    -- ITEM table fields
    l_itemid item.itemid%TYPE;
    l_prodid item.prodid%TYPE;
    l_actualprice item.actualprice%TYPE;
    l_qty item.qty%TYPE;
    l_itemtot item.itemtot%TYPE;
    --
    l_prev_ordref ord.ordref%TYPE;
    l_result BOOLEAN := FALSE;
    l_fileid importcsv.fileid%TYPE;
    l_recid importcsv.recid%TYPE;
    l_rec_count NUMBER;
    l_next_ordid NUMBER;
  BEGIN
    
    SAVEPOINT before_load_csv;
    
    -- Load the order data into the staging table IMPORTCSV
    l_fileid := util_file.load_csv(p_filename);

    IF l_fileid = -1 THEN
      RAISE e_file_not_found;
    END IF;
    --
    SAVEPOINT csv_data_loaded;

    -- Validate the data in the staging table, recording all errors found. 
    -- If no errors, proceed, otherwise delete IMPORTCSV data
    -- and exit.
    IF NOT ord_valid(l_fileid) THEN
      -- Invalid order data found
      -- Delete data from staging table. CSV file will need to be fixed and re-processed.
      -- NB: Cannot ROLLBACK to before_load_csv as you would lose the recorded invalid data messages
      -- in the table importerror.
      l_rec_count := util_file.delete_csv(l_fileid);
      RAISE e_invalid_data;
    END IF;
    
    SAVEPOINT data_validated;

    -- CSV data validated OK. 
    -- Process the CSV data in the staging table
    --
    l_prev_ordref := ' ';

    FOR r_csv IN csv_cur(l_fileid) LOOP
      
      -- Store the current CSV record for error reporting  
      rec_current_csv := r_csv.csv_rec;
      l_recid := r_csv.recid;

      -- Extract the Order Reference field from the CSV record
      -- ORDREF is used to detect each distinct order 
      l_ordref := util_string.get_field(r_csv.csv_rec,1,lc_delim);

      IF l_ordref <> l_prev_ordref THEN
        -- New order, at change of ORDREF.
       
        -- Generate the next ORDID at the change of ORDREF
        BEGIN
          SELECT ordid_seq.NEXTVAL INTO l_next_ordid FROM dual;
          l_ordid := l_next_ordid;
        EXCEPTION
          WHEN VALUE_ERROR THEN
            RAISE e_ordid_value_error;
        END;
        
        -- Reset total order value
        l_total :=0;

        -- Restart ITEMID numbering from 1
        l_itemid :=1;

        -- Extract the order header fields from the CSV record
        l_orderdate  := TO_DATE(
                        util_string.get_field(r_csv.csv_rec,2,lc_delim)
                        ,'DD/MM/YYYY');
        l_commplan   := util_string.get_field(r_csv.csv_rec,3,lc_delim);
        l_custid     := util_string.get_field(r_csv.csv_rec,4,lc_delim);
        l_shipdate   := TO_DATE(
                        util_string.get_field(r_csv.csv_rec,5,lc_delim)
                        ,'DD/MM/YYYY');
        l_total      := 0;
       
        -- Create ORD row
        INSERT INTO ord (
                         ordid,
                         ordref,
                         orderdate,
                         commplan,
                         custid,
                         shipdate,
                         total
                        )
                VALUES  ( 
                         l_ordid,
                         l_ordref,
                         l_orderdate,
                         l_commplan,
                         l_custid,
                         l_shipdate,
                         l_total
                        );
        l_prev_ordref := l_ordref;


      END IF;

      -- Process ITEMS
      -- Extract fields from CSV record
      l_prodid   := util_string.get_field(r_csv.csv_rec,6,lc_delim);
      l_qty      := util_string.get_field(r_csv.csv_rec,7,lc_delim);

      -- Lookup the current actual price
      -- Amended to call function in order rules package to get current price
      /*
      OPEN price_cur(l_prodid);
      FETCH price_cur INTO l_actualprice;
      CLOSE price_cur;
      */
      l_actualprice := orderrp.currentprice(l_prodid);
      
      l_itemtot := NVL(l_actualprice * l_qty,0);
      l_total := l_total + l_itemtot;

      INSERT INTO item (
                        ordid,
                        itemid,
                        prodid,
                        actualprice,
                        qty,
                        itemtot
                       )
                VALUES (
                        l_ordid,
                        l_itemid,
                        l_prodid,
                        l_actualprice,
                        l_qty,
                        l_itemtot
                       );

      -- Increment ITEMID to next line number
      l_itemid := l_itemid+1;

      -- Update ORD with total value of ITEM
      UPDATE ord SET total = l_total WHERE ordid = l_ordid;

    END LOOP;

    -- Tidy up

    -- Delete old error messages with KEY_VALUE matching that on the order successfully imported
    delete_error(l_fileid);

    -- Delete data from staging table. 
    l_rec_count := util_file.delete_csv(l_fileid);

    -- Move CSV file to processed directory
    util_file.rename_file(gc_import_directory,p_filename,gc_import_processed_dir,p_filename);

    -- Import completed without errors
    l_result := TRUE;
    RETURN l_result;
  EXCEPTION
    WHEN E_FILE_NOT_FOUND THEN
      -- CSV file not found so log the error
      import_error(p_filename, rec_current_csv, 'IMPORT.ORD_IMP File not found. Order import failed.',NULL,SQLERRM);
      util_admin.log_message('File not found importing file ' || p_filename,SQLERRM,'IMPORT.ORD_IMP','B',gc_error);
      RETURN FALSE;
    WHEN E_INVALID_DATA THEN
      -- CSV data failed validation
      -- Log the error but do not rollback because we need to keep the validation error messages inserted into IMPORTERROR
      util_admin.log_message('Invalid data importing file ' || p_filename,SQLERRM,'IMPORT.ORD_IMP','B',gc_error);
      -- Move CSV file to error directory
      util_file.rename_file(gc_import_directory,p_filename,gc_import_error_dir,p_filename);
      RETURN FALSE;
    WHEN E_ORDID_VALUE_ERROR THEN
      -- Maximum value of ORDID exceeded. Cannot allocate next ORDID. 
      -- The data will have been loaded into the staging table and passed validation without errors so rollback all the way to the beginning
      ROLLBACK TO before_load_csv;
      -- Log the error
      import_error(p_filename, rec_current_csv, 'IMPORT.ORD_IMP ORDID maximum value exceeded. Next ORDID is '||to_char(l_next_ordid),NULL,SQLERRM);
      util_admin.log_message('Maximum ORDID value exceeded importing file ' || p_filename,SQLERRM,'IMPORT.ORD_IMP','B',gc_error);
      -- Move CSV file to error directory
      util_file.rename_file(gc_import_directory,p_filename,gc_import_error_dir,p_filename);
      RETURN FALSE;
    WHEN OTHERS THEN
      -- Unexpected error so rollback to before the CSV data was loaded into the staging table
      ROLLBACK TO before_load_csv;
      -- Report the error before executing the next command or you will lose the SQLERRM value
      import_error(p_filename, rec_current_csv, 'IMPORT.ORD_IMP Unexpected error. Order import failed.',NULL,SQLERRM);
      util_admin.log_message('Unexpected error importing file ' || p_filename,SQLERRM,'IMPORT.ORD_IMP','B',gc_error);
      -- Move CSV file to error directory
      util_file.rename_file(gc_import_directory,p_filename,gc_import_error_dir,p_filename);
      RETURN FALSE;
  END ord_imp;

END import;
/
