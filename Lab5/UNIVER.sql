SELECT PULPIT.PULPIT_NAME
FROM PULPIT,FACULTY
WHERE FACULTY.FACULTY=PULPIT.FACULTY
AND FACULTY.FACULTY in (select PROFESSION.FACULTY from 
							PROFESSION
							where PROFESSION.PROFESSION_NAME LIKE '%����������%' or
							PROFESSION.PROFESSION_NAME LIKE '%����������%')
SELECT PULPIT.PULPIT_NAME
FROM PULPIT inner join FACULTY
on FACULTY.FACULTY=PULPIT.FACULTY
where FACULTY.FACULTY in (select PROFESSION.FACULTY from 
							PROFESSION
							where PROFESSION.PROFESSION_NAME LIKE '%����������%' or
							PROFESSION.PROFESSION_NAME LIKE '%����������%')
SELECT PULPIT.PULPIT_NAME
FROM PULPIT inner join FACULTY
on FACULTY.FACULTY=PULPIT.FACULTY
INNER JOIN PROFESSION 
ON PROFESSION.FACULTY=FACULTY.FACULTY
							where PROFESSION.PROFESSION_NAME LIKE '%����������%' or
							PROFESSION.PROFESSION_NAME LIKE '%����������%'

SELECT AUDITORIUM_TYPE.AUDITORIUM_TYPENAME,AUDITORIUM.AUDITORIUM_CAPACITY
FROM AUDITORIUM INNER JOIN AUDITORIUM_TYPE
ON AUDITORIUM.AUDITORIUM=AUDITORIUM_TYPE.AUDITORIUM_TYPE
WHERE AUDITORIUM.AUDITORIUM_CAPACITY=(SELECT TOP(1) AUDITORIUM.AUDITORIUM_CAPACITY FROM AUDITORIUM
											
											)

SELECT a.AUDITORIUM_TYPE,a.AUDITORIUM_CAPACITY
FROM AUDITORIUM AS a
WHERE a.AUDITORIUM_CAPACITY=(SELECT TOP(1) aa.AUDITORIUM_CAPACITY
										FROM AUDITORIUM as aa
										WHERE aa.AUDITORIUM_TYPE=a.AUDITORIUM_TYPE
										ORDER BY aa.AUDITORIUM_CAPACITY desc) 
ORDER BY a.AUDITORIUM_CAPACITY DESC

SELECT f.FACULTY_NAME
FROM FACULTY AS f
WHERE NOT EXISTS (SELECT * 
					FROM PULPIT AS p
					where p.FACULTY=f.FACULTY)

SELECT TOP(1)
(SELECT avg (PROGRESS.NOTE)from PROGRESS
	WHERE PROGRESS.SUBJECT LIKE '����')[����],
(SELECT avg (PROGRESS.NOTE)from PROGRESS
	WHERE PROGRESS.SUBJECT LIKE '��')[��],
	(SELECT avg (PROGRESS.NOTE)from PROGRESS
	WHERE PROGRESS.SUBJECT LIKE '����')[����]
FROM PROGRESS

SELECT * 
FROM GROUPS
WHERE YEAR_FIRST >=ALL (SELECT YEAR_FIRST 
						FROM GROUPS
						WHERE PROFESSION LIKE '1-4%');

SELECT s.NAME
FROM STUDENT as s
WHERE IDSTUDENT = ANY (
    SELECT p.IDSTUDENT
    FROM PROGRESS as p
    WHERE NOTE = 4
);
