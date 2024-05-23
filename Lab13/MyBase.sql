CREATE proc PKREDIT AS
BEGIN
	declare @COUNT INT= (SELECT COUNT(*) FROM �������)
	SELECT �������.ID_�������, �������.����� FROM �������
	return @COUNT
end

declare @COUNT_OUTPUT int = 0
exec @COUNT_OUTPUT =  PKREDIT
print 'Count : ' + cast(@COUNT_OUTPUT as varchar)


CREATE PROC NEWKREDIT @NAME varchar(20), @STAVKA decimal(2,2) AS
BEGIN
	begin try
		insert into ����_��������(��������_�������, ������) VALUES(@NAME,@STAVKA)
		return 1
	end try
	begin catch
		print 'ERROR_NUMBER:  ' + cast(ERROR_NUMBER() as varchar)
		print 'ERROR_SEVERITY: ' + cast(ERROR_SEVERITY() as varchar)
		print 'ERROR_MESSAGE:   ' + cast(ERROR_MESSAGE() as varchar)
		return -1
	end catch
END

exec NEWKREDIT @name='test', @STAVKA=0.2
SELECT * FROM ����_��������