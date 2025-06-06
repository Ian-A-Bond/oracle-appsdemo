/*
** Copyright (c) 2022 Bond & Pollard Ltd. All rights reserved.  
** NAME   : seed_data.sql
**
** DESCRIPTION
**   This script loads data into the database.
**
** INSTRUCTIONS
**   1. Run this script ONCE to load data into the database.
** 
**------------------------------------------------------------------------------------------------------------------------------
** MODIFICATION HISTORY
**
** Date         Name          Description
**------------------------------------------------------------------------------------------------------------------------------
** 30/06/2022   Ian Bond      Created script
*/

  SET TERMOUT ON
  SET ECHO OFF

/*
 *****************************************
 * Set the schema name and password here *
 *****************************************
*/
  DEFINE v_dbservice = "&1"
  DEFINE v_dbconnect = "&2"
  DEFINE v_app_owner = "&3"
  DEFINE v_password  = "&4"

  PROMPT Load data into &v_app_owner in database &v_dbservice

 
/*
** Connect to the database
*/
  CONNECT &v_app_owner/&v_password@&v_dbconnect


/*
** Load data into tables
*/

/*
** DEPT table data load
*/

INSERT INTO dept VALUES (10,'ACCOUNTING','NEW YORK');
INSERT INTO dept VALUES (20,'RESEARCH','DALLAS');
INSERT INTO dept VALUES (30,'SALES','CHICAGO');
INSERT INTO dept VALUES (40,'OPERATIONS','BOSTON');


/*
** EMP table data load
*/

INSERT INTO emp VALUES (7839,'KING','PRESIDENT',NULL,'17-NOV-1981',5000,NULL,10);
INSERT INTO emp VALUES (7698,'BLAKE','MANAGER',7839,'1-MAY-1981',2850,NULL,30);
INSERT INTO emp VALUES (7782,'CLARK','MANAGER',7839,'9-JUN-1981',2450,NULL,10);
INSERT INTO emp VALUES (7566,'JONES','MANAGER',7839,'2-APR-1981',2975,NULL,20);
INSERT INTO emp VALUES (7654,'MARTIN','SALESMAN',7698,'28-SEP-1981',1250,1400,30);
INSERT INTO emp VALUES (7499,'ALLEN','SALESMAN',7698,'20-FEB-1981',1600,300,30);
INSERT INTO emp VALUES (7844,'TURNER','SALESMAN',7698,'8-SEP-1981',1500,0,30);
INSERT INTO emp VALUES (7900,'JAMES','CLERK',7698,'3-DEC-1981',950,NULL,30);
INSERT INTO emp VALUES (7521,'WARD','SALESMAN',7698,'22-FEB-1981',1250,500,30);
INSERT INTO emp VALUES (7902,'FORD','ANALYST',7566,'3-DEC-1981',3000,NULL,20);
INSERT INTO emp VALUES (7369,'SMITH','CLERK',7902,'17-DEC-1980',800,NULL,20);
INSERT INTO emp VALUES (7788,'SCOTT','ANALYST',7566,'09-DEC-1982',3000,NULL,20);
INSERT INTO emp VALUES (7876,'ADAMS','CLERK',7788,'12-JAN-1983',1100,NULL,20);
INSERT INTO emp VALUES (7934,'MILLER','CLERK',7782,'23-JAN-1982',1300,NULL,10);

  
/*
** SALGRADE table data load
*/

INSERT INTO salgrade VALUES (1,700,1200);
INSERT INTO salgrade VALUES (2,1201,1400);
INSERT INTO salgrade VALUES (3,1401,2000);
INSERT INTO salgrade VALUES (4,2001,3000);
INSERT INTO salgrade VALUES (5,3001,9999);


/*
** CUSTOMER table data load
*/

