SQL> create table Pincode(
  2  Pin number(6) constraint Pin_prim_key primary key,
  3  Loc char(15)
  4  );

Table created.

SQL> 
SQL> create table Employee(
  2  Emp_No varchar2(5) constraint Emp_prim_key primary key,
  3  Emp_Name char(15),
  4  DOB DATE,
  5  Pin number(6) constraint Emp_fk references Pincode(Pin),
  6  constraint Emp_check check(Emp_No like 'E%')
  7  );

Table created.

SQL> create table Customer(
  2  Cust_no varchar2(10) constraint Cust_prim_key primary key,
  3  Cust_name char(15),
  4  Street_name char(15),
  5  Pin number(6) constraint Cust_pcheck references Pincode(Pin),
  6  DOB DATE,
  7  Phone_No number(10),
  8  constraint Cust_check check(Cust_no like 'C%')
  9  );

Table created.

SQL> create table Part(
  2  P_No varchar2(15) constraint Part_prim_key primary key,
  3  P_Name char(15),
  4  Price number(10) constraint p_price not null,
  5  Qty number(10) constraint p_qty check(Qty>0),
  6  constraint Part_check check (P_No like 'P%')
  7  );

Table created.

SQL> create table Order_Purchase(
  2  Order_No varchar2(5) constraint Order_prim_key primary key,
  3  Emp_No varchar2(5) constraint Emp_fk1 references Employee(Emp_No),
  4  Cust_no varchar2(5) constraint Cust_fk1 references Customer(Cust_no),
  5  rd DATE,
  6  sd DATE,
  7  constraint Date_check check(rd<sd),
  8  constraint Order_check check(Order_No like 'O%')
  9  );

Table created.

SQL> create table Order_Details(
  2  Order_No varchar2(5) constraint Order_fk1 references Order_Purchase(Order_No),
  3  P_No varchar2(5) constraint Order_fk2 references Part(P_No),
  4  Qty number(10) constraint Qtych2 check(Qty>0),
  5  constraint  Orderd_prim_key primary key(Order_No,P_No)
  6  );

Table created.

SQL> insert into Pincode(Pin,Loc)
  2  values(600041,'Thiruvanmiyur');

1 row created.

SQL> insert into Pincode(Pin,Loc)
  2  values(600020,'Adyar');

1 row created.

SQL> insert into Pincode(Pin,Loc)
  2  values(600103,'Anna nagar');

1 row created.

SQL> insert into Pincode(Pin,Loc)
  2  values(600001,'Adambakkam');

1 row created.

SQL> insert into Employee(Emp_No,Emp_Name,DOB,Pin)
  2  values('E01','Ram', TO_DATE('19/06/1999', 'DD/MM/YYYY'), 600020);

1 row created.

SQL> insert into Employee(Emp_No,Emp_Name,DOB,Pin)
  2  values('E02','Nanda', TO_DATE('06/04/2000', 'DD/MM/YYYY'), 600103);

1 row created.

SQL> insert into Employee(Emp_No,Emp_Name,DOB,Pin)
  2  values('E03','Balajee', TO_DATE('02/09/1999', 'DD/MM/YYYY'), 600001);

1 row created.

SQL> 
SQL> insert into Employee(Emp_No,Emp_Name,DOB,Pin)
  2  values('E04','Shriram', TO_DATE('07/07/1999', 'DD/MM/YYYY'), 600001);

1 row created.

SQL> 
SQL> insert into Employee(Emp_No,Emp_Name,DOB,Pin)
  2  values('E05','Apurva', TO_DATE('30/07/1999', 'DD/MM/YYYY'), 600020);

1 row created.

SQL> 
SQL> insert into Employee(Emp_No,Emp_Name,DOB,Pin)
  2  values('E06','Felix', TO_DATE('24/10/1989', 'DD/MM/YYYY'), 600103);

1 row created.

SQL> insert into Customer(Cust_no, Cust_name, Street_name,Pin, DOB, Phone_No)
  2  values('C01', 'Nandah','Kasturi nagar', 600020, TO_DATE('06/04/2000','DD/MM/YYYY'), 1234569876);

1 row created.

SQL> insert into Customer(Cust_no, Cust_name, Street_name,Pin, DOB, Phone_No)
  2  values('C02', 'Kaushik','Nehru nagar', 600020, TO_DATE('17/12/1998','DD/MM/YYYY'), 2452693261);

1 row created.

