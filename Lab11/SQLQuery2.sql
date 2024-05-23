DECLARE disp CURSOR FOR SELECT SUBJECT.SUBJECT_NAME from SUBJECT where SUBJECT.PULPIT like 'ИСиТ';

DECLARE @subject char(35), @subjects char(500) = '';
OPEN disp;
FETCH disp into @subject;
print 'Дисциплины кафедры ИСиТ';
while @@FETCH_STATUS = 0
	begin
		set @subjects = RTRIM(@subject) +', ' +  @subjects;
		FETCH  disp into @subject;	
	end;
	print @subjects;
CLOSE disp;
--EX2
DECLARE Puplit_cursor CURSOR LOCAL for select PULPIT.FACULTY from PULPIT where PULPIT.PULPIT = 'ИСиТ';
--deallocate Puplit_cursor;
DECLARE @pupl char(50), @pupls char(100) ='';
OPEN Puplit_cursor;
print 'Факультеты ИСиТ: ';
FETCH  Puplit_cursor into @pupl;
	set @pupls ='1. ' + RTRIM(@pupl);	
	print @pupls;
CLOSE Puplit_cursor;

go
DECLARE @pupl char(50), @pupls char(100) ='';
OPEN Puplit_cursor;
FETCH  Puplit_cursor into @pupl;
	set @pupls ='2. ' + RTRIM(@pupl);	
	print @pupls;
CLOSE Puplit_cursor
--EX3
INSERT Into AUDITORIUM values('301-1','ЛБ-К','15','301-1');
DELETE AUDITORIUM where AUDITORIUM ='301-1';
DECLARE Auditorium_local_static CURSOR  STATIC for select AUDITORIUM,AUDITORIUM_CAPACITY from AUDITORIUM where  AUDITORIUM_TYPE = 'ЛБ-К';

DECLARE @q int = 0, @auditorium char(10), @iter int = 1;
open Auditorium_local_static;
print 'Количество строк: ' + cast(@@CURSOR_ROWS as varchar(5));

FETCH Auditorium_local_static into @auditorium, @q;
while @@FETCH_STATUS = 0
	begin
		print cast(@iter as varchar(5)) + '. Аудитория ' + rtrim(@auditorium) +': ' + cast(@q as varchar(5)) + ' мест' ;
		set @iter += 1;
		FETCH Auditorium_local_static into @auditorium, @q;
	end;
CLOSE Auditorium_local_static;

go
INSERT Into AUDITORIUM values('301-1','ЛБ-К','15','301-1');
DECLARE Auditorium_local_dynamic CURSOR  DYNAMIC for select AUDITORIUM,AUDITORIUM_CAPACITY from AUDITORIUM where  AUDITORIUM_TYPE = 'ЛБ-К';
DECLARE @q int = 0, @auditorium char(10), @iter int = 1;
open Auditorium_local_dynamic;
print 'Количество строк: ' + cast(@@CURSOR_ROWS as varchar(5));
DELETE AUDITORIUM where AUDITORIUM ='301-1';
FETCH Auditorium_local_dynamic into @auditorium, @q;
while @@FETCH_STATUS = 0
	begin
		print cast(@iter as varchar(5)) + '. Аудитория ' + rtrim(@auditorium) +': ' + cast(@q as varchar(5)) + ' мест' ;
		set @iter += 1;
		FETCH Auditorium_local_dynamic into @auditorium, @q;
	end;
CLOSE Auditorium_local_dynamic;
--EX4
DECLARE @number varchar(100), @sub varchar(10), @idstudent varchar(6), @pdate varchar (11), @note varchar (2);
DECLARE PROGRESS_CURSOR_SCROLL CURSOR LOCAL DYNAMIC SCROLL
	for select ROW_NUMBER() over (order by IDSTUDENT) Номер,
	* from PROGRESS;

