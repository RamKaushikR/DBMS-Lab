SQL> @z:/Ex5/Ex5.sql
SQL> REM 1. Check whether the given combination of food and flavor is available. If any one or
SQL> REM    both are not available, display the relevant message.
SQL> set serveroutput on;
SQL> declare
  2  fl products.flavor%type;
  3  fo products.food%type;
  4  cursor c1 is select food,flavor from products
  5  where food=fo and flavor=fl;
  6  cursor c2 is select food from products p
  7  where p.food=fo and fl not in p.flavor;
  8  cursor c3 is select flavor from products p
  9  where p.flavor=fl and fo not in p.food;
 10  c1_fl products.flavor%type;
 11  c1_fo products.food%type;
 12  c2_fo products.food%type;
 13  c3_fl products.flavor%type;
 14  begin
 15  	     fl := '&flavor';
 16  	     fo := '&food';
 17  	     open c1;
 18  	     open c2;
 19  	     open c3;
 20  	     fetch c1 into c1_fo,c1_fl;
 21  	     fetch c2 into c2_fo;
 22  	     fetch c3 into c3_fl;
 23  	     if c1%found then
 24  		     dbms_output.put_line(fo||' & '||fl||' are found');
 25  	     elsif c2%found then
 26  		     dbms_output.put_line(fo||' found but '||fl||' not found');
 27  	     elsif c3%found then
 28  		     dbms_output.put_line(fl||' found but '||fo||' not found');
 29  	     else
 30  		     dbms_output.put_line('Not found');
 31  	     end if;
 32  end;
 33  /
Enter value for flavor: Chocolate
old  15: 	fl := '&flavor';
new  15: 	fl := 'Chocolate';
Enter value for food: Cake
old  16: 	fo := '&food';
new  16: 	fo := 'Cake';
Cake            & Chocolate       are found                                     

PL/SQL procedure successfully completed.

SQL> REM 2. On a given date, find the number of items sold (Use Implicit cursor).
SQL> declare
  2  date_search receipts.rdate%type;
  3  begin
  4  	     date_search := '&date_search';
  5  	     update item_list i
  6  	     set i.ordinal=i.ordinal+1-1
  7  	     where i.rno in
  8  	     (select r.rno from item_list i join receipts r on r.rno=i.rno
  9  	  where r.rdate=date_search);
 10  	     if SQL%found and SQL%rowcount>0 then
 11  		     dbms_output.put_line('No. of items sold on '||date_search||' is/are:'||SQL%rowcount);
 12  	     else
 13  		     dbms_output.put_line('No items sold');
 14  	     end if;
 15  end;
 16  /
Enter value for date_search: 03-OCT-2007
old   4: 	date_search := '&date_search';
new   4: 	date_search := '03-OCT-2007';
No. of items sold on 03-OCT-07 is/are:23                                        

PL/SQL procedure successfully completed.

SQL> REM 3.An user desired to buy the product with the specific price. Ask the user for a price,
SQL> REM find the food item(s) that is equal or closest to the desired price. Print the product
SQL> REM number, food type, flavor and price. Also print the number of items that is equal or
SQL> REM closest to the desired price.
SQL> declare
  2  ip_price products.price%type;
  3  cursor c1 is select * from products
  4  where abs(price-ip_price) =
  5  (select min(abs(price-ip_price)) from products);
  6  pro products%rowtype;
  7  c integer;
  8  begin
  9   ip_price := &input_price;
 10     open c1;
 11     c := 0;
 12   dbms_output.put_line('PRODUCTID FLAVOR FOOD PRICE');
 13   dbms_output.put_line('---------------------------');
 14     loop
 15         fetch c1
 16         into pro.pid, pro.flavor, pro.food, pro.price;
 17         if c1%found then
 18     dbms_output.put_line(pro.pid||' '||pro.flavor||' '||pro.food||' '||pro.price);
 19       c := c+1;
 20    else
 21         exit;
 22       end if;
 23      end loop;
 24   dbms_output.put_line('---------------------------');
 25    dbms_output.put_line(c||' product(s) found equal/closest to given price');
 26   end;
 27   /
Enter value for input_price: 0.8
old   9:  ip_price := &input_price;
new   9:  ip_price := 0.8;
PRODUCTID FLAVOR FOOD PRICE
---------------------------
70-LEM Lemon           Cookie          .79
70-W Walnut          Cookie          .79
---------------------------
2 product(s) found equal/closest to given price

PL/SQL procedure successfully completed.

SQL> REM 4.Display the customer name along with the details of item and its quantity ordered for
SQL> REM the given order number. Also calculate the total quantity ordered
SQL> declare
  2  c_fname customers.fname%type;
  3  c_lname customers.lname%type;
  4  qty integer;
  5  rec_sel receipts.rno%type;
  6  co integer;
  7  food_sel products.food%type;
  8  flavor_sel products.flavor%type;
  9  qtys integer;
 10  cursor c1 is select food,flavor,count(*) as qty
 11  from products p join item_list i on i.item = p.pid
 12  where i.rno = rec_sel group by (p.food,p.flavor);
 13  cursor c2 is select fname,lname from customers c join receipts r
 14  on r.cid = c.cid where rno=rec_sel;
 15  begin
 16  	     rec_sel := &rec_sel;
 17  	     select count(count(*)) into co from products p join item_list i on i.item = p.pid
 18  	     where i.rno = rec_sel
 19  	     group by (p.food,p.flavor);
 20  	 select sum(count(*)) into qty from products p join item_list i on i.item = p.pid
 21  	     where i.rno = rec_sel
 22  	     group by (p.food,p.flavor);
 23  	     open c1;
 24  	     open c2;
 25  	     fetch c2 into c_fname,c_lname;
 26  	     dbms_output.put_line('Customer name: '||c_lname||' '||c_fname);
 27  	     dbms_output.put_line('FOOD FLAVOR QUANTITY');
 28  	     dbms_output.put_line('------------------------------------------');
 29  	     for count in 1..co loop
 30  		     fetch c1 into food_sel,flavor_sel,qtys;
 31  		     dbms_output.put_line(flavor_sel||' '||food_sel||' '||qtys);
 32  	 end loop;
 33  	     dbms_output.put_line('------------------------------------------');
 34  	     dbms_output.put_line('Total Quantity='||qty);
 35  end;
 36  /
Enter value for rec_sel: 51991
old  16: 	rec_sel := &rec_sel;
new  16: 	rec_sel := 51991;
Customer name: SOPKO                RAYFORD                                     
FOOD FLAVOR QUANTITY                                                            
------------------------------------------                                      
Chocolate       Tart            1                                               
Apple           Tart            1                                               
Apple           Pie             1                                               
Truffle         Cake            1                                               
------------------------------------------                                      
Total Quantity=4                                                                

PL/SQL procedure successfully completed.

SQL> spool off