INSERT INTO customer (ZIP, STATE, REPID, PHONE, NAME, CUSTID, CREDITLIMIT, CITY, AREA, ADDRESS, COMMENTS) VALUES ('96711', 'CA', '7844', '598-6609', 'JOCKSPORTS', '100', '5000', 'BELMONT', '415', '345 VIEWRIDGE', 'Very friendly people to work with -- sales rep likes to be called Mike.');
INSERT INTO customer (ZIP, STATE, REPID, PHONE, NAME, CUSTID, CREDITLIMIT, CITY, AREA, ADDRESS, COMMENTS) VALUES ('94061', 'CA', '7521', '368-1223', 'TKB SPORT SHOP','101', '10000', 'REDWOOD CITY', '415', '490 BOLI RD.', 'Rep called 5/8 about change in order - contact shipping.');
INSERT INTO customer (ZIP, STATE, REPID, PHONE, NAME, CUSTID, CREDITLIMIT, CITY, AREA, ADDRESS, COMMENTS) VALUES ('95133', 'CA', '7654', '644-3341','VOLLYRITE', '102','7000', 'BURLINGAME', '415', '9722 HAMILTON','Company doing heavy promotion beginning 10/89. Prepare for large orders during winter.');
INSERT INTO customer (ZIP, STATE, REPID, PHONE, NAME, CUSTID, CREDITLIMIT, CITY, AREA, ADDRESS, COMMENTS) VALUES ('97544', 'CA', '7521', '677-9312', 'JUST TENNIS','103', '3000', 'BURLINGAME', '415', 'HILLVIEW MALL', 'Contact rep about new line of tennis rackets.');
INSERT INTO customer (ZIP, STATE, REPID, PHONE, NAME, CUSTID, CREDITLIMIT, CITY, AREA, ADDRESS, COMMENTS) VALUES ('93301', 'CA', '7499', '996-2323','EVERY MOUNTAIN','104', '10000', 'CUPERTINO', '408', '574 SURRY RD.', 'Customer with high market share (23%) due to aggressive advertising.');
INSERT INTO customer (ZIP, STATE, REPID, PHONE, NAME, CUSTID, CREDITLIMIT, CITY, AREA, ADDRESS, COMMENTS) VALUES ('91003', 'CA', '7844', '376-9966', 'K + T SPORTS','105', '5000', 'SANTA CLARA', '408', '3476 EL PASEO','Tends to order large amounts of merchandise at once. Accounting is considering raising their credit limit. Usually pays on time.');
INSERT INTO customer (ZIP, STATE, REPID, PHONE, NAME, CUSTID, CREDITLIMIT, CITY, AREA, ADDRESS, COMMENTS) VALUES ('94301', 'CA', '7521', '364-9777','SHAPE UP','106','6000', 'PALO ALTO', '415', '908 SEQUOIA','Support intensive. Orders small amounts (< 800) of merchandise at a time.');
INSERT INTO customer (ZIP, STATE, REPID, PHONE, NAME, CUSTID, CREDITLIMIT, CITY, AREA, ADDRESS, COMMENTS) VALUES ('93301', 'CA', '7499', '967-4398','WOMENS SPORTS','107', '10000', 'SUNNYVALE', '408', 'VALCO VILLAGE','First sporting goods store geared exclusively towards women. Unusual promotional style and very willing to take chances towards new products!');
INSERT INTO customer (ZIP, STATE, REPID, PHONE, NAME, CUSTID, CREDITLIMIT, CITY, AREA, ADDRESS, COMMENTS) VALUES ('55649', 'MN', '7844', '566-9123','NORTH WOODS HEALTH AND FITNESS SUPPLY CENTER','108', '8000', 'HIBBING', '612', '98 LONE PINE WAY', '');


/*
** PRODUCT table data load
*/

