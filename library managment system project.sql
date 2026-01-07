create table branch(
branch_id varchar(10) primary key,
manager_id varchar(10),
branch_address varchar(50),
contact_no bigint
);
copy branch 
from 'C:/Program Files/PostgreSQL/18/data/project 2 csv file/branch.csv'
delimiter ','
header csv;
select * from branch;


drop table books;
create table books(
isbn varchar(20) primary key,
book_title varchar(60),
category varchar(50),
rental_price float,
status varchar(3),
author varchar(50),
publisher varchar(50)

);
copy books 
from 'C:/Program Files/PostgreSQL/18/data/project 2 csv file/books.csv'
delimiter ','
header csv;

select * from books;

drop table employee;
create table employee(emp_id varchar primary key,
emp_name varchar(50),
position varchar(25),
salary float,
branch_id varchar(15)
);

copy employee 
from 'C:/Program Files/PostgreSQL/18/data/project 2 csv file/employees.csv'
delimiter ','
header csv;

select * from employee;

create table issue_status(issued_id	varchar(5) primary key ,
issued_member_id varchar(10),--foreign key
issued_book_name varchar(60),
issued_date date,
issued_book_isbn varchar(20),--foriegn key
issued_emp_id varchar(10)
);

copy issue_status
from 'C:/Program Files/PostgreSQL/18/data/project 2 csv file/issued_status.csv'
delimiter ','
header csv;

select * from issue_status;

create table members(member_id varchar(10) primary key,
member_name	varchar(50),
member_address varchar(60),
reg_date date
);

copy members 
from 'C:/Program Files/PostgreSQL/18/data/project 2 csv file/members.csv'
delimiter ','
header csv;

select * from members;
drop table return_status;
create table return_status(return_id varchar(10),
issued_id varchar(10) primary key,
return_book_name varchar(50),
return_date	date ,
return_book_isbn varchar(20)
);
copy return_status 
from 'C:/Program Files/PostgreSQL/18/data/project 2 csv file/return_status.csv'
delimiter ','
header csv;

select * from return_status;

--adding some constraints

alter table issue_status
add  foreign key (issued_member_id)
references members(member_id);

alter table issue_status
add foreign key (issued_emp_id)
references employee(emp_id);

alter table issue_status
add foreign key (issued_book_isbn)
references books(isbn);

alter table employee
add foreign key (branch_id)
references branch(branch_id);


alter table return_status
add foreign key (issued_id)
references issue_status(issued_id);

ALTER TABLE return_status
ADD CONSTRAINT fk_return_issue
FOREIGN KEY (issued_id)
REFERENCES issue_status(issued_id);;







select * from books;
select * from branch;
select * from members;
select * from employee;
select * from issue_status;
select * from return_Status;


					-- basic to intermediate level sql query

--task 1 . add record in the books table '978-0-553-29798-2','To Kill Mockingbird','Classic',6.0,'Harper Lee','J.B.Lipincott & Co.'

insert into books(isbn,book_title,category,rental_price,author,publisher) values
('978-0-553-29798-2','To Kill Mockingbird','Classic',6.0,'Harper Lee','J.B.Lipincott & Co.')
select count(1) from books;

--task 2 . updating two member address from members table

update members set member_address ='125 Main St' 
where member_address = '123 Main St';
update members set member_address ='145 Main St' 
where member_address = '143 Main St';


--task 3. delete record from return_issue table where return_id is RS104
delete from return_status
where return_id ='RS104';

--task 4. all details of employee whose issue_id is 'E101'
select * from issue_status 
where issued_emp_id = 'E101';

--task 5. find the member who issue more than one books 
select * from issue_status
select issued_emp_id ,count(issued_id) "as count of issued by employee" 
from issue_status group by issued_emp_id having count(issued_id)>1 order by count(issued_id) desc;

--task 6. create summary table : create new table with books name and count of issued books

create table no_of_issued as 
(select b.isbn,b.book_title,count(issued_id) as "no of books issued" from books b 
join issue_status i on b.isbn=i.issued_book_isbn group by 1 ,2 order by "no of books issued" desc);



--Task 7. Retrieve all books in the specific category

select  category,book_title from books
group by 1 ,2 order by category;


--task 8. find the rental_price income by category

select b.category , sum(b.rental_price) as income from books b
join 
issue_status i on b.isbn=i.issued_book_isbn 
group by category;


--task 9. member who registered in last one months

select * from members 
where reg_date > current_date-interval '31 days';


--task 10. list employee with thier branch  manager's name and thier branch details 


select e.*,b.manager_id,b.contact_no from employee e
join 
branch b on e.branch_id = b.branch_id
select * from books;

--task 11.create table of the books with rental price above certain shreshold 7
create table rental_price_greater_than_7 
as select * from books 
where rental_price>7;

select * from rental_price_greater_than_7;  --for just checking

--task 12. Retrieve the list of books which hasn't return yet


select distinct ist.issued_book_name from issue_status ist
left join 
return_status rst on ist.issued_id=rst.issued_id 
where rst.issued_id is null;


								-- advanced sql query for library management system * data analysis


/*task 1. identify the member overdue books
 write a query to find the member who have overdue books(30days is return peroid) display the member_id,
member_name , book_title,issued_date and days overdues*/



select m.member_id,
m.member_name,
ist.issued_book_name ,
rst.return_date,
ist.issued_date,
ist.issued_id ,
current_Date-ist.issued_date as "late days"
from members m 
join
issue_status ist on m.member_id=ist.issued_member_id
left join 
return_status rst on ist.issued_id=rst.issued_id 
WHERE current_Date-ist.issued_date>30
order by 1;






