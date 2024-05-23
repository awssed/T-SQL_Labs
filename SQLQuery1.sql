use master;
alter database SES_MyBase set single_user with rollback immediate
DROP database SES_MyBase
create database SES_MyBase

USE SES_MyBase

CREATE database SES_MyBase on primary
(name = 'SES_MyBase_mdf', filename = 'D:\�����\4���\DataBase\Lab3\BD\SES_MyBase_mdf.mdf',
size = 10240Kb,maxsize=UNLIMITED, filegrowth=1024Kb),
( name = 'SES_MyBase_ndf', filename = 'D:\�����\4���\DataBase\Lab3\BD\SES_MyBase_ndf.ndf', 
   size = 10240KB, maxsize=1Gb, filegrowth=25%),
filegroup FG
( name = 'SES_MyBase_fg1_1', filename = 'D:\�����\4���\DataBase\Lab3\BD\SES_MyBase_ndf2.ndf', 
   size = 10240Kb, maxsize=1Gb, filegrowth=25%),
( name = 'SES_MyBase_fg1_2', filename = 'D:\�����\4���\DataBase\Lab3\BD\SES_MyBase_ndf3.ndf', 
   size = 10240Kb, maxsize=1Gb, filegrowth=25%)
log on
( name = 'SES_MyBase_log', filename='D:\�����\4���\DataBase\Lab3\BD\SES_MyBase_log.ldf',       
   size=10240Kb,  maxsize=2048Gb, filegrowth=10%)

CREATE table ����_��������(
��������_������� nvarchar(50) primary key,
������ decimal(2,2)
) on FG

CREATE table ����_�������������(
ID_������������� int primary key,
��� nvarchar(50)
)on FG

CREATE table �������(
ID_������� int primary key,
��������_����� nvarchar(50),
���_������������� int foreign key references ����_�������������(ID_�������������),
����� nvarchar(50),
������� nvarchar(50),
����������_���� nvarchar(50)
)on FG

CREATE table �������(
ID int primary key,
������������_������� nvarchar(50) foreign key references ����_��������(��������_�������),
ID_������� int foreign key references �������(ID_�������),
����_������ date,
����_�������� date,
����� money
)on FG
USE SES_MyBase
 ALTER Table ������� DROP column ����������_����
 
 ALTER Table ������� ADD ����������_���� nvarchar(50)

 INSERT INTO ����_�������� (��������_�������, ������)
VALUES ('��������� ������', 0.05),
       ('��������������� ������', 0.1),
       ('����������', 0.07);

INSERT INTO ����_������������� (ID_�������������, ���)
VALUES (1, '������� �������������'),
       (2, '��������������� �������������'),
       (3, '������������� �������������');


INSERT INTO ������� (ID_�������, ��������_�����, ���_�������������, �����, �������, ����������_����)
VALUES (1, '��� ABC Corporation', 1, '��. ������, 1', '+7 123-456-7890', '������ ����'),
       (2, '�� ������', 1, '��. ������, 2', '+7 987-654-3210', '������ ����'),
       (3, '��������������� �����������', 2, '��. ������, 3', '+7 555-555-5555', '������� �������');


INSERT INTO ������� (ID, ������������_�������, ID_�������, ����_������, ����_��������, �����)
VALUES (1, '��������� ������', 1, '2023-07-15', '2043-07-15', 5000000),
       (2, '��������������� ������', 2, '2024-02-20', '2025-02-20', 100000),
       (3, '����������', 3, '2024-01-10', '2027-01-10', 2000000);


SELECT * FROM �������

SELECT count(*) FROM �������

UPDATE ������� set �����=20000 WHERE ID_�������=2