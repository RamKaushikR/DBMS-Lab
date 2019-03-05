SQL> @z:/Ex6/Ex6.sql
SQL> set serveroutput on;
SQL> REM 1. For the given receipt number, calculate the Discount as follows:
SQL> REM For total amount > $10 and total amount < $25: Discount=5%
SQL> REM For total amount > $25 and total amount < $50: Discount=10%
SQL> REM For total amount > $50: Discount=20%
SQL> REM Calculate the amount (after the discount) and update the same in Receipts table.
SQL> REM Print the receipt
SQL> alter table receipts
  2  add amount float default 0;

Table altered.

SQL> create or replace procedure discountcalc(amt IN products.price%type,
  2  discount OUT products.price%type, total OUT products.price%type, discountp OUT int) as
  3  begin
  4  	     discount := 0;
  5  	     discountp := 0;
  6  	     if amt > 50 then
  7  		     discount := 0.2*amt;
  8  		     discountp := 20;
  9  	     elsif amt > 25 then
 10  		     discount := 0.1*amt;
 11  		     discountp := 10;
 12  	     elsif amt > 10 then
 13  		     discount := 0.05*amt;
 14  		     discountp := 5;
 15  	     end if;
 16  	     total := amt - discount;
 17  end discountcalc;
 18  /

Procedure created.

SQL> declare
  2  	     cust_name1 customers.lname%type;
  3  	     cust_name2 customers.fname%type;
  4  	     discount products.price%type;
  5  	     discountp int;
  6  	     total products.price%type;
  7  	     amt products.price%type;
  8  	     qty integer;
  9  	     lprice products.price%type;
 10  	     rec_sel receipts.rno%type;
 11  	     rec_date date;
 12  	     counts integer;
 13  	     food_sel products.food%type;
 14  	     flavor_sel products.flavor%type;
 15  	     qtys integer;
 16  	     cursor c1 is select food, flavor, count(*) as qty, price
 17  	     from products p join item_list i on i.item = p.pid
 18  	     where i.rno = rec_sel
 19  	     group by (p.food,p.flavor,p.price);
 20  	     cursor c2 is select fname,lname,rdate from customers c join receipts r on r.cid = c.cid
 21  	     where rno = rec_sel;
 22  begin
 23  	     rec_sel := &rec_sel;
 24  	     select count(count(*)) into counts from products p join item_list i on i.item = p.pid
 25  	     where i.rno = rec_sel
 26  	     group by (p.food,p.flavor);
 27  	     select sum(count(*)) into qty from products p join item_list i on i.item = p.pid
 28  	     where i.rno = rec_sel
 29  	     group by (p.food,p.flavor);
 30  	     open c1;
 31  	     open c2;
 32  	     fetch c2 into cust_name1,cust_name2,rec_date;
 33  	     dbms_output.put_line('Customer name: '||cust_name1||' '||cust_name2);
 34  	     dbms_output.put_line('Receipt No.: '||rec_sel);
 35  	     dbms_output.put_line('Receipt date: '||rec_date);
 36  	     dbms_output.put_line('------------------------------------------');
 37  	     dbms_output.put_line('SNO FOOD	      FLAVOR	     QUANTITY');
 38  	     dbms_output.put_line('------------------------------------------');
 39  	     amt:=0;
 40  	     for a in 1..counts loop
 41  		     fetch c1 into food_sel,flavor_sel,qtys,lprice;
 42  		     dbms_output.put_line(' '||a||' '||flavor_sel||' '||food_sel||' '||qtys);
 43  		     amt := amt + qtys*lprice;
 44  	     end loop;
 45  	     dbms_output.put_line('------------------------------------------');
 46  	     dbms_output.put_line('Total Quantity = '||qty);
 47  	     dbms_output.put_line('Total = $ '||amt);
 48  	     discountcalc(amt, discount, total, discountp);
 49  	     update Receipts set amount = total where Receipts.rno = rec_sel;
 50  	     dbms_output.put_line('Discount ('||discountp||'%) = $ '||discount);
 51  	     dbms_output.put_line('Grand Total = $ '||total);
 52  	     dbms_output.put_line('------------------------------------------');
 53  	     dbms_output.put_line('Upto 20% discount available!');
 54  	     dbms_output.put_line('------------------------------------------');
 55  end;
 56  /
