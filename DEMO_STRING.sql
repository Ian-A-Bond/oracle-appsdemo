CREATE OR REPLACE PACKAGE demo_string AS
  /*
  ** (c) Bond and Pollard Ltd 2022
  ** This software is free to use and modify at your own risk.
  ** 
  ** Module Name   : demo_string
  ** Description   : Demonstrate String Functions
  ** Notes         : Use this package for demonstrating string functions
  **                 and training.
  ** 
  **------------------------------------------------------------------------
  ** Modification History
  **  
  ** Date            Name                 Description
  **------------------------------------------------------------------------
  ** 09/07/2022      Ian Bond          Program created
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
  ** Public functions and procedures
  */
  
  /*
  ** ALPHACODE functions convert a positive integer into an alphabetic string.
  ** e.g.
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
  */

  /*
  ** alphacode - Convert a positive integer into an alphabetic code
  **
  ** Inefficient loop method.
  **
  ** With 3 registers used for the code, the maximum value this works for is 18278.
  ** This code is inefficient as it uses a loop, only works for codes up to ZZZ, and repeats code.
  ** Create an improved version using an array, removing the repeated code.
  ** Use an algorithm to calculate the code, instead of looping through every number from 1 to n.
  **
  ** IN
  **   p_number     - a positive integer
  ** RETURN
  **   VARCHAR2     - alphabetic string representing the integer value passed in
  ** EXCEPTIONS
  **   <exception_name1>      - <brief description>
  */
  FUNCTION alphacode (
    p_number IN INTEGER
    ) RETURN VARCHAR2;

  /*
  ** alphacode_array - Convert a positive integer into an alphabetic code.
  **
  ** Convert a positive integer into an alphabetic code. Uses an array to eliminate duplicate code.
  ** This code is stll inefficient as it loops through every number from 1 to N.
  ** With a code length of 5 characters, this works for a maximum value of 12356630 which is ZZZZZ.
  **
  ** IN
  **   p_number     - a positive integer
  ** RETURN
  **   VARCHAR2     - alphabetic string representing the integer value passed in
  ** EXCEPTIONS
  **   <exception_name1>      - <brief description>
  */
  FUNCTION alphacode_array (
    p_number IN INTEGER
    ) RETURN VARCHAR2;


  /*
  ** alphacode_calc - Convert a positive integer into an alphabetic code using an efficient calculation.
  **
  ** Convert a positive integer into an alphabetic code. Uses an efficient calculation instead of a simple
  ** but highly inefficient loop. This is an efficient algorithmic solution.
  ** Maximum value of integer this works for is: 
  **
  ** IN
  **   p_number     - a positive integer
  ** RETURN
  **   VARCHAR2     - alphabetic string representing the integer value passed in
  ** EXCEPTIONS
  **   <exception_name1>      - <brief description>
  */
  FUNCTION alphacode_calc (
    p_number IN INTEGER
    ) RETURN VARCHAR2;

  /*
  ** alphacode_calc_na - Convert a positive integer into an alphabetic code using an efficient calculation.
  **                     No arrary required.
  **
  ** Convert a positive isnteger into an alphabetic code. Uses an efficient calculation instead of a simple
  ** but highly inefficient loop. This is an efficient algorithmic solution.
  ** This version has been simplified and does not need and array for the result.
  ** Maximum value of integer this works for is: 
  **
  ** IN
  **   p_number     - a positive integer
  ** RETURN
  **   VARCHAR2     - alphabetic string representing the integer value passed in
  ** EXCEPTIONS
  **   <exception_name1>      - <brief description>
  */
  FUNCTION alphacode_calc_na (
    p_number IN INTEGER
    ) RETURN VARCHAR2;

  /*
  ** alphacode_range - Convert a positive integer into an alphabetic code, using the specified range of letters.
  **
  ** Uses an efficient calculation instead of a simple but highly inefficient loop. 
  **
  ** IN
  **   p_number     - Positive integer to be converted to an alpha code
  **   p_range      - Number between 1 and 26 giving the number of letter to use in the code
  ** RETURN
  **   VARCHAR2     - alphabetic string representing the integer value passed in
  ** EXCEPTIONS
  **   <exception_name1>      - <brief description>
  */
  FUNCTION alphacode_range (
    p_number IN INTEGER, 
    p_range  IN INTEGER
    ) RETURN VARCHAR2;

  /*
  ** alphacode_atg - Convert a positive integer into an alphabetic code
  **
  ** ATG Coding test
  **
  ** This is the corrected version, which works but only for numbers up to
  ** 18278, as we only code 3 characters. The source code is poorly written with repeated lines of code.
  ** For the correct way to program the solution, see alphacode_calc.
  **
  ** IN
  **   p_number     - Positive integer to be converted to an alpha code
  ** RETURN
  **   VARCHAR2     - alphabetic string representing the integer value passed in
  ** EXCEPTIONS
  **   <exception_name1>      - <brief description>
  */
  FUNCTION alphacode_atg (
    p_number IN INTEGER
    ) RETURN VARCHAR2;

  /*
  ** alphacode_atg_wrong - Convert a positive integer into an alphabetic code
  **
  ** ATG Coding test: WRONG code values returned
  **
  ** The code I submitted to ATG was incorrect:
  ** 1. Should have started at rightmost column and calculated units first
  ** 2. First column should have been calculated using MOD, then DIV for others.
  ** 3. Needed a boundary check for values < 1 or > 26
  **
  ** IN
  **   p_number     - Positive integer to be converted to an alpha code
  ** RETURN
  **   VARCHAR2     - alphabetic string representing the integer value passed in
  ** EXCEPTIONS
  **   <exception_name1>      - <brief description>
  */
  FUNCTION alphacode_atg_wrong (
    p_number IN INTEGER
    ) RETURN VARCHAR2;

  /*
  ** alphadecode - Convert an alphabetic code to an integer
  **
  ** Decode an alphabetic code, converting it back to an integer.
  ** Where:
  ** A=1
  ** B=2
  ** Z=26
  ** AA=27
  ** ZZ=702
  ** AAA=703
  **
  ** IN
  **   p_code       - Alphabetic code string
  ** RETURN
  **   NUMBER       - Positive integer value of alphabetic code
  ** EXCEPTIONS
  **   <exception_name1>      - <brief description>
  */
  FUNCTION alphadecode(
    p_code IN VARCHAR2
  ) RETURN NUMBER;

 /*
  ** alphadecode_range - Convert an alphabetic code with a specified range of characters to an integer
  **
  ** Decode an alphabetic code, converting it back to an integer.
  **
  ** IN
  **   p_code       - Alphabetic code string
  **   p_range      - Number between 1 and 26 specifying the range of alphabetic characters in the code
  **                  e.g. 4 uses leters A to D.
  ** RETURN
  **   NUMBER       - Positive integer value of alphabetic code
  ** EXCEPTIONS
  **   <exception_name1>      - <brief description>
  */
  FUNCTION alphadecode_range(
    p_code  IN VARCHAR2, 
    p_range IN INTEGER
  ) RETURN NUMBER;

