exec sp_helpindex 'AUDITORIUM' 
exec sp_helpindex 'AUDITORIUM_TYPE'
exec sp_helpindex 'FACULTY'
exec sp_helpindex 'GROUPS'
exec sp_helpindex 'PROFESSION'
exec sp_helpindex 'PROGRESS'
exec sp_helpindex 'PULPIT'
exec sp_helpindex 'STUDENT'
exec sp_helpindex 'SUBJECT'
exec sp_helpindex 'TEACHER'


CREATE TABLE #New_table
(	
	ID int identity(1,1),
	STRING varchar(13)
)
DECLARE @iter int = 0;
WHILE @iter < 10000
	begin
	INSERT INTO #New_table values ('Hello');
	SET @iter = @iter + 1;
	end;

select * from #New_table
checkpoint;
DBCC DROPCLEANBUFFERS;
CREATE CLUSTERED INDEX #EXAMPLE_CL1 on #New_table(ID asc);
SELECT * FROM #New_table where ID between 150 and 200 order by ID;
checkpoint; 
DBCC DROPCLEANBUFFERS;
--ex2
create table #SecondTable
(
	id int identity(1,1),
	stroke varchar(15)
);

declare @iteration int = 0;
while @iteration < 10000
begin
insert into #SecondTable values ('stroke')
set @iteration =@iteration + 1;
end

CREATE index #index2 on #SecondTable(id,stroke);
DROP index [#table2].[#index2]
checkpoint;  
DBCC DROPCLEANBUFFERS;

select * from #SecondTable
where #SecondTable.id > 150 and #SecondTable.id<456
order by id
--ex3
CREATE INDEX #index3 on #SecondTable(id) INCLUDE (stroke);
SELECT stroke from #SecondTable where id between 1 and 10;
--ex4
CREATE INDEX #index4 on #SecondTable(id) where(id>=0 and id<=200)
drop INDEX #index4 on #table2

select stroke from #SecondTable
where id>=0 and id<=200
--ex5
Use TEMPDB
CREATE TABLE  #TASK5
(
ITERATOR INT IDENTITY(1,1),
INDEX_ INT 
)


DECLARE @X INT =0;
WHILE @X <= 10000
BEGIN
INSERT INTO  #TASK5(INDEX_)
VALUES (FLOOR(20000*RAND()))
SET @X +=1;
END

CHECKPOINT;
DBCC DROPCLEANBUFFERS

CREATE INDEX #TASK5_KEY ON #TASK5(INDEX_)

SELECT NAME [Индекс], AVG_FRAGMENTATION_IN_PERCENT [Фрагментация (%)] 
FROM SYS.DM_DB_INDEX_PHYSICAL_STATS(DB_ID(N'TEMPDB'),
OBJECT_ID(N'#TASK5'), NULL, NULL, NULL) SS
JOIN SYS.INDEXES II ON SS.OBJECT_ID = II.OBJECT_ID
AND SS.INDEX_ID = II.INDEX_ID WHERE NAME IS NOT NULL; 

INSERT TOP(10000) #TASK5(INDEX_ ) SELECT INDEX_ FROM #TASK5

ALTER INDEX #TASK5_KEY ON #TASK5 REORGANIZE
ALTER INDEX #TASK5_KEY ON #TASK5 REBUILD WITH (ONLINE = OFF)
--EX6
CREATE TABLE  #TASK6
(
INFO NVARCHAR (20),
ITERATOR INT IDENTITY(1,1),
INDEX_ INT 
)

DECLARE @X INT =0;
WHILE @X <= 100000
BEGIN
INSERT INTO  #TASK6(INFO,INDEX_)
VALUES ('STRING' + CAST(@X AS NVARCHAR),FLOOR(20000*RAND()))
SET @X +=1;
END
CREATE INDEX #TASK6_TKEY ON #TASK6(INDEX_) WITH FILLFACTOR = 65

INSERT TOP(100) PERCENT #TASK6(INDEX_, INFO)
SELECT INDEX_, INFO FROM #TASK6

SELECT name [Индекс], avg_fragmentation_in_percent [Фрагментация (%)]
FROM sys.dm_db_index_physical_stats(DB_ID(N'TEMPDB'),    
OBJECT_ID(N'#TASK6'), NULL, NULL, NULL) ss  JOIN sys.indexes ii 
ON ss.object_id = ii.object_id and ss.index_id = ii.index_id  WHERE name is not null;


DROP INDEX #TASK6_TKEY ON #TASK6