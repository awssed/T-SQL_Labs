create table TR_AUDIT
(
	ID int identity(1, 1),										-- ID
	STMT varchar(20) check (STMT in ('INS', 'DEL', 'UPD')),		-- DML operator name
	TRNAME varchar(50),											-- trigger name
	CC varchar(300)												-- comment
)

create trigger TR_TEACHER_INS on TEACHER after insert
as declare @TEACHER char(10), @TEACHER_NAME varchar(100),
			@GENDER char(1), @PULPIT char(20), @IN varchar(300)
print 'Операция вставки'
set @TEACHER = (select TEACHER from INSERTED)
set @TEACHER_NAME = (select TEACHER_NAME from INSERTED)
set @GENDER = (select GENDER from INSERTED)
set @PULPIT = (select PULPIT from INSERTED)
set @IN = ltrim(rtrim(@TEACHER)) + ' ' + ltrim(rtrim(@TEACHER_NAME)) + 
		  ' ' + ltrim(rtrim(@GENDER)) + ' ' + ltrim(rtrim(@PULPIT))
insert into TR_AUDIT (STMT, TRNAME, CC) values ('INS', 'TR_TEACHER_INS', @IN)
return;

insert into TEACHER values('Teacher1','FIO','м','ИСиТ')
select * from TEACHER

select * from TR_AUDIT order by ID

--EX2

create trigger TR_TEACHER_DEL on TEACHER  after delete
as declare  @TEACHER char(10), @TEACHER_NAME varchar(100),
			@GENDER char(1), @PULPIT char(20), @IN varchar(300)
print 'Операция вставки'
set @TEACHER = (select TEACHER from DELETED)
set @TEACHER_NAME = (select TEACHER_NAME from DELETED)
set @GENDER = (select GENDER from DELETED)
set @PULPIT = (select PULPIT from DELETED)
set @IN = ltrim(rtrim(@TEACHER)) + ' ' + ltrim(rtrim(@TEACHER_NAME)) + 
		  ' ' + ltrim(rtrim(@GENDER)) + ' ' + ltrim(rtrim(@PULPIT))
insert into TR_AUDIT (STMT, TRNAME, CC) values ('DEL', 'TR_TEACHER_INS', @IN)
return;

delete from TEACHER where TEACHER='Teacher1'

--EX3

create trigger TR_TEACHER_UPD on TEACHER  after update
as declare  @TEACHER char(10), @TEACHER_NAME varchar(100),
			@GENDER char(1), @PULPIT char(20), @IN varchar(300)
print 'Операция обновления'
set @TEACHER = (select TEACHER from DELETED where TEACHER is not null)
set @TEACHER_NAME = (select TEACHER_NAME from DELETED where TEACHER_NAME is not null)
set @GENDER = (select GENDER from DELETED where GENDER is not null)
set @PULPIT = (select PULPIT from DELETED where PULPIT is not null)
set @IN = ltrim(rtrim(@TEACHER)) + ' ' + ltrim(rtrim(@TEACHER_NAME)) + 
		  ' ' + ltrim(rtrim(@GENDER)) + ' ' + ltrim(rtrim(@PULPIT)) + ' -> '

set @TEACHER = (select TEACHER from INSERTED where TEACHER is not null)
set @TEACHER_NAME = (select TEACHER_NAME from INSERTED where TEACHER_NAME is not null)
set @GENDER = (select GENDER from INSERTED where GENDER is not null)
set @PULPIT = (select PULPIT from INSERTED where PULPIT is not null)
set @IN = @IN + ltrim(rtrim(@TEACHER)) + ' ' + ltrim(rtrim(@TEACHER_NAME)) + 
		  ' ' + ltrim(rtrim(@GENDER)) + ' ' + ltrim(rtrim(@PULPIT))

insert into TR_AUDIT (STMT, TRNAME, CC) values ('UPD', 'TR_TEACHER_UPD', @IN)
return;

update TEACHER set GENDER = 'м' where TEACHER='Teacher1'
select * from TR_AUDIT;

--EX4
create trigger TR_TEACHER on TEACHER after insert, update, delete
as declare @TEACHER char(10), @TEACHER_NAME varchar(100),
		   @GENDER char(1), @PULPIT char(20), @IN varchar(300)

