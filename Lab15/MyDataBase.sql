create table TR_KREDIT
(
	ID int identity(1, 1),										-- ID
	STMT varchar(20) check (STMT in ('INS', 'DEL', 'UPD')),		-- DML operator name
	TRNAME varchar(50),											-- trigger name
	CC varchar(300)												-- comment
)
DROP TABLE TR_KREDIT
DROP TRIGGER TR_INS
DROP TRIGGER TR_DEL
create trigger TR_SOBST_INS on ВИДЫ_СОБСТВЕННОСТИ after insert
as
begin
    declare @ID INT, @NAME varchar(100), @IN varchar(300);
    
    print 'Операция вставки';
    
    set @ID = (select ID_Собственности from INSERTED);
    set @NAME = (select Вид from INSERTED);
    set @IN = CAST(@ID AS VARCHAR(10)) + ' ' + ltrim(rtrim(@NAME));
    
    insert into TR_KREDIT (STMT, TRNAME, CC) values ('INS', 'TR_INS', @IN);
    return;
end;

INSERT INTO ВИДЫ_СОБСТВЕННОСТИ(ID_Собственности, Вид) VALUES ('20','vid1')

select * from TR_KREDIT