Enter value for rec_sel: 51991
old  23: 	rec_sel := &rec_sel;
new  23: 	rec_sel := 51991;
Customer name: RAYFORD              SOPKO                                       
Receipt No.: 51991                                                              
Receipt date: 17-OCT-07                                                         
------------------------------------------                                      
SNO FOOD           FLAVOR         QUANTITY                                      
------------------------------------------                                      
1 Apple           Tart            1                                             
2 Chocolate       Tart            1                                             
3 Truffle         Cake            1                                             
4 Apple           Pie             1                                             
------------------------------------------                                      
Total Quantity = 4                                                              
Total = $ 28.2                                                                  
Discount (10%) = $ 2.82                                                         
Grand Total = $ 25.38                                                           
------------------------------------------                                      
Upto 20% discount available!                                                    
------------------------------------------                                      

PL/SQL procedure successfully completed.

SQL> REM 2. Ask the user for the budget and his/her preferred food type. You recommend the best
SQL> REM item(s) within the planned budget for the given food type. The best item is determined
SQL> REM by the maximum ordered product among many customers for the given food type.
SQL> REM Print the recommended product that suits your budget
SQL> create or replace procedure budgetitems(budget IN products.price%type, iprice IN products.price%type, qty OUT int) as
  2  begin
  3  	     qty := trunc(budget/iprice);
  4  end budgetitems;
  5  /

Procedure created.

SQL> declare
  2  	     budget products.price%type;
  3  	     qty int;
  4  	     iprice products.price%type;
  5  	     foodin products.food%type;
  6  	     foodo products.flavor%type;
  7  	     flavoro products.flavor%type;
  8  	     pido products.pid%type;
  9  	     priceo products.price%type;
 10  	     counto int;
 11  	     cursor c2 is select p.pid, p.food, p.flavor, p.price, count(*) as counts from item_list i join products p on(i.item=p.pid)
 12  	     where p.food = foodin and p.price <= budget
 13  	     group by p.pid, p.food, p.flavor, p.price
 14  	     order by counts desc;
 15  	     cursor c1 is select p.pid, p.food, p.flavor, p.price, count(*) as counts from item_list i join products p on(i.item=p.pid)
 16  	     where p.food = foodin and p.price <= budget
 17  	     group by p.pid, p.food, p.flavor, p.price
 18  	     order by counts desc;
 19  begin
 20  	     budget := &budget;
 21  	     foodin := '&foodin';
 22  	     dbms_output.put_line('Budget: '||budget||' Food: '||foodin);
 23  	     dbms_output.put_line('PID	      FOOD	   FLAVOR	PRICE');
 24  	     open c2;
 25  	     loop
 26  		     fetch c2 into pido, foodo, flavoro, priceo, counto;
 27  		     if c2%FOUND then
 28  			     dbms_output.put_line(pido||' '||foodo||' '||flavoro||' '||priceo);
 29  		     else
 30  			     exit;
 31  		     end if;
 32  	     end loop;
 33  	     open c1;
 34  	     fetch c1 into pido, foodo, flavoro, priceo, counto;
 35  	     if c1%NOTFOUND then
 36  		     dbms_output.put_line('Cannot buy!');
 37  	     else
 38  		     budgetitems(budget, priceo, qty);
 39  		     dbms_output.put_line('The recommended item is '||pido||' '||flavoro||' '||foodo||'and you can purchase '||qty||' of these!');
 40  	     end if;
 41  end;
 42  /
Enter value for budget: 17
old  20: 	budget := &budget;
new  20: 	budget := 17;
Enter value for foodin: Cake
old  21: 	foodin := '&foodin';
new  21: 	foodin := 'Cake';
Budget: 17 Food: Cake                                                           
PID        FOOD         FLAVOR       PRICE                                      
20-CA-7.5 Cake            Casino          15.95                                 
46-11 Cake            Napoleon        13.49                                     
24-8x10 Cake            Opera           15.95                                   
26-8x10 Cake            Truffle         15.95                                   
20-BC-L-10 Cake            Lemon           8.95                                 
25-STR-9 Cake            Strawberry      11.95                                  
The recommended item is 20-CA-7.5 Casino          Cake           and you can    
purchase 1 of these!                                                            

PL/SQL procedure successfully completed.

