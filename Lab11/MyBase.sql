use SES_MyBase
SELECT * FROM �������
DECLARE newcursor CURSOR FOR SELECT �������.������������_�������, �������.����� FROM ������� WHERE �������.������������_�������='����������'

DECLARE	@name nvarchar(20), @sum nvarchar(20)
OPEN newcursor
FETCH newcursor into @name, @sum
print '�������'
WHILE @@FETCH_STATUS = 0
	begin
		print @name+'-'+@sum
		FETCH newcursor into @name,@sum
	end
CLOSE newcursor

DECLARE newcursor2 CURSOR FOR SELECT �������.����������_����,�������.�����, ����_��������.������ FROM ������� INNER JOIN �������
									on �������.ID_�������=�������.ID_�������	INNER JOIN ����_��������
									on �������.������������_�������=����_��������.��������_�������
DECLARE	@name nvarchar(20), @sum nvarchar(20), @stavka nvarchar(20), @result nvarchar(400)=''
OPEN newcursor2
FETCH newcursor2 into @name,@sum,@stavka
WHILE @@FETCH_STATUS=0
	BEGIN
		set @result=@result+RTRIM(@name)+'-'+RTRIM(@sum)+@stavka;
		FETCH newcursor2 into @name,@sum,@stavka;
	END
print @result
CLOSE newcursor2

DECLARE newcursor3 CURSOR LOCAL DYNAMIC FOR SELECT �������.����� FROM ������� WHERE �������.������������_�������='����������'

OPEN newcursor3
FETCH newcursor3
while @@FETCH_STATUS=0
	begin
		UPDATE ������� SET �������.�����=�����+1000
		FETCH newcursor3
	end
CLOSE newcursor3
