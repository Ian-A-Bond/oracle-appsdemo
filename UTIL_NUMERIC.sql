CREATE OR REPLACE PACKAGE util_numeric AS
  /*
  ** (c) Bond and Pollard Ltd 2022
  ** This software is free to use and modify at your own risk.
  ** 
  ** Module Name   : util_numeric
  ** Description   : Number handling utilities
  ** 
  **------------------------------------------------------------------------
  ** Modification History
  **  
  ** Date            Name                 Description
  **------------------------------------------------------------------------
  ** 16/06/2022      Ian Bond             Program created
  ** 12/02/2024      Ian Bond             Add AI generated function num_to_alphanumeric
  **                                      to convert integer to alphanumeric code.
  ** 16/03/2024      Ian Bond             Add function to calculate pi   
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
  ** Public functions and procedures
  */
  
  /*
  ** dectobase - Convert a decimal integer to the specified base value
  **
  ** IN
  **   p_number        - Decimal integer to be converted
  **   p_base          - Integer representing number base, e.g. 2 is Binary, 8 is octal, 
  **                     16 is hexadecimal
  ** RETURN
  **   VARCHAR2   A string representing the base value of the decimal
  ** EXCEPTIONS
  **   <exception_name1>      - <brief description>
  */
  FUNCTION dectobase (
    p_number IN INTEGER, 
    p_base   IN INTEGER
    ) RETURN VARCHAR2;

  /*
  ** basetodec - Convert a number of the specified base to a decimal value
  **
  ** IN
  **   p_number        - A string containing the base value to be converted to decimal.
  **                     e.g. '10' is the binary string representing 2 in base 10.
  **   p_base          - Integer representing number base, e.g. 2 is Binary, 8 is octal, 
  **                     16 is hexadecimal
  ** RETURN
  **   NUMBER  Is the decimal value of the specified base number
  ** EXCEPTIONS
  **   <exception_name1>      - <brief description>
  */
  FUNCTION basetodec (
    p_number IN VARCHAR2, 
    p_base   IN INTEGER
  ) RETURN NUMBER;

  /*
  ** dectohex - Convert a decimal integer to a hexadecimal string value
  **
  ** IN
  **   p_number        - A decimal integer value to be converted to Hexadecimal
  ** RETURN
  **   VARCHAR2   A string containing the Hexadecimal value of the decimal integer
  ** EXCEPTIONS
  **   <exception_name1>      - <brief description>
  */
  FUNCTION dectohex (
    p_number IN INTEGER
  ) RETURN VARCHAR2;

  /*
  ** hextodec - Convert a hexadecimal string value to a decimal integer
  **
  ** IN
  **   p_number        - Hexadecimal string to be converted to decimal
  ** RETURN
  **   NUMBER  The decimal value of the Hexadecimal number
  ** EXCEPTIONS
  **   <exception_name1>      - <brief description>
  */
  FUNCTION hextodec (
    p_number IN VARCHAR2
  ) RETURN NUMBER;

  /*
  ** factorial - Calculate the factorial for a positive integer
  **
  ** IN
  **   p_number        - Positive integer
  ** RETURN
  **   NUMBER  Factorial of p_number
  ** EXCEPTIONS
  **   <exception_name1>      - <brief description>
  */
  FUNCTION factorial(
    p_number IN INTEGER
  ) RETURN NUMBER;

  /*
  ** factorialr - Calculate the factorial for a positive integer
  **
  ** Calculate the factorial using a recursive function.
  ** IN
  **   p_number        - Positive integer
  ** RETURN
  **   NUMBER  Factorial of p_number
  ** EXCEPTIONS
  **   <exception_name1>      - <brief description>
  */
  FUNCTION factorialr (
    p_number IN INTEGER
  ) RETURN NUMBER;

  /*
  ** sort_numbers - Sort a list of numbers
  **
  ** 
  ** IN
  **   p_string       - String of numbers to sort, separated by commas
  **   p_order        - Sort sequence 'A' for Ascending, all other values Descending
  ** RETURN
  **   VARCHAR2  String containing the sorted list of numbers
  ** EXCEPTIONS
  **   <exception_name1>      - <brief description>
  */
  FUNCTION sort_numbers (
    p_string IN VARCHAR2, 
    p_order  IN VARCHAR2
  ) RETURN VARCHAR2;
  
  /*
  ** num_to_alphanumeric - Convert integer to alphanumeric code
  **
  ** A copilot AI generated pl/sql function to convert numbers to an alphanumeric code where:
  ** 1=A, 2=B, 26=Z, 27=AA, 28=AB, 52=AZ, 53=BA etc.
  **
  ** Here’s how the function works:
  ** We start with the input number.
  ** In each iteration, we calculate the remainder after dividing by 26 (the number of letters in the alphabet).
  ** We convert the remainder to the corresponding letter (‘A’ for 1, ‘B’ for 2, and so on).
  ** We prepend the letter to the result string.
  ** We update the input number by subtracting the remainder and dividing by 26.
  ** Repeat until the input number becomes zero.
  ** Now you can use this function to convert numbers to the desired alphanumeric code. For example:
  **
  ** NUM_TO_ALPHANUMERIC(1) returns 'A'.
  ** NUM_TO_ALPHANUMERIC(27) returns 'AA'.
  ** NUM_TO_ALPHANUMERIC(52) returns 'AZ'.
  ** NUM_TO_ALPHANUMERIC(53) returns 'BA'.
  ** 
  ** IN
  **   p_number       - Positive integer to convert
  ** RETURN
  **   VARCHAR2  String containing the alphanumeric code
  ** EXCEPTIONS
  **   <exception_name1>      - <brief description>
  */
  FUNCTION num_to_alphanumeric (
    p_number IN NUMBER
  ) 
  RETURN VARCHAR2;

  /*
  ** dectoalpha - Convert a decimal value to an alphabetic code
  **
  ** Convert a positive integer into an alphabetic code, using the specified range of letters. 
  ** Use an efficient calculation instead of a simple but highly inefficient loop. 
  ** 
  ** e.g.
  **
  ** 1=A
  ** 2=B
  ** 3=C
  ** 26=Z
  ** 27=AA
  ** 28=AB 
  ** 52=AZ
  ** 53=BA
  ** 700=ZX
  ** 702=ZZ
  ** 703=AAA
  ** 704=AAB
  ** 18278=ZZZ
  ** 18279=AAAA
  ** 72385=DCBA
  ** 475254=ZZZZ
  ** 1143606698788=ELIZABETH
  ** 
  ** IN
  **   p_number      - Positive decimal integer to be converted
  **   p_range       - Number between 1 and 26, representing range of alphabetic characters to use in code.
  **                   e.g. 5 would use letters A to E.
  ** RETURN
  **   VARCHAR2  String containing the alphabetic code
  ** EXCEPTIONS
  **   <exception_name1>      - <brief description>
  */
  FUNCTION dectoalpha (
    p_number IN INTEGER, 
    p_range  IN INTEGER
  ) RETURN VARCHAR2;

  /*
  ** alphatodec - Convert an alphabetic code to a decimal integer
  **
  ** Decode an alphabetic code, with the specified range of characters, converting it back to an integer. 
  **
  ** Example alphacodes using all 26 letters of the alphabet:
  ** A=1
  ** B=2
  ** Z=26
  ** AA=27
  ** ZZ=702
  ** AAA=703
  ** 
  ** IN
  **   p_code        - String containing the alphabetic code
  **   p_range       - Number between 1 and 26, representing range of alphabetic characters to use in code.
  **                   e.g. 5 would use letters A to E.
  ** RETURN
  **   NUMBER  Decimal integer value of the alphabetic code
  ** EXCEPTIONS
  **   <exception_name1>      - <brief description>
  */
  FUNCTION alphatodec(
    p_code  IN VARCHAR2, 
    p_range IN INTEGER
  ) RETURN NUMBER;

  /*
  ** pi - Calculate pi to a reasonable accuracy
  **
  ** RETURN
  **   NUMBER  Value of pi
  **
  */
  FUNCTION pi
    RETURN NUMBER;
    
