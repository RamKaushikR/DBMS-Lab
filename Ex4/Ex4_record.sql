SQL> @z:/Ex4/Ex4.sql
SQL> REM 1. Create a view named Blue_Flavor, which display the product details
SQL> REM (product id,food, price) of Blueberry flavor.
SQL> create view Blue_Flavor as
  2  select pid,food,price from products
  3  where flavor = 'Blueberry';

View created.

SQL> select * from Blue_Flavor;

PID             FOOD                 PRICE                                      
--------------- --------------- ----------                                      
90-BLU-11       Tart                  3.25                                      
51-BLU          Danish                1.15                                      

SQL> REM Updatable
SQL> select COLUMN_NAME,UPDATABLE from USER_UPDATABLE_COLUMNS
  2  where table_name = 'BLUE_FLAVOR';

COLUMN_NAME                    UPD                                              
------------------------------ ---                                              
PID                            YES                                              
FOOD                           YES                                              
PRICE                          YES                                              

SQL> REM Check Update
SQL> insert into products
  2  values('20-BC-C-12','Blueberry','Cake',10.12);

1 row created.

SQL> select * from Blue_Flavor;

PID             FOOD                 PRICE                                      
--------------- --------------- ----------                                      
90-BLU-11       Tart                  3.25                                      
51-BLU          Danish                1.15                                      
20-BC-C-12      Cake                 10.12                                      

SQL> REM Update
SQL> update Blue_Flavor
  2  set price = price+5
  3  where food='Tart';

1 row updated.

SQL> REM Delete
SQL> delete from Blue_Flavor
  2  where food = 'Cake';

1 row deleted.

SQL> select * from Blue_Flavor;

PID             FOOD                 PRICE                                      
--------------- --------------- ----------                                      
90-BLU-11       Tart                  8.25                                      
51-BLU          Danish                1.15                                      

SQL> REM 2. Create a view named Cheap_Food, which display the details (product id, flavor,
SQL> REM food, price) of products with price lesser than $1. Ensure that, the price of these
SQL> REM food(s) should never rise above $1 through view.
SQL> create view Cheap_Food as
  2  select * from products
  3  where price < 1
  4  with check option;

View created.

SQL> select * from Cheap_Food;

PID             FLAVOR          FOOD                 PRICE                      
--------------- --------------- --------------- ----------                      
70-LEM          Lemon           Cookie                 .79                      
70-W            Walnut          Cookie                 .79                      

SQL> REM Updatable
SQL> select COLUMN_NAME,UPDATABLE from USER_UPDATABLE_COLUMNS
  2  where table_name = 'CHEAP_FOOD';

COLUMN_NAME                    UPD                                              
------------------------------ ---                                              
PID                            YES                                              
FLAVOR                         YES                                              
FOOD                           YES                                              
PRICE                          YES                                              

SQL> REM Check Update
SQL> insert into products
  2  values('20-BC-C-13','Blueberry','Cake',0.79);

1 row created.

SQL> select * from Cheap_Food;

PID             FLAVOR          FOOD                 PRICE                      
--------------- --------------- --------------- ----------                      
70-LEM          Lemon           Cookie                 .79                      
70-W            Walnut          Cookie                 .79                      
20-BC-C-13      Blueberry       Cake                   .79                      

SQL> REM Update
SQL> update Cheap_Food
  2  set price = (price+1)/3;

3 rows updated.

SQL> select * from Cheap_Food;

PID             FLAVOR          FOOD                 PRICE                      
--------------- --------------- --------------- ----------                      
70-LEM          Lemon           Cookie               .5967                      
70-W            Walnut          Cookie               .5967                      
20-BC-C-13      Blueberry       Cake                 .5967                      

SQL> REM Delete
SQL> delete from Cheap_Food
  2  where food = 'Cake';

1 row deleted.

SQL> select * from Cheap_Food;

PID             FLAVOR          FOOD                 PRICE                      
--------------- --------------- --------------- ----------                      
70-LEM          Lemon           Cookie               .5967                      
70-W            Walnut          Cookie               .5967                      

SQL> REM 3. Create a view called Hot_Food that show the product id and its quantity where the
SQL> REM same product is ordered more than once in the same receipt.
SQL> create view Hot_Food as
  2  select item,count(*) as Count from item_list
  3  group by rno,item
  4  having count(*) > 1;

View created.

SQL> select * from Hot_Food;

