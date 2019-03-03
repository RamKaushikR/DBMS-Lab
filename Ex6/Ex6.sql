REM Add column for amount
alter table Receipts add amount number(5,2);
REM 1. For the given receipt number, calculate the Discount as follows:
REM For total amount > $10 and total amount < $25: Discount=5%
REM For total amount > $25 and total amount < $50: Discount=10%
REM For total amount > $50: Discount=20%
REM Calculate the amount (after the discount) and update the same in Receipts table.
REM Print the receipt
create or replace procedure discountcalc(amt IN products.price%type, 
discount OUT products.price%type, total OUT products.price%type, discountp OUT int) as
begin
	discount := 0;
	discountp := 0;
	if amt > 50 then
		discount := 0.2*amt;
		discountp := 20;
	elsif amt > 25 then
		discount := 0.1*amt;
		discountp := 10;
	elsif amt > 10 then
		discount := 0.05*amt;
		discountp := 5;
	end if;
	total := amt - discount;
end discountcalc;
/
declare 
	cust_name1 customers.lname%type;
	cust_name2 customers.fname%type;
	discount products.price%type;
	discountp int;
	total products.price%type;
	amt products.price%type;
	qty integer;
	lprice products.price%type;
	rec_sel receipts.rno%type;
	rec_date date;
	counts integer;
	food_sel products.food%type;
	flavor_sel products.flavor%type;
	qtys integer;
	cursor c1 is select food, flavor, count(*) as qty, price 
	from products p join item_list i on i.item = p.pid
	where i.rno = rec_sel 
	group by (p.food,p.flavor,p.price);
	cursor c2 is select fname,lname,rdate from customers c join receipts r on r.cid = c.cid
	where rno = rec_sel;
begin
	rec_sel := &rec_sel;
	select count(count(*)) into counts from products p join item_list i on i.item = p.pid 
	where i.rno = rec_sel
	group by (p.food,p.flavor);
	select sum(count(*)) into qty from products p join item_list i on i.item = p.pid 
	where i.rno = rec_sel
	group by (p.food,p.flavor);
	open c1;
	open c2;
	fetch c2 into cust_name1,cust_name2,rec_date;
	dbms_output.put_line('Customer name: '||cust_name1||' '||cust_name2);
	dbms_output.put_line('Receipt No.: '||rec_sel);
	dbms_output.put_line('Receipt date: '||rec_date);
	dbms_output.put_line('------------------------------------------');
	dbms_output.put_line('SNO FOOD           FLAVOR         QUANTITY');
	dbms_output.put_line('------------------------------------------');
	amt:=0;
	for a in 1..counts loop
		fetch c1 into food_sel,flavor_sel,qtys,lprice;
		dbms_output.put_line(' '||a||' '||flavor_sel||' '||food_sel||' '||qtys);
		amt := amt + qtys*lprice;
	end loop;
	dbms_output.put_line('------------------------------------------');
	dbms_output.put_line('Total Quantity = '||qty);
	dbms_output.put_line('Total = $ '||amt);
	discountcalc(amt, discount, total, discountp);
	update Receipts set amount = total where Receipts.rno = rec_sel;
	dbms_output.put_line('Discount ('||discountp||'%) = $ '||discount);
	dbms_output.put_line('Grand Total = $ '||total);
	dbms_output.put_line('------------------------------------------');
	dbms_output.put_line('Upto 20% discount available!');
	dbms_output.put_line('------------------------------------------');
end;
/
REM 2. Ask the user for the budget and his/her preferred food type. You recommend the best 
REM item(s) within the planned budget for the given food type. The best item is determined 
REM by the maximum ordered product among many customers for the given food type.
REM Print the recommended product that suits your budget
create or replace procedure budgetitems(budget IN products.price%type, iprice IN products.price%type, qty OUT int) as
begin
	qty := trunc(budget/iprice);
end budgetitems;
/
declare
	budget products.price%type;
	qty int;
	iprice products.price%type;
	foodin products.food%type;
	foodo products.flavor%type;
	flavoro products.flavor%type;
	pido products.pid%type;
	priceo products.price%type;
	counto int;
	cursor c2 is select p.pid, p.food, p.flavor, p.price, count(*) as counts from item_list i join products p on(i.item=p.pid)
	where p.food = foodin and p.price <= budget
	group by p.pid, p.food, p.flavor, p.price
	order by counts desc;
	cursor c1 is select p.pid, p.food, p.flavor, p.price, count(*) as counts from item_list i join products p on(i.item=p.pid)
	where p.food = foodin and p.price <= budget
	group by p.pid, p.food, p.flavor, p.price
	order by counts desc;
begin
	budget := &budget;
	foodin := '&foodin';
	dbms_output.put_line('Budget: '||budget||' Food: '||foodin);
	dbms_output.put_line('PID        FOOD         FLAVOR       PRICE');
	open c2;
	loop
		fetch c2 into pido, foodo, flavoro, priceo, counto;
		if c2%FOUND then
			dbms_output.put_line(pido||' '||foodo||' '||flavoro||' '||priceo);
		else
			exit;
		end if;
	end loop;
	open c1;
	fetch c1 into pido, foodo, flavoro, priceo, counto;
	if c1%NOTFOUND then
		dbms_output.put_line('Cannot buy!');
	else
		budgetitems(budget, priceo, qty);
		dbms_output.put_line('The recommended item is '||pido||' '||flavoro||' '||foodo||'and you can purchase '||qty||' of these!');
	end if;
