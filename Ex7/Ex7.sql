REM 1  The combination of Flavor and Food determines the product id. Hence, while 
REM    inserting a new instance into the Products relation, ensure that the same combination
REM    of Flavor and Food is not already available.
set serveroutput on; 
create or replace trigger combination
before insert on products for each row
declare
   	p_food products.food%type;
	p_flavor products.flavor%type;
	cursor c1 is select food,flavor from products;
begin
	open c1;
	loop	
		fetch c1 into p_food,p_flavor;
     	if c1%found then
        	if p_food = :new.food and p_flavor = :new.flavor then
				raise_application_error(-20000,'error:combination present');
			end if;
		else
			exit;
    	end if;
	end loop;
end;
/
insert into products values('50-klmop','almond','twist',6.12);
REM 2. While entering an item into the item_list relation, update the amount in Receipts with
REM the total amount for that receipt number.
alter table receipts
add amount float;
create view tot_price as
select i.rno as rno,sum(p.price) as price from item_list i join products p 
on i.item=p.pid group by i.rno;
create view temp_view as
select r.rno as rno,r.rdate as rdate,r.cid as cid,t.price as amount
from receipts r left join tot_price t
on r.rno=t.rno;
create or replace trigger q2
after insert on item_list for each row 
declare
	temp temp_view%rowtype;
	pid products.pid%type;
	price products.price%type;
	cursor c2_1 is select * from temp_view;
	cursor c2_2 is select pid,price from products;
begin
	open c2_1;
	open c2_2;
	loop
		fetch c2 into temp.rno,temp.rdate,temp.cid,temp.amount;
		if c2%found then 
			if :new.rno = temp.rno then
				loop
					fetch c3 into pid,price;
					if c3%found then
						if :new.item = pid then
							temp.amount := temp.amount+price;
						end if;
					else
						exit;
					end if;
				end loop;
			end if;
		else
			exit;
		end if;
	end loop;
end;
/		
REM 3 Implement the following constraints for Item_list relation:
REM a. A receipt can contain a maximum of five items only.
REM b. A receipt should not allow an item to be purchased more than thrice.
create or replace trigger item_a
before insert or update on item_list for each row
begin
	if :new.ordinal>5 then
		raise_application_error(-20002,:new.rno||'has more than 5 item');
	end if;
end;
/
insert into item_list values(52761,6,'70-TU');
create or replace trigger item_b
before insert or update on item_list for each row
declare
	rnum item_list.rno%type;
	item_1 item_list.item%type;
	total int;
	cursor c3_b is
	select rno,item,count(*) from item_list
	group by (rno,item) having count(*) > 1;
begin
	open c3_b;
	loop
		fetch c3_b into rnum,item_1,total;
		if c3_b%found then 
			if rnum = :new.rno and item_1 = :new.item then
				raise_application_error(-20003,item_1||' will be purchased more than thrice in '||rnum);
			end if;
		else
			exit;
		end if;
	end loop;
end;
/