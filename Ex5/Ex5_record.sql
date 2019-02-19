SQL> @z:/Ex5/Ex5.sql
SQL> REM 1. Check whether the given combination of food and flavor is available. If any one or
SQL> REM    both are not available, display the relevant message.
SQL> set serveroutput on;
SQL> create or replace procedure select_1(fl IN products.flavor%type, fo IN products.food%type, count_1 OUT integer) IS
  2  begin
  3  	     select count(*) into count_1
  4  	     from (select pid from products
  5  	     where food=fo and flavor=fl);
  6  end;
  7  /

Procedure created.

SQL> declare
  2  fl products.flavor%type;
  3  fo products.food%type;
  4  c number(3);
  5  begin
  6  	     fl := '&flavor';
  7  	     fo := '&food';
  8  	     select_1(fl,fo,c);
  9  	     if SQL%found and c>0 then
 10  		     dbms_output.put_line(c||' found');
 11  	     else
 12  		     dbms_output.put_line('Not found');
 13  	     end if;
 14  end;
 15  /
Enter value for flavor: Chocolate 
old   6: 	fl := '&flavor';
new   6: 	fl := 'Chocolate ';
Enter value for food: Cake
old   7: 	fo := '&food';
new   7: 	fo := 'Cake';
1 found                                                                         

PL/SQL procedure successfully completed.

SQL> REM 2. On a given date, find the number of items sold (Use Implicit cursor).
SQL> create or replace procedure select_2(date_1 IN receipts.rdate%type, count_1 OUT integer) IS
  2  begin
  3  	     select count(*) into count_1
  4  	     from (select rdate from item_list i join receipts r on r.rno=i.rno
  5  	     where r.rdate=date_1);
  6  end;
  7  /

Procedure created.

SQL> declare
  2  date_search receipts.rdate%type;
  3  c number(3);
  4  begin
  5  	     date_search := '&date_search';
  6  	     select_2(date_search,c);
  7  	     if SQL%found and c>0 then
  8  		     dbms_output.put_line('No. of items sold on '||date_search||' is/are:'||c);
  9  	     else
 10  		     dbms_output.put_line('No items sold');
 11  	     end if;
 12  end;
 13  /
Enter value for date_search: 03-OCT-2007
old   5: 	date_search := '&date_search';
new   5: 	date_search := '03-OCT-2007';
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
  9  	     ip_price := &input_price;
 10  	     open c1;
 11  	     c := 0;
 12  	     loop
 13  		     fetch c1
 14  		     into pro.pid, pro.flavor, pro.food, pro.price;
 15  		     if c1%found then
 16  			     dbms_output.put_line(pro.pid||' '||pro.flavor||' '||pro.food||' '||pro.price);
 17  			     c := c+1;
 18  		     else
 19  			     exit;
 20  		     end if;
 21  	     end loop;
 22  	     dbms_output.put_line(c);
 23  end;
 24  /
Enter value for input_price: 0.8
old   9: 	ip_price := &input_price;
new   9: 	ip_price := 0.8;
70-LEM Lemon           Cookie          .79                                      
70-W Walnut          Cookie          .79                                        
2                                                                               

PL/SQL procedure successfully completed.

SQL> REM 4.Display the customer name along with the details of item and its quantity ordered for
SQL> REM the given order number. Also calculate the total quantity ordered
SQL> spool off
