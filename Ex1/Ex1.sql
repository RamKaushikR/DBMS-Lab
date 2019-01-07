create table Pincode(
Pin number(6) constraint Pin_prim_key primary key,
Loc char(15)
);

create table Employee(
Emp_No varchar2(5) constraint Emp_prim_key primary key,
Emp_Name char(15),
DOB DATE,
Pin number(6) constraint Emp_fk references Pincode(Pin),
constraint Emp_check check(Emp_No like 'E%')
); 

create table Customer(
Cust_no varchar2(10) constraint Cust_prim_key primary key,
Cust_name char(15),
Street_name char(15),
Pin number(6) constraint Cust_pcheck references Pincode(Pin),
DOB DATE,
Phone_No number(10),
constraint Cust_check check(Cust_no like 'C%')
);

create table Part(
P_No varchar2(15) constraint Part_prim_key primary key,
P_Name char(15),
Price number(10) constraint p_price not null,
Qty number(10) constraint p_qty check(Qty>0),
constraint Part_check check (P_No like 'P%')
);

create table Order_Purchase(
Order_No varchar2(5) constraint Order_prim_key primary key,
Emp_No varchar2(5) constraint Emp_fk1 references Employee(Emp_No),
Cust_no varchar2(5) constraint Cust_fk1 references Customer(Cust_no),
rd DATE,
sd DATE,
constraint Date_check check(rd<sd),
constraint Order_check check(Order_No like 'O%')
);

create table Order_Details(
Order_No varchar2(5) constraint Order_fk1 references Order_Purchase(Order_No),
P_No varchar2(5) constraint Order_fk2 references Part(P_No),
Qty number(10) constraint Qtych2 check(Qty>0),
constraint  Orderd_prim_key primary key(Order_No,P_No)
);



insert into Pincode(Pin,Loc)
values(600041,'Thiruvanmiyur');

insert into Pincode(Pin,Loc)
values(600020,'Adyar');

insert into Pincode(Pin,Loc)
values(600103,'Anna nagar');

insert into Pincode(Pin,Loc)
values(600001,'Adambakkam');


insert into Employee(Emp_No,Emp_Name,DOB,Pin)
values('E01','Ram', TO_DATE('19/06/1999', 'DD/MM/YYYY'), 600020);

insert into Employee(Emp_No,Emp_Name,DOB,Pin)
values('E02','Nanda', TO_DATE('06/04/2000', 'DD/MM/YYYY'), 600103);

insert into Employee(Emp_No,Emp_Name,DOB,Pin)
values('E03','Balajee', TO_DATE('02/09/1999', 'DD/MM/YYYY'), 600001);

insert into Employee(Emp_No,Emp_Name,DOB,Pin)
values('E04','Shriram', TO_DATE('07/07/1999', 'DD/MM/YYYY'), 600001);

insert into Employee(Emp_No,Emp_Name,DOB,Pin)
values('E05','Apurva', TO_DATE('30/07/1999', 'DD/MM/YYYY'), 600020);

insert into Employee(Emp_No,Emp_Name,DOB,Pin)
values('E06','Felix', TO_DATE('24/10/1989', 'DD/MM/YYYY'), 600103);


insert into Customer(Cust_no, Cust_name, Street_name,Pin, DOB, Phone_No)
values('C01', 'Nandah','Kasturi nagar', 600020, TO_DATE('06/04/2000','DD/MM/YYYY'), 1234569876);

insert into Customer(Cust_no, Cust_name, Street_name,Pin, DOB, Phone_No)
values('C02', 'Kaushik','Nehru nagar', 600020, TO_DATE('17/12/1998','DD/MM/YYYY'), 2452693261);

insert into Customer(Cust_no, Cust_name, Street_name,Pin, DOB, Phone_No)
values('C03', 'Praveen','Gandhi Nagar', 600103, TO_DATE('04/12/1986','DD/MM/YYYY'), 2341698769);

insert into Customer(Cust_no, Cust_name, Street_name,Pin, DOB, Phone_No)
values('C04', 'Ryan','Higa Street', 600001, TO_DATE('15/06/1969','DD/MM/YYYY'), 9887654321);

insert into Customer(Cust_no, Cust_name, Street_name,Pin, DOB, Phone_No)
values('C05', 'Jeff','Grand Street', 600041, TO_DATE('26/08/1977','DD/MM/YYYY'), 8762390123);


insert into Part(P_No, P_Name, Price, Qty)
values('P01','Bat', 300, 14);

insert into Part(P_No, P_Name, Price, Qty)
values('P02','Ball', 25, 150);

insert into Part(P_No, P_Name, Price, Qty)
values('P03','Hoddie', 1000, 60);

insert into Part(P_No, P_Name, Price, Qty)
values('P04','Pants', 550, 30);

insert into Part(P_No, P_Name, Price, Qty)
values('P05','Shoes', 999,56 );

insert into Part(P_No, P_Name, Price, Qty)
values('P06','Deoderant',250,100);

insert into Order_Purchase(Order_No, Emp_No, Cust_No, rd, sd)
values('O01','E03','C04',TO_DATE('19/06/2018','DD/MM/YYYY'),TO_DATE('29/06/2018','DD/MM/YYYY'));

insert into Order_Purchase(Order_No, Emp_No, Cust_No, rd, sd)
values('O02','E02','C01',TO_DATE('01/01/2018','DD/MM/YYYY'),TO_DATE('20/01/2018','DD/MM/YYYY'));

insert into Order_Purchase(Order_No, Emp_No, Cust_No, rd, sd)
values('O03','E03','C03',TO_DATE('19/10/2018','DD/MM/YYYY'),TO_DATE('06/11/2018','DD/MM/YYYY'));


insert into Order_Details(Order_No, P_No, Qty)
values('O02','P05',2);

insert into Order_Details(Order_No, P_No, Qty)
values('O01','P04',4);

insert into Order_Details(Order_No, P_No, Qty)
values('O03','P01',1);

insert into Order_Details(Order_No, P_No, Qty)
values('O02','P06',2);

insert into Order_Details(Order_No, P_No, Qty)
values('O03','P02',6);


alter table Part add reorder_level number(5);

alter table Employee add hire_date date;

alter table Customer modify Cust_Name char(30);

alter table Employee drop column DOB;

alter table Order_Purchase modify rd constraint not null;