INSERT INTO product (prodid, descrip) VALUES ('100860', 'ACE TENNIS RACKET I');
INSERT INTO product (prodid, descrip) VALUES ('100861', 'ACE TENNIS RACKET II');
INSERT INTO product (prodid, descrip) VALUES ('100870', 'ACE TENNIS BALLS-3 PACK');
INSERT INTO product (prodid, descrip) VALUES ('100871', 'ACE TENNIS BALLS-6 PACK');
INSERT INTO product (prodid, descrip) VALUES ('100890', 'ACE TENNIS NET');
INSERT INTO product (prodid, descrip) VALUES ('101860', 'SP TENNIS RACKET');
INSERT INTO product (prodid, descrip) VALUES ('101863', 'SP JUNIOR RACKET');
INSERT INTO product (prodid, descrip) VALUES ('102130', 'RH: "GUIDE TO TENNIS"');
INSERT INTO product (prodid, descrip) VALUES ('200376', 'SB ENERGY BAR-6 PACK');
INSERT INTO product (prodid, descrip) VALUES ('200380', 'SB VITA SNACK-6 PACK');


/*
** ORD table data load
*/

INSERT INTO ord (total, shipdate, ordid, orderdate, custid, commplan) VALUES ('2.4', '30-MAY-1986', '601', '01-MAY-1986', '106', 'A');
INSERT INTO ord (total, shipdate, ordid, orderdate, custid, commplan) VALUES ('56', '20-JUN-1986', '602', '05-JUN-1986', '102', 'B');
INSERT INTO ord (total, shipdate, ordid, orderdate, custid, commplan) VALUES ('224', '05-JUN-1986', '603', '05-JUN-1986', '102', '');
INSERT INTO ord (total, shipdate, ordid, orderdate, custid, commplan) VALUES ('698', '30-JUN-1986', '604', '15-JUN-1986', '106', 'A');
INSERT INTO ord (total, shipdate, ordid, orderdate, custid, commplan) VALUES ('8324', '30-JUL-1986', '605', '14-JUL-1986', '106', 'A');
INSERT INTO ord (total, shipdate, ordid, orderdate, custid, commplan) VALUES ('3.4', '30-JUL-1986', '606', '14-JUL-1986', '100', 'A');
INSERT INTO ord (total, shipdate, ordid, orderdate, custid, commplan) VALUES ('5.6', '18-JUL-1986', '607', '18-JUL-1986', '104', 'C');
INSERT INTO ord (total, shipdate, ordid, orderdate, custid, commplan) VALUES ('35.2', '25-JUL-1986', '608', '25-JUL-1986', '104', 'C');
INSERT INTO ord (total, shipdate, ordid, orderdate, custid, commplan) VALUES ('97.5', '15-AUG-1986', '609', '01-AUG-1986', '100', 'B');
INSERT INTO ord (total, shipdate, ordid, orderdate, custid, commplan) VALUES ('101.4', '08-JAN-1987', '610', '07-JAN-1987', '101', 'A');
INSERT INTO ord (total, shipdate, ordid, orderdate, custid, commplan) VALUES ('45', '11-JAN-1987', '611', '11-JAN-1987', '102', 'B');
INSERT INTO ord (total, shipdate, ordid, orderdate, custid, commplan) VALUES ('5860', '20-JAN-1987', '612', '15-JAN-1987', '104', 'C');
INSERT INTO ord (total, shipdate, ordid, orderdate, custid, commplan) VALUES ('6400', '01-FEB-1987', '613', '01-FEB-1987', '108', '');
INSERT INTO ord (total, shipdate, ordid, orderdate, custid, commplan) VALUES ('23940', '05-FEB-1987', '614', '01-FEB-1987', '102', '');
INSERT INTO ord (total, shipdate, ordid, orderdate, custid, commplan) VALUES ('710', '06-FEB-1987', '615', '01-FEB-1987', '107', '');
INSERT INTO ord (total, shipdate, ordid, orderdate, custid, commplan) VALUES ('764', '10-FEB-1987', '616', '03-FEB-1987', '103', '');
INSERT INTO ord (total, shipdate, ordid, orderdate, custid, commplan) VALUES ('46370', '03-MAR-1987', '617', '05-FEB-1987', '105', '');
INSERT INTO ord (total, shipdate, ordid, orderdate, custid, commplan) VALUES ('3510.5', '06-MAR-1987', '618', '15-FEB-1987', '102', 'A');
INSERT INTO ord (total, shipdate, ordid, orderdate, custid, commplan) VALUES ('1260', '04-FEB-1987', '619', '22-FEB-1987', '104', '');
INSERT INTO ord (total, shipdate, ordid, orderdate, custid, commplan) VALUES ('4450', '12-MAR-1987', '620', '12-MAR-1987', '100', '');
INSERT INTO ord (total, shipdate, ordid, orderdate, custid, commplan) VALUES ('730', '01-JAN-1987', '621', '15-MAR-1987', '100', 'A');