if (select count(*) from INSERTED) > 0 and (select count(*) from DELETED) > 0
begin
	print 'Операция удаления'
	set @TEACHER = (select TEACHER from DELETED where TEACHER is not null)
	set @TEACHER_NAME = (select TEACHER_NAME from DELETED where TEACHER_NAME is not null)
	set @GENDER = (select GENDER from DELETED where GENDER is not null)
	set @PULPIT = (select PULPIT from DELETED where PULPIT is not null)
	set @IN = ltrim(rtrim(@TEACHER)) + ' ' + ltrim(rtrim(@TEACHER_NAME)) + 
			  ' ' + ltrim(rtrim(@GENDER)) + ' ' + ltrim(rtrim(@PULPIT)) + ' -> '

	set @TEACHER = (select TEACHER from INSERTED where TEACHER is not null)
	set @TEACHER_NAME = (select TEACHER_NAME from INSERTED where TEACHER_NAME is not null)
	set @GENDER = (select GENDER from INSERTED where GENDER is not null)
	set @PULPIT = (select PULPIT from INSERTED where PULPIT is not null)
	set @IN = @IN + ltrim(rtrim(@TEACHER)) + ' ' + ltrim(rtrim(@TEACHER_NAME)) + 
			  ' ' + ltrim(rtrim(@GENDER)) + ' ' + ltrim(rtrim(@PULPIT))

	insert into TR_AUDIT (STMT, TRNAME, CC) values ('UPD', 'TR_TEACHER', @IN)
end

if (select count(*) from INSERTED) > 0 and (select count(*) from DELETED) = 0
begin
	print 'Операция вставки'
	set @TEACHER = (select TEACHER from INSERTED)
	set @TEACHER_NAME = (select TEACHER_NAME from INSERTED)
	set @GENDER = (select GENDER from INSERTED)
	set @PULPIT = (select PULPIT from INSERTED)
	set @IN = ltrim(rtrim(@TEACHER)) + ' ' + ltrim(rtrim(@TEACHER_NAME)) + 
			  ' ' + ltrim(rtrim(@GENDER)) + ' ' + ltrim(rtrim(@PULPIT))
	insert into TR_AUDIT (STMT, TRNAME, CC) values ('INS', 'TR_TEACHER', @IN)
end

if (select count(*) from INSERTED) = 0 and (select count(*) from DELETED) > 0
begin
	print 'Оперция удаления'
	set @TEACHER = (select TEACHER from DELETED)
	set @TEACHER_NAME = (select TEACHER_NAME from DELETED)
	set @GENDER = (select GENDER from DELETED)
	set @PULPIT = (select PULPIT from DELETED)
	set @IN = ltrim(rtrim(@TEACHER)) + ' ' + ltrim(rtrim(@TEACHER_NAME)) + 
			  ' ' + ltrim(rtrim(@GENDER)) + ' ' + ltrim(rtrim(@PULPIT))
	insert into TR_AUDIT (STMT, TRNAME, CC) values ('DEL', 'TR_TEACHER', @IN)
end




insert into TEACHER values('Teacher1','FIO','м','ИСиТ')
update TEACHER set GENDER = 'м' where TEACHER='Teacher1'
delete from TEACHER where TEACHER='Teacher1'

select * from TR_AUDIT order by ID
--EX5

insert into TEACHER values('Teacher1','FIO','м','ИСиТ')
select * from TR_AUDIT order by ID

--EX6

create trigger TR_TEACHER_DEL1 on TEACHER after delete
as declare @TEACHER char(10), @TEACHER_NAME varchar(100),
		   @GENDER char(1), @PULPIT char(20), @IN varchar(300)
print 'DELETE Trigger 1'
set @IN = 'Trigger Normal Priority'
insert into TR_AUDIT (STMT, TRNAME, CC) values ('DEL', 'TR_TEACHER_DEL1', @IN)


create trigger TR_TEACHER_DEL2 on TEACHER after delete
as declare @TEACHER char(10), @TEACHER_NAME varchar(100),
		   @GENDER char(1), @PULPIT char(20), @IN varchar(300)
print 'DELETE Trigger 2'
set @IN = 'Trigger Low Priority'
insert into TR_AUDIT (STMT, TRNAME, CC) values ('DEL', 'TR_TEACHER_DEL2', @IN)