SQL> 
SQL> insert into Customer(Cust_no, Cust_name, Street_name,Pin, DOB, Phone_No)
  2  values('C03', 'Praveen','Gandhi Nagar', 600103, TO_DATE('04/12/1986','DD/MM/YYYY'), 2341698769);

1 row created.

SQL> 
SQL> insert into Customer(Cust_no, Cust_name, Street_name,Pin, DOB, Phone_No)
  2  values('C04', 'Ryan','Higa Street', 600001, TO_DATE('15/06/1969','DD/MM/YYYY'), 9887654321);

1 row created.

SQL> 
SQL> insert into Customer(Cust_no, Cust_name, Street_name,Pin, DOB, Phone_No)
  2  values('C05', 'Jeff','Grand Street', 600041, TO_DATE('26/08/1977','DD/MM/YYYY'), 8762390123);

1 row created.

SQL> insert into Part(P_No, P_Name, Price, Qty)
  2  values('P01','Bat', 300, 14);

1 row created.

SQL> 
SQL> insert into Part(P_No, P_Name, Price, Qty)
  2  values('P02','Ball', 25, 150);

1 row created.

SQL> 
SQL> insert into Part(P_No, P_Name, Price, Qty)
  2  values('P03','Hoddie', 1000, 60);

1 row created.

SQL> 
SQL> insert into Part(P_No, P_Name, Price, Qty)
  2  values('P04','Pants', 550, 30);

1 row created.

SQL> 
SQL> insert into Part(P_No, P_Name, Price, Qty)
  2  values('P05','Shoes', 999,56 );

1 row created.

SQL> 
SQL> insert into Part(P_No, P_Name, Price, Qty)
  2  values('P06','Deoderant',250,100);

1 row created.

SQL> insert into Order_Purchase(Order_No, Emp_No, Cust_No, rd, sd)
  2  values('O01','E03','C04',TO_DATE('19/06/2018','DD/MM/YYYY'),TO_DATE('29/06/2018','DD/MM/YYYY'));

1 row created.

SQL> 
SQL> insert into Order_Purchase(Order_No, Emp_No, Cust_No, rd, sd)
  2  values('O02','E02','C01',TO_DATE('01/01/2018','DD/MM/YYYY'),TO_DATE('20/01/2018','DD/MM/YYYY'));

1 row created.

SQL> 
SQL> insert into Order_Purchase(Order_No, Emp_No, Cust_No, rd, sd)
  2  values('O03','E03','C03',TO_DATE('19/10/2018','DD/MM/YYYY'),TO_DATE('06/11/2018','DD/MM/YYYY'));

1 row created.

SQL> 
SQL> 
SQL> insert into Order_Details(Order_No, P_No, Qty)
  2  values('O02','P05',2);

1 row created.

SQL> 
SQL> insert into Order_Details(Order_No, P_No, Qty)
  2  values('O01','P04',4);

1 row created.

SQL> 
SQL> insert into Order_Details(Order_No, P_No, Qty)
  2  values('O03','P01',1);

1 row created.

SQL> 
SQL> insert into Order_Details(Order_No, P_No, Qty)
  2  values('O02','P06',2);

1 row created.

SQL> 
SQL> insert into Order_Details(Order_No, P_No, Qty)
  2  values('O03','P02',6);

1 row created.

SQL> alter table Part add reorder_level number(5);

Table altered.

SQL> alter table Employee add hire_date date;

Table altered.

SQL> alter table Customer modify Cust_Name char(30);

Table altered.

SQL> alter table Employee drop column DOB;

Table altered. 

SQL> alter table Order_Purchase modify rd constraint date_not_null not null;

Table altered.

SQL> select * from pincode;

       PIN LOC                                                                  
---------- ---------------                                                      
    600041 Thiruvanmiyur                                                        
    600020 Adyar                                                                
    600103 Anna nagar                                                           
    600001 Adambakkam                                                           

SQL> select * from employee;

EMP_N EMP_NAME               PIN HIRE_DATE                                      
----- --------------- ---------- ---------                                      
E01   Ram                 600020                                                
E02   Nanda               600103                                                
E03   Balajee             600001                                                
E04   Shriram             600001                                                
E05   Apurva              600020                                                
E06   Felix               600103                                                

6 rows selected.

SQL> select * from order_details;

ORDER P_NO         QTY                                                          
----- ----- ----------                                                          
O02   P05            2                                                          
O01   P04            4                                                          
O03   P01            1                                                          
O02   P06            2                                                          
O03   P02            6                                                          

SQL> spool off