SQL> REM 3. Take a receipt number and item as arguments, and insert this information into
SQL> REM the Item list. However, if there is already a receipt with that receipt number, then
SQL> REM keep adding 1 to the maximum ordinal number. Else before inserting into the Item list
SQL> REM with ordinal as 1, ask the user to give the customer name who placed the order and insert
SQL> REM this information into the Receipts.
SQL> alter table receipts
  2  drop column amount;

Table altered.

SQL> create or replace procedure ordinalinc(ord1 IN item_list.ordinal%type,o OUT item_list.ordinal%type) as
  2  begin
  3  	     o := ord1 + 1;
  4  end ordinalinc;
  5  /

Procedure created.

SQL> declare
  2  	     ord1 item_list.ordinal%type;
  3  	     o item_list.ordinal%type;
  4  	     itemin item_list.item%type;
  5  	     receiptin item_list.rno%type;
  6  	     cidin customers.cid%type;
  7  	     datein date;
  8  	     ordcount item_list.ordinal%type;
  9  	     cursor c1 is select ordinal from item_list where rno = receiptin;
 10  begin
 11  	     ord1 := 1;
 12  	     o := 1;
 13  	     itemin := '&itemin';
 14  	     receiptin := &receiptin;
 15  	     open c1;
 16  	     loop
 17  		     fetch c1 into ordcount;
 18  		     if c1%FOUND then
 19  			     ordinalinc(ord1,o);
 20  		     else
 21  			     exit;
 22  		     end if;
 23  	     end loop;
 24  	     if o = 1 then
 25  		     cidin := '&cidin';
 26  		     datein := '&datein';
 27  		     insert into Receipts values(receiptin, datein, cidin);
 28  	     end if;
 29  	     insert into item_list values(receiptin, o, itemin);
 30  	     dbms_output.put_line('Inserted '||receiptin||' '||o||' '||itemin);
 31  end;
 32  /
Enter value for itemin: 90-LEM-11
old  13: 	itemin := '&itemin';
new  13: 	itemin := '90-LEM-11';
Enter value for receiptin: 10000
old  14: 	receiptin := &receiptin;
new  14: 	receiptin := 10000;
Enter value for cidin: 1
old  25: 		cidin := '&cidin';
new  25: 		cidin := '1';
Enter value for datein: 15-APR-2007
old  26: 		datein := '&datein';
new  26: 		datein := '15-APR-2007';
Inserted 10000 1 90-LEM-11                                                      

PL/SQL procedure successfully completed.

SQL> REM 4. Write a stored function to display the customer name who ordered
SQL> REM maximum for the given food and flavor.
SQL> create or replace function maxcustomer(p IN products.pid%type) return varchar2 as
  2  c customers.cid%type;
  3  m int;
  4  n1 customers.fname%type;
  5  n2 customers.lname%type;
  6  name varchar2(40);
  7  begin
  8  	     select max(count(*)) into m from receipts r join item_list i on i.rno = r.rno
  9  	     where i.item = p
 10  	     group by r.cid;
 11  	     select r.cid into c from receipts r join item_list i on i.rno = r.rno
 12  	     where i.item = p
 13  	     group by r.cid
 14  	     having count(*) = m;
 15  	     select c1.fname into n1 from customers c1 where c1.cid = c;
 16  	     select c1.lname into n2 from customers c1 where c1.cid = c;
 17  	     name := n1||n2;
 18  	     return name;
 19  end maxcustomer;
 20  /

Function created.

SQL> declare
  2  	     name varchar2(40);
  3  	     p products.pid%type;
  4  	     fo products.food%type;
  5  	     fl products.flavor%type;
  6  begin
  7  	     fo:='&food';
  8  	     fl:='&flavor';
  9  	     select p1.pid into p from products p1 where p1.food = fo and p1.flavor = fl;
 10  	     name := maxcustomer(p);
 11  	     dbms_output.put_line('Name: '||name);
 12  end;
 13  /
Enter value for food: Eclair
old   7:  fo:='&food';
new   7:  fo:='Eclair';
Enter value for flavor: Coffee
old   8:  fl:='&flavor';
new   8:  fl:='Coffee';
Name: STEPHEN             ZEME

PL/SQL procedure successfully completed.

SQL> REM 5. Implement Question (2) using stored function to return the amount to be paid
SQL> REM and update the same, for the given receipt number.
SQL> alter table receipts
  2  add amount float default 0;

Table altered.

