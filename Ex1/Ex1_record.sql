SQL> @z:Ex_1.sql
SQL> REM: Dropping the tables
SQL> drop table Order_Details;

Table dropped.

SQL> 
SQL> drop table Order_Purchase;

Table dropped.

SQL> 
SQL> drop table Part;

Table dropped.

SQL> 
SQL> drop table Customer;

Table dropped.

SQL> 
SQL> drop table Employee;

Table dropped.

SQL> 
SQL> drop table Pincode;

Table dropped.

SQL> 
SQL> REM: Creating table pincode
SQL> create table Pincode(
  2  Pin number(6) constraint Pin_prim_key primary key,
  3  Loc char(15)
  4  );

Table created.

SQL> 
SQL> DESC Pincode;
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 PIN                                       NOT NULL NUMBER(6)
 LOC                                                CHAR(15)

SQL> 
SQL> REM: Inserting into table pincode
SQL> 
SQL> insert into Pincode(Pin,Loc)
  2  values(600020,'Adyar');

1 row created.

SQL> 
SQL> REM: constraint violation
SQL> insert into Pincode(Pin,Loc)
  2  values(600020,'Adyar');
insert into Pincode(Pin,Loc)
*
ERROR at line 1:
ORA-00001: unique constraint (4125.PIN_PRIM_KEY) violated 


SQL> 
SQL> REM: Creating table employee
SQL> create table Employee(
  2  Emp_No varchar2(5) constraint Emp_prim_key primary key,
  3  Emp_Name char(15),
  4  DOB DATE,
  5  Pin number(6) constraint Emp_fk references Pincode(Pin),
  6  constraint Emp_check check(Emp_No like 'E%')
  7  );

Table created.

SQL> 
SQL> DESC Employee;
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 EMP_NO                                    NOT NULL VARCHAR2(5)
 EMP_NAME                                           CHAR(15)
 DOB                                                DATE
 PIN                                                NUMBER(6)

SQL> 
SQL> REM: Inserting into table employee
SQL> insert into Employee(Emp_No,Emp_Name,DOB,Pin)
  2  values('E01','Ram', TO_DATE('19/06/1999', 'DD/MM/YYYY'), 600020);

1 row created.

SQL> 
SQL> REM: constraint violations
SQL> insert into Employee(Emp_No,Emp_Name,DOB,Pin)
  2  values('F06','Felix', TO_DATE('24/10/1989', 'DD/MM/YYYY'), 600020);
insert into Employee(Emp_No,Emp_Name,DOB,Pin)
*
ERROR at line 1:
ORA-02290: check constraint (4125.EMP_CHECK) violated 


SQL> 
SQL> insert into Employee(Emp_No,Emp_Name,DOB,Pin)
  2  values('E01','Felix', TO_DATE('24/10/1989', 'DD/MM/YYYY'), 600020);
insert into Employee(Emp_No,Emp_Name,DOB,Pin)
*
ERROR at line 1:
ORA-00001: unique constraint (4125.EMP_PRIM_KEY) violated 


SQL> 
SQL> insert into Employee(Emp_No,Emp_Name,DOB,Pin)
  2  values('E06','Felix', TO_DATE('24/10/1989', 'DD/MM/YYYY'), 600021);
insert into Employee(Emp_No,Emp_Name,DOB,Pin)
*
ERROR at line 1:
ORA-02291: integrity constraint (4125.EMP_FK) violated - parent key not found 


SQL> 
SQL> REM: Creating table customer
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

SQL> 
SQL> DESC Customer;
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 CUST_NO                                   NOT NULL VARCHAR2(10)
 CUST_NAME                                          CHAR(15)
 STREET_NAME                                        CHAR(15)
 PIN                                                NUMBER(6)
 DOB                                                DATE
 PHONE_NO                                           NUMBER(10)

SQL> 
SQL> REM: Inserting into table Customer
SQL> 
SQL> insert into Customer(Cust_no, Cust_name, Street_name,Pin, DOB, Phone_No)
  2  values('C05', 'Jeff','Grand Street', 600020, TO_DATE('26/08/1977','DD/MM/YYYY'), 8762390123);

1 row created.

