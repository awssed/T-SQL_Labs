create function COUNT_STUDENTS (@FACULTY varchar(20)) returns int
as begin
	declare @COUNT int = (select count(*)
						  from STUDENT s
						  join GROUPS g on s.IDGROUP = g.IDGROUP
						  join FACULTY f on f.FACULTY = g.FACULTY
						  where g.FACULTY = @FACULTY)
	return @COUNT
end

--drop function COUNT_STUDENTS

declare @RES int = dbo.COUNT_STUDENTS('ТОВ')
print 'RESULT: ' + cast(@RES as varchar)

--EX1.2

alter function COUNT_STUDENTS (@FACULTY varchar(20) = null, @PROFFESION varchar(20) = null) returns int
as begin
	declare @COUNT int = (select count(*)
						  from   STUDENT s
						  join   GROUPS g on s.IDGROUP = g.IDGROUP
						  join   FACULTY f on f.FACULTY = g.FACULTY
						  where  g.FACULTY = isnull(@FACULTY, g.FACULTY)
						  and    g.PROFESSION = isnull(@PROFFESION, g.PROFESSION))
	return @COUNT
end

declare @RES int = dbo.COUNT_STUDENTS('ТОВ', '1-48 01 02')
print 'COUNT: ' + cast(@RES as varchar)

--EX2
create function FSUBJECTS (@PULPIT varchar(20)) returns varchar(300)
as begin
	declare @OUT varchar(300) = 'subjects: '
	declare @SUBJ varchar(100) = ''
	declare cur cursor local static for
		(select s.SUBJECT 
		 from   SUBJECT s 
		 where  s.PULPIT = @PULPIT)
	open cur
	fetch cur into @SUBJ
	while @@FETCH_STATUS = 0
	begin
		set @OUT += rtrim(ltrim(@SUBJ)) + ', '
		fetch cur into @SUBJ
	end
	return @OUT
end

drop function FSUBJECTS

select PULPIT , dbo.FSUBJECTS(PULPIT)
from   PULPIT

--EX 3

create function FFACPUL (@FACULTY varchar(20), @PULPIT varchar(20)) returns table
as return
	select f.FACULTY FACULTY, p.PULPIT PULPIT
	from   FACULTY f left join PULPIT p 
	on	   p.FACULTY = f.FACULTY
	where  f.FACULTY = isnull(@FACULTY, f.FACULTY)
	and	   p.PULPIT = isnull (@PULPIT, p.PULPIT)

--drop function FFACPUL

select * from FFACPUL(null, null)
select * from FFACPUL('ИДиП', null)
select * from FFACPUL(null, 'ЛМиЛЗ')
select * from FFACPUL('ТТЛП', 'ЛМиЛЗ')

--EX 4

create function FCTEACHER (@PULPIT varchar(20)) returns int
as begin
	declare @COUNT int = (select count(*)
						  from   TEACHER t
						  where  t.PULPIT = isnull(@PULPIT, t.PULPIT))
	return @COUNT
end


select PULPIT PULPIT, dbo.FCTEACHER(PULPIT) Teacher_count 
from   PULPIT
--EX6

create function COUNT_PULPITS (@FACULTY varchar(20)) returns int
as begin
	declare @COUNT int = (select count(PULPIT) from PULPIT where FACULTY = isnull(@FACULTY, FACULTY))
	return @COUNT
end

create function COUNT_GROUPS (@FACULTY varchar(20)) returns int
as begin
	declare @COUNT int = (select count(IDGROUP) from GROUPS where FACULTY = isnull(@FACULTY, FACULTY))
	return @COUNT
end

create function COUNT_PROFESSIONS (@FACULTY varchar(20)) returns int
as begin
	declare @COUNT int =  (select count(PROFESSION) from PROFESSION where FACULTY = isnull(@FACULTY, FACULTY))
	return @COUNT
end


--drop function COUNT_PULPITS
--drop function COUNT_GROUPS
--drop function COUNT_PROFESSIONS
--drop function FACULTY_REPORT


create function FACULTY_REPORT(@c int) returns @fr table
([faculty] varchar(50), [кафедры] int, [группы] int, [студенты] int, [специальности] int)
as begin 
	declare @f varchar(30);
	declare cc CURSOR static for 
	select FACULTY from FACULTY 
	where  dbo.COUNT_STUDENTS(FACULTY, default) > @c; 

	open cc;  
		fetch cc into @f;
	    while @@fetch_status = 0
			begin
	            insert @fr values(@f,  dbo.COUNT_PULPITS(@f),
	            dbo.COUNT_GROUPS(@f),   dbo.COUNT_STUDENTS(@f, default),
	            dbo.COUNT_PROFESSIONS(@f)); 
	            fetch cc into @f;  
	       end;   
	return; 
end;


select * from FACULTY_REPORT(0)

--ex****


