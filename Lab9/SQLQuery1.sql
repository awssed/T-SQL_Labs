
--EX1
DECLARE @c char = 'A', 
	@vc varchar(4) = 'BSTU',
	@dt datetime,
	@t time(0),
	@i int,
	@si smallint,
	@ti tinyint,
	@num numeric(12,5)

SET @i = (SELECT SUM(NOTE) FROM PROGRESS);
SET @dt = GETDATE();

SELECT @si = 20, @num = AVG(NOTE) FROM PROGRESS;


SET @ti = @i + @si; 

SELECT @ti;
print @ti
--EX2
DECLARE @capacity int = (select cast(sum(AUDITORIUM_CAPACITY) as int) from AUDITORIUM),
		@q int = (select cast(count(*) as int) from AUDITORIUM),
		@avg int = (select cast(avg(AUDITORIUM_CAPACITY) as int) from AUDITORIUM);
Declare	@lessavg int =  (select cast(count(*) as int) from AUDITORIUM where AUDITORIUM_CAPACITY < @avg);
Declare @percent float = cast(cast(@lessavg as float) / cast(@q as float) * 100  as float);
IF @capacity > 200
		begin 
		SELECT @q '����������',			@avg '�������',
			   @lessavg  '������ ��������',		cast(@percent as varchar) '������� ������ ��������'
		end
	ELSE IF @capacity < 200
		begin
		PRINT @capacity
		end;
--EX 3
print '����� ������������ ����� = ' + cast(@@ROWCOUNT as varchar(10));
print '(������ SQL Server = ' + cast(@@VERSION as varchar(300));
print '��������� ������������� ��������, ����������� �������� �������� ����������� = ' + cast(@@SPID as varchar(300));
print '��� ��������� ������ = ' + cast(@@ERROR as varchar(30));
print '��� ������� = ' + cast(@@SERVERNAME as varchar(30));
print '���������� ������� ����������� ���������� = ' + cast(@@trancount as varchar(30));
print '�������� ���������� ���������� ����� ��������������� ������ = ' + cast(@@FETCH_STATUS as varchar(30));
print '������� ����������� ������� ��������� = ' + cast(@@NESTLEVEL as varchar(30));
--EX 4.1
DECLARE @t2 int = 45, 
		@z float(10),
		@x int = 52;

if @t2 > @x
begin
set @z = power(sin(@t2),2);
print 'Z = '+cast(@z as varchar(15));
end

else if @t2 < @x
begin
set @z = 4 * (@t2 + @x);
print 'Z = '+cast(@z as varchar(15));
end

else if @t2 = @x
begin
set @z = 1 - exp(@x-2);
print 'Z = '+cast(@z as varchar(15));
end
--EX 4.2
DECLARE @name varchar(100) = '�������� ������� ����������';
SET @name = (SELECT SUBSTRING(@name, 1, CHARINDEX(' ', @name))
            + SUBSTRING(@name, CHARINDEX(' ', @name) + 1, 1) + '.'
            + SUBSTRING(@name, CHARINDEX(' ', @name, CHARINDEX(' ', @name) + 1) + 1, 1) + '.');

PRINT @name;
--EX 5.3
DECLARE @next_month int = MONTH(GETDATE()) + 1;
select * from STUDENT where MONTH(STUDENT.BDAY) = @next_month;
--EX5.4
select CASE 
							when DATEPART(weekday,PDATE) = 1 then '�����������'
							when DATEPART(weekday,PDATE) = 2 then '�������'
							when DATEPART(weekday,PDATE) = 3 then '�����'
							when DATEPART(weekday,PDATE) = 4 then '�������'
							when DATEPART(weekday,PDATE) = 5 then '�������'
							when DATEPART(weekday,PDATE) = 6 then '�������'
							when DATEPART(weekday,PDATE) = 7 then '�����������'
						end
from PROGRESS where SUBJECT = '����'
--EX 6
SELECT PROGRESS.IDSTUDENT,PROGRESS.SUBJECT,CASE
			when AVG(PROGRESS.NOTE) = 4 then '�����'
			when AVG(PROGRESS.NOTE)	between 5 and 6 then '�����������������'
			when AVG(PROGRESS.NOTE) between 7 and 8 then '����'
			when AVG(PROGRESS.NOTE) between 9 and 10 then '�������'
			end
from PROGRESS
group by PROGRESS.IDSTUDENT,PROGRESS.SUBJECT
--EX 7
DROP TABLE #TEMP1;
CREATE TABLE #TEMP1
		(
			ID int identity(1,1),
			RANDOM_NUMBER int,
		);
DECLARE  @iter int = 0;
WHILE @iter < 10
	begin
	INSERT #TEMP1(RANDOM_NUMBER)
			values(rand() * 1000);
	SET @iter = @iter + 1;
	end
SELECT * from #TEMP1;
--EX 8
DECLARE @X int = 1
print @X+1
print @X+2
RETURN
print @X+3
--EX 9
BEGIN TRY
    CREATE TABLE #TestTable (ID INT PRIMARY KEY);

    INSERT INTO #TestTable (ID) VALUES (1), (1);
END TRY
BEGIN CATCH
    PRINT '�����: ' + CAST(ERROR_NUMBER() AS VARCHAR(10));
    PRINT '���������: ' + ERROR_MESSAGE();
    PRINT '������: ' + CAST(ERROR_LINE() AS	VARCHAR(10));
    PRINT '���������: ' + ERROR_PROCEDURE();
    PRINT '������� �����������: ' + CAST(ERROR_SEVERITY() AS VARCHAR(10));
    PRINT '�����: ' + CAST(ERROR_STATE() AS VARCHAR(10));
END CATCH