use SES_MyBase

CREATE VIEW [��������VIEW]
AS SELECT *
FROM �������

CREATE VIEW [���������� �������]
AS SELECT �������.������������_�������,COUNT(*)[����������]
FROM �������
GROUP BY �������.������������_�������

CREATE VIEW [�������View]
as
SELECT *
FROM �������
WHERE	�������.������� LIKE '+7 123%'

INSERT �������View(ID_�������,��������_�����,���_�������������, �����, ������� , ����������_����)	
Values(7,'�����7',1,'��. �������, 7', '+8 123','����� ������')

ALTER VIEW [�������View]
as
SELECT *
FROM �������
WHERE	�������.������� LIKE '+7 123%' WITH CHECK OPTION

INSERT �������View(ID_�������,��������_�����,���_�������������, �����, ������� , ����������_����)	
Values(8,'�����7',1,'��. �������, 7', '+8 123','����� ������')

CREATE VIEW [�������View2]
as
SELECT TOP 150 *
FROM �������
ORDER BY �������.�����

ALTER VIEW [���������� �������] WITH SCHEMABINDING
AS SELECT �������.������������_�������,COUNT(*)[����������]
FROM dbo.�������
GROUP BY �������.������������_�������