DECLARE discpipline CURSOR for select SUBJECT.SUBJECT_NAME from SUBJECT where SUBJECT.PULPIT like '����';
--deallocate  discpipline;

DECLARE @subject char(35), @subjects char(500) = '';
OPEN discpipline;
FETCH discpipline into @subject;
print '���������� ������� ����';
while @@FETCH_STATUS = 0
	begin
		set @subjects = RTRIM(@subject) +', ' +  @subjects;
		FETCH  discpipline into @subject;
	end;
	print @subjects;
CLOSE discpipline;
