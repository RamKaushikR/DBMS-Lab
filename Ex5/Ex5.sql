REM 1. Check whether the given combination of food and flavor is available. If any one or
REM    both are not available, display the relevant message.
set serveroutput on;
create or replace procedure select_1(fl IN products.flavor%type, fo IN products.food%type, count_1 OUT integer) IS 
begin
	select count(*) into count_1
	from (select pid from products 
	where food=fo and flavor=fl);
end;
/
declare
fl products.flavor%type;
fo products.food%type;
c number(3);
begin	
	fl := '&flavor';
	fo := '&food';
	select_1(fl,fo,c);
	if SQL%found and c>0 then
		dbms_output.put_line(c||' found');
	else
		dbms_output.put_line('Not found');
	end if;
end;
/
REM 2. On a given date, find the number of items sold (Use Implicit cursor).
create or replace procedure select_2(date_1 IN receipts.rdate%type, count_1 OUT integer) IS 
begin
	select count(*) into count_1
	from (select rdate from item_list i join receipts r on r.rno=i.rno 
	where r.rdate=date_1);
end;
/
declare
date_search receipts.rdate%type;
c number(3);
begin	
	date_search := '&date_search';
	select_2(date_search,c);
	if SQL%found and c>0 then
		dbms_output.put_line('No. of items sold on '||date_search||' is/are:'||c);
	else
		dbms_output.put_line('No items sold');
	end if;
end;
/
REM 3.An user desired to buy the product with the specific price. Ask the user for a price,
REM find the food item(s) that is equal or closest to the desired price. Print the product
REM number, food type, flavor and price. Also print the number of items that is equal or
REM closest to the desired price.
declare 
ip_price products.price%type;
cursor c1 is select * from products 
where abs(price-ip_price) = 
(select min(abs(price-ip_price)) from products);
pro products%rowtype;
c integer;
begin 
	ip_price := &input_price;
	open c1;
	c := 0;
	loop
		fetch c1 
		into pro.pid, pro.flavor, pro.food, pro.price;
		if c1%found then 
			dbms_output.put_line(pro.pid||' '||pro.flavor||' '||pro.food||' '||pro.price);
			c := c+1;
		else	
			exit;
		end if;
	end loop;
	dbms_output.put_line(c);
end;
/
REM 4.Display the customer name along with the details of item and its quantity ordered for
REM the given order number. Also calculate the total quantity ordered
declare 
c_fname customer.fname%type;
c_lname customer.lname%type;
qty integer;
rec_sel receipts.rno%type;
c integer;
food_sel products.food%type;
flavor_sel products.flavor%type;
cursor c1 is select food,flavor,count(*) as qty
from products p join item_list i on i.item = p.pid 
where i.rno = rec_sel group by (p.food,p.flavor);
cursor c2 is select fname,lname from customers c join receipts r 
on r.cid = c.cid where rno=rec_sel;
begin	
	rec_sel := &rec_sel;
	select 