ITEM                 COUNT                                                      
--------------- ----------                                                      
70-R                     2                                                      
90-APR-PF                2                                                      
50-APP                   2                                                      
51-ATW                   2                                                      
90-ALM-I                 2                                                      
90-BER-11                2                                                      
90-PEC-11                2                                                      
70-M-CH-DZ               2                                                      
46-11                    2                                                      
70-M-CH-DZ               2                                                      
90-CHR-11                2                                                      

ITEM                 COUNT                                                      
--------------- ----------                                                      
90-BLU-11                2                                                      
50-CHS                   2                                                      
70-M-CH-DZ               2                                                      
70-R                     2                                                      
90-APP-11                2                                                      
70-MAR                   2                                                      
50-APR                   2                                                      
51-BC                    2                                                      
50-ALM                   2                                                      

20 rows selected.

SQL> REM UPDATABLE
SQL> select COLUMN_NAME,UPDATABLE from USER_UPDATABLE_COLUMNS
  2  where table_name = 'HOT_FOOD';

COLUMN_NAME                    UPD                                              
------------------------------ ---                                              
ITEM                           NO                                               
COUNT                          NO                                               

SQL> REM Check Update
SQL> insert into item_list values(73716, 6,'70-MAR');

1 row created.

SQL> select * from Hot_Food;

ITEM                 COUNT                                                      
--------------- ----------                                                      
70-R                     2                                                      
90-APR-PF                2                                                      
50-APP                   2                                                      
51-ATW                   2                                                      
90-ALM-I                 2                                                      
90-BER-11                2                                                      
90-PEC-11                2                                                      
70-M-CH-DZ               2                                                      
46-11                    2                                                      
70-M-CH-DZ               2                                                      
90-CHR-11                2                                                      

ITEM                 COUNT                                                      
--------------- ----------                                                      
90-BLU-11                2                                                      
50-CHS                   2                                                      
70-M-CH-DZ               2                                                      
70-R                     2                                                      
90-APP-11                2                                                      
70-MAR                   2                                                      
50-APR                   2                                                      
51-BC                    2                                                      
50-ALM                   2                                                      

20 rows selected.

SQL> REM Update
SQL> update Hot_Food
  2  set Count = Count+1
  3  where item = '46-11';
update Hot_Food
       *
ERROR at line 1:
ORA-01732: data manipulation operation not legal on this view 


SQL> select * from Hot_Food;

ITEM                 COUNT                                                      
--------------- ----------                                                      
70-R                     2                                                      
90-APR-PF                2                                                      
50-APP                   2                                                      
51-ATW                   2                                                      
90-ALM-I                 2                                                      
90-BER-11                2                                                      
90-PEC-11                2                                                      
70-M-CH-DZ               2                                                      
46-11                    2                                                      
70-M-CH-DZ               2                                                      
90-CHR-11                2                                                      

ITEM                 COUNT                                                      
--------------- ----------                                                      
90-BLU-11                2                                                      
50-CHS                   2                                                      
70-M-CH-DZ               2                                                      
70-R                     2                                                      
90-APP-11                2                                                      
70-MAR                   2                                                      
50-APR                   2                                                      
51-BC                    2                                                      
50-ALM                   2                                                      

20 rows selected.

SQL> REM Delete
SQL> delete from Hot_Food
  2  where Count = 2;
delete from Hot_Food
            *
ERROR at line 1:
ORA-01732: data manipulation operation not legal on this view 

SQL> select * from Hot_Food;

ITEM                 COUNT                                                      
--------------- ----------                                                      
70-R                     2                                                      
90-APR-PF                2                                                      
50-APP                   2                                                      
51-ATW                   2                                                      
90-ALM-I                 2                                                      
90-BER-11                2                                                      
90-PEC-11                2                                                      
70-M-CH-DZ               2                                                      
46-11                    2                                                      
70-M-CH-DZ               2                                                      
90-CHR-11                2                                                      

ITEM                 COUNT                                                      
--------------- ----------                                                      
90-BLU-11                2                                                      
50-CHS                   2                                                      
70-M-CH-DZ               2                                                      
70-R                     2                                                      
90-APP-11                2                                                      
70-MAR                   2                                                      
50-APR                   2                                                      
51-BC                    2                                                      
50-ALM                   2                                                      

20 rows selected.

