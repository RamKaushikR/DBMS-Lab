SQL> REM ***SSN COLLEGE OF ENGINEERING***
SQL> REM ***DEPARTMENT OF COMPUTER SCIENCE ENGINEERING***
SQL> REM ***DATABASE MANAGEMENT SYSTEMS LAB***
SQL> REM ***Assignment 2: DML Fundamentals***
SQL> REM ***Creating nobel relation***
SQL> create table nobel(
  2  laureate_id number(3) constraint laur_pk PRIMARY KEY,
  3  name varchar2(30) constraint name_nn NOT NULL,
  4  gender char(1) constraint gen_ch check (gender in('m','f')),
  5  category char(3) constraint cat_ch check (category in('Phy','Che','Med','Lit','Pea','Eco','Lit')),
  6  field varchar2(25),
  7  year_award number(4),
  8  aff_role varchar2(30),
  9  dob date,
 10  country varchar2(10)
 11  );

Table created.

SQL> REM ***Populate nobel relation***
SQL> insert into nobel values(100,'Robert B. Laughlin','m','Phy','Condensed matter',1998,'Stanford University','01-nov-1950','USA');

1 row created.

SQL> insert into nobel values(101,'Horst L Stormer','m','Phy','Condensed matter',1998,'Columbia University','06-apr-1949','Germany');

1 row created.

SQL> insert into nobel values(102,'Daniel C. Tsui','m','Phy','Condensed matter',1998,'Princeton University','28-feb-1939','China');

1 row created.

SQL> insert into nobel values(103,'Walter Kohn','m','Che','Theoretical Chemistry',1998,'University of California','09-mar-1923','Austria');

1 row created.

SQL> insert into nobel values(104,'John Pople','m','Che','Theoretical Chemistry',1998,'North Western University','31-oct-1925','UK');

1 row created.

SQL> insert into nobel values(106,'John Hume','m','Pea','Negotiation',1998,'Labour party Leader','18-jan-1937','Ireland');

1 row created.

SQL> insert into nobel values(107,'David Trimble','m','Pea','Negotiation',1998,'Ulster Unionist party Leader','15-oct-1944','Ireland');

1 row created.

SQL> insert into nobel values(108,'Louis J Ignaroo','m','Med','Cardiovascular system',1998,'University of California','31-may-1941','USA');

1 row created.

SQL> insert into nobel values(109,'Amartya Sen','m','Eco','Welfare Economics',1998,'Trinity College','03-nov-1933','India');

1 row created.

SQL> insert into nobel values(110,'Jose Saramago','m','Lit','Portuguese',1998,null,'16-nov-1922','Portugal');

1 row created.

SQL> 
SQL> insert into nobel values(111,'Eric A Cornell','m','Phy','Atomic physics',2001,'University of Colorado','19-dec-1961','USA');

1 row created.

SQL> insert into nobel values(112,'Carl E Wieman','m','Phy','Atomic physics',2001,'University of Colorado','26-mar-1951','USA');

1 row created.

SQL> insert into nobel values(113,'Ryoji Noyori','m','Che','Organic Chemistry',2001,'Nagoya University','03-sep-1938','Japan');

1 row created.

SQL> insert into nobel values(114,'K Barry Sharpless','m','Che','Organic Chemistry',2001,'Scripps Research Institute','28-apr-1941','USA');

1 row created.

SQL> insert into nobel values(115,'Kofi Annan','m','Pea','World organizing',2001,'UN General','08-apr-1938','Ghana');

1 row created.

SQL> insert into nobel values(116,'Joerge A Akeriof','m','Eco','Economic of Information',2001,'University of California','17-jun-1940','USA');

1 row created.

SQL> insert into nobel values(117,'V S Naipaul','m','Lit','English',2001,null,'17-aug-1932','UK');

1 row created.

SQL> 
SQL> insert into nobel values(118,'Charles A Kao','m','Phy','Fiber technology',2009,'University of Hongkong','04-nov-1933','China');

1 row created.

SQL> insert into nobel values(119,'Willard S Boyle','m','Phy','Semiconductor technology',2009,'Bell Laboratories','19-aug-1924','Canada');

