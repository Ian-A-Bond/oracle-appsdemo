CREATE OR REPLACE PACKAGE util_string AS
  /*
  ** (c) Bond & Pollard Ltd 2022
  ** This software is free to use and modify at your own risk.
  ** 
  ** Module Name   : util_string
  ** Description   : String handling utilities
  ** 
  **------------------------------------------------------------------------
  ** Modification History
  **  
  ** Date            Name                 Description
  **------------------------------------------------------------------------
  ** 16/06/2022      Ian Bond             Program created
  **   
  */
  

  /*
  ** Global constants
  */
  gc_newline              plsql_constants.newline%TYPE                := plsql_constants.newline;
  gc_newline_str          plsql_constants.newline_string%TYPE         := plsql_constants.newline_string;
  gc_carriage_return      plsql_constants.carriage_return%TYPE        := plsql_constants.carriage_return;
  gc_carriage_return_str  plsql_constants.carriage_return_string%TYPE := plsql_constants.carriage_return_string;
  gc_tab                  plsql_constants.tab%TYPE                    := plsql_constants.tab;
  gc_tab_str              plsql_constants.tab_string%TYPE             := plsql_constants.tab_string;


  /*
  ** Global variables
  */


  /*
  ** Global exceptions
  */


  /*
  ** Public functions and procedures
  */


  /*
  ** delimiter_position - Return position of Nth delimiter in string
  **
  ** Return the position within a string of the Nth delimiter from the start position.
  ** Ignore delimiters between a pair of double quotes.
  ** Fields that are delimited by quotes can contain quotes.
  ** Ignore spaces between fields and delimiters.
  **
  ** IN
  **   p_string           - Delimited string such as a CSV record "ABC",124,"Some text"
  **   p_start_position   - Start searching string at this position
  **   p_delim_position   - Indicate which delimiter to return e.g. Nth in string 
  **   p_delimiter        - Delimiter character to search for
  ** RETURN
  **   NUMBER  Position of the delimiter in string, 0 if not found, -1 if error
  ** EXCEPTIONS
  **   <exception_name1>      - <brief description>
  */
  FUNCTION delimiter_position (
    p_string         IN VARCHAR2, 
    p_start_position IN NUMBER, 
    p_delim_position IN NUMBER, 
    p_delimiter      IN VARCHAR2 DEFAULT ','
  ) RETURN NUMBER;


 
  /*
  ** get_field - Return the Nth field within a string, where the fields are separated by a specified delimiter 
  **
  ** Return the Nth field within a string, where the fields are separated by a specified delimiter 
  ** e.g. semicolon, comma or tab character.
  ** Ignore the delimiters within pairs of double quotes. 
  ** Strip double quotes from the start and end of the string.
  ** Example:
  **   select get_field('field1;"field;;;2";"field"""3";field4',3,';') from dual;
  ** Result:
  **   field3"""3
  **
  ** IN
  **   p_string        - String containing delimiter separated values 
  **   p_position      - Indicates which field to return, Nth in string
  **   p_delimiter     - Delimiter character used to separate fields
  ** RETURN
  **   VARCHAR2  Nth field of the string
  ** EXCEPTIONS
  **   <exception_name1>      - <brief description>
  */
  FUNCTION get_field(
    p_string    IN VARCHAR2, 
    p_position  IN NUMBER, 
    p_delimiter IN VARCHAR2 DEFAULT ','
  ) RETURN VARCHAR2;
  
  

  /*
  ** delimiter_position_nospace - Return the position within a string of the Nth delimiter
  **
  ** Return the position within a string of the Nth delimiter.
  ** Ignore delimiters if they are within a pair of double quotes.
  ** NB: There must be no spaces between the delimiters and the previous and next fields
  **
  ** IN
  **   p_string         - String containing delimiter separated values 
  **   p_delim_position - Which delimiter to find, Nth in string
  **   p_delimiter      - Delimiter character used to separate fields
  ** RETURN
  **   NUMBER  Position of the Nth delimiter in the string. 0 if not found, -1 if error.
  ** EXCEPTIONS
  **   <exception_name1>      - <brief description>
  */
  FUNCTION delimiter_position_nospace (
    p_string         IN VARCHAR2, 
    p_delim_position IN NUMBER, 
    p_delimiter      IN VARCHAR2 DEFAULT ','
  ) RETURN NUMBER;
  
  
  /*
  ** get_field_nospace - Return the Nth field within a string, where the fields are separated by a specified delimiter 
  **
  ** Note: This only works if there are no spaces between the fields and delimiters.
  **       Use the get_field function instead, as it handles spaces correctly.
  **
  ** Return the Nth field within a string, where the fields are separated by a specified delimiter 
  ** e.g. semicolon, comma or tab character.
  ** Ignore the delimiters within pairs of double quotes. 
  ** Strip double quotes from the start and end of the string.
  ** Example:
  **   select get_field('field1;"field;;;2";"field"""3";field4',3,';') from dual;
  ** Result:
  **   field3"""3
  **
  ** IN
  **   p_string        - String containing delimiter separated values 
  **   p_position      - Indicates which field to return, Nth in string
  **   p_delimiter     - Delimiter character used to separate fields
  ** RETURN
  **   VARCHAR2  Nth field of the string
  ** EXCEPTIONS
  **   <exception_name1>      - <brief description>
  */
  FUNCTION get_field_nospace(
    p_string    IN VARCHAR2, 
    p_position  IN NUMBER, 
    p_delimiter IN VARCHAR2 DEFAULT ','
  ) RETURN VARCHAR2;


  /*
  ** get_delimiter - Return the field delimiter character used in a string
  **
  ** Return best match for the delimiter used in string, as most frequently occuring
  ** of comma, semicolon or tab characters.
  ** Tab is the default.
  **
  ** IN
  **   p_string        - String containing fields separated by a delimiter
  ** RETURN
  **   VARCHAR2  The delimiter character found
  ** EXCEPTIONS
  **   <exception_name1>      - <brief description>
  */
  FUNCTION get_delimiter(
    p_string IN VARCHAR2
  ) RETURN VARCHAR2;


  /*
  ** count_fields - Count number of fields in a delimited string
  **
  ** Return the number of fields found in a delimited string
  ** Count number of fields in a delimited string
  **
  ** IN
  **   p_string        - String containing fields separated by a delimiter
  ** RETURN
  **   NUMBER  Count of fields found separated by the delimiter
  ** EXCEPTIONS
  **   <exception_name1>      - <brief description>
  */
  FUNCTION count_fields(
    p_string    IN VARCHAR2, 
    p_delimiter IN VARCHAR2 DEFAULT ','
  ) RETURN NUMBER;

  
  /*
  ** replace - Replace all occurrences of one string within another
  **
  ** Replace all occurrences of substring within string.
  ** This replicates the Oracle REPLACE function.
  **
  ** Note that this function must handle the new substring containing some or all of the 
  ** characters in the old substring. For example, if you replace "a" with "an" the function must not
  ** repeatedly replace the "a" in "an" with another "an".
  **
  ** IN
  **   p_instring        - Input string 
  **   p_replacewhat     - The substring you want to replace 
  **   p_replacewith     - Insert this value in place of p_replacewhat
  ** RETURN
  **   VARCHAR2  Output string with all replacements made
  ** EXCEPTIONS
  **   <exception_name1>      - <brief description>
  */
  FUNCTION replace(
    p_instring    IN VARCHAR2, 
    p_replacewhat IN VARCHAR2, 
    p_replacewith IN VARCHAR2
  ) RETURN VARCHAR2;


  /*
  ** textconvert - Replace escaped formatting characters with ASCII equivalent
  **
  ** Replace backslash n with ASCII char 10 (new line)
  ** Replace backslash t with ASCII char  9 (tab)
  ** Replace backslash r with ASCII char 13 (Carriage Return)
  ** Replace backslash t with tab, backslash n with new line, and backslash r with carriage return
  **
  ** If you place the output string in a text document, it will be formatted
  ** using the above characters. New lines will cause a line break etc.
  **
  ** IN
  **   p_instring        - Original string containing escaped characters
  ** RETURN
  **   VARCHAR2  Converted string containing ASCII formatting characters
  ** EXCEPTIONS
  **   <exception_name1>      - <brief description>
  */
  FUNCTION textconvert(
    p_instring IN VARCHAR2
  ) RETURN VARCHAR2;

  

  /*
  ** sort_string - Sort the contents of a string into ascending or descending order.
  **
  ** Sort the characters within a string into ascending or descending sequence
  **
  ** IN
  **   p_string        - String containing unsorted characters
  **   p_order         - A for Ascending sort, any other value is a Descending sort
  ** RETURN
  **   VARCHAR2  is the sorted string
  ** EXCEPTIONS
  **   <exception_name1>      - <brief description>
  */
  FUNCTION sort_string (
    p_string IN VARCHAR2, 
    p_order  IN VARCHAR2 DEFAULT 'A'
  ) RETURN VARCHAR2;

  /*
  ** sort_list - Sort a list of comma separated values into ascending or descending order
  **
  **  Sort values in a comma separated list into either ascending or descending order of value.
  **  This is a simple bubble sort.
  **
  ** IN
  **   p_string        - String containing a list of values separated by commas
  **   p_order         - A for Ascending sort, any other value for Descending sort
  ** RETURN
  **   <return datatype> <brief description>
  ** EXCEPTIONS
  **   <exception_name1>      - <brief description>
  */
  FUNCTION sort_list (
    p_string IN VARCHAR2, 
    p_order  IN VARCHAR2 DEFAULT 'A'
  ) RETURN VARCHAR2;


