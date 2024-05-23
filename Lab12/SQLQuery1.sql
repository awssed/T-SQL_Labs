--EX1
set nocount on
if  exists (select * from  SYS.OBJECTS where OBJECT_ID = object_id(N'DBO.TASK1') )	            
drop table TASK1;           
declare @c int, @flag char = 'c';         
SET IMPLICIT_TRANSACTIONS  ON  
CREATE table TASK1(K int );                        
INSERT TASK1 values (1),(2),(3);
set @c = (select count(*) from TASK1);
print 'TASK1: ' + cast( @c as varchar(2));
if @flag = 'c'  
	commit;                  
else 
	rollback;                              
SET IMPLICIT_TRANSACTIONS  OFF  

if  exists (select * from  SYS.OBJECTS where OBJECT_ID= object_id(N'DBO.TASK1') )
	print 'создана TASK1';  
else 
	print 'не создана TASK1'
--EX2
begin try
	begin tran
		delete AUDITORIUM where AUDITORIUM.AUDITORIUM = '206-1';
		insert AUDITORIUM(AUDITORIUM, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY, AUDITORIUM_NAME) VALUES ('303-1', 'ЛБ-К', 15, '303-1');
		insert AUDITORIUM(AUDITORIUM, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY, AUDITORIUM_NAME) VALUES ('206-1', 'ЛБ-К', 15, '206-1');
	commit tran;
end try
begin catch
		print 'ошибка' + case
		when error_number() = 2627 and patindex('%AUDITORIUM_PK%', error_message()) > 0
		then ' дублирование'
		else ' неизвестная ошибка: ' + cast(error_number() as varchar(5)) + error_message()
	end;
	if @@TRANCOUNT > 0 
		rollback tran;
end catch;

--EX3
DECLARE @point varchar(3)

BEGIN TRY
	BEGIN TRAN
		DELETE FROM AUDITORIUM WHERE AUDITORIUM = '123-1'
		SET @point = 'p1'; SAVE TRAN @point
		INSERT INTO AUDITORIUM VALUES('aud1', 'ЛБ-К', 40, 'aud1')
		SET @point = 'p2'; SAVE TRAN @point
		INSERT INTO AUDITORIUM VALUES('aud1', 'ЛБ-К', 50, 'aud2')
		SET @point = 'p3'; SAVE TRAN @point
	COMMIT TRAN
END TRY
BEGIN CATCH
	print 'Ошибка: ' + error_message()
	IF @@TRANCOUNT > 0
	BEGIN
		print 'Контрольная точка: ' + cast(@point as varchar)
		ROLLBACK TRAN @point
		COMMIT TRAN
	END
END CATCH
--EX4
--------- A ---------
set transaction isolation level READ UNCOMMITTED --непотвержденное чтение
begin transaction 
-------------------------- t1 ------------------
select @@SPID ID, 'INSERT AUDITORIUM' Результат, 
	   * from AUDITORIUM where AUDITORIUM = '001'
select @@SPID Id, 'UPDATE AUDITORIUM' Результат, 
	   * from AUDITORIUM where AUDITORIUM = '001'
commit
-------------------------- t2 -----------------
--------- B ---------
begin transaction 
insert AUDITORIUM values ('001', 'ЛБ-К', 80, '1234')
update AUDITORIUM set AUDITORIUM = '002'
				  where AUDITORIUM = '001' 
-------------------------- t1 --------------------
-------------------------- t2 --------------------
rollback
delete from AUDITORIUM where AUDITORIUM='aud1'
--EX5
set transaction isolation level READ COMMITTED --неповторяющее
-- A ---
begin transaction 
select count(*) from AUDITORIUM where AUDITORIUM = '002'
-------------------------- t1 ------------------ 
-------------------------- t2 -----------------
select 'update' Результат, AUDITORIUM.AUDITORIUM_CAPACITY from AUDITORIUM where AUDITORIUM = '002'
commit
--- B ---	
begin transaction 	  
-------------------------- t1 --------------------
update AUDITORIUM set AUDITORIUM.AUDITORIUM_CAPACITY = '100' where AUDITORIUM = '001' 
commit
-------------------------- t2 --------------------
--EX6
use UNIVER;
delete AUDITORIUM where AUDITORIUM = 'aud2'
-- A ---
set transaction isolation level  REPEATABLE READ --фантомное чтение
begin transaction 
select AUDITORIUM_CAPACITY from AUDITORIUM where AUDITORIUM.AUDITORIUM = 'aud1'
-------------------------- t1 ------------------ 
-------------------------- t2 ------------------
select case
       when AUDITORIUM_CAPACITY = 50 then 'insert'  else ' ' 
end 'рузультат', AUDITORIUM from AUDITORIUM where AUDITORIUM = 'aud1'
commit

--- B ---	
begin transaction 	  
-------------------------- t1 --------------------
insert AUDITORIUM values ('aud1', 'ЛБ-К', 10, 'aud1');

commit

-------------------------- t2 --------------------
--EX7
-- A ---	
set transaction isolation level SERIALIZABLE 
begin transaction 
	delete AUDITORIUM where AUDITORIUM = 'aud1'
    insert AUDITORIUM values ('aud1', 'ЛБ-К', 10, 'aud1')
    update AUDITORIUM set AUDITORIUM_NAME = 'aud1' where AUDITORIUM = 'aud1'
    select AUDITORIUM from AUDITORIUM where AUDITORIUM = 'aud1'
-------------------------- t1 -----------------
	select AUDITORIUM from AUDITORIUM where AUDITORIUM = 'aud2'
-------------------------- t2 ------------------ 
commit 	

--- B ---	
begin transaction 	  
	delete AUDITORIUM where AUDITORIUM_NAME = 'aud1'; 
    insert AUDITORIUM values ('aud1', 'ЛБ-К', 10, 'aud1')
    update AUDITORIUM set AUDITORIUM_NAME = 'aud2' where AUDITORIUM = 'aud1'
    select AUDITORIUM from AUDITORIUM  where AUDITORIUM = 'aud2'
-------------------------- t1 --------------------
commit

select AUDITORIUM from AUDITORIUM  where AUDITORIUM = 'aud2'
-------------------------- t2 -------------------
--EX8
begin tran
	insert AUDITORIUM_TYPE values ('СЗ', 'Спорт зал')
	begin tran
		update AUDITORIUM set AUDITORIUM = '99' where AUDITORIUM_TYPE = 'CЗ'
		commit
	if @@TRANCOUNT > 0
rollback

select (select count(*) from AUDITORIUM where AUDITORIUM_TYPE = 'СЗ') ,
	   (select count(*) from AUDITORIUM_TYPE where AUDITORIUM_TYPE = 'СЗ')