end;
/
REM 3. Take a receipt number and item as arguments, and insert this information into 
REM the Item list. However, if there is already a receipt with that receipt number, then 
REM keep adding 1 to the maximum ordinal number. Else before inserting into the Item list 
REM with ordinal as 1, ask the user to give the customer name who placed the order and insert 
REM this information into the Receipts.
create or replace procedure ordinalinc(ord IN OUT item_list.ordinal%type) as
begin
	ord := ord + 1;
end ordinalinc;
/
declare
	ord item_list.ordinal%type;
	itemin item_list.item%type;
	receiptin item_list.rno%type;
	cidin customers.cid%type;
	datein date;
	ordcount item_list.ordinal%type;
	cursor c1 is select ordinal from item_list where rno = receiptin;
begin
	ord := 1;
	itemin := '&itemin';
	receiptin := &receiptin;
	open c1;
	loop
		fetch c1 into ordcount;
		if c1%FOUND then
			ordinalinc(ord);
		else
			exit;
		end if;
	end loop;
	if ord = 1 then
		cidin := '&cidin';
		datein := '&datein';
		insert into Receipts values(receiptin, datein, cidin);
	end if;
	insert into item_list values(receiptin, ord, itemin);
	dbms_output.put_line('Inserted '||receiptin||' '||ord||' '||itemin);
end;
/
REM 4. Write a stored function to display the customer name who ordered 
REM maximum for the given food and flavor.
create or replace function maxcustomer(p IN products.pid%type) return varchar2 as
c customers.cid%type;
m int;
n1 customers.fname%type;
n2 customers.lname%type;
name varchar2(40);
begin
	select max(count(*)) into m from receipts r join item_list i on i.rno = r.rno
	where i.item = p
	group by r.cid;
	select r.cid into c from receipts r join item_list i on i.rno = r.rno
	where i.item = p
	group by r.cid
	having count(*) = m;
	select c1.fname into n1 from customers c1 where c1.cid = c;
	select c1.lname into n2 from customers c1 where c1.cid = c;
	name := n1||n2;
	return name;
end maxcustomer;
/
declare 
	name varchar2(40);
	p products.pid%type;
	fo products.food%type;
	fl products.flavor%type;
begin
	fo:='&food';
	fl:='&flavor';
	select p1.pid into p from products p1 where p1.food = fo and p1.flavor = fl;
	name := maxcustomer(p);
	dbms_output.put_line('Name: '||name);
end;
/
REM 5. Implement Question (2) using stored function to return the amount to be paid 
REM and update the same, for the given receipt number.
create or replace function amountcalc(amt IN products.price%type) return products.price%type
as
discount products.price%type;
begin
discount := 0;
if amt > 50 then
	discount := 0.2*amt;
elsif amt > 25 then
	discount := 0.1*amt;
elsif amt > 10 then
	discount := 0.05*amt;
end if;
return (amt - discount);
end amountcalc;
/
declare 
	cust_name1 customers.lname%type;
	cust_name2 customers.fname%type;
	discount products.price%type;
	discountp int;
	total products.price%type;
	amt products.price%type;
	qty integer;
	lprice products.price%type;
	rec_sel receipts.rno%type;
	rec_date date;
	counts integer;
	food_sel products.food%type;
	flavor_sel products.flavor%type;
	qtys integer;
	cursor c1 is select food, flavor, count(*) as qty, price 
	from products p join item_list i on i.item = p.pid
	where i.rno = rec_sel 
	group by (p.food,p.flavor,p.price);
	cursor c2 is select fname,lname,rdate from customers c join receipts r on r.cid = c.cid
	where rno = rec_sel;
begin
	rec_sel := &rec_sel;
	select count(count(*)) into counts from products p join item_list i on i.item = p.pid 
	where i.rno = rec_sel
	group by (p.food,p.flavor);
	select sum(count(*)) into qty from products p join item_list i on i.item = p.pid 
	where i.rno = rec_sel
	group by (p.food,p.flavor);
	open c1;
	open c2;
	fetch c2 into cust_name1,cust_name2,rec_date;
	dbms_output.put_line('Customer name: '||cust_name1||' '||cust_name2);
	dbms_output.put_line('Receipt No.: '||rec_sel);
	dbms_output.put_line('Receipt date: '||rec_date);
	dbms_output.put_line('------------------------------------------');
	dbms_output.put_line('SNO FOOD           FLAVOR         QUANTITY');
	dbms_output.put_line('------------------------------------------');
	amt:=0;
	for a in 1..counts loop
		fetch c1 into food_sel,flavor_sel,qtys,lprice;
		dbms_output.put_line(' '||a||' '||flavor_sel||' '||food_sel||' '||qtys);
		amt := amt + qtys*lprice;
	end loop;
	dbms_output.put_line('------------------------------------------');
	dbms_output.put_line('Total Quantity = '||qty);
	dbms_output.put_line('Total = $ '||amt);
	total := amountcalc(amt);
	discount := amt - total;
	discountp := ROUND(discount*100/amt);
	update Receipts set amount = total where Receipts.rno = rec_sel;
	dbms_output.put_line('Discount ('||discountp||'%) = $ '||discount);
	dbms_output.put_line('Grand Total = $ '||total);
	dbms_output.put_line('------------------------------------------');
	dbms_output.put_line('Upto 20% discount available!');
	dbms_output.put_line('------------------------------------------');
end;
/