SQL> 
SQL> REM: Constraint violations
SQL> insert into Customer(Cust_no, Cust_name, Street_name,Pin, DOB, Phone_No)
  2  values('D05', 'Jeff','Grand Street', 600020, TO_DATE('26/08/1977','DD/MM/YYYY'), 8762390123);
insert into Customer(Cust_no, Cust_name, Street_name,Pin, DOB, Phone_No)
*
ERROR at line 1:
ORA-02290: check constraint (4125.CUST_CHECK) violated 


SQL> 
SQL> insert into Customer(Cust_no, Cust_name, Street_name,Pin, DOB, Phone_No)
  2  values('C05', 'Jeff','Grand Street', 600020, TO_DATE('26/08/1977','DD/MM/YYYY'), 8762390123);
insert into Customer(Cust_no, Cust_name, Street_name,Pin, DOB, Phone_No)
*
ERROR at line 1:
ORA-00001: unique constraint (4125.CUST_PRIM_KEY) violated 


SQL> 
SQL> insert into Customer(Cust_no, Cust_name, Street_name,Pin, DOB, Phone_No)
  2  values('C06', 'Jeff','Grand Street', 600021, TO_DATE('26/08/1977','DD/MM/YYYY'), 8762390123);
insert into Customer(Cust_no, Cust_name, Street_name,Pin, DOB, Phone_No)
*
ERROR at line 1:
ORA-02291: integrity constraint (4125.CUST_PCHECK) violated - parent key not 
found 


SQL> 
SQL> REM: Creating table part
SQL> create table Part(
  2  P_No varchar2(15) constraint Part_prim_key primary key,
  3  P_Name char(15),
  4  Price number(10) constraint p_price not null,
  5  Qty number(10) constraint p_qty check(Qty>0),
  6  constraint Part_check check (P_No like 'P%')
  7  );

Table created.

SQL> 
SQL> DESC Part;
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 P_NO                                      NOT NULL VARCHAR2(15)
 P_NAME                                             CHAR(15)
 PRICE                                     NOT NULL NUMBER(10)
 QTY                                                NUMBER(10)

SQL> 
SQL> REM: Inserting into table part
SQL> insert into Part(P_No, P_Name, Price, Qty)
  2  values('P01','Bat', 300, 14);

1 row created.

SQL> 
SQL> insert into Part(P_No, P_Name, Price, Qty)
  2  values('P02','Ball', 25, 150);

1 row created.

SQL> 
SQL> REM: Constraint violations
SQL> insert into Part(P_No, P_Name, Price, Qty)
  2  values('Q06','Deoderant',250,100);
insert into Part(P_No, P_Name, Price, Qty)
*
ERROR at line 1:
ORA-02290: check constraint (4125.PART_CHECK) violated 


SQL> 
SQL> insert into Part(P_No, P_Name, Price, Qty)
  2  values('P02','Deoderant',250,100);
insert into Part(P_No, P_Name, Price, Qty)
*
ERROR at line 1:
ORA-00001: unique constraint (4125.PART_PRIM_KEY) violated 


SQL> 
SQL> insert into Part(P_No, P_Name, Price, Qty)
  2  values('P07','Deoderant',null,100);
values('P07','Deoderant',null,100)
                         *
ERROR at line 2:
ORA-01400: cannot insert NULL into ("4125"."PART"."PRICE") 


SQL> 
SQL> insert into Part(P_No, P_Name, Price, Qty)
  2  values('P08','Deoderant',250,0);
insert into Part(P_No, P_Name, Price, Qty)
*
ERROR at line 1:
ORA-02290: check constraint (4125.P_QTY) violated 


SQL> 
SQL> REM: Creating order purchase
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

SQL> 
SQL> DESC Order_Purchase;
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 ORDER_NO                                  NOT NULL VARCHAR2(5)
 EMP_NO                                             VARCHAR2(5)
 CUST_NO                                            VARCHAR2(5)
 RD                                                 DATE
 SD                                                 DATE

SQL> 
SQL> REM: Inserting into table order purchase
SQL> insert into Order_Purchase(Order_No, Emp_No, Cust_No, rd, sd)
  2  values('O01','E01','C05',TO_DATE('19/06/2018','DD/MM/YYYY'),TO_DATE('29/06/2018','DD/MM/YYYY')); 
1 row created.

