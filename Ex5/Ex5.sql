REM 1. Check whether the given combination of food and flavor is available. If any one or
REM    both are not available, display the relevant message.
set serveroutput on;
declare
fl products.flavor%type;
fo products.food%type;
cursor c1 is select food,flavor from products 
where food=fo and flavor=fl;
cursor c2 is select food from products p 
where p.food=fo and fl not in p.flavor;
cursor c3 is select flavor from products p 
where p.flavor=fl and fo not in p.food;
c1_fl products.flavor%type;
c1_fo products.food%type;
c2_fo products.food%type;
c3_fl products.flavor%type;
begin	
	fl := '&flavor';
	fo := '&food';
	open c1;
	open c2;
	open c3;
	fetch c1 into c1_fo,c1_fl;
	fetch c2 into c2_fo;
	fetch c3 into c3_fl;
	if c1%found then
		dbms_output.put_line(fo||' & '||fl||' are found');
	elsif c2%found then 
		dbms_output.put_line(fo||' found but '||fl||' not found');
	elsif c3%found then 
		dbms_output.put_line(fl||' found but '||fo||' not found');
	else
		dbms_output.put_line('Not found');
	end if;
end;
/
REM 2. On a given date, find the number of items sold (Use Implicit cursor).
declare
date_search receipts.rdate%type;
begin	
	date_search := '&date_search';
	update item_list i 
	set i.ordinal=i.ordinal+1-1  
	where i.rno in 
	(select r.rno from item_list i join receipts r on r.rno=i.rno
     where r.rdate=date_search);
	if SQL%found and SQL%rowcount>0 then
		dbms_output.put_line('No. of items sold on '||date_search||' is/are:'||SQL%rowcount);
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
	dbms_output.put_line('PRODUCTID FLAVOR FOOD PRICE');
	dbms_output.put_line('---------------------------');
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
	dbms_output.put_line('---------------------------');
 	dbms_output.put_line(c||' product(s) found equal/closest to given price');
 end;
 /
REM 4.Display the customer name along with the details of item and its quantity ordered for
REM the given order number. Also calculate the total quantity ordered
declare 
c_fname customers.fname%type;
c_lname customers.lname%type;
qty integer;
rec_sel receipts.rno%type;
co integer;
food_sel products.food%type;
flavor_sel products.flavor%type;
qtys integer;
cursor c1 is select food,flavor,count(*) as qty
from products p join item_list i on i.item = p.pid 
where i.rno = rec_sel group by (p.food,p.flavor);
cursor c2 is select fname,lname from customers c join receipts r 
on r.cid = c.cid where rno=rec_sel;
begin	
	rec_sel := &rec_sel;
	select count(count(*)) into co from products p join item_list i on i.item = p.pid 
	where i.rno = rec_sel
	group by (p.food,p.flavor);
    select sum(count(*)) into qty from products p join item_list i on i.item = p.pid 
	where i.rno = rec_sel
	group by (p.food,p.flavor);
	open c1;
	open c2;
	fetch c2 into c_fname,c_lname;
	dbms_output.put_line('Customer name: '||c_lname||' '||c_fname); 
	dbms_output.put_line('FOOD FLAVOR QUANTITY');
	dbms_output.put_line('------------------------------------------');
	for count in 1..co loop
		fetch c1 into food_sel,flavor_sel,qtys;
		dbms_output.put_line(flavor_sel||' '||food_sel||' '||qtys);
    end loop;
	dbms_output.put_line('------------------------------------------');
	dbms_output.put_line('Total Quantity='||qty);
end;
/