CREATE PROCEDURE PRINT_REPORTX @f CHAR(10) = NULL, @p CHAR(10) = NULL
AS
BEGIN
    DECLARE @faculty VARCHAR(150), @pulpit VARCHAR(200), @discipline VARCHAR(2000), @discipline_list VARCHAR(2000) = '',
            @qteacher VARCHAR(3), @temp_faculty VARCHAR(50), @temp_pulpit VARCHAR(50), @q INT = 0, @out INT = 0;

    DECLARE GET_REPORT_CURSOR CURSOR LOCAL STATIC FOR
        SELECT FACULTY.FACULTY, PULPIT.PULPIT, dbo.FSUBJECTS(PULPIT.PULPIT), COUNT(TEACHER.TEACHER_NAME)
        FROM FACULTY
        INNER JOIN PULPIT ON PULPIT.FACULTY = FACULTY.FACULTY
        LEFT OUTER JOIN SUBJECT ON SUBJECT.PULPIT = PULPIT.PULPIT
        LEFT OUTER JOIN TEACHER ON TEACHER.PULPIT = PULPIT.PULPIT
        GROUP BY FACULTY.FACULTY, PULPIT.PULPIT, SUBJECT.SUBJECT
        ORDER BY FACULTY, PULPIT ASC;

    BEGIN TRY
        IF (@f IS NOT NULL AND @p IS NULL)
        BEGIN
            OPEN GET_REPORT_CURSOR;
            FETCH GET_REPORT_CURSOR INTO @faculty, @pulpit, @discipline, @qteacher;
            WHILE (@@FETCH_STATUS = 0)
            BEGIN
                IF (@out = 1)
                BEGIN
                    WHILE (@temp_pulpit = @pulpit AND @@FETCH_STATUS = 0)
                    BEGIN
                        FETCH GET_REPORT_CURSOR INTO @faculty, @pulpit, @discipline, @qteacher;
                    END;
                    SET @out = 0;
                END;
                IF (@faculty != @f)
                    FETCH GET_REPORT_CURSOR INTO @faculty, @pulpit, @discipline, @qteacher;
                ELSE IF (@faculty = @f AND @out != 1)
                BEGIN
                    PRINT ' ▬ Факультет: ' + RTRIM(@f);
                    PRINT '  ►Кафедра: ' + RTRIM(@pulpit);
                    PRINT '   •Количество преподавателей: ' + CAST(dbo.FCTEACHER(@pulpit) AS VARCHAR);
                    SET @discipline_list = '';
                    SET @discipline_list += @discipline;
                    SET @temp_pulpit = @pulpit;
                    SET @out = 1;
                    FETCH GET_REPORT_CURSOR INTO @faculty, @pulpit, @discipline, @qteacher;
                    IF (@discipline_list != '')
                    BEGIN
                        PRINT '    ' + RTRIM(@discipline_list);
                        SET @discipline_list = '';
                    END
                    ELSE
                    BEGIN
                        PRINT RTRIM(@discipline_list) + 'Дисцплины: нет';
                    END;
                    IF (@@FETCH_STATUS != 0)
                    BEGIN
                        BREAK;
                    END;
                END;
            END;
            CLOSE GET_REPORT_CURSOR;
            RETURN @q;
        END
        ELSE IF (@f IS NOT NULL AND @p IS NOT NULL)
        BEGIN
            OPEN GET_REPORT_CURSOR;
            FETCH GET_REPORT_CURSOR INTO @faculty, @pulpit, @discipline, @qteacher;
            WHILE (@@FETCH_STATUS = 0)
            BEGIN
                IF (@faculty != @f)
                BEGIN
                    FETCH GET_REPORT_CURSOR INTO @faculty, @pulpit, @discipline, @qteacher;
                END;
                ELSE IF (@faculty = @f)
                BEGIN
                    WHILE (@pulpit != @p AND @@FETCH_STATUS = 0)
                    BEGIN
                        FETCH GET_REPORT_CURSOR INTO @faculty, @pulpit, @discipline, @qteacher;
                    END;
                    IF (@pulpit != @p)
                        RETURN 0;
                    PRINT ' ▬ Факультет: ' + RTRIM(@f);
                    PRINT '  ►Кафедра: ' + RTRIM(@pulpit);
                    PRINT '   •Количество преподавателей: ' + CAST(dbo.FCTEACHER(@pulpit) AS VARCHAR);
                    SET @discipline_list = '';
                    SET @discipline_list += @discipline;
                    IF (@discipline_list != '')
                    BEGIN
                        PRINT '    ' + RTRIM(@discipline_list);
                    END
                    ELSE
                    BEGIN
                        PRINT  RTRIM(@discipline_list) + 'Дисцплины: нет';
                    END;
                    CLOSE GET_REPORT_CURSOR;
                    RETURN @q;
                END;
            END;
            CLOSE GET_REPORT_CURSOR;
            RETURN @q;
        END;
    END TRY
    BEGIN CATCH
        CLOSE GET_REPORT_CURSOR;
        THROW;
    END CATCH;
END;

go
SELECT FACULTY.FACULTY,PULPIT.PULPIT,SUBJECT.SUBJECT, count(TEACHER.TEACHER_NAME)
  from FACULTY inner join PULPIT
  on PULPIT.FACULTY = FACULTY.FACULTY left outer join SUBJECT
  on SUBJECT.PULPIT = PULPIT.PULPIT left outer join TEACHER
  on TEACHER.PULPIT = PULPIT.PULPIT
  group by FACULTY.FACULTY,PULPIT.PULPIT,SUBJECT.SUBJECT order by FACULTY, PULPIT asc;

print '▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬ Заданы параметры @f и @p ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬';
 EXEC PRINT_REPORTX @f = 'ИТ',@p = 'ИСиТ';
print '▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬ Задан параметр @f  ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬';
 EXEC PRINT_REPORTX @f = 'ИТ';
print '▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬ Задан параметр @p  ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬';
 EXEC PRINT_REPORTX @p = 'ЭТиМ';
print '▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬ Неверный параметр  ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬';  
 EXEC PRINT_REPORTX @p = '123';

DROP PROCEDURE PRINT_REPORTX;