SQL> 
SQL> REM: Constraint violations
SQL> insert into Order_Purchase(Order_No, Emp_No, Cust_No, rd, sd)
  2  values('P03','E03','C03',TO_DATE('19/10/2018','DD/MM/YYYY'),TO_DATE('06/11/2018','DD/MM/YYYY'));
insert into Order_Purchase(Order_No, Emp_No, Cust_No, rd, sd)
*
ERROR at line 1:
ORA-02290: check constraint (4125.ORDER_CHECK) violated 


SQL> 
SQL> insert into Order_Purchase(Order_No, Emp_No, Cust_No, rd, sd)
  2  values('O01','E01','C01',TO_DATE('19/10/2018','DD/MM/YYYY'),TO_DATE('06/11/2018','DD/MM/YYYY'));
insert into Order_Purchase(Order_No, Emp_No, Cust_No, rd, sd)
*
ERROR at line 1:
ORA-02291: integrity constraint (4125.CUST_FK1) violated - parent key not found 


SQL> 
SQL> insert into Order_Purchase(Order_No, Emp_No, Cust_No, rd, sd)
  2  values('O04','E10','C01',TO_DATE('19/10/2018','DD/MM/YYYY'),TO_DATE('06/11/2018','DD/MM/YYYY'));
insert into Order_Purchase(Order_No, Emp_No, Cust_No, rd, sd)
*
ERROR at line 1:
ORA-02291: integrity constraint (4125.CUST_FK1) violated - parent key not found 


SQL> 
SQL> insert into Order_Purchase(Order_No, Emp_No, Cust_No, rd, sd)
  2  values('O04','E01','C11',TO_DATE('19/10/2018','DD/MM/YYYY'),TO_DATE('06/11/2018','DD/MM/YYYY'));
insert into Order_Purchase(Order_No, Emp_No, Cust_No, rd, sd)
*
ERROR at line 1:
ORA-02291: integrity constraint (4125.CUST_FK1) violated - parent key not found 


SQL> 
SQL> insert into Order_Purchase(Order_No, Emp_No, Cust_No, rd, sd)
  2  values('O04','E01','C01',TO_DATE('19/10/2018','DD/MM/YYYY'),TO_DATE('06/10/2018','DD/MM/YYYY'));
insert into Order_Purchase(Order_No, Emp_No, Cust_No, rd, sd)
*
ERROR at line 1:
ORA-02290: check constraint (4125.DATE_CHECK) violated 


SQL> 
SQL> REM: Creating table order deatils
SQL> create table Order_Details(
  2  Order_No varchar2(5) constraint Order_fk1 references Order_Purchase(Order_No),
  3  P_No varchar2(5) constraint Order_fk2 references Part(P_No),
  4  Qty number(10) constraint Qtych2 check(Qty>0),
  5  constraint  Orderd_prim_key primary key(Order_No,P_No)
  6  );

Table created.

SQL> 
SQL> DESC Order_Details;
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 ORDER_NO                                  NOT NULL VARCHAR2(5)
 P_NO                                      NOT NULL VARCHAR2(5)
 QTY                                                NUMBER(10)

SQL> 
SQL> REM: Inserting into table order details
SQL> insert into Order_Details(Order_No, P_No, Qty)
  2  values('O01','P01',2);
1 row created.

SQL> 
SQL> REM: Constraint violations
SQL> insert into Order_Details(Order_No, P_No, Qty)
  2  values('O01','P10',6);
insert into Order_Details(Order_No, P_No, Qty)
*
ERROR at line 1:
ORA-02291: integrity constraint (4125.ORDER_FK2) violated - parent key not 
found 


SQL> 
SQL> insert into Order_Details(Order_No, P_No, Qty)
  2  values('O01','P01',6);
insert into Order_Details(Order_No, P_No, Qty)
*
ERROR at line 1:
ORA-02291: integrity constraint (4125.ORDER_FK1) violated - parent key not 
found 


SQL> 
SQL> insert into Order_Details(Order_No, P_No, Qty)
  2  values('O01','P04',0);
insert into Order_Details(Order_No, P_No, Qty)
*
ERROR at line 1:
ORA-02290: check constraint (4125.QTYCH2) violated 


