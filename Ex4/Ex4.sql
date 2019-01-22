REM 1. Create a view named Blue_Flavor, which display the product details  
REM (product id,food, price) of Blueberry flavor.
create view Blue_Flavor as
select pid,food,price from products
where flavor = 'Blueberry';
select * from Blue_Flavor;
REM 2. Create a view named Cheap_Food, which display the details (product id, flavor, 
REM food, price) of products with price lesser than $1. Ensure that, the price of these 
REM food(s) should never rise above $1 through view.
create view Cheap_Food as
select * from products
where price < 1
with check option;
select * from Cheap_Food;
REM 3. Create a view called Hot_Food that show the product id and its quantity where the 
REM same product is ordered more than once in the same receipt.
create view Hot_Food as
select item,count(*) as Count from item_list 
group by rno,item
having count(*) > 1;
select * from Hot_Food;
REM 4. Create a view named Pie_Food that will display the details (customer lname, flavor, 
REM	receipt number and date, ordinal) who had ordered the Pie food with receipt details.
create view Pie_Food as
select c.lname,p.flavor,r.rno,r.rdate,i.ordinal
from customers c,products p,receipts r,item_list i
where p.food = 'Pie' and c.cid = r.cid and i.item = p.pid and i.rno = r.rno;
select * from Pie_Food;
REM 5. Create a view Cheap_View from Cheap_Food that shows only the product id, flavor and food.
create view Cheap_View as 
select pid,flavor,food from Cheap_Food;
select * from Cheap_View;
REM 6. Create a sequence named Ordinal_No_Seq which generates the ordinal number 
REM starting from 1, increment by 1, to a maximum of 10. Include the options of cycle, 
REM cache and order. Use this sequence to populate the item_list table for a new order.
REM 7. Create a synonym named Product_details for the item_list relation. Perform the 
REM DML operations on it.
create synonym Product_details for item_list;
REM 8. Drop all the above created database objects.
drop view Blue_Flavor;
drop view Cheap_Food;
drop view Hot_Food;
drop view Pie_Food;
drop view Cheap_View;
REM drop sequence Ordinal_No_Seq;
drop synonym Product_Details;