END util_numeric;
/


CREATE OR REPLACE PACKAGE BODY util_numeric AS
  /*
  ** (c) Bond and Pollard Ltd 2022
  ** This software is free to use and modify at your own risk.
  ** 
  ** Module Name   : util_numeric
  ** Description   : Number handling utilities
  ** 
  **------------------------------------------------------------------------
  ** Modification History
  **  
  ** Date            Name                 Description
  **------------------------------------------------------------------------
  ** 16/06/2022      Ian Bond             Program created
  ** 12/02/2024      Ian Bond             Add AI generated function num_to_alphanumeric
  **                                      to convert integer to alphanumeric code.
  **   
  */


  /*
  ** Private functions and procedures
  */

  /* 
  ** Public functions and procedures
  */

  FUNCTION dectobase(
    p_number IN INTEGER, 
    p_base   IN INTEGER
  ) 
  RETURN VARCHAR2
  IS
    v_result plsql_constants.maxvarchar2_t;
    v_quotient INTEGER;
    v_remainder INTEGER;
    c_digits CONSTANT VARCHAR2(16) :='0123456789ABCDEF';
  BEGIN
    v_quotient := p_number;
    WHILE v_quotient > 0 LOOP
      v_remainder := mod(v_quotient,p_base);
      v_quotient := trunc(v_quotient / p_base);
      v_result := substr(c_digits, v_remainder +1, 1) || v_result;
    END LOOP;
    RETURN nvl(v_result,'0');
  END dectobase;

  FUNCTION basetodec(
    p_number IN VARCHAR2, 
    p_base   IN INTEGER
  ) 
  RETURN NUMBER 
  IS
    c_digits CONSTANT VARCHAR2(16) := '0123456789ABCDEF';
    v_power INTEGER;
    v_result INTEGER :=0;
    v_decimal INTEGER;
  BEGIN
    FOR i IN REVERSE 1 .. length(p_number) LOOP
      v_power := p_base**(length(p_number)-i);
      v_decimal := instr(c_digits,substr(p_number,i,1))-1;
      v_result := v_result + (v_decimal * v_power);
    END LOOP;
    RETURN v_result;
  END basetodec;

  FUNCTION dectohex(
    p_number IN INTEGER
  ) 
  RETURN VARCHAR2 
  IS
    v_result plsql_constants.maxvarchar2_t;
    v_quotient INTEGER;
    v_remainder INTEGER;
    c_base CONSTANT INTEGER :=16;
    c_digits CONSTANT VARCHAR2(c_base) :='0123456789ABCDEF';
  BEGIN
    v_quotient := p_number;
    WHILE v_quotient > 0 LOOP
      v_remainder := mod(v_quotient,c_base);
      v_quotient := trunc(v_quotient / c_base);
      v_result := substr(c_digits, v_remainder +1, 1) || v_result;
    END LOOP;
    RETURN nvl(v_result,'0');
  END dectohex;

  FUNCTION hextodec(
    p_number IN VARCHAR2
  ) 
  RETURN NUMBER 
  IS
    c_digits CONSTANT VARCHAR2(16) := '0123456789ABCDEF';
    c_base CONSTANT INTEGER := 16;
    v_power INTEGER;
    v_result INTEGER :=0;
    v_decimal INTEGER;
  BEGIN
    FOR i IN REVERSE 1 .. length(p_number) LOOP
      v_power := c_base**(length(p_number)-i);
      v_decimal := instr(c_digits,substr(p_number,i,1))-1;
      v_result := v_result + (v_decimal * v_power);
    END LOOP;
    RETURN v_result;
  END hextodec;

  FUNCTION factorial(
    p_number IN INTEGER
  ) 
  RETURN NUMBER 
  IS
    v_fact NUMBER := 1;
    i NUMBER;
  BEGIN
    i := p_number;
    WHILE i > 1 LOOP
      v_fact := v_fact * i;
      i := i-1;
    END LOOP;
    RETURN (v_fact);
  END factorial;

  -- Factorial using recursion
  FUNCTION factorialr(
    p_number IN INTEGER
  ) 
  RETURN NUMBER 
  IS
  BEGIN
    IF p_number <=1 THEN
      RETURN p_number;
    ELSE 
      RETURN p_number * factorialr(p_number -1);
    END IF;
  END factorialr;

  -- Sort a list of comma separated numbers into ascending or descending order
  FUNCTION sort_numbers (
    p_string IN VARCHAR2, 
    p_order  IN VARCHAR2
  ) 
  RETURN VARCHAR2 
  IS
    v_result plsql_constants.maxvarchar2_t;
    c_max_entries CONSTANT INTEGER := 10;
    TYPE t_list_array IS VARRAY(c_max_entries) OF NUMBER;
    v_list t_list_array := t_list_array(NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
    v_temp NUMBER;
  BEGIN
    -- Populate arrary with fields passed in p_string, a comma separated list of values
    FOR m IN 1 .. c_max_entries LOOP
      v_temp := nvl(to_number(util_string.get_field(p_string,m,',')),0);
      v_list(m) := to_number(util_string.get_field(p_string,m,','));
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
    FOR m IN 1 .. v_list.LAST LOOP
      IF m = 1 THEN
        v_result := to_char(v_list(m));
      ELSIF v_list(m) IS NOT NULL THEN
        v_result := v_result || ',' || to_char(v_list(m));
      END IF;
    END LOOP;
    RETURN v_result;
  END sort_numbers;

  FUNCTION num_to_alphanumeric(
    p_number IN NUMBER
  ) 
  RETURN VARCHAR2
  IS
    v_result VARCHAR2(100);
    v_base NUMBER := 26; -- Number of letters in the alphabet
    v_calc NUMBER;
    v_remainder NUMBER;
  BEGIN
    IF p_number <= 0 THEN
        RETURN 'Invalid input. Please provide a positive number.';
    END IF;
    v_calc := p_number;
    WHILE v_calc > 0 LOOP
      v_remainder := MOD(v_calc  - 1, v_base) + 1; -- Adjust for 1-based indexing
      v_result := CHR(ASCII('A') + v_remainder - 1) || v_result;
      v_calc  := (v_calc - v_remainder) / v_base;
    END LOOP;
    RETURN v_result;
  END num_to_alphanumeric;

  FUNCTION dectoalpha (
    p_number IN INTEGER, 
    p_range  IN INTEGER
  ) 
  RETURN VARCHAR2 
  IS
    c_max CONSTANT INTEGER := 30;
    c_alpha_max CONSTANT INTEGER := 26;
    v_alpha_range INTEGER;
    v_result VARCHAR2(c_max);
    v_power INTEGER;
    v_total INTEGER;
    v_n1 INTEGER;
  BEGIN
    v_total := p_number;
    IF p_range < 1 THEN
      v_alpha_range :=1;
    ELSIF p_range > c_alpha_max THEN
      v_alpha_range := c_alpha_max;
    ELSE
      v_alpha_range := p_range;
    END IF;
    FOR n IN 1 .. c_max LOOP
      IF v_total <= 0 THEN
        EXIT;
      END IF;
      v_power := power(v_alpha_range,n-1);
      IF n = 1 THEN
        v_n1 := mod(v_total, v_alpha_range);
      ELSE
        v_n1 := floor(v_total / v_power);
      END IF;
      IF v_n1 < 1 THEN
        v_n1 := v_alpha_range;
      ELSIF v_n1 > v_alpha_range THEN
        v_n1 := mod(v_n1,v_alpha_range); 
        IF v_n1 < 1 THEN
          v_n1 := v_alpha_range;
        END IF;
      END IF;
      v_result := chr(v_n1+64) || v_result;
      v_total := v_total - (v_n1 * v_power);
    END LOOP;
    RETURN ltrim(v_result);
  END dectoalpha;

  FUNCTION alphatodec(
    p_code  IN VARCHAR2, 
    p_range IN INTEGER
  ) 
  RETURN NUMBER 
  IS
    c_max CONSTANT INTEGER := 26;
    v_range INTEGER;
    v_power INTEGER;
    p_total INTEGER :=0;
  BEGIN    
    IF p_range < 1 THEN
      v_range := 1;
    ELSIF p_range > c_max THEN
      v_range := c_max;
    ELSE
      v_range := p_range;
    END IF;
    FOR i IN REVERSE 1 .. length(p_code) LOOP
      IF i = 1 THEN
        v_power := 1;
      ELSE
        v_power := power(v_range,i-1);
      END IF;
      p_total := p_total + ((ascii(substr(p_code,length(p_code)+1-i,1))-64)*v_power);   
    END LOOP;
    RETURN p_total;
  END alphatodec;
  
  FUNCTION pi 
  RETURN NUMBER 
  IS
    last_pi NUMBER := 0;
    delta   NUMBER := 0.000001;
    pi      NUMBER := 1;
    denom   NUMBER := 3;
    oper    NUMBER := -1;
    negone  NUMBER := -1;
    two     NUMBER := 2;
  BEGIN
    LOOP
      last_pi := pi;
      pi := pi + oper * 1/denom;
      EXIT WHEN (abs(last_pi-pi) <= delta );
      denom := denom + two;
      oper := oper * negone;
    END LOOP;
    RETURN pi*4;
  END pi;

END util_numeric;
/
