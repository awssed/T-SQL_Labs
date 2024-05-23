--EX1
create proc PSUBJECT as
begin
	declare @COUNT int = (select count(*) from SUBJECT)
	select s.SUBJECT , s.SUBJECT_NAME, s.PULPIT from SUBJECT s
	return @COUNT
end

drop proc PSUBJECT;

declare @COUNT_OUTPUT int = 0
exec @COUNT_OUTPUT = PSUBJECT
print 'Count : ' + cast(@COUNT_OUTPUT as varchar)

--EX2
alter proc PSUBJECT @PULPIT varchar(20), @COUNT_OUT int output
as
begin
	declare @COUNT_ALL int = (select count(*) from SUBJECT)
	print 'Кафедра: @PULPIT = ' + @PULPIT + '; @COUNT_OUT = ' + cast(@COUNT_OUT as varchar)
	select s.SUBJECT, s.SUBJECT_NAME, s.PULPIT
	from   SUBJECT s
	where  s.PULPIT = @PULPIT
	set @COUNT_OUT = @@ROWCOUNT
	return @COUNT_ALL
end

drop procedure PSUBJECT;

declare @COUNT_SUBJECTS int = 0
declare @PARAM int = 0
exec @COUNT_SUBJECTS = PSUBJECT @PULPIT = 'ИСиТ', @COUNT_OUT = @PARAM output
print 'param: ' + cast(@PARAM as varchar)
print 'Count: ' + cast(@COUNT_SUBJECTS as varchar)

--EX3
alter proc PSUBJECT @PULPIT varchar(20)
as begin
	select * 
	from   SUBJECT
	where  SUBJECT.PULPIT = @PULPIT
end

drop table #SUBJECT
create table #SUBJECT
(
	Subject varchar(10) primary key,
	Subject_Name varchar(50),
	Pulpit varchar(10)
)
insert #SUBJECT exec PSUBJECT @PULPIT = 'ИСиТ'
select * from #SUBJECT
--EX4
create proc PAUDITORIUM_INSERT @AUD char(20), @NAME varchar(50), @CAPACITY int = 0, @TYPE char(10)
as begin
	begin try
		insert into AUDITORIUM (AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_CAPACITY, AUDITORIUM_TYPE)
		values (@AUD, @NAME, @CAPACITY, @TYPE)
		return 1
	end try
	begin catch
		print 'ERROR_NUMBER:  ' + cast(ERROR_NUMBER() as varchar)
		print 'ERROR_SEVERITY: ' + cast(ERROR_SEVERITY() as varchar)
		print 'ERROR_MESSAGE:   ' + cast(ERROR_MESSAGE() as varchar)
		return -1
	end catch
end

drop proc PAUDITORIUM_INSERT
delete AUDITORIUM where AUDITORIUM = '322-1'

declare @RETURN int
exec @RETURN = PAUDITORIUM_INSERT @AUD = '322-1', @NAME = '322-1', @CAPACITY = 20, @TYPE = 'ЛБ-К'
print 'RETURN: ' + cast(@RETURN as varchar)
--EX5
create proc SUBJECT_REPORT @PULPIT varchar(20)
as
begin try
	declare @SUBJ_OUT varchar(200) = ''
	declare @SUBJ_ONE varchar(20) = ''
	declare @ROWCOUNT int = 0
	declare cur cursor local static for (select SUBJECT from SUBJECT where SUBJECT.PULPIT = @PULPIT)
	if not exists (select SUBJECT from SUBJECT where SUBJECT.PULPIT = @PULPIT)
		raiserror('Ошибка в параметрах! ', 11, 1)
	else
	open cur
		fetch cur into @SUBJ_ONE
		while @@FETCH_STATUS = 0
		begin
			set @SUBJ_OUT += rtrim(@SUBJ_ONE) + ', '
			set @ROWCOUNT = @ROWCOUNT + 1
			fetch cur into @SUBJ_ONE
		end
	print @SUBJ_OUT
	close cur
	return @ROWCOUNT
end try
begin catch
	print 'Произошла ошибка!'
	print 'Сообщение: ' + cast(ERROR_MESSAGE() as varchar(max))
	print 'Номер строки: ' + cast(@ROWCOUNT as varchar) 
end catch


drop proc SUBJECT_REPORT


declare @COUNT int = 0
exec @COUNT = SUBJECT_REPORT @PULPIT = 'ИСиТ'
print 'Count: ' + cast(@COUNT as varchar)

--EX6
create proc PAUDITORIUM_INSERTX 
@AUD char(20), @NAME varchar(50), @CAPACITY int = 0, @AUD_TYPE char(10), @AUD_TYPENAME varchar(70)
as 
begin try
	set transaction isolation level SERIALIZABLE
	begin tran
		insert into AUDITORIUM_TYPE (AUDITORIUM_TYPE, AUDITORIUM_TYPENAME)
		values (@AUD_TYPE, @AUD_TYPENAME)
		exec PAUDITORIUM_INSERT @AUD, @NAME, @CAPACITY, @AUD_TYPE
	commit tran
