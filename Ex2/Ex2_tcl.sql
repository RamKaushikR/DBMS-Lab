savepoint A;

insert into nobel values(129,'Ram','m','Phy','World Organizing','2018','Cambridge University','19-JUN-1958','India');

select * from nobel where name = 'Ram';

update nobel set aff_role='Linguists' where category = 'Lit';

delete from nobel where field='Enzymes';

select * from nobel where field='Enzymes';

rollback to A;

select * from nobel where name = 'Ram';

commit;