/*
** ITEM table data load
*/

INSERT INTO item ( qty , prodid , ordid , itemtot , itemid , actualprice) VALUES ( '1', '200376', '601', '2.4', '1', '2.4');

INSERT INTO item ( qty , prodid , ordid , itemtot , itemid , actualprice) VALUES ( '20', '100870', '602', '56', '1', '2.8');

INSERT INTO item ( qty , prodid , ordid , itemtot , itemid , actualprice) VALUES ( '4', '100860', '603', '224', '1', '56');

INSERT INTO item ( qty , prodid , ordid , itemtot , itemid , actualprice) VALUES ( '3', '100890', '604', '174', '1', '58');
INSERT INTO item ( qty , prodid , ordid , itemtot , itemid , actualprice) VALUES ( '2', '100861', '604', '84', '2', '42');
INSERT INTO item ( qty , prodid , ordid , itemtot , itemid , actualprice) VALUES ( '10', '100860', '604', '440', '3', '44');

INSERT INTO item ( qty , prodid , ordid , itemtot , itemid , actualprice) VALUES ('100', '100861', '605', '4500', '1', '45');
INSERT INTO item ( qty , prodid , ordid , itemtot , itemid , actualprice) VALUES ('500', '100870', '605', '1400', '2', '2.8');
INSERT INTO item ( qty , prodid , ordid , itemtot , itemid , actualprice) VALUES ('5', '100890', '605', '290', '3', '58');
INSERT INTO item ( qty , prodid , ordid , itemtot , itemid , actualprice) VALUES ('50', '101860', '605', '1200', '4', '24');
INSERT INTO item ( qty , prodid , ordid , itemtot , itemid , actualprice) VALUES ('100', '101863', '605', '900', '5', '9');
INSERT INTO item ( qty , prodid , ordid , itemtot , itemid , actualprice) VALUES ('10', '102130', '605', '34', '6', '3.4');

INSERT INTO item ( qty , prodid , ordid , itemtot , itemid , actualprice) VALUES ('1', '102130', '606', '3.4', '1', '3.4');

INSERT INTO item ( qty , prodid , ordid , itemtot , itemid , actualprice) VALUES ('1', '100871', '607', '5.6', '1', '5.6');

INSERT INTO item ( qty , prodid , ordid , itemtot , itemid , actualprice) VALUES ('1', '101860', '608', '24', '1', '24');
INSERT INTO item ( qty , prodid , ordid , itemtot , itemid , actualprice) VALUES ('2', '100871', '608', '11.2', '2', '5.6');

INSERT INTO item ( qty , prodid , ordid , itemtot , itemid , actualprice) VALUES ('1', '100861', '609', '35', '1', '35');
INSERT INTO item ( qty , prodid , ordid , itemtot , itemid , actualprice) VALUES ('5', '100870', '609', '12.5', '2', '2.5');
INSERT INTO item ( qty , prodid , ordid , itemtot , itemid , actualprice) VALUES ('1', '100890', '609', '50', '3', '50');

INSERT INTO item ( qty , prodid , ordid , itemtot , itemid , actualprice) VALUES ( '1', '100860', '610', '35', '1', '35');
INSERT INTO item ( qty , prodid , ordid , itemtot , itemid , actualprice) VALUES ( '3', '100870', '610', '8.4', '2', '2.8');
INSERT INTO item ( qty , prodid , ordid , itemtot , itemid , actualprice) VALUES ( '1', '100890', '610', '58', '3', '58');

