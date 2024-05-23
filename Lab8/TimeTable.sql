
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
    (1, 1, '206-1', 'БД', 'АКНВЧ', 'Понедельник'),
    (2, 2, '236-1', 'ВТЛ', 'АРС', 'Вторник'),
    (3, 1, '300', 'ДМ', 'БЗБРДВ', 'Вторник'),
    (4, 3, '301-1', 'ИГ', 'БРГ', 'Четверг'),
    (5, 2, '313-1', 'ИНФ', 'БРКВЧ', 'Пятница'),

CREATE VIEW ScheduleView AS
SELECT *
FROM
(
SELECT IDGROUP, DayOfWeek, SUBJECT
 FROM TIMETABLE) AS SourceTable
PIVOT
(
MAX(SUBJECT)
FOR DayOfWeek IN ([Понедельник], [Вторник], [Среда], [Четверг], [Пятница])
) AS PivotTable;

SELECT * FROM ScheduleView