SQL> REM 4. Create a view named Pie_Food that will display the details (customer lname, flavor,
SQL> REM     receipt number and date, ordinal) who had ordered the Pie food with receipt details.
SQL> create view Pie_Food as
  2  select c.lname,p.flavor,r.rno,r.rdate,i.ordinal
  3  from customers c,products p,receipts r,item_list i
  4  where p.food = 'Pie' and c.cid = r.cid and i.item = p.pid and i.rno = r.rno;

View created.

SQL> select * from Pie_Food;

LNAME                FLAVOR                 RNO RDATE        ORDINAL            
-------------------- --------------- ---------- --------- ----------            
SOPKO                Apple                51991 17-OCT-07          1            
CRUZEN               Apple                44798 04-OCT-07          3            
SOPKO                Apple                29226 26-OCT-07          2            
LOGAN                Apple                66227 10-OCT-07          2            
HELING               Apple                53376 30-OCT-07          3            
LOGAN                Apple                39685 28-OCT-07          4            
HAFFERKAMP           Apple                50660 18-OCT-07          2            
CRUZEN               Apple                39109 02-OCT-07          1            
MESDAQ               Apple                98806 15-OCT-07          3            
SLINGLAND            Apple                47353 12-OCT-07          2            
SLINGLAND            Apple                87454 21-OCT-07          1            

LNAME                FLAVOR                 RNO RDATE        ORDINAL            
-------------------- --------------- ---------- --------- ----------            
ESPOSITA             Apple                48647 09-OCT-07          2            
ARNN                 Apple                11548 21-OCT-07          2            

13 rows selected.

SQL> REM Updatable
SQL> select COLUMN_NAME,UPDATABLE from USER_UPDATABLE_COLUMNS
  2  where table_name = 'PIE_FOOD';

COLUMN_NAME                    UPD
------------------------------ ---
LNAME                          NO
FLAVOR                         NO
RNO                            NO
RDATE                          NO
ORDINAL                        YES                                              

SQL> REM Check Update
SQL> insert into Customers
  2  values(23,'Ram','Kaushik');

1 row created.

SQL> insert into item_list
  2  values(50660, 7,  '70-W');

1 row created.

SQL> select * from Pie_Food;

LNAME                FLAVOR                 RNO RDATE        ORDINAL            
-------------------- --------------- ---------- --------- ----------            
SOPKO                Apple                51991 17-OCT-07          1            
CRUZEN               Apple                44798 04-OCT-07          3            
SOPKO                Apple                29226 26-OCT-07          2            
LOGAN                Apple                66227 10-OCT-07          2            
HELING               Apple                53376 30-OCT-07          3            
LOGAN                Apple                39685 28-OCT-07          4            
HAFFERKAMP           Apple                50660 18-OCT-07          2            
CRUZEN               Apple                39109 02-OCT-07          1            
MESDAQ               Apple                98806 15-OCT-07          3            
SLINGLAND            Apple                47353 12-OCT-07          2            
SLINGLAND            Apple                87454 21-OCT-07          1            

LNAME                FLAVOR                 RNO RDATE        ORDINAL            
-------------------- --------------- ---------- --------- ----------            
ESPOSITA             Apple                48647 09-OCT-07          2            
ARNN                 Apple                11548 21-OCT-07          2            

13 rows selected.
 
SQL> REM 5. Create a view Cheap_View from Cheap_Food that shows only the product id, flavor and food.
SQL> create view Cheap_View as
  2  select pid,flavor,food from Cheap_Food;

View created.

SQL> select * from Cheap_View;

PID             FLAVOR          FOOD                                            
--------------- --------------- ---------------                                 
70-LEM          Lemon           Cookie                                          
70-W            Walnut          Cookie                                          

SQL> REM Updatable
SQL> select COLUMN_NAME,UPDATABLE from USER_UPDATABLE_COLUMNS
  2  where table_name = 'CHEAP_VIEW';

COLUMN_NAME                    UPD                                              
------------------------------ ---                                              
PID                            YES                                              
FLAVOR                         YES                                              
FOOD                           YES                                              

SQL> REM Check Update
SQL> insert into Cheap_Food
  2  values('20-BC-C-15','Blueberry','Cake',0.79);

1 row created.

SQL> select * from Cheap_View;

PID             FLAVOR          FOOD                                            
--------------- --------------- ---------------                                 
70-LEM          Lemon           Cookie                                          
70-W            Walnut          Cookie                                          
20-BC-C-15      Blueberry       Cake                                            

SQL> REM Update
SQL> update Cheap_View
  2  set flavor='Lemon' where food='Cake';

1 row updated.

SQL> select * from Cheap_View;

PID             FLAVOR          FOOD                                            
--------------- --------------- ---------------                                 
70-LEM          Lemon           Cookie                                          
70-W            Walnut          Cookie                                          
20-BC-C-15      Lemon           Cake                                            

SQL> REM Delete
SQL> delete from Cheap_View
  2  where pid='20-BC-C-15';

1 row deleted.

SQL> select * from Cheap_View;

PID             FLAVOR          FOOD                                            
--------------- --------------- ---------------                                 
70-LEM          Lemon           Cookie                                          
70-W            Walnut          Cookie                                          

SQL> REM 6. Create a sequence named Ordinal_No_Seq which generates the ordinal number
SQL> REM starting from 1, increment by 1, to a maximum of 10. Include the options of cycle,
SQL> REM cache and order. Use this sequence to populate the item_list table for a new order.
SQL> create sequence Ordinal_No_Seq
  2  start with 1
  3  increment by 1
  4  minvalue 1
  5  maxvalue 10
  6  cycle
  7  cache 5;

Sequence created.

SQL> insert into Receipts values(69696, '28-Oct-2007', 15);

1 row created.

SQL> insert into item_list values(69696, Ordinal_No_Seq.nextval,  '70-TU');

1 row created.

SQL> insert into item_list values(69696, Ordinal_No_Seq.nextval,  '70-TU');

1 row created.

SQL> insert into item_list values(69696, Ordinal_No_Seq.nextval,  '70-TU');

1 row created.

SQL> insert into item_list values(69696, Ordinal_No_Seq.nextval,  '70-TU');

1 row created.

SQL> insert into item_list values(69696, Ordinal_No_Seq.nextval,  '70-TU');

1 row created.

SQL> insert into item_list values(69696, Ordinal_No_Seq.nextval,  '70-TU');

1 row created.

SQL> insert into item_list values(69696, Ordinal_No_Seq.nextval,  '70-TU');

1 row created.

SQL> insert into item_list values(69696, Ordinal_No_Seq.nextval,  '70-TU');

1 row created.

SQL> insert into item_list values(69696, Ordinal_No_Seq.nextval,  '70-TU');

1 row created.

SQL> insert into item_list values(69696, Ordinal_No_Seq.nextval,  '70-TU');
insert into item_list values(69696, Ordinal_No_Seq.nextval,  '70-TU')
                                    *
ERROR at line 1:
ORA-01438: value larger than specified precision allowed for this column 


SQL> insert into item_list values(69696, Ordinal_No_Seq.nextval,  '70-TU');
insert into item_list values(69696, Ordinal_No_Seq.nextval,  '70-TU')
*
ERROR at line 1:
ORA-00001: unique constraint (4125.I_PRIMKEY) violated 

SQL> select * from item_list
  2  where item='70-TU' and rno=69696;

       RNO    ORDINAL ITEM                                                      
---------- ---------- ---------------                                           
     69696          1 70-TU                                                     
     69696          2 70-TU                                                     
     69696          3 70-TU                                                     
     69696          4 70-TU                                                     
     69696          5 70-TU                                                     
     69696          6 70-TU                                                     
     69696          7 70-TU                                                     
     69696          8 70-TU                                                     
     69696          9 70-TU                                                     

9 rows selected.

SQL> REM 7. Create a synonym named Product_details for the item_list relation. Perform the
SQL> REM DML operations on it.
SQL> create synonym Product_details for item_list;

Synonym created.

SQL> insert into Product_details values(41963,5,'45-VA');

1 row created.

SQL> select * from Product_details where rno = 41963;

       RNO    ORDINAL ITEM                                                      
---------- ---------- ---------------                                           
     41963          1 50-ALM                                                    
     41963          2 90-CH-PF                                                  
     41963          5 45-VA                                                     

SQL> delete from Product_details where rno = 41963;

3 rows deleted.

SQL> select * from Product_details where rno = 41963;

no rows selected
 
SQL> REM 8. Drop all the above created database objects.
SQL> drop view Blue_Flavor;

View dropped.

SQL> drop view Cheap_Food;

View dropped.

SQL> drop view Hot_Food;

View dropped.

SQL> drop view Pie_Food;

View dropped.

SQL> drop view Cheap_View;

View dropped.

SQL> drop sequence Ordinal_No_Seq;

Sequence dropped.

SQL> drop synonym Product_Details;

Synonym dropped.

SQL> spool off