OPEN PROGRESS_CURSOR_SCROLL
FETCH PROGRESS_CURSOR_SCROLL into @number, @sub ,@idstudent ,@pdate,@note;
print 'Первая выбранная строка: ' + CHAR(10) +
'Номер записи: '+ rtrim(@number)  +
'. Дисциплина: '+ rtrim(@sub) +
'. ID студента: ' + rtrim(@idstudent) +
'. Дата экзамена: '  + rtrim(@pdate) + 
'. Оценка: ' + rtrim(@note);

FETCH LAST from PROGRESS_CURSOR_SCROLL into @number, @sub ,@idstudent ,@pdate,@note;
print 'Последняя строка: ' + CHAR(10) +
'Номер записи: '+ rtrim(@number)  +
'. Дисциплина: '+ rtrim(@sub) +
'. ID студента: ' + rtrim(@idstudent) +
'. Дата экзамена: '  + rtrim(@pdate) + 
'. Оценка: ' + rtrim(@note);

FETCH RELATIVE -1  from PROGRESS_CURSOR_SCROLL into @number, @sub ,@idstudent ,@pdate,@note;
print 'Первая до предыдущей строка: ' + CHAR(10) +
'Номер записи: '+ rtrim(@number)  +
'. Дисциплина: '+ rtrim(@sub) +
'. ID студента: ' + rtrim(@idstudent) +
'. Дата экзамена: '  + rtrim(@pdate) + 
'. Оценка: ' + rtrim(@note);

FETCH ABSOLUTE 2  from PROGRESS_CURSOR_SCROLL into @number, @sub ,@idstudent ,@pdate,@note;
print 'Вторая с начала строка: ' + CHAR(10) +
'Номер записи: '+ rtrim(@number)  +
'. Дисциплина: '+ rtrim(@sub) +
'. ID студента: ' + rtrim(@idstudent) +
'. Дата экзамена: '  + rtrim(@pdate) + 
'. Оценка: ' + rtrim(@note);

FETCH RELATIVE 1  from PROGRESS_CURSOR_SCROLL into @number, @sub ,@idstudent ,@pdate,@note;
print 'Первая после предыдущей строка: ' + CHAR(10) +
'Номер записи: '+ rtrim(@number)  +
'. Дисциплина: '+ rtrim(@sub) +
'. ID студента: ' + rtrim(@idstudent) +
'. Дата экзамена: '  + rtrim(@pdate) + 
'. Оценка: ' + rtrim(@note);

FETCH ABSOLUTE -3  from PROGRESS_CURSOR_SCROLL into @number, @sub ,@idstudent ,@pdate,@note;
print 'Третья с конца строка: ' + CHAR(10) +
'Номер записи: '+ rtrim(@number)  +
'. Дисциплина: '+ rtrim(@sub) +
'. ID студента: ' + rtrim(@idstudent) +
'. Дата экзамена: '  + rtrim(@pdate) + 
'. Оценка: ' + rtrim(@note);
close PROGRESS_CURSOR_SCROLL

--EX5
DECLARE Auditorium CURSOR  dynamic for select AUDITORIUM_CAPACITY from AUDITORIUM where  AUDITORIUM_TYPE = 'ЛБ-К' FOR UPDATE;
DECLARE @capacity int;
OPEN Auditorium
while @@FETCH_STATUS = 0
begin
	FETCH Auditorium into @capacity
	update AUDITORIUM set AUDITORIUM_CAPACITY=AUDITORIUM_CAPACITY+1
							WHERE CURRENT OF Auditorium
end
CLOSE Auditorium
select * from AUDITORIUM
--EX 6
use UNIVER;
DECLARE newCursor cursor local dynamic 
						for SELECT STUDENT.NAME, GROUPS.PROFESSION, PROGRESS.NOTE
						from STUDENT inner join GROUPS on STUDENT.IDGROUP = GROUPS.IDGROUP inner join
						PROGRESS on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT


DECLARE @name varchar(300), @profession varchar(300), @mark varchar(2), @list varchar(400);

OPEN newCursor;
fetch newCursor into @name,@profession,@mark;
if(@mark < 4)
			begin
				DELETE PROGRESS where CURRENT OF newCursor;
			end;
print @name + ' - '+ @profession + ' - ' + @mark ;
While (@@FETCH_STATUS = 0)
	begin
		fetch newCursor into @name,@profession,@mark;
		print @name + ' - '+ @profession + ' - ' + @mark ;
		if(@mark < 4)
			begin
				DELETE PROGRESS where CURRENT OF newCursor;
			end;
	end;
CLOSE newCursor;

use UNIVER;
DECLARE newCursor cursor local dynamic 
						for SELECT STUDENT.NAME, GROUPS.PROFESSION, PROGRESS.NOTE
						from STUDENT inner join GROUPS on STUDENT.IDGROUP = GROUPS.IDGROUP inner join
						PROGRESS on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
						WHERE STUDENT.IDSTUDENT=1014


DECLARE @name varchar(300), @profession varchar(300), @mark varchar(2), @list varchar(400);

OPEN newCursor;
fetch newCursor into @name,@profession,@mark;
UPDATE PROGRESS SET PROGRESS.NOTE=PROGRESS.NOTE+1  where CURRENT OF newCursor;
print @name + ' - '+ @profession + ' - ' + @mark ;
While (@@FETCH_STATUS = 0)
	begin
		fetch newCursor into @name,@profession,@mark;
		print @name + ' - '+ @profession + ' - ' + @mark ;
		UPDATE PROGRESS SET PROGRESS.NOTE=PROGRESS.NOTE+1  where CURRENT OF newCursor;
	end;
CLOSE newCursor;
SELECT * FROM PROGRESS
SELECT * FROM PULPIT
--*
DECLARE excursor CURSOR LOCAL STATIC FOR SELECT PULPIT.FACULTY,PULPIT.PULPIT_NAME,COUNT(TEACHER.TEACHER_NAME), COUNT(SUBJECT.SUBJECT_NAME) FROM PULPIT LEFT JOIN TEACHER
																				ON PULPIT.PULPIT = TEACHER.PULPIT LEFT JOIN SUBJECT
																				ON PULPIT.PULPIT = SUBJECT.PULPIT
																				GROUP BY PULPIT.FACULTY,PULPIT.PULPIT_NAME


DECLARE @faculty nvarchar(20),@pulpit nvarchar(20),@teachers nvarchar(20),@subjects nvarchar(20),@prevfaculty nvarchar(20);
OPEN excursor;
	FETCH excursor into @faculty,@pulpit,@teachers,@subjects
	WHILE @@FETCH_STATUS=0
	begin
		if(@faculty!= @prevfaculty)
			begin
				print 'факулmтет: '+@faculty+char(10);
			end
		print 'Кафедра:'+@pulpit+char(10);
		print 'Преподаватели: '
		if(@teachers<=0)
			begin
				print 'нет'
			end
		else
			begin
				print @teachers
			end
		print char(10)
		print 'Дисциплины:'
		if (@subjects<=0)
			begin
				DECLARE subjcursor CURSOR local FOR
				SELECT SUBJECT_NAME
				FROM SUBJECT
				WHERE PULPIT = @pulpit;

				DECLARE @subject nvarchar(20)='';

				OPEN subjcursor;
				FETCH subjcursor INTO @subject;

				WHILE @@FETCH_STATUS = 0
				BEGIN
					PRINT @subject+', ';
					FETCH subjcursor INTO @subject;
				END

				CLOSE subjcursor;
				DEALLOCATE subjcursor;
			end
		else
			begin
			print 'нет'
			end
		print char(10)
		SET @prevfaculty=@faculty
		FETCH excursor into @faculty,@pulpit,@teachers,@subjects
	end
CLOSE excursor;