1 row created.

SQL> insert into nobel values(120,'George E Smith','m','Phy','Semiconductor technology',2009,'Bell Laboratories','10-may-1930','USA');

1 row created.

SQL> insert into nobel values(121,'Venkatraman Ramakrishnan','m','Che','Biochemistry',2009,'MRC Laboratory','19-aug-1952','India');

1 row created.

SQL> insert into nobel values(122,'Ada E Yonath','f','Che','Biochemistry',2009,'Weizmann Institute of Science','22-jun-1939','Isreal');

1 row created.

SQL> insert into nobel values(123,'Elizabeth H Blackburn','f','Med','Enzymes',2009,'University of California','26-nov-1948','Australia');

1 row created.

SQL> insert into nobel values(124,'Carol W Greider','f','Med','Enzymes',2009,'Johns Hopkins University','15-apr-1961','USA');

1 row created.

SQL> insert into nobel values(125,'Barack H Obama','m','Pea','World organizing',2009,'President of USA','04-aug-1961','USA');

1 row created.

SQL> insert into nobel values(126,'Oliver E Williamson','m','Eco','Economic governance',2009,'University of California','27-sep-1932','USA');

1 row created.

SQL> insert into nobel values(127,'Elinor Ostrom','m','Eco','Economic governance',2009,'Indiana University','07-aug-1933','USA');

1 row created.

SQL> insert into nobel values(128,'Herta Muller','f','Lit','German',2009,null,'17-aug-1953','Romania');

1 row created.

SQL> 
SQL> REM ***************************END OF INSERT****************************************
SQL> REM 1: Display the nobel laureate(s) who born after 1­Jul­1960.
SQL> select Name,Category,DOB from Nobel where DOB > '01-JUL-60';

NAME                           CAT DOB                                          
------------------------------ --- ---------                                    
Eric A Cornell                 Phy 19-DEC-61                                    
Carol W Greider                Med 15-APR-61                                    
Barack H Obama                 Pea 04-AUG-61                                    

SQL> REM 2: Display the Indian laureate (name, category, field, country, year awarded) who was awarded in the Chemistry category.
SQL> select Name,Category,Field,Country,Year_Award from Nobel where Country = 'India' and Category = 'Che';

NAME                           CAT FIELD                     COUNTRY            
------------------------------ --- ------------------------- ----------         
YEAR_AWARD                                                                      
----------                                                                      
Venkatraman Ramakrishnan       Che Biochemistry              India              
      2009                                                                      
                                                                                

SQL> REM 3: . Display the laureates (name, category,field and year of award) who was awarded between 2000 and 2005 for the Physics or Chemistry category.
SQL> select Name,Category,Field,Country,Year_Award from Nobel where Year_Award between 2000 and 2005 and Category in ('Phy', 'Che');

NAME                           CAT FIELD                     COUNTRY            
------------------------------ --- ------------------------- ----------         
YEAR_AWARD                                                                      
----------                                                                      
Eric A Cornell                 Phy Atomic physics            USA                
      2001                                                                      
                                                                                
Carl E Wieman                  Phy Atomic physics            USA                
      2001                                                                      
                                                                                
Ryoji Noyori                   Che Organic Chemistry         Japan              
      2001                                                                      
                                                                                

NAME                           CAT FIELD                     COUNTRY            
------------------------------ --- ------------------------- ----------         
YEAR_AWARD                                                                      
----------                                                                      
K Barry Sharpless              Che Organic Chemistry         USA                
      2001                                                                      
                                                                                

SQL> REM 4: Display the laureates name with their age at the time of award for the Peace category.
SQL> select Name,Year_Award - extract(year from DOB) as Age from Nobel where Category = 'Pea';

NAME                                  AGE                                       
------------------------------ ----------                                       
John Hume                              61                                       
David Trimble                          54                                       
Kofi Annan                             63                                       
Barack H Obama                         48                                       