create trigger TR_TEACHER_DEL3 on TEACHER after delete
as declare @TEACHER char(10), @TEACHER_NAME varchar(100),
		   @GENDER char(1), @PULPIT char(20), @IN varchar(300)
print 'DELETE Trigger 3'
set @IN = 'Trigger High Priority'
insert into TR_AUDIT (STMT, TRNAME, CC) values ('DEL', 'TR_TEACHER_DEL3', @IN)


select t.name, e.type_desc 
from sys.triggers t join  sys.trigger_events e  
on t.object_id = e.object_id  
where OBJECT_NAME(t.parent_id) = 'TEACHER' and e.type_desc = 'DELETE'

exec SP_SETTRIGGERORDER @triggername = 'TR_TEACHER_DEL3', @order = 'First', @stmttype = 'DELETE'
exec SP_SETTRIGGERORDER @triggername = 'TR_TEACHER_DEL2', @order = 'Last',  @stmttype = 'DELETE'

delete from TEACHER where TEACHER='Teacher1'

--EX7
create trigger TEACH_TRAN on TEACHER after insert, delete, update
AS
declare @c int = (select COUNT(TEACHER) from TEACHER);
		if(@c > 20)
			begin
				raiserror('Общее количество учетелей не может быть более 20', 10, 1);
				rollback;
			end;
		return;



insert into TEACHER values ('Teacher2', 'FIO', 'м', 'ИСиТ')
select * from TR_AUDIT order by ID

--EX8

create trigger TR_TEACHER_INSTEAD_OF on TEACHER instead of delete
as raiserror('Удаление запрещено', 10, 1)
return

delete from TEACHER where TEACHER = 'Teacher1'

--EX9
create trigger TR_TEACHER_DDL on database 
for DDL_DATABASE_LEVEL_EVENTS  as   
declare @EVENT_TYPE varchar(50) = EVENTDATA().value('(/EVENT_INSTANCE/EventType)[1]', 'varchar(50)')
declare @OBJ_NAME varchar(50) = EVENTDATA().value('(/EVENT_INSTANCE/ObjectName)[1]', 'varchar(50)')
declare @OBJ_TYPE varchar(50) = EVENTDATA().value('(/EVENT_INSTANCE/ObjectType)[1]', 'varchar(50)')
if @OBJ_NAME = 'TEACHER' 
begin
	print 'Event: ' + cast(@EVENT_TYPE as varchar)
	print 'Obj: ' + cast(@OBJ_NAME as varchar)
	print 'Type: ' + cast(@OBJ_TYPE as varchar)
	raiserror('Изменения запрещены.', 16, 1)
	rollback  
end


alter table TEACHER drop column TEACHER_NAME

--EX 11*
CREATE TABLE WEATHER (
    city VARCHAR(50),
    start_date DATETIME,
    end_date DATETIME,
    temperature INT
);

GO

CREATE TRIGGER trg_weather_check
ON WEATHER
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @city VARCHAR(50), @start_date DATETIME, @end_date DATETIME, @temp INT;

    SELECT @city = city, @start_date = start_date, @end_date = end_date, @temp = temperature
    FROM inserted;

    IF EXISTS (
        SELECT 1
        FROM WEATHER w
        WHERE w.city = @city
            AND w.start_date <= @end_date
            AND w.end_date >= @start_date
            AND w.temperature != @temp
    )
    BEGIN
        RAISERROR ('Температура в этом периоде уже определена.', 16, 1);
        ROLLBACK TRANSACTION;
    END;
END;

INSERT INTO WEATHER (city, start_date, end_date, temperature)
VALUES ('Minsk', '2022-01-01 00:00:00', '2022-01-01 23:59:00', -6);

INSERT INTO WEATHER (city, start_date, end_date, temperature)
VALUES ('Minsk', '2022-01-01 00:00:00', '2022-01-01 23:59:00', -2);

drop table TR_AUDIT
drop trigger TEACH_TRAN
drop trigger TR_TEACHER_DEL
drop trigger TR_TEACHER_DEL1
drop trigger TR_TEACHER_DEL2
drop trigger TR_TEACHER_DEL3
drop trigger TR_TEACHER_INS
drop trigger TR_TEACHER
drop trigger TR_TEACHER_INSTEAD_OF
drop trigger TR_TEACHER_UPD
drop trigger TR_TEACHER_DDL on database