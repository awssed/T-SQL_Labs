use UNIVER

SELECT GROUPS.PROFESSION,PROGRESS.SUBJECT,GROUPS.FACULTY,AVG(PROGRESS.NOTE) [MARK]
from GROUPS, PROGRESS, FACULTY, STUDENT
where GROUPS.FACULTY = FACULTY.FACULTY and
FACULTY.FACULTY ='���'
GROUP BY ROLLUP( GROUPS.PROFESSION, PROGRESS.SUBJECT, GROUPS.FACULTY )

SELECT GROUPS.PROFESSION,PROGRESS.SUBJECT,GROUPS.FACULTY,AVG(PROGRESS.NOTE) [MARK]
from GROUPS, PROGRESS, FACULTY, STUDENT
where GROUPS.FACULTY = FACULTY.FACULTY and
FACULTY.FACULTY ='���'
GROUP BY CUBE( GROUPS.PROFESSION, PROGRESS.SUBJECT, GROUPS.FACULTY )


SELECT GROUPS.PROFESSION ,PROGRESS.SUBJECT,GROUPS.FACULTY,AVG(PROGRESS.NOTE)
FROM PROGRESS INNER JOIN STUDENT
ON PROGRESS.IDSTUDENT=STUDENT.IDSTUDENT
INNER JOIN GROUPS
ON GROUPS.IDGROUP=STUDENT.IDGROUP
WHERE GROUPS.FACULTY='���'
GROUP BY GROUPS.FACULTY,GROUPS.PROFESSION,PROGRESS.SUBJECT
UNION
SELECT GROUPS.PROFESSION ,PROGRESS.SUBJECT,GROUPS.FACULTY,AVG(PROGRESS.NOTE)
FROM PROGRESS INNER JOIN STUDENT
ON PROGRESS.IDSTUDENT=STUDENT.IDSTUDENT
INNER JOIN GROUPS
ON GROUPS.IDGROUP=STUDENT.IDGROUP
WHERE GROUPS.FACULTY='����'
GROUP BY GROUPS.FACULTY,GROUPS.PROFESSION,PROGRESS.SUBJECT


SELECT GROUPS.PROFESSION ,PROGRESS.SUBJECT,GROUPS.FACULTY,AVG(PROGRESS.NOTE)
FROM PROGRESS INNER JOIN STUDENT
ON PROGRESS.IDSTUDENT=STUDENT.IDSTUDENT
INNER JOIN GROUPS
ON GROUPS.IDGROUP=STUDENT.IDGROUP
WHERE GROUPS.FACULTY='����'
GROUP BY GROUPS.FACULTY,GROUPS.PROFESSION,PROGRESS.SUBJECT
INTERSECT
SELECT GROUPS.PROFESSION ,PROGRESS.SUBJECT,GROUPS.FACULTY,AVG(PROGRESS.NOTE)
FROM PROGRESS INNER JOIN STUDENT
ON PROGRESS.IDSTUDENT=STUDENT.IDSTUDENT
INNER JOIN GROUPS
ON GROUPS.IDGROUP=STUDENT.IDGROUP
WHERE GROUPS.FACULTY='����'
GROUP BY GROUPS.FACULTY,GROUPS.PROFESSION,PROGRESS.SUBJECT

SELECT GROUPS.PROFESSION ,PROGRESS.SUBJECT,GROUPS.FACULTY,AVG(PROGRESS.NOTE) as Mark
FROM PROGRESS INNER JOIN STUDENT
ON PROGRESS.IDSTUDENT=STUDENT.IDSTUDENT
INNER JOIN GROUPS
ON GROUPS.IDGROUP=STUDENT.IDGROUP
WHERE GROUPS.FACULTY='����'
GROUP BY GROUPS.FACULTY,GROUPS.PROFESSION,PROGRESS.SUBJECT
EXCEPT
SELECT GROUPS.PROFESSION ,PROGRESS.SUBJECT,GROUPS.FACULTY,AVG(PROGRESS.NOTE) as Mark
FROM PROGRESS INNER JOIN STUDENT
ON PROGRESS.IDSTUDENT=STUDENT.IDSTUDENT
INNER JOIN GROUPS
ON GROUPS.IDGROUP=STUDENT.IDGROUP
WHERE GROUPS.FACULTY='����'
GROUP BY GROUPS.FACULTY,GROUPS.PROFESSION,PROGRESS.SUBJECT
HAVING AVG(PROGRESS.NOTE)>5

SELECT GROUPS.FACULTY,GROUPS.IDGROUP,COUNT(*) AS TotalCount
FROM STUDENT INNER JOIN GROUPS
ON GROUPS.IDGROUP=STUDENT.IDGROUP
GROUP BY ROLLUP(GROUPS.FACULTY, GROUPS.IDGROUP)

SELECT  A.AUDITORIUM_TYPE, COUNT(A.AUDITORIUM) AS TotalAuditoriums, SUM(A.AUDITORIUM_CAPACITY) AS TotalCapacity
FROM  AUDITORIUM A INNER JOIN AUDITORIUM_TYPE AT ON A.AUDITORIUM_TYPE = AT.AUDITORIUM_TYPE
GROUP BY ROLLUP (A.AUDITORIUM_TYPE);