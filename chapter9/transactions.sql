show databases;
use dsg_11;
show tables;
drop table bank_account;

create table bank_account(
account_id int primary key,
user_name varchar(50),
balance int
);

insert into bank_account
values
(1,"amit",5000),
(2,"Ravi",3000);

select * from bank_account;

begin;
update bank_account
set balance=balance-1000
where account_id=1;

commit;

rollback;

select * from bank_account;

begin;
update bank_account
set balance=balance-1000
where account_id=1;

savepoint sp1;

update bank_account
set balance=balance-800
where account_id=1;

savepoint sp2;

update bank_account
set balance=balance-500
where account_id=1;

savepoint sp3;

rollback to sp2;