INSERT INTO item ( qty , prodid , ordid , itemtot , itemid , actualprice) VALUES ( '1', '100861', '611', '45', '1', '45');

INSERT INTO item ( qty , prodid , ordid , itemtot , itemid , actualprice) VALUES ( '100', '100860', '612', '3000', '1', '30');
INSERT INTO item ( qty , prodid , ordid , itemtot , itemid , actualprice) VALUES ( '20', '100861', '612', '810', '2', '40.5');
INSERT INTO item ( qty , prodid , ordid , itemtot , itemid , actualprice) VALUES ('150', '101863', '612', '1500', '3', '10');
INSERT INTO item ( qty , prodid , ordid , itemtot , itemid , actualprice) VALUES ('100', '100871', '612', '550', '4', '5.5');

INSERT INTO item ( qty , prodid , ordid , itemtot , itemid , actualprice) VALUES ( '100', '100871', '613', '560', '1', '5.6');
INSERT INTO item ( qty , prodid , ordid , itemtot , itemid , actualprice) VALUES ('200', '101860', '613', '4800', '2', '24');
INSERT INTO item ( qty , prodid , ordid , itemtot , itemid , actualprice) VALUES ('150', '200380', '613', '600', '3', '4');
INSERT INTO item ( qty , prodid , ordid , itemtot , itemid , actualprice) VALUES ( '200', '200376', '613', '440', '4', '2.2');

INSERT INTO item ( qty , prodid , ordid , itemtot , itemid , actualprice) VALUES ( '444', '100860', '614', '15540', '1', '35');
INSERT INTO item ( qty , prodid , ordid , itemtot , itemid , actualprice) VALUES ( '1000', '100870', '614', '2800', '2', '2.8');
INSERT INTO item ( qty , prodid , ordid , itemtot , itemid , actualprice) VALUES ('1000', '100871', '614', '5600', '3', '5.6');

INSERT INTO item ( qty , prodid , ordid , itemtot , itemid , actualprice) VALUES ('4', '100861', '615', '180', '1', '45');
INSERT INTO item ( qty , prodid , ordid , itemtot , itemid , actualprice) VALUES ('100', '100870', '615', '280', '2', '2.8');
INSERT INTO item ( qty , prodid , ordid , itemtot , itemid , actualprice) VALUES ('50', '100871', '615', '250', '3', '5');

INSERT INTO item ( qty , prodid , ordid , itemtot , itemid , actualprice) VALUES ('10', '100861', '616', '450', '1', '45');
INSERT INTO item ( qty , prodid , ordid , itemtot , itemid , actualprice) VALUES ('50', '100870', '616', '140', '2', '2.8');
INSERT INTO item ( qty , prodid , ordid , itemtot , itemid , actualprice) VALUES ('2', '100890', '616', '116', '3', '58');
INSERT INTO item ( qty , prodid , ordid , itemtot , itemid , actualprice) VALUES ('10', '102130', '616', '34', '4', '3.4');
INSERT INTO item ( qty , prodid , ordid , itemtot , itemid , actualprice) VALUES ('10', '200376' , '616', '24', '5', '2.4');

INSERT INTO item ( qty , prodid , ordid , itemtot , itemid , actualprice) VALUES ('50', '100860', '617', '1750', '1', '35');
INSERT INTO item ( qty , prodid , ordid , itemtot , itemid , actualprice) VALUES ('100', '100861', '617', '4500', '2', '45');
INSERT INTO item ( qty , prodid , ordid , itemtot , itemid , actualprice) VALUES ('500', '100870', '617', '1400', '3', '2.8');
INSERT INTO item ( qty , prodid , ordid , itemtot , itemid , actualprice) VALUES ('500', '100871', '617', '2800', '4', '5.6');
INSERT INTO item ( qty , prodid , ordid , itemtot , itemid , actualprice) VALUES ('500', '100890', '617', '29000', '5', '58');
INSERT INTO item ( qty , prodid , ordid , itemtot , itemid , actualprice) VALUES ('100', '101860', '617', '2400', '6', '24');
INSERT INTO item ( qty , prodid , ordid , itemtot , itemid , actualprice) VALUES ('200', '101863', '617', '2500', '7', '12.5');
INSERT INTO item ( qty , prodid , ordid , itemtot , itemid , actualprice) VALUES ('100', '102130', '617', '340', '8', '3.4');
INSERT INTO item ( qty , prodid , ordid , itemtot , itemid , actualprice) VALUES ('200', '200376', '617', '480', '9', '2.4');
INSERT INTO item ( qty , prodid , ordid , itemtot , itemid , actualprice) VALUES ('300', '200380', '617', '1200', '10', '4');

INSERT INTO item ( qty , prodid , ordid , itemtot , itemid , actualprice) VALUES ('23', '100860', '618', '805', '1', '35');
INSERT INTO item ( qty , prodid , ordid , itemtot , itemid , actualprice) VALUES ('50', '100861', '618', '2255.5', '2', '45.11');
INSERT INTO item ( qty , prodid , ordid , itemtot , itemid , actualprice) VALUES ('10', '100870', '618', '450', '3', '45');

INSERT INTO item ( qty , prodid , ordid , itemtot , itemid , actualprice) VALUES ('100', '200380', '619', '400', '1', '4');
INSERT INTO item ( qty , prodid , ordid , itemtot , itemid , actualprice) VALUES ('100', '200376', '619', '240', '2', '2.4');
INSERT INTO item ( qty , prodid , ordid , itemtot , itemid , actualprice) VALUES ('100', '102130', '619', '340', '3', '3.4');
INSERT INTO item ( qty , prodid , ordid , itemtot , itemid , actualprice) VALUES ('50', '100871', '619', '280', '4', '5.6');

INSERT INTO item ( qty , prodid , ordid , itemtot , itemid , actualprice) VALUES ('10', '100860', '620', '350', '1', '35');
INSERT INTO item ( qty , prodid , ordid , itemtot , itemid , actualprice) VALUES ('1000', '200376', '620', '2400', '2', '2.4');
INSERT INTO item ( qty , prodid , ordid , itemtot , itemid , actualprice) VALUES ('500', '102130', '620', '1700', '3', '3.4');

INSERT INTO item ( qty , prodid , ordid , itemtot , itemid , actualprice) VALUES ('10', '100861', '621', '450', '1', '45');
INSERT INTO item ( qty , prodid , ordid , itemtot , itemid , actualprice) VALUES ('100', '100870', '621', '280', '2', '2.8');


/*
** PRICE table data load
*/

INSERT INTO price (stdprice, startdate, prodid, minprice, enddate) VALUES ('30', '01-JAN-1985', '100860', '24', '31-DEC-1985');
INSERT INTO price (stdprice, startdate, prodid, minprice, enddate) VALUES ('32', '01-JAN-1986', '100860', '25.6', '31-MAY-1986');
INSERT INTO price (stdprice, startdate, prodid, minprice, enddate) VALUES ('35', '01-JUN-1986', '100860', '28', '');

INSERT INTO price (stdprice, startdate, prodid, minprice, enddate) VALUES ('39', '01-JAN-1985', '100861', '31.2', '31-DEC-1985');
INSERT INTO price (stdprice, startdate, prodid, minprice, enddate) VALUES ('42', '01-JAN-1986', '100861', '33.6', '31-MAY-1986');
INSERT INTO price (stdprice, startdate, prodid, minprice, enddate) VALUES ('45', '01-JUN-1986', '100861', '36', '');

INSERT INTO price (stdprice, startdate, prodid, minprice, enddate) VALUES ('2.4', '01-JAN-1985', '100870', '1.9', '01-DEC-1985');
INSERT INTO price (stdprice, startdate, prodid, minprice, enddate) VALUES ('2.8', '01-JAN-1986', '100870', '2.4', '');


INSERT INTO price (stdprice, startdate, prodid, minprice, enddate) VALUES ('4.8', '01-JAN-1985', '100871', '3.2', '01-DEC-1985');
INSERT INTO price (stdprice, startdate, prodid, minprice, enddate) VALUES ('5.6', '01-JAN-1986', '100871', '4.8', '');

-- Deliberate error: enddate before startdate. No price available for orders prior to 1 Jan 1985
INSERT INTO price (stdprice, startdate, prodid, minprice, enddate) VALUES ('54', '01-JUN-1984', '100890', '40.5', '31-MAY-1984');
INSERT INTO price (stdprice, startdate, prodid, minprice, enddate) VALUES ('58', '01-JAN-1985', '100890', '46.4', '');

INSERT INTO price (stdprice, startdate, prodid, minprice, enddate) VALUES ('24', '15-FEB-1985', '101860', '18', '');

INSERT INTO price (stdprice, startdate, prodid, minprice, enddate) VALUES ('12.5', '15-FEB-1985', '101863', '9.4', '');

INSERT INTO price (stdprice, startdate, prodid, minprice, enddate) VALUES ('3.4', '18-AUG-1985', '102130', '2.8', '');

INSERT INTO price (stdprice, startdate, prodid, minprice, enddate) VALUES ('2.4', '15-NOV-1986', '200376', '1.75', '');

INSERT INTO price (stdprice, startdate, prodid, minprice, enddate) VALUES ('4', '15-NOV-1986', '200380', '3.2', '');


/*
** COUNTRY table data load
*/

INSERT INTO country (country_id, country_name)
  VALUES ('UK','United Kingdom');

INSERT INTO country (country_id, country_name)
  VALUES ('US','United States of America');
  
INSERT INTO country (country_id, country_name)
  VALUES ('FR','France');
  
INSERT INTO country (country_id, country_name)
  VALUES ('XX','TEST DATA');

/*
** COUNTRY_HOLIDAY table data load
** UK National Holidays 2022
*/


INSERT INTO country_holiday (country_id, year_no, holiday_date)
  VALUES ('UK',2022,'01-JAN-2022');
  
INSERT INTO country_holiday (country_id, year_no, holiday_date)
  VALUES ('UK',2022,'03-JAN-2022');
  
INSERT INTO country_holiday (country_id, year_no, holiday_date)
  VALUES ('UK',2022,'15-APR-2022');
 
INSERT INTO country_holiday (country_id, year_no, holiday_date)
  VALUES ('UK',2022,'18-APR-2022');
  
INSERT INTO country_holiday (country_id, year_no, holiday_date)
  VALUES ('UK',2022,'02-MAY-2022');
  
INSERT INTO country_holiday (country_id, year_no, holiday_date)
  VALUES ('UK',2022,'02-JUN-2022');
  
INSERT INTO country_holiday (country_id, year_no, holiday_date)
  VALUES ('UK',2022,'03-JUN-2022');

INSERT INTO country_holiday (country_id, year_no, holiday_date)
  VALUES ('UK',2022,'29-AUG-2022');
  
INSERT INTO country_holiday (country_id, year_no, holiday_date)
  VALUES ('UK',2022,'25-DEC-2022');
  
INSERT INTO country_holiday (country_id, year_no, holiday_date)
  VALUES ('UK',2022,'26-DEC-2022');
  
INSERT INTO country_holiday (country_id, year_no, holiday_date)
  VALUES ('UK',2022,'27-DEC-2022');


/*
** APPSEVERITY table data load
*/

INSERT INTO appseverity (severity, severity_desc)
  VALUES ('I','Information');
  
INSERT INTO appseverity (severity, severity_desc)
  VALUES ('E','Error');
  
INSERT INTO appseverity (severity, severity_desc)
  VALUES ('W','Warning');
  
/*
 ***************************
 * Commit database changes *
 ***************************
*/

COMMIT;

/*
** End of script
*/

