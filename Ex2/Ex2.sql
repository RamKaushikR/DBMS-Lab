select Name, Category,DOB from Nobel where DOB > '01-JUL-60';

select Name,Category,Field,Country,Year_Award from Nobel where Country = 'India' and Category = 'Che';

select Name,Category,Field,Country,Year_Award from Nobel where Year_Award between 2000 and 2005 and Category in ('Phy', 'Che');

select Name,Year_Award - extract(year from DOB) as Age from Nobel where Category = 'Pea';

select Name,Category,Aff_Role,Country from Nobel where (Name like 'A%' or Name like '%a') and Country not like 'Isreal';

select Name,Gender,Aff_Role,DOB as Born1950,Country from Nobel where extract(year from DOB) between 1950 and 1960;

select Name,Gender,Category,Aff_Role,Country from Nobel where Aff_Role is not null and (Name like 'A%' or Name like 'D%' or Name like 'H%') order by Name;

select Aff_Role,count(*) from Nobel where Aff_Role like '%University%' group by Aff_Role having count(*)>=2;

select Country,max(DOB) as Youngest,min(DOB) as Oldest,count(*) from Nobel group by Country having count(*)>=2 order by Country;

select Year_Award,Category,Field,count(*) from Nobel where Country not like 'USA' group by (Year_Award,Category,Field) having count(*)>=2 order by Year_Award;