END demo_string;
/


CREATE OR REPLACE PACKAGE BODY demo_string AS
  /*
  ** (c) Bond and Pollard Ltd 2022
  ** This software is free to use and modify at your own risk.
  ** 
  ** Module Name   : demo_string
  ** Description   : Demonstrate String Functions
  ** Notes         : Use this package for demonstrating string functions
  **                and training.
  ** 
  **------------------------------------------------------------------------
  ** Modification History
  **  
  ** Date            Name                 Description
  **------------------------------------------------------------------------
  ** 09/07/2022      Ian Bond          Program created
  **   
  */


  /*
  ** Private functions and procedures
  */


  /*
  ** Public functions and procedures
  */
  

  FUNCTION alphacode (
    p_number IN INTEGER
  ) 
  RETURN VARCHAR2 
  IS
    c_max CONSTANT INTEGER := 26;
    r1 INTEGER :=0;
    r2 INTEGER :=0;
    r3 INTEGER :=0;
    v_result VARCHAR2(4);
  BEGIN
    FOR i IN 1 .. p_number LOOP
      r1 := r1+1;
      IF r1 > c_max THEN
        r1 :=1;
        r2 :=r2+1;
      END IF;
      IF r2 > c_max THEN
        r2 :=1;
        r3 :=r3+1;
      END IF;
    END LOOP;

    IF r3 > 0 THEN
      v_result := v_result||chr(r3+64);
    END IF;
    IF r2 > 0 THEN
      v_result := v_result||chr(r2+64);
    END IF;
    IF r1 > 0 THEN
      v_result := v_result||chr(r1+64);
    END IF;

    RETURN v_result;
  END alphacode;


  FUNCTION alphacode_array (
    p_number IN INTEGER
  ) 
  RETURN VARCHAR2 
  IS
    c_max CONSTANT INTEGER := 26;
    c_max_code CONSTANT INTEGER := 5;
    TYPE t_codesarray IS VARRAY(c_max_code) OF INTEGER;
    codes t_codesarray := t_codesarray(0,0,0,0,0);
    v_result VARCHAR2(20);
  BEGIN
    FOR i IN 1 .. p_number LOOP  
      codes(1) := codes(1)+1;
      FOR m IN 1 .. c_max_code -1 LOOP
        IF codes(m) > c_max THEN
          codes(m) :=1;
          codes(m+1) := codes(m+1)+1;
        END IF;
      END LOOP;
    END LOOP;
    FOR n IN REVERSE 1 ..c_max_code LOOP
      IF NVL(codes(n),0) > 0 THEN
        v_result := v_result||chr(codes(n)+64);
      ELSE
        v_result := v_result||' ';
      END IF;
    END LOOP;
    RETURN v_result;
  END alphacode_array;


  FUNCTION alphacode_calc (
    p_number IN INTEGER
  ) 
  RETURN VARCHAR2 
  IS
    c_max CONSTANT INTEGER := 30;
    c_group CONSTANT INTEGER := 26;
    v_result VARCHAR2(c_max);
    v_power INTEGER;
    v_total INTEGER;
    v_n1 INTEGER;
    TYPE t_codesarray IS VARRAY(c_max) OF INTEGER;
    codes t_codesarray := t_codesarray(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
  BEGIN
    v_total := p_number;
    FOR n IN 1 .. c_max LOOP
      IF v_total <= 0 THEN
        EXIT;
      END IF;
      v_power := power(c_group,n-1);
      IF n = 1 THEN
        v_n1 := mod(v_total, c_group);
      ELSE
        v_n1 := floor(v_total / v_power);
      END IF;
      IF v_n1 < 1 THEN
        v_n1 := c_group;
      ELSIF v_n1 > c_group THEN
        v_n1 := mod(v_n1,c_group); 
        IF v_n1 < 1 THEN
          v_n1 := c_group;
        END IF;
      END IF;
      codes(n) := v_n1;
      v_total := v_total - (v_n1 * v_power);
    END LOOP;

    FOR n IN REVERSE 1 ..c_max LOOP
      IF NVL(codes(n),0) > 0 THEN
        v_result := v_result||chr(codes(n)+64);
      ELSE
        v_result := v_result||' ';
      END IF;
    END LOOP;

    RETURN ltrim(v_result);
  END alphacode_calc;

 
  FUNCTION alphacode_calc_na (
    p_number IN INTEGER
  ) 
  RETURN VARCHAR2 
  IS
    c_max CONSTANT INTEGER := 30;
    c_group CONSTANT INTEGER := 26;
    v_result VARCHAR2(c_max);
    v_power INTEGER;
    v_total INTEGER;
    v_n1 INTEGER;
  BEGIN
    v_total := p_number;
    FOR n IN 1 .. c_max LOOP
      IF v_total <= 0 THEN
        EXIT;
      END IF;
      v_power := power(c_group,n-1);
      IF n = 1 THEN
        v_n1 := mod(v_total, c_group);
      ELSE
        v_n1 := floor(v_total / v_power);
      END IF;
      IF v_n1 < 1 THEN
        v_n1 := c_group;
      ELSIF v_n1 > c_group THEN
        v_n1 := mod(v_n1,c_group); 
        IF v_n1 < 1 THEN
          v_n1 := c_group;
        END IF;
      END IF;
      v_result := chr(v_n1+64) || v_result;
      v_total := v_total - (v_n1 * v_power);
    END LOOP;
    RETURN ltrim(v_result);
  END alphacode_calc_na;


  FUNCTION alphacode_range (
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
  END alphacode_range;


  FUNCTION alphacode_atg (
    p_number IN INTEGER
  ) 
  RETURN VARCHAR2 
  IS
    v_result VARCHAR2(4);
    vn1 CONSTANT INTEGER :=26;
    vn2 CONSTANT INTEGER := vn1 * vn1;
    vn3 CONSTANT INTEGER := vn1 * vn1 * vn1;
    vr1 NUMBER;
    vr2 NUMBER;
    vr3 NUMBER;
    vt NUMBER;
    vc1 VARCHAR2(1);
    vc2 VARCHAR2(1);
    vc3 VARCHAR2(1);
  BEGIN
    vt := p_number;

    IF vt / vn1 >= 0 THEN
      vr1 := mod(vt,vn1);
      IF vr1 < 1 THEN
        vr1 := vn1;
      ELSIF vr1 > vn1 THEN
        vr1 := mod(vr1,vn1);
        IF vr1 < 1 THEN
          vr1 := 1;
        END IF;
      END IF;
      vt := vt - vr1;
    END IF;

    IF vt / vn1 >= 1 THEN
      vr2 := floor(vt / vn1);
      IF vr2 < 1 THEN
        vr2 := vn1;
      ELSIF vr2 > vn1 THEN
        vr2 := mod(vr2,vn1);
        IF vr2 < 1 THEN
          vr2 := vn1;
        END IF;
      END IF;
      vt := vt - vr2*vn1;
    END IF;

    IF vt / vn2 >= 1 THEN
      vr3 := floor(vt / vn2);
      IF vr3 < 1 THEN
        vr3 := vn1;
      ELSIF vr3 > vn1 THEN
        vr3 := mod(vr3,vn1);
        IF vr3 < 1 THEN
          vr3 := vn1;
        END IF;
      END IF;
      vt := vt - vr3*vn1;
    END IF;

    vc1 := CHR(vr1+64);
    vc2 := CHR(vr2+64);
    vc3 := CHR(vr3+64);
    v_result := vc3||vc2||vc1;
    RETURN v_result;
  END alphacode_atg;


  FUNCTION alphacode_atg_wrong (
    p_number IN INTEGER
  ) 
  RETURN VARCHAR2 
  IS
    v_result VARCHAR2(4);
    vn1 CONSTANT INTEGER :=26;
    vn2 CONSTANT INTEGER := vn1 * vn1;
    vn3 CONSTANT INTEGER := vn1 * vn1 * vn1;
    vr1 NUMBER;
    vr2 NUMBER;
    vr3 NUMBER;
    vt NUMBER;
    vc0 VARCHAR2(1);
    vc1 VARCHAR2(1);
    vc2 VARCHAR2(1);
    vc3 VARCHAR2(1);
  BEGIN
    vt := p_number;
    IF p_number / vn3 > 1 THEN
      vr3 := floor(p_number / vn3);
      vt := vt - vr3*vn3;
    END IF;
    IF vt / vn2 > 1 THEN
      vr2 := floor(vt / vn2);
      vt := vt - vr2*vn2;
    END IF;
    IF vt / vn1 > 1 THEN
      vr1 := floor(vt / vn1);
      vt := vt - vr1*vn1;
    END IF;
    IF vt > 0 THEN
      vc0 := CHR(vt+64);
    END IF;
    vc1 := chr(vr1+64);
    vc2 := chr(vr2+64);
    vc3 := chr(vr3+64);
    v_result := vc3||vc2||vc1||vc0;
    RETURN v_result;
  END alphacode_atg_wrong;


  FUNCTION alphadecode(
    p_code IN VARCHAR2
  ) 
  RETURN NUMBER 
  IS
    c_max CONSTANT INTEGER := 26;
    v_power INTEGER;
    p_total INTEGER :=0;
  BEGIN    
    FOR i IN REVERSE 1 .. length(p_code) LOOP
      IF i = 1 THEN
        v_power := 1;
      ELSE
        v_power := power(c_max,i-1);
      END IF;
      p_total := p_total + ((ascii(substr(p_code,length(p_code)+1-i,1))-64)*v_power);   
    END LOOP;
    RETURN p_total;
  END alphadecode;


  FUNCTION alphadecode_range(
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
  END alphadecode_range;

END demo_string;
/
