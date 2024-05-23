
use univer

CREATE TABLE TIMETABLE (
	LESSON int primary key,
    IDGROUP INT,
    AUDITORIUM char(20),
    SUBJECT nvarchar(10),
    TEACHER nvarchar(10),
    DayOfWeek VARCHAR(20),
    FOREIGN KEY (IDGROUP) REFERENCES GROUPS(IDGROUP),
    FOREIGN KEY (AUDITORIUM) REFERENCES AUDITORIUM(AUDITORIUM),
    FOREIGN KEY (SUBJECT) REFERENCES SUBJECT(SUBJECT),
    FOREIGN KEY (TEACHER) REFERENCES TEACHER(TEACHER)
);
SELECT * FROM GROUPS

INSERT INTO TIMETABLE (LESSON, IDGROUP, AUDITORIUM, SUBJECT, TEACHER, DayOfWeek)
VALUES
    (1, 1, '206-1', '��', '�����', '�����������'),
    (2, 2, '236-1', '���', '���', '�������'),
    (3, 1, '300', '��', '������', '�������'),
    (4, 3, '301-1', '��', '���', '�������'),
    (5, 2, '313-1', '���', '�����', '�������'),

CREATE VIEW ScheduleView AS
SELECT *
FROM
(
SELECT IDGROUP, DayOfWeek, SUBJECT
 FROM TIMETABLE) AS SourceTable
PIVOT
(
MAX(SUBJECT)
FOR DayOfWeek IN ([�����������], [�������], [�����], [�������], [�������])
) AS PivotTable;

SELECT * FROM ScheduleView