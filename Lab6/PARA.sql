SELECT STUDENT.NAME,AVG(PROGRESS.NOTE)
FROM PROGRESS INNER JOIN STUDENT
ON PROGRESS.IDSTUDENT=STUDENT.IDSTUDENT
INNER JOIN GROUPS
ON GROUPS.IDGROUP=STUDENT.IDGROUP
WHERE GROUPS.FACULTY='���'
GROUP BY STUDENT.NAME