END util_string;
/


CREATE OR REPLACE PACKAGE BODY util_string AS
  /*
  ** (c) Bond & Pollard Ltd 2022
  ** This software is free to use and modify at your own risk.
  ** 
  ** Module Name   : util_string
  ** Description   : String handling utilities
  ** 
  **------------------------------------------------------------------------
  ** Modification History
  **  
  ** Date            Name                 Description
  **------------------------------------------------------------------------
  ** 16/06/2022      Ian Bond             Program created
  **   
  */

  /*
  ** Private functions and procedures
  */

  /*
  ** text_replace - replace escaped chars with ASCII equivalent
  **
  ** Called by the textconvert function
  ** Swap backslash t for ASCII char 9  (tab)
  **      backslash n for ASCII char 10 (newline)
  **      backslash r for ASCII char 13 (carriage return)
  **
  ** IN
  **   p_instring         - Source string containing escaped chars
  **   p_replacewhat      - Escaped character string to be replaced
  ** RETURN
  **   VARCHAR2  String with escaped characters replaced with ASCII equivalent
  ** EXCEPTIONS
  **   <exception_name1>      - <brief description>
  */
  FUNCTION text_replace(
    p_instring    IN VARCHAR2,
    p_replacewhat IN VARCHAR2
  ) 
  RETURN VARCHAR2
  IS
    c_max CONSTANT NUMBER := 500;
    l_outstring plsql_constants.maxvarchar2_t := '';
    l_replacewith VARCHAR2(1);
    l_npos NUMBER := 0;
    l_counter NUMBER := 0;
  BEGIN
    l_outstring := p_instring;

    CASE p_replacewhat
      WHEN gc_tab_str THEN
        l_replacewith := gc_tab;
      WHEN gc_newline_str THEN
        l_replacewith := gc_newline;
      WHEN gc_carriage_return_str THEN
        l_replacewith := gc_carriage_return;
    ELSE
        l_replacewith := ' ';
    END CASE;

    WHILE( instr(l_outstring, p_replacewhat) <> 0) LOOP
      l_counter := l_counter + 1;
      l_npos := instr(l_outstring, p_replacewhat);
      l_outstring := substr(l_outstring, 1,l_npos - 1)||l_replacewith||substr(l_outstring,  l_npos + 2);
      IF l_counter > c_max THEN
        l_outstring:='ERROR TEXTCONVERT';
        EXIT;
      END IF;
    END LOOP;

    RETURN l_outstring;
  END text_replace;
  

  /*
  ** Public functions and procedures
  */

  FUNCTION delimiter_position (
    p_string         IN VARCHAR2, 
    p_start_position IN NUMBER, 
    p_delim_position IN NUMBER, 
    p_delimiter      IN VARCHAR2 DEFAULT ','
  ) 
  RETURN NUMBER 
  IS
    c_quote CONSTANT VARCHAR2(1) := '"';  
    v_start_position NUMBER;
    v_delim_pos NUMBER;
    v_delim_count NUMBER;
    v_current_char VARCHAR2(1);
    v_quotes_open BOOLEAN;
    v_delim_found BOOLEAN;
    v_quote_found BOOLEAN;
    custom_error EXCEPTION;
  BEGIN
    IF LENGTH(p_delimiter) <> 1 THEN
      RAISE custom_error;
    END IF;
    IF LENGTH(p_string) < 1 THEN
      RAISE custom_error;
    END IF;
    v_quotes_open := FALSE;
    v_delim_found := FALSE;
    v_quote_found := FALSE;
    v_delim_count := 0;
    v_delim_pos := 0;
    -- Start searching string from this position
    v_start_position := NVL(p_start_position,1);
    FOR I IN v_start_position..LENGTH(p_string) LOOP
      -- Current char in string
      v_current_char := substr(p_string,I,1);
      -- Flag whether most recent char found that is not a space or quote, is a delimiter
      IF v_current_char = p_delimiter THEN
        v_delim_found := TRUE;
      ELSIF NVL(v_current_char,' ') <> ' ' AND v_current_char <> c_quote THEN
        v_delim_found := FALSE;
      END IF;

      -- Flag whether most recent char found that is not a space or delimiter is a quote
      IF v_current_char = c_quote THEN
        v_quote_found := TRUE;
      ELSIF NVL(v_current_char,' ') <> ' ' AND v_current_char <> p_delimiter THEN
        v_quote_found := FALSE;
      END IF;

      IF v_current_char = c_quote AND (v_delim_found OR I=v_start_position) THEN
        -- Open quotes
        -- Current character is a quote either first in string or previous non-space char was a delimiter
        v_quotes_open := TRUE; 
      ELSIF v_current_char = p_delimiter AND v_quote_found THEN
        -- Close quotes
        -- Current character is a delimiter and previous non-space char was a quote
        v_quotes_open := FALSE;
      END IF;

      IF NOT v_quotes_open THEN
        -- Ignore delimiters inside pairs of open quotes
        IF v_current_char = p_delimiter AND I > v_start_position THEN
          -- Increment count of delimiters found only if character matches delimiter and is not within a pair of quotes
          -- Ignore the first delimiter found if you are starting the search at a delimiter part way along the string
          v_delim_count := v_delim_count +1;
          IF (p_start_position = 1 AND v_delim_count = p_delim_position) OR v_start_position > 1 THEN
            -- Nth delimiter found, mark position and stop searching
            v_delim_pos := I;
            EXIT;
          END IF;
        END IF;
      END IF;
    END LOOP;
    RETURN v_delim_pos;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN -1;
  END delimiter_position;


  FUNCTION delimiter_position_nospace (
    p_string         IN VARCHAR2, 
    p_delim_position IN NUMBER, 
    p_delimiter      IN VARCHAR2 DEFAULT ','
  ) 
  RETURN NUMBER 
  IS
    c_quote CONSTANT VARCHAR2(1) := '"';  
    v_delim_pos NUMBER;
    v_delim_count NUMBER;
    v_char VARCHAR2(1);
    v_prev_char VARCHAR2(1);
    v_next_char VARCHAR2(1);
    v_inside_quotes BOOLEAN;
    v_quote_count NUMBER;
    custom_error EXCEPTION;
  BEGIN
    IF LENGTH(p_delimiter) <> 1 THEN
      RAISE custom_error;
    END IF;
    IF LENGTH(p_string) < 1 THEN
      RAISE custom_error;
    END IF;
    v_inside_quotes := FALSE;
    v_quote_count := 0;
    v_delim_count := 0;
    v_delim_pos := 0;
    FOR I IN 1..LENGTH(p_string) LOOP
      -- Current char in string
      v_char := substr(p_string,I,1);
      -- Previous char in string
      IF I > 1 THEN
        v_prev_char := substr(p_string,I-1,1);
      ELSE 
        -- At first char in string so previous is null
        v_prev_char := NULL;
      END IF;
      -- Next char in string
      v_next_char := substr(p_string,I+1,1);
      IF v_char = c_quote THEN
        IF (v_prev_char IS NULL OR v_prev_char = p_delimiter) OR (v_next_char = p_delimiter OR v_next_char IS NULL) THEN
          -- Increment count of quotes found only if open quote is first in string or preceded by a delimiter, or
          -- closing quote last in string or followed by a delimiter. Ignore all other quotes between pairs of quotes.
          v_quote_count := v_quote_count +1;
        END IF;
        IF MOD(v_quote_count,2) = 1 AND (v_prev_char IS NULL OR v_prev_char = p_delimiter) THEN
          -- Opening quote detected
          v_inside_quotes := TRUE;
        ELSIF v_next_char = p_delimiter OR v_next_char IS NULL THEN
          -- Closing quote detected
          v_inside_quotes := FALSE;
        END IF;
      END IF;
      IF NOT v_inside_quotes AND v_char = p_delimiter THEN
        -- Increment count of delimiters found only if character matches delimiter and is not within a pair of quotes
        v_delim_count := v_delim_count +1;
      END IF;
      IF v_delim_count = p_delim_position THEN
        -- Nth delimiter found, mark position and stop searching
        v_delim_pos := I;
        EXIT;
      END IF; 
    END LOOP;
    RETURN v_delim_pos;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN -1;
  END delimiter_position_nospace;



  FUNCTION get_field (
    p_string    IN VARCHAR2, 
    p_position  IN NUMBER, 
    p_delimiter IN VARCHAR2 DEFAULT ','
  ) 
  RETURN VARCHAR2 
  IS
    c_quote CONSTANT VARCHAR2(1) := '"';
    v_pos1 NUMBER;
    v_pos2 NUMBER;
    v_field plsql_constants.maxvarchar2_t;
    v_first_char VARCHAR(1);
    v_last_char VARCHAR2(1);
  BEGIN
    -- Find the position of the delimiter that marks the start of the field
    IF p_position = 1 THEN
      -- First field starts at position 1 in the string
      v_pos1 := 1;
    ELSE
      -- Nth field starts at the preceding delimiter. Field 3 starts after delimiter 2.
      -- Start searching from the 1st character
      v_pos1 := delimiter_position(p_string, 1,  p_position -1, p_delimiter);
    END IF;

    IF v_pos1 > 0 THEN
      -- First delimiter position found
      -- Find the position of the delimiter that marks the end of the field
      -- Search for the next delimiter from the delimiter at the start of the field
      v_pos2 := delimiter_position(p_string, v_pos1, 1, p_delimiter);
      IF p_position > 1 THEN
        -- For the 2nd field onward the starting position of the field is the next character after the delimiter
        v_pos1 := v_pos1 +1;
      END IF;
      IF v_pos2 < 1 THEN
        -- Last field in the string so no end delimiter found
        v_pos2 := LENGTH(p_string)+1;
      END IF;

      -- Extract field from the string, using the delimiter positions
      v_field := TRIM(BOTH ' ' FROM substr(p_string, v_pos1, v_pos2 - v_pos1));

      -- If the field is enclosed by double quotes (first and last char are quotes)
      -- then remove the enclosing quotes.
      -- Do not strip the quotes that are part of the field, e.g. "Title "Subtitle""
      -- must give: Title "Subtitle" 

      -- ORIGINAL CODE: v_field := TRIM(c_quote FROM TRIM(substr(p_string, v_pos1, v_pos2 - v_pos1)));

      v_first_char := substr(v_field,1,1);
      v_last_char := substr(v_field,LENGTH(v_field),1);
      IF v_first_char = v_last_char AND v_last_char = c_quote THEN
        -- First and last chars form pair of quotes enclosing field
        -- Remove first and last chars (quotes)
        v_field := substr(v_field,2,LENGTH(v_field)-2);
      END IF;
    ELSE
      v_field := NULL;
    END IF;
    RETURN v_field;
  END get_field;



  FUNCTION get_field_nospace (
    p_string    IN VARCHAR2, 
    p_position  IN NUMBER, 
    p_delimiter IN VARCHAR2 DEFAULT ','
  ) 
  RETURN VARCHAR2 
  IS
    c_quote CONSTANT VARCHAR2(1) := '"';
    v_pos1 NUMBER;
    v_pos2 NUMBER;
    v_field plsql_constants.maxvarchar2_t;
  BEGIN
    -- Find the position of the delimiter that marks the start of the field
    IF p_position = 1 THEN
      -- First field starts at position 1 in the string
      v_pos1 := 1;
    ELSE
      v_pos1 := delimiter_position_nospace(p_string, p_position -1, p_delimiter);
    END IF;

    IF v_pos1 > 0 THEN
      -- First delimiter position found
      IF p_position > 1 THEN
        -- For the 2nd field onward the starting position is the next character after the delimiter
        v_pos1 := v_pos1 +1;
      END IF;
      -- Find the position of the delimiter that marks the end of the field
      v_pos2 := delimiter_position_nospace(p_string, p_position, p_delimiter);
      IF v_pos2 < 1 THEN
        -- Last field in the string so no end delimiter found
        v_pos2 := LENGTH(p_string)+1;
      END IF;
      -- Strip the double quotes from the start and end of the field
      v_field := TRIM(c_quote FROM TRIM(substr(p_string, v_pos1, v_pos2 - v_pos1)));
    ELSE
      v_field := 'ERROR: Field not found';
    END IF;

    RETURN v_field;
  END get_field_nospace;


  FUNCTION get_delimiter (
    p_string IN VARCHAR2
  ) 
  RETURN VARCHAR2 
  IS
    c_tab CONSTANT VARCHAR2(1) := CHR(9);
    v_count_comma NUMBER :=0;
    v_count_semi NUMBER :=0;
    v_count_tab NUMBER :=0;
    v_delimiter VARCHAR2(1);
    v_current VARCHAR2(1);
  BEGIN
    FOR I IN 1..LENGTH(p_string) LOOP
      v_current := SUBSTR(p_string,I,1);
      IF v_current = ';' OR v_current = ',' OR v_current = c_tab THEN
        CASE v_current
          WHEN ';'   THEN v_count_semi := v_count_semi +1;
          WHEN ','   THEN v_count_comma := v_count_comma +1;
          ELSE v_count_tab := v_count_tab +1;
        END CASE;
      END IF;
    END LOOP;
    IF v_count_semi > v_count_comma AND v_count_semi > v_count_tab THEN
      v_delimiter := ';';
    ELSIF v_count_comma > v_count_semi AND v_count_comma > v_count_tab THEN
      v_delimiter := ',';
    ELSE
      v_delimiter := c_tab;
    END IF;
    RETURN v_delimiter;
  END get_delimiter;


  FUNCTION count_fields(
    p_string    IN VARCHAR2, 
    p_delimiter IN VARCHAR2 DEFAULT ','
  ) 
  RETURN NUMBER 
  IS
    v_pos NUMBER :=1;
    v_count NUMBER :=0;
  BEGIN
    -- Count the delimiters
    WHILE v_pos <= length(p_string) AND v_pos > 0 LOOP
      v_pos := NVL(delimiter_position(p_string, v_pos, 1, p_delimiter),length(p_string));
      v_count := v_count +1;
    END LOOP;
    RETURN v_count;
  END count_fields;


  FUNCTION REPLACE(
    p_instring    IN VARCHAR2, 
    p_replacewhat IN VARCHAR2, 
    p_replacewith IN VARCHAR2
  ) 
  RETURN VARCHAR2 
  IS
    l_outstring plsql_constants.maxvarchar2_t := '';
    npos NUMBER := 0;
    l_space VARCHAR2(1);
    l_offset NUMBER;
    l_found BOOLEAN;
    l_to_search plsql_constants.maxvarchar2_t;
    l_search_pos NUMBER;
  BEGIN
    l_outstring := p_instring;
    l_offset := 1;
    l_found := TRUE;
    WHILE(l_found) LOOP
      -- Remaining portion of string to be searched and replaced, starting after position of last replacement
      l_to_search := substr(l_outstring,l_offset,LENGTH(l_outstring));

      -- Position of characters to be be replaced within portion of string being searched
      l_search_pos := instr(l_to_search , p_replacewhat);

      IF l_search_pos > 0 THEN
        -- Substring to replace was found
        -- npos is the start position of the substring to be replaced withing the entire string, not just
        -- the portion currently being searched and replaced
        npos := l_offset -1 + l_search_pos;

        -- If what your are replacing is part of a longer word, don't put a space after the replacement string
        IF substr(l_outstring,npos+LENGTH(p_replacewhat),1) <> ' ' THEN
          l_space := '';
        ELSE
          l_space := ' ';
        END IF;

        -- Replace the original substring with the new substring
        l_outstring := LTRIM(substr(l_outstring, 1, npos - 1))
                     ||p_replacewith||l_space||
                     LTRIM(substr(l_outstring, npos + LENGTH(p_replacewhat),LENGTH(l_outstring)));

        -- The offset is the position within the string following the group of characters just replaced
        l_offset := npos + nvl(LENGTH(p_replacewith),0);
      ELSE
        l_found :=FALSE;
      END IF;
    END LOOP;
    RETURN l_outstring;
  EXCEPTION
    WHEN OTHERS THEN RETURN sqlerrm;
  END REPLACE;


  FUNCTION textconvert(
    p_instring IN VARCHAR2
  ) 
  RETURN VARCHAR2 
  IS
    l_outstring plsql_constants.maxvarchar2_t := '';
  BEGIN
    l_outstring := p_instring;
    l_outstring := text_replace(l_outstring,gc_newline_str);
    l_outstring := text_replace(l_outstring,gc_tab_str);
    l_outstring := text_replace(l_outstring,gc_carriage_return_str);
    RETURN l_outstring;
  END textconvert;


  FUNCTION sort_string (
    p_string IN VARCHAR2, 
    p_order  IN VARCHAR2 DEFAULT 'A'
  ) 
  RETURN VARCHAR2 
  IS
    v_result plsql_constants.maxvarchar2_t;
    v_len NUMBER;
    v1 VARCHAR2(1);
    v2 VARCHAR2(1);
  BEGIN
    v_len := LENGTH(p_string);
    v_result := p_string;
    FOR p1 IN 1 .. v_len LOOP
      FOR p2 IN p1+1 .. v_len LOOP
        v1 := substr(v_result,p1,1);
        v2 := substr(v_result,p2,1);
        IF (UPPER(p_order) = 'A' AND v2 < v1) OR (UPPER(p_order) <> 'A' AND v2 > v1) THEN
          v_result := substr(v_result,1,p1-1) || v2 || substr(v_result,p1+1,p2-p1-1) || v1 || substr(v_result,p2+1,v_len);
        END IF;
      END LOOP;
    END LOOP;
    RETURN v_result;
  END sort_string;


  FUNCTION sort_list (
    p_string IN VARCHAR2, 
    p_order  IN VARCHAR2 DEFAULT 'A'
  ) 
  RETURN VARCHAR2 
  IS
    v_result plsql_constants.maxvarchar2_t;
    c_max_entries CONSTANT INTEGER := 10;
    c_entry_size CONSTANT INTEGER := 20;
    TYPE t_list_array IS VARRAY(c_max_entries) OF VARCHAR2(c_entry_size);
    v_list t_list_array := t_list_array('','','','','','','','','','');
    v_temp VARCHAR2(c_entry_size);
  BEGIN
    -- Populate arrary with fields passed in p_string, a comma separated list of values
    FOR m IN 1 .. c_max_entries LOOP
      v_temp := nvl(get_field(p_string,m,','),'*');
      IF v_temp = '*' THEN
        EXIT;
      END IF;
      v_list(m) := get_field(p_string,m,',');
    END LOOP;

    -- Sort list
    FOR p1 IN 1 .. v_list.COUNT LOOP
      FOR p2 IN p1+1 .. v_list.COUNT LOOP
        IF (UPPER(p_order) = 'A' AND v_list(p2) < v_list(p1)) OR (UPPER(p_order) <> 'A' AND v_list(p2) > v_list(p1)) THEN
          v_temp := v_list(p1);
          v_list(p1) := v_list(p2);
          v_list(p2) := v_temp;
        END IF;
      END LOOP;
    END LOOP;


    -- Put sorted list into result string
    FOR m IN 1 .. v_list.COUNT LOOP
      IF v_list(m) IS NULL THEN
        EXIT;
      END IF;
      v_result := v_result || v_list(m);
      IF m <= v_list.COUNT -1 THEN
        v_result := v_result || ',';
      END IF;
    END LOOP;
    RETURN v_result;
  END sort_list;

END util_string;
/
