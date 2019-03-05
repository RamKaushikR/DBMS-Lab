REM Drop amount from receipts
alter table receipts 
drop column amount;
insert into products values('50-klmop','almond','twist',6.12);
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
add amount float default 0;
create view tot_price as
select i.rno as rno,sum(p.price) as price from item_list i join products p 
on i.item=p.pid group by i.rno;
create view temp_view as
select r.rno as rno,r.rdate as rdate,r.cid as cid,t.price as amount
from receipts r left join tot_price t
on r.rno=t.rno;
update receipts r
set amount=(select amount from temp_view
where rno=r.rno);
create or replace trigger q2
before insert on item_list for each row 
declare
	price products.price%type;
begin
	select p.price into price
	from products p where p.pid=:new.item;
	update receipts
	set amount=amount+price
	where :new.rno=rno;
end;
/
select * from receipts where rno=46674;
insert into item_list values(46674,2,'70-R');
select * from receipts where rno=46674;
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
insert into item_list values(41028, 2,  '90-BER-11');
insert into item_list values(41028, 3,  '90-BER-11');
