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
create trigger TR_SOBST_INS on ����_������������� after insert
as
begin
    declare @ID INT, @NAME varchar(100), @IN varchar(300);
    
    print '�������� �������';
    
    set @ID = (select ID_������������� from INSERTED);
    set @NAME = (select ��� from INSERTED);
    set @IN = CAST(@ID AS VARCHAR(10)) + ' ' + ltrim(rtrim(@NAME));
    
    insert into TR_KREDIT (STMT, TRNAME, CC) values ('INS', 'TR_INS', @IN);
    return;
end;

INSERT INTO ����_�������������(ID_�������������, ���) VALUES ('20','vid1')

select * from TR_KREDIT