SQL> 
SQL> REM: Altering the tables
SQL> DESC Part;
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 P_NO                                      NOT NULL VARCHAR2(15)
 P_NAME                                             CHAR(15)
 PRICE                                     NOT NULL NUMBER(10)
 QTY                                                NUMBER(10)

SQL> 
SQL> alter table Part add reorder_level number(5);

Table altered.

SQL> 
SQL> DESC Part;
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 P_NO                                      NOT NULL VARCHAR2(15)
 P_NAME                                             CHAR(15)
 PRICE                                     NOT NULL NUMBER(10)
 QTY                                                NUMBER(10)
 REORDER_LEVEL                                      NUMBER(5)

SQL> 
SQL> DESC Employee;
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 EMP_NO                                    NOT NULL VARCHAR2(5)
 EMP_NAME                                           CHAR(15)
 DOB                                                DATE
 PIN                                                NUMBER(6)

SQL> 
SQL> alter table Employee add hire_date date;

Table altered.

SQL> 
SQL> DESC Employee;
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 EMP_NO                                    NOT NULL VARCHAR2(5)
 EMP_NAME                                           CHAR(15)
 DOB                                                DATE
 PIN                                                NUMBER(6)
 HIRE_DATE                                          DATE

SQL> 
SQL> DESC Customer;
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 CUST_NO                                   NOT NULL VARCHAR2(10)
 CUST_NAME                                          CHAR(15)
 STREET_NAME                                        CHAR(15)
 PIN                                                NUMBER(6)
 DOB                                                DATE
 PHONE_NO                                           NUMBER(10)

SQL> 
SQL> alter table Customer modify Cust_Name char(30);

Table altered.

SQL> 
SQL> DESC Customer;
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 CUST_NO                                   NOT NULL VARCHAR2(10)
 CUST_NAME                                          CHAR(30)
 STREET_NAME                                        CHAR(15)
 PIN                                                NUMBER(6)
 DOB                                                DATE
 PHONE_NO                                           NUMBER(10)

SQL> 
SQL> DESC Employee;
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 EMP_NO                                    NOT NULL VARCHAR2(5)
 EMP_NAME                                           CHAR(15)
 DOB                                                DATE
 PIN                                                NUMBER(6)
 HIRE_DATE                                          DATE

SQL> 
SQL> alter table Employee drop column DOB;

Table altered.

SQL> 
SQL> DESC Employee;
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 EMP_NO                                    NOT NULL VARCHAR2(5)
 EMP_NAME                                           CHAR(15)
 PIN                                                NUMBER(6)
 HIRE_DATE                                          DATE

SQL> 
SQL> DESC Order_Purchase;
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 ORDER_NO                                  NOT NULL VARCHAR2(5)
 EMP_NO                                             VARCHAR2(5)
 CUST_NO                                            VARCHAR2(5)
 RD                                                 DATE
 SD                                                 DATE

SQL> 
SQL> alter table Order_Purchase modify rd constraint rd_date not null;

Table altered.

SQL> 
SQL> DESC Order_Purchase;
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 ORDER_NO                                  NOT NULL VARCHAR2(5)
 EMP_NO                                             VARCHAR2(5)
 CUST_NO                                            VARCHAR2(5)
 RD                                        NOT NULL DATE
 SD                                                 DATE

SQL> 
SQL> DESC Order_Details;
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 ORDER_NO                                  NOT NULL VARCHAR2(5)
 P_NO                                      NOT NULL VARCHAR2(5)
 QTY                                                NUMBER(10)

SQL> delete from Order_Purchase where Order_No = 'O01';
delete from Order_Purchase where Order_No = 'O01'
*
ERROR at line 1:
ORA-02292: integrity constraint (4125.ORDER_FK1) violated - child record found

SQL> alter table Order_Details drop constraint Order_fk1;

Table altered.

SQL> 
SQL> alter table Order_Details add constraint Order_cons1 foreign key(Order_No) references Order_Purchase(Order_No) on delete cascade;

Table altered.

SQL> delete from Order_Purchase where Order_No = 'O01';

1 row deleted.

SQL> DESC Order_Details;
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 ORDER_NO                                  NOT NULL VARCHAR2(5)
 P_NO                                      NOT NULL VARCHAR2(5)
 QTY                                                NUMBER(10)

SQL> spool off