SQL> REM 5: Display the laureates (name,category,aff_role,country) whose name starts with A or ends with a, but not from Isreal.
SQL> select Name,Category,Aff_Role,Country from Nobel where (Name like 'A%' or Name like '%a') and Country not like 'Israel';

NAME                           CAT AFF_ROLE                       COUNTRY       
------------------------------ --- ------------------------------ ----------    
Amartya Sen                    Eco Trinity College                India         
Ada E Yonath                   Che Weizmann Institute of Science  Isreal        
Barack H Obama                 Pea President of USA               USA           

SQL> REM 6: Display the name, gender, affiliation, dob and country of laureates who was born in 1950s Label the dob column as Born 1950.
SQL> select Name,Gender,Aff_Role,DOB as Born1950,Country from Nobel where extract(year from DOB) between 1950 and 1960;

NAME                           G AFF_ROLE                       BORN1950        
------------------------------ - ------------------------------ ---------       
COUNTRY                                                                         
----------                                                                      
Robert B. Laughlin             m Stanford University            01-NOV-50       
USA                                                                             
                                                                                
Carl E Wieman                  m University of Colorado         26-MAR-51       
USA                                                                             
                                                                                
Venkatraman Ramakrishnan       m MRC Laboratory                 19-AUG-52       
India                                                                           
                                                                                

NAME                           G AFF_ROLE                       BORN1950        
------------------------------ - ------------------------------ ---------       
COUNTRY                                                                         
----------                                                                      
Herta Muller                   f                                17-AUG-53       
Romania                                                                         
                                                                                

SQL> REM 7: Display the laureates (name,gender,category,aff_role,country) whose name starts with A, D or H. Remove the laureate if he/she do not have any affiliation. Sort the results in ascending order of name.
SQL> select Name,Gender,Category,Aff_Role,Country from Nobel where Aff_Role is not null and (Name like 'A%' or Name like 'D%' or Name like 'H%') order by Name;

NAME                           G CAT AFF_ROLE                       COUNTRY     
------------------------------ - --- ------------------------------ ----------  
Ada E Yonath                   f Che Weizmann Institute of Science  Isreal      
Amartya Sen                    m Eco Trinity College                India       
Daniel C. Tsui                 m Phy Princeton University           China       
David Trimble                  m Pea Ulster Unionist party Leader   Ireland     
Horst L Stormer                m Phy Columbia University            Germany     

SQL> REM 8: Display the university name(s) that has to its credit by having at least 2 nobel laureate with them.
SQL> select Aff_Role,count(*) from Nobel where Aff_Role like '%University%' group by Aff_Role having count(*)>=2;

AFF_ROLE                         COUNT(*)                                       
------------------------------ ----------                                       
University of California                5                                       
University of Colorado                  2                                       

SQL> REM 9: List the date of birth of youngest and eldest laureates by country­wise. Label the column as Younger, Elder respectively. Include only the country having more than one laureate. Sort the output in alphabetical order of country. 
SQL> select Country,max(DOB) as Youngest,min(DOB) as Oldest,count(*) from Nobel group by Country having count(*)>=2 order by Country;

COUNTRY    YOUNGEST  OLDEST      COUNT(*)                                       
---------- --------- --------- ----------                                       
China      28-FEB-39 04-NOV-33          2                                       
India      19-AUG-52 03-NOV-33          2                                       
Ireland    15-OCT-44 18-JAN-37          2                                       
UK         17-AUG-32 31-OCT-25          2                                       
USA        19-DEC-61 10-MAY-30         11                                       

SQL> REM 10: Show the details (year award,category,field) where the award is shared among the laureates in the same category and field. Exclude the laureates from USA.
SQL> select Year_Award,Category,Field,count(*) from Nobel where Country not like 'USA' group by (Year_Award,Category,Field) having count(*)>=2 order by Year_Award;

YEAR_AWARD CAT FIELD                       COUNT(*)                             
---------- --- ------------------------- ----------                             
      1998 Che Theoretical Chemistry              2                             
      1998 Pea Negotiation                        2                             
      1998 Phy Condensed matter                   2                             
      2009 Che Biochemistry                       2                             

SQL> spool off
