SQL> @z:/Ex7/Ex7.sql
SQL> REM Drop amount from receipts
SQL> alter table receipts
  2  drop column amount;

Table altered.

SQL> insert into products values('50-klmop','almond','twist',6.12);

1 row created.

SQL> REM 1  The combination of Flavor and Food determines the product id. Hence, while
SQL> REM    inserting a new instance into the Products relation, ensure that the same combination
SQL> REM    of Flavor and Food is not already available.
SQL> set serveroutput on;
SQL> create or replace trigger combination
  2  before insert on products for each row
  3  declare
  4  	     p_food products.food%type;
  5  	     p_flavor products.flavor%type;
  6  	     cursor c1 is select food,flavor from products;
  7  begin
  8  	     open c1;
  9  	     loop
 10  		     fetch c1 into p_food,p_flavor;
 11  	     if c1%found then
 12  		     if p_food = :new.food and p_flavor = :new.flavor then
 13  				     raise_application_error(-20000,'error:combination present');
 14  			     end if;
 15  		     else
 16  			     exit;
 17  	     end if;
 18  	     end loop;
 19  end;
 20  /

Trigger created.

SQL> insert into products values('50-klmop','almond','twist',6.12);
insert into products values('50-klmop','almond','twist',6.12)
            *
ERROR at line 1:
ORA-20000: error:combination present
ORA-06512: at "4125.COMBINATION", line 11
ORA-04088: error during execution of trigger '4125.COMBINATION'

SQL> REM 2. While entering an item into the item_list relation, update the amount in Receipts with
SQL> REM the total amount for that receipt number.
SQL> alter table receipts
  2  add amount float default 0;

Table altered.

SQL> create view tot_price as
  2  select i.rno as rno,sum(p.price) as price from item_list i join products p
  3  on i.item=p.pid group by i.rno;

View created.

SQL> create view temp_view as
  2  select r.rno as rno,r.rdate as rdate,r.cid as cid,t.price as amount
  3  from receipts r left join tot_price t
  4  on r.rno=t.rno;

View created.

SQL> update receipts r
  2  set amount=(select amount from temp_view
  3  where rno=r.rno);

200 rows updated.

SQL> create or replace trigger q2
  2  before insert on item_list for each row
  3  declare
  4  	     price products.price%type;
  5  begin
  6  	     select p.price into price
  7  	     from products p where p.pid=:new.item;
  8  	     update receipts
  9  	     set amount=amount+price
 10  	     where :new.rno=rno;
 11  end;
 12  /

Trigger created.

SQL> select * from receipts where rno=46674;

       RNO RDATE            CID     AMOUNT                                      
---------- --------- ---------- ----------                                      
     46674 29-OCT-07         15       1.95                                      

SQL> insert into item_list values(46674,2,'70-R');

1 row created.

SQL> select * from receipts where rno=46674;

       RNO RDATE            CID     AMOUNT                                      
---------- --------- ---------- ----------                                      
     46674 29-OCT-07         15       3.04                                      

SQL> REM 3 Implement the following constraints for Item_list relation:
SQL> REM a. A receipt can contain a maximum of five items only.
SQL> REM b. A receipt should not allow an item to be purchased more than thrice.
SQL> create or replace trigger item_a
  2  before insert or update on item_list for each row
  3  begin
  4  	     if :new.ordinal>5 then
  5  		     raise_application_error(-20002,:new.rno||'has more than 5 item');
  6  	     end if;
  7  end;
  8  /

Trigger created.

SQL> insert into item_list values(52761,6,'70-TU');
insert into item_list values(52761,6,'70-TU')
            *
ERROR at line 1:
ORA-20002: 52761has more than 5 item 
ORA-06512: at "4125.ITEM_A", line 3 
ORA-04088: error during execution of trigger '4125.ITEM_A' 


SQL> create or replace trigger item_b
  2  before insert or update on item_list for each row
  3  declare
  4  	     rnum item_list.rno%type;
  5  	     item_1 item_list.item%type;
  6  	     total int;
  7  	     cursor c3_b is
  8  	     select rno,item,count(*) from item_list
  9  	     group by (rno,item) having count(*) > 1;
 10  begin
 11  	     open c3_b;
 12  	     loop
 13  		     fetch c3_b into rnum,item_1,total;
 14  		     if c3_b%found then
 15  			     if rnum = :new.rno and item_1 = :new.item then
 16  				     raise_application_error(-20003,item_1||' will be purchased more than thrice in '||rnum);
 17  			     end if;
 18  		     else
 19  			     exit;
 20  		     end if;
 21  	     end loop;
 22  end;
 23  /

Trigger created.

SQL> insert into item_list values(41028, 2,  '90-BER-11');

1 row created.

SQL> insert into item_list values(41028, 3,  '90-BER-11');
insert into item_list values(41028, 3,  '90-BER-11')
            *
ERROR at line 1:
ORA-20003: 90-BER-11 will be purchased more than thrice in 41028
ORA-06512: at "4125.ITEM_B", line 14
ORA-04088: error during execution of trigger '4125.ITEM_B'

SQL> spool off;
