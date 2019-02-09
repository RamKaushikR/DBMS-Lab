REM 1. Create a view named Blue_Flavor, which display the product details  
REM (product id,food, price) of Blueberry flavor.
create view Blue_Flavor as
select pid,food,price from products
where flavor = 'Blueberry';
select * from Blue_Flavor;
REM Updatable
select COLUMN_NAME,UPDATABLE from USER_UPDATABLE_COLUMNS 
where table_name = 'BLUE_FLAVOR';
REM Check Update 
insert into products
values('20-BC-C-12','Blueberry','Cake',10.12);
select * from Blue_Flavor;
REM Update 
update Blue_Flavor
set price = price+5
where food='Tart';
REM Delete 
delete from Blue_Flavor
where food = 'Cake';
select * from Blue_Flavor;

REM 2. Create a view named Cheap_Food, which display the details (product id, flavor, 
REM food, price) of products with price lesser than $1. Ensure that, the price of these 
REM food(s) should never rise above $1 through view.
create view Cheap_Food as
select * from products
where price < 1
with check option;
select * from Cheap_Food;
REM Updatable
select COLUMN_NAME,UPDATABLE from USER_UPDATABLE_COLUMNS 
where table_name = 'CHEAP_FOOD';
REM Check Update 
insert into products
values('20-BC-C-13','Blueberry','Cake',0.79);
select * from Cheap_Food;
REM Update
update Cheap_Food 
set price = (price+1)/3;
select * from Cheap_Food;
REM Delete 
delete from Cheap_Food
where food = 'Cake';
select * from Cheap_Food;

REM 3. Create a view called Hot_Food that show the product id and its quantity where the 
REM same product is ordered more than once in the same receipt.
create view Hot_Food as
select item,count(*) as Count from item_list 
group by rno,item
having count(*) > 1;
select * from Hot_Food;
REM UPDATABLE
select COLUMN_NAME,UPDATABLE from USER_UPDATABLE_COLUMNS 
where table_name = 'HOT_FOOD';
REM Check Update
insert into item_list values(73716, 6,'70-MAR');
select * from Hot_Food;
REM Update 
update Hot_Food 
set Count = Count+1 
where item = '46-11';
select * from Hot_Food;
REM Delete 
delete from Hot_Food 
where Count = 2;
select * from Hot_Food;

REM 4. Create a view named Pie_Food that will display the details (customer lname, flavor, 
REM	receipt number and date, ordinal) who had ordered the Pie food with receipt details.
create view Pie_Food as
select c.lname,p.flavor,r.rno,r.rdate,i.ordinal
from customers c,products p,receipts r,item_list i
where p.food = 'Pie' and c.cid = r.cid and i.item = p.pid and i.rno = r.rno;
select * from Pie_Food;
REM Updatable
select COLUMN_NAME,UPDATABLE from USER_UPDATABLE_COLUMNS 
where table_name = 'HOT_FOOD';
REM Check Update 
insert into Customers
values(23,'Ram','Kaushik');
insert into item_list
values(50660, 7,  '70-W');
select * from Pie_Food;

REM 5. Create a view Cheap_View from Cheap_Food that shows only the product id, flavor and food.
create view Cheap_View as 
select pid,flavor,food from Cheap_Food;
select * from Cheap_View;
REM Updatable
select COLUMN_NAME,UPDATABLE from USER_UPDATABLE_COLUMNS 
where table_name = 'CHEAP_VIEW';
REM Check Update
insert into Cheap_Food
values('20-BC-C-15','Blueberry','Cake',0.79);
select * from Cheap_View;
REM Update
update Cheap_View 
set flavor='Lemon' where food='Cake';
select * from Cheap_View;
REM Delete 
delete from Cheap_View
where pid='20-BC-C-15';
select * from Cheap_View;

REM 6. Create a sequence named Ordinal_No_Seq which generates the ordinal number 
REM starting from 1, increment by 1, to a maximum of 10. Include the options of cycle, 
REM cache and order. Use this sequence to populate the item_list table for a new order.
create sequence Ordinal_No_Seq
start with 1
increment by 1 
minvalue 1 
maxvalue 10
cycle
cache 5;
insert into Receipts values(69696, '28-Oct-2007', 15);
insert into item_list values(69696, Ordinal_No_Seq.nextval,  '70-TU');
insert into item_list values(69696, Ordinal_No_Seq.nextval,  '70-TU');
insert into item_list values(69696, Ordinal_No_Seq.nextval,  '70-TU');
insert into item_list values(69696, Ordinal_No_Seq.nextval,  '70-TU');
insert into item_list values(69696, Ordinal_No_Seq.nextval,  '70-TU');
insert into item_list values(69696, Ordinal_No_Seq.nextval,  '70-TU');
insert into item_list values(69696, Ordinal_No_Seq.nextval,  '70-TU');
insert into item_list values(69696, Ordinal_No_Seq.nextval,  '70-TU');
insert into item_list values(69696, Ordinal_No_Seq.nextval,  '70-TU');
insert into item_list values(69696, Ordinal_No_Seq.nextval,  '70-TU');
insert into item_list values(69696, Ordinal_No_Seq.nextval,  '70-TU');
select * from item_list
where item='70-TU' and rno=69696; 

REM 7. Create a synonym named Product_details for the item_list relation. Perform the 
REM DML operations on it.
create synonym Product_details for item_list;

REM 8. Drop all the above created database objects.
drop view Blue_Flavor;
drop view Cheap_Food;
drop view Hot_Food;
drop view Pie_Food;
drop view Cheap_View;
drop sequence Ordinal_No_Seq;
drop synonym Product_Details;