end try
begin catch
	print 'Number error:  ' + cast(ERROR_NUMBER() as varchar)
	print 'Error severity: ' + cast(ERROR_SEVERITY() as varchar)
	print 'Message:   ' + cast(ERROR_MESSAGE() as varchar)
	if @@TRANCOUNT > 0 
		rollback tran
	return -1
end catch


exec PAUDITORIUM_INSERTX @AUD = '323-1', @NAME = '323-1', @CAPACITY = 50, @AUD_TYPE = 'CП', @AUD_TYPENAME = 'Спортивный зал'


--****
drop procedure PRINT_REPORT;

create procedure PRINT_REPORT
 @fac char(10) = null, @pul char(10) = null
 as declare @faculty char(50), @pulpit char(10), @subject char(10), @cnt_teacher int;
  declare @temp_fac char(50), @temp_pul char(10), @list varchar(100)='', 
   @DISCIPLINES char(12) = 'Дисциплины: ', @DISCIPLINES_NONE char(16) = 'Дисциплины: нет.';
 begin try
  if (@pul is not null 
   and not exists (select FACULTY from PULPIT where PULPIT = @pul))
   raiserror('Ошибка в параметрах', 11, 1);

  declare @count int = 0;

  declare EX8 cursor local static 
   for select FACULTY.FACULTY, PULPIT.PULPIT, SUBJECT.SUBJECT, count(TEACHER.TEACHER)
   from FACULTY 
    inner join PULPIT on FACULTY.FACULTY = PULPIT.FACULTY
    left outer join SUBJECT on PULPIT.PULPIT = SUBJECT.PULPIT
    left outer join TEACHER on PULPIT.PULPIT = TEACHER.PULPIT
   where FACULTY.FACULTY = isnull(@fac, FACULTY.FACULTY)
    and PULPIT.PULPIT = isnull(@pul, PULPIT.PULPIT)
   group by FACULTY.FACULTY, PULPIT.PULPIT, SUBJECT.SUBJECT
   order by FACULTY asc, PULPIT asc, SUBJECT asc;

  open EX8;
   fetch EX8 into @faculty, @pulpit, @subject, @cnt_teacher;
   while @@FETCH_STATUS = 0
    begin 
     print 'Факультет '  + rtrim(@faculty) +  ': ';
     set @temp_fac = @faculty;
     while (@faculty = @temp_fac)
      begin
       print char(9) +  'Кафедра '  + rtrim(@pulpit)  + ': ';
       set @count  = 1;
       print char(9) +  char(9) +  'Количество преподавателей: '  + rtrim(@cnt_teacher)  + '.';
       set @list = @DISCIPLINES;

       if(@subject is not null)
        begin
         if(@list = @DISCIPLINES)
          set @list  = rtrim(@subject);
         else
          set @list  = @list + ', '  + rtrim(@subject);
        end;
       if (@subject is null) set @list = @DISCIPLINES_NONE;

       set @temp_pul = @pulpit;
       fetch EX8 into @faculty, @pulpit, @subject, @cnt_teacher;
       while (@pulpit = @temp_pul)
        begin
         if(@subject is not null)
          begin
           if(@list = @DISCIPLINES)
            set @list  = rtrim(@subject);
           else
            set @list  = ', '+   rtrim(@subject);
          end;
         fetch EX8 into @faculty, @pulpit, @subject, @cnt_teacher;
         if(@@FETCH_STATUS != 0) break;
        end;
       print char(9) +  char(9)+   @list;
       if(@@FETCH_STATUS != 0) break;
      end;
    end;
  close EX8;
  deallocate EX8;
  return @count;
 end try
 begin catch
  print 'Номер ошибки: '  + convert(varchar, error_number());
  print 'Сообщение: ' +  error_message();
  print 'Уровень: ' +  convert(varchar, error_severity());
  print 'Метка: ' +  convert(varchar, error_state());
  print 'Номер строки: ' +  convert(varchar, error_line());
  if error_procedure() is not null
   print 'Имя процедуры: '  + error_procedure();
  return -1;
 end catch;

declare @temp_8_1 int;
exec @temp_8_1 = PRINT_REPORT null, null;
select @temp_8_1;

declare @temp_8_2 int;
exec @temp_8_2 = PRINT_REPORT 'ИТ', null;
select @temp_8_2;

declare @temp_8_3 int;
exec @temp_8_3 = PRINT_REPORT null, 'ПОиСОИ';
select @temp_8_3;

declare @temp_8_4 int;
exec @temp_8_4 = PRINT_REPORT null, 'testing';
select @temp_8_4;