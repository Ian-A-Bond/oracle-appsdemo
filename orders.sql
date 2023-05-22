/*
** Copyright (c) 2022 Bond & Pollard Ltd. All rights reserved.  
** NAME   : orders.sql
**
** DESCRIPTION
**   Sales order report
** 
**------------------------------------------------------------------------------------------------------------------------------
** MODIFICATION HISTORY
**
** Date         Name          Description
**------------------------------------------------------------------------------------------------------------------------------
** 21/07/2022   Ian Bond       Created script
*/

CLEAR COLUMNS
CLEAR BREAKS
CLEAR COMPUTES

COLUMN ordid       HEADING 'Order ID'    FORMAT A8;
COLUMN ordref      HEADING 'Ord Ref'     FORMAT A10; 
COLUMN orderdate   HEADING 'Date Ordered'; 
COLUMN shipdate    HEADING 'To Ship'     FORMAT A12;
COLUMN commplan    HEADING 'Comm'        FORMAT A4; 
COLUMN total       HEADING 'Total'       FORMAT 999,999.99;
COLUMN custid      HEADING 'Cust'        FORMAT A6;
COLUMN name        HEADING 'Name'        FORMAT A15;
COLUMN ename       HEADING 'Rep'         FORMAT A10;
COLUMN itemid      HEADING 'Item'        FORMAT 999;
COLUMN prodid      HEADING 'Product'     FORMAT A7;
COLUMN descrip     HEADING 'Description' FORMAT A20;
COLUMN actualprice HEADING 'Price'       FORMAT 9,999.99;
COLUMN qty         HEADING 'Qty'         FORMAT 999,999;
COLUMN itemtot     HEADING 'Item Total'  FORMAT 999,999.99;

BREAK ON ordid SKIP 2 NODUP

COMPUTE SUM OF itemtot ON ordid

SET PAGESIZE 66
SET NEWPAGE 0
SET LINESIZE 132

TTITLE CENTER 'Bond and Pollard Limited' SKIP 1 -
  CENTER ======================== SKIP 1-
  LEFT 'Sales Order Report'  -
  RIGHT 'Page:' SQL.PNO SKIP 2
  
SELECT O.ordid,
       O.ordref,
       O.orderdate,
       O.shipdate,
       O.commplan,
       O.total,
       O.custid,
       C.name,
       E.ename,
       I.itemid,
       I.prodid,
       P.descrip,
       I.actualprice,
       I.qty,
       I.itemtot
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
