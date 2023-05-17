/***** use database *****/
USE DB_class;


/***** info *****/
CREATE TABLE if not exists self (
    StuID varchar(10) NOT NULL,
    Department varchar(10) NOT NULL,
    SchoolYear int DEFAULT 1,
    Name varchar(10) NOT NULL,
    PRIMARY KEY (StuID)
);

INSERT INTO self
VALUES ('r10725059', '資管所', 2, '謝佳穎');


SELECT DATABASE();
SELECT * FROM self;


/* Prepared statement */
prepare stm1 from "select * from student where 系所 = ?;";
set @dprt = '資管系';
execute stm1 using @dprt;

set @dprt = '公衛系';
execute stm1 using @dprt;



/* Stored-function */
delimiter %%
create function chinese_name (orig_name char(30)) returns char(30)
deterministic
begin
	declare chinese_name char(30);
    set chinese_name = substring(orig_name, 1, 3);
    return chinese_name;
end %%english_name
delimiter ;


delimiter %%
create function english_name (orig_name char(30)) returns char(30)
deterministic
begin
    declare english_name char(30);
    set english_name = replace(orig_name, ")", "");
    set english_name = substring(english_name, 6);
    return english_name;
end %%
delimiter ;

select chinese_name(姓名), english_name(姓名)
from DB_class.student
where 學號 in ('R10725059', 'R11725058', 'R11725047', 'R11725044');



/* Stored procedure */
delimiter %%
create procedure count_students (in dprt char(30), out STCOUNT int)
begin
	select count(姓名) as "department student count"
	from student
	where 系所 = dprt;
end %%
delimiter ;

set @STCOUNT = 0;
call count_students("資管系", @STCOUNT);
call count_students("公衛系", @STCOUNT);



/* Trigger I  */
set @NUMCAPS = 0;

delimiter %%
create trigger count_captain
after update on student for each row
begin
set @NUMCAPS = (select count(new.final_captain) from student where final_captain = "Y");
end %%
delimiter ;


update student set final_captain = "Y" where 學號 = "B07202043";
update student set final_captain = "Y" where 學號 = "B08305037";
update student set final_captain = "Y" where 學號 = "R11725058";
update student set final_captain = "Y" where 學號 = "R10725059";
update student set final_captain = "Y" where 學號 = "B08B01073";

select * from student where final_captain = "Y";
select @NUMCAPS;


/* Trigger II */
create table who_changes_student (name char(30), time datetime);

delimiter %%
create trigger record_changes_on_insert
after insert on student for each row
begin
insert into who_changes_student values (user(), now());
end %%
delimiter ;

delimiter %%
create trigger record_changes_on_delete
after delete on student for each row
begin
insert into who_changes_student values (user(), now());
end %%
delimiter ;

select * from who_changes_student;

insert into student values ("學生", "資管系", 5, "B01234567", "小魚", "a@gmail.com", "SQL", "0", "0");
insert into student values ("學生", "資管系", 6, "B01234568", "小雞", "b@gmail.com", "SQL", "0", "0");
insert into student values ("學生", "資管系", 7, "B01234569", "小鴨", "c@gmail.com", "SQL", "0", "0");
delete from student where 姓名 = "小魚";
delete from student where 姓名 = "小雞";

select * from who_changes_student;


/* drop database */
drop database DB_class;