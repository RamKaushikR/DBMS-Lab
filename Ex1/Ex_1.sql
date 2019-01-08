REM: Dropping the tables
drop table Order_Details;

drop table Order_Purchase;

drop table Part;

drop table Customer;

drop table Employee;

drop table Pincode;

REM: Creating table pincode
create table Pincode(
Pin number(6) constraint Pin_prim_key primary key,
Loc char(15)
);

DESC Pincode;

REM: Inserting into table pincode

insert into Pincode(Pin,Loc)
values(600020,'Adyar');

REM: constraint violation
insert into Pincode(Pin,Loc)
values(600020,'Adyar');

REM: Creating table employee
create table Employee(
Emp_No varchar2(5) constraint Emp_prim_key primary key,
Emp_Name char(15),
DOB DATE,
Pin number(6) constraint Emp_fk references Pincode(Pin),
constraint Emp_check check(Emp_No like 'E%')
); 

DESC Employee;

REM: Inserting into table employee
insert into Employee(Emp_No,Emp_Name,DOB,Pin)
values('E01','Ram', TO_DATE('19/06/1999', 'DD/MM/YYYY'), 600020);

REM: constraint violations
insert into Employee(Emp_No,Emp_Name,DOB,Pin)
values('F06','Felix', TO_DATE('24/10/1989', 'DD/MM/YYYY'), 600020);

insert into Employee(Emp_No,Emp_Name,DOB,Pin)
values('E01','Felix', TO_DATE('24/10/1989', 'DD/MM/YYYY'), 600020);

insert into Employee(Emp_No,Emp_Name,DOB,Pin)
values('E06','Felix', TO_DATE('24/10/1989', 'DD/MM/YYYY'), 600021);

REM: Creating table customer
create table Customer(
Cust_no varchar2(10) constraint Cust_prim_key primary key,
Cust_name char(15),
Street_name char(15),
Pin number(6) constraint Cust_pcheck references Pincode(Pin),
DOB DATE,
Phone_No number(10),
constraint Cust_check check(Cust_no like 'C%')
);

DESC Customer;

REM: Inserting into table Customer

insert into Customer(Cust_no, Cust_name, Street_name,Pin, DOB, Phone_No)
values('C05', 'Jeff','Grand Street', 600020, TO_DATE('26/08/1977','DD/MM/YYYY'), 8762390123);

REM: Constraint violations
insert into Customer(Cust_no, Cust_name, Street_name,Pin, DOB, Phone_No)
values('D05', 'Jeff','Grand Street', 600020, TO_DATE('26/08/1977','DD/MM/YYYY'), 8762390123);

insert into Customer(Cust_no, Cust_name, Street_name,Pin, DOB, Phone_No)
values('C05', 'Jeff','Grand Street', 600020, TO_DATE('26/08/1977','DD/MM/YYYY'), 8762390123);

insert into Customer(Cust_no, Cust_name, Street_name,Pin, DOB, Phone_No)
values('C06', 'Jeff','Grand Street', 600021, TO_DATE('26/08/1977','DD/MM/YYYY'), 8762390123);

REM: Creating table part
create table Part(
P_No varchar2(15) constraint Part_prim_key primary key,
P_Name char(15),
Price number(10) constraint p_price not null,
Qty number(10) constraint p_qty check(Qty>0),
constraint Part_check check (P_No like 'P%')
);

DESC Part;

REM: Inserting into table part
insert into Part(P_No, P_Name, Price, Qty)
values('P01','Bat', 300, 14);

insert into Part(P_No, P_Name, Price, Qty)
values('P02','Ball', 25, 150);

REM: Constraint violations
insert into Part(P_No, P_Name, Price, Qty)
values('Q06','Deoderant',250,100);

insert into Part(P_No, P_Name, Price, Qty)
values('P02','Deoderant',250,100);

insert into Part(P_No, P_Name, Price, Qty)
values('P07','Deoderant',null,100);

insert into Part(P_No, P_Name, Price, Qty)
values('P08','Deoderant',250,0);

REM: Creating order purchase
create table Order_Purchase(
Order_No varchar2(5) constraint Order_prim_key primary key,
Emp_No varchar2(5) constraint Emp_fk1 references Employee(Emp_No),
Cust_no varchar2(5) constraint Cust_fk1 references Customer(Cust_no),
rd DATE,
sd DATE,
constraint Date_check check(rd<sd),
constraint Order_check check(Order_No like 'O%')
);

DESC Order_Purchase;

REM: Inserting into table order purchase
insert into Order_Purchase(Order_No, Emp_No, Cust_No, rd, sd)
values('O01','E03','C04',TO_DATE('19/06/2018','DD/MM/YYYY'),TO_DATE('29/06/2018','DD/MM/YYYY'));

REM: Constraint violations
insert into Order_Purchase(Order_No, Emp_No, Cust_No, rd, sd)
values('P03','E03','C03',TO_DATE('19/10/2018','DD/MM/YYYY'),TO_DATE('06/11/2018','DD/MM/YYYY'));

insert into Order_Purchase(Order_No, Emp_No, Cust_No, rd, sd)
values('O01','E01','C01',TO_DATE('19/10/2018','DD/MM/YYYY'),TO_DATE('06/11/2018','DD/MM/YYYY'));

insert into Order_Purchase(Order_No, Emp_No, Cust_No, rd, sd)
values('O04','E10','C01',TO_DATE('19/10/2018','DD/MM/YYYY'),TO_DATE('06/11/2018','DD/MM/YYYY'));

insert into Order_Purchase(Order_No, Emp_No, Cust_No, rd, sd)
values('O04','E01','C11',TO_DATE('19/10/2018','DD/MM/YYYY'),TO_DATE('06/11/2018','DD/MM/YYYY'));

insert into Order_Purchase(Order_No, Emp_No, Cust_No, rd, sd)
values('O04','E01','C01',TO_DATE('19/10/2018','DD/MM/YYYY'),TO_DATE('06/10/2018','DD/MM/YYYY'));

REM: Creating table order deatils
create table Order_Details(
Order_No varchar2(5) constraint Order_fk1 references Order_Purchase(Order_No),
P_No varchar2(5) constraint Order_fk2 references Part(P_No),
Qty number(10) constraint Qtych2 check(Qty>0),
constraint  Orderd_prim_key primary key(Order_No,P_No)
);

DESC Order_Details;

REM: Inserting into table order details
insert into Order_Details(Order_No, P_No, Qty)
values('O01','P05',2);

REM: Constraint violations
insert into Order_Details(Order_No, P_No, Qty)
values('O01','P10',6);

insert into Order_Details(Order_No, P_No, Qty)
values('O01','P01',6);

insert into Order_Details(Order_No, P_No, Qty)
values('O01','P04',0);

REM: Altering the tables
DESC Part;

alter table Part add reorder_level number(5);

DESC Part;

DESC Employee;

alter table Employee add hire_date date;

DESC Employee;

DESC Customer;

alter table Customer modify Cust_Name char(30);

DESC Customer;

DESC Employee;

alter table Employee drop column DOB;

DESC Employee;

DESC Order_Purchase;

alter table Order_Purchase modify rd constraint rd_date not null;

DESC Order_Purchase;

DESC Order_Details;

alter table Order_Details drop constraint Order_fk1;

alter table Order_Details add constraint Order_cons1 foreign key(Order_No) references Order_Purchase(Order_No) on delete cascade;

DESC Order_Details;