SQL> create or replace function amountcalc(amt IN products.price%type) return products.price%type
  2  as
  3  discount products.price%type;
  4  begin
  5  discount := 0;
  6  if amt > 50 then
  7  	     discount := 0.2*amt;
  8  elsif amt > 25 then
  9  	     discount := 0.1*amt;
 10  elsif amt > 10 then
 11  	     discount := 0.05*amt;
 12  end if;
 13  return (amt - discount);
 14  end amountcalc;
 15  /

Function created.

SQL> declare
  2  	     cust_name1 customers.lname%type;
  3  	     cust_name2 customers.fname%type;
  4  	     discount products.price%type;
  5  	     discountp int;
  6  	     total products.price%type;
  7  	     amt products.price%type;
  8  	     qty integer;
  9  	     lprice products.price%type;
 10  	     rec_sel receipts.rno%type;
 11  	     rec_date date;
 12  	     counts integer;
 13  	     food_sel products.food%type;
 14  	     flavor_sel products.flavor%type;
 15  	     qtys integer;
 16  	     cursor c1 is select food, flavor, count(*) as qty, price
 17  	     from products p join item_list i on i.item = p.pid
 18  	     where i.rno = rec_sel
 19  	     group by (p.food,p.flavor,p.price);
 20  	     cursor c2 is select fname,lname,rdate from customers c join receipts r on r.cid = c.cid
 21  	     where rno = rec_sel;
 22  begin
 23  	     rec_sel := &rec_sel;
 24  	     select count(count(*)) into counts from products p join item_list i on i.item = p.pid
 25  	     where i.rno = rec_sel
 26  	     group by (p.food,p.flavor);
 27  	     select sum(count(*)) into qty from products p join item_list i on i.item = p.pid
 28  	     where i.rno = rec_sel
 29  	     group by (p.food,p.flavor);
 30  	     open c1;
 31  	     open c2;
 32  	     fetch c2 into cust_name1,cust_name2,rec_date;
 33  	     dbms_output.put_line('Customer name: '||cust_name1||' '||cust_name2);
 34  	     dbms_output.put_line('Receipt No.: '||rec_sel);
 35  	     dbms_output.put_line('Receipt date: '||rec_date);
 36  	     dbms_output.put_line('------------------------------------------');
 37  	     dbms_output.put_line('SNO FOOD	      FLAVOR	     QUANTITY');
 38  	     dbms_output.put_line('------------------------------------------');
 39  	     amt:=0;
 40  	     for a in 1..counts loop
 41  		     fetch c1 into food_sel,flavor_sel,qtys,lprice;
 42  		     dbms_output.put_line(' '||a||' '||flavor_sel||' '||food_sel||' '||qtys);
 43  		     amt := amt + qtys*lprice;
 44  	     end loop;
 45  	     dbms_output.put_line('------------------------------------------');
 46  	     dbms_output.put_line('Total Quantity = '||qty);
 47  	     dbms_output.put_line('Total = $ '||amt);
 48  	     total := amountcalc(amt);
 49  	     discount := amt - total;
 50  	     discountp := ROUND(discount*100/amt);
 51  	     update Receipts set amount = total where Receipts.rno = rec_sel;
 52  	     dbms_output.put_line('Discount ('||discountp||'%) = $ '||discount);
 53  	     dbms_output.put_line('Grand Total = $ '||total);
 54  	     dbms_output.put_line('------------------------------------------');
 55  	     dbms_output.put_line('Upto 20% discount available!');
 56  	     dbms_output.put_line('------------------------------------------');
 57  end;
 58  /
Enter value for rec_sel: 51991
old  23: 	rec_sel := &rec_sel;
new  23: 	rec_sel := 51991;
Customer name: RAYFORD              SOPKO                                       
Receipt No.: 51991                                                              
Receipt date: 17-OCT-07                                                         
------------------------------------------                                      
SNO FOOD           FLAVOR         QUANTITY                                      
------------------------------------------                                      
1 Apple           Tart            1                                             
2 Chocolate       Tart            1                                             
3 Truffle         Cake            1                                             
4 Apple           Pie             1                                             
------------------------------------------                                      
Total Quantity = 4                                                              
Total = $ 28.2                                                                  
Discount (10%) = $ 2.82                                                         
Grand Total = $ 25.38                                                           
------------------------------------------                                      
Upto 20% discount available!                                                    
------------------------------------------                                      

PL/SQL procedure successfully completed.

SQL> spool off;