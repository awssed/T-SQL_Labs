use SES_MyBase

CREATE VIEW [КредитыпVIEW]
AS SELECT *
FROM КРЕДИТЫ

CREATE VIEW [Количество кредито]
AS SELECT КРЕДИТЫ.Наименование_кредита,COUNT(*)[Количество]
FROM КРЕДИТЫ
GROUP BY КРЕДИТЫ.Наименование_кредита

CREATE VIEW [КлиентыView]
as
SELECT *
FROM КЛИЕНТЫ
WHERE	КЛИЕНТЫ.Телефон LIKE '+7 123%'

INSERT КлиентыView(ID_клиента,Название_фирмы,Вид_собственности, Адрес, Телефон , Контактное_лицо)	
Values(7,'Фирма7',1,'ул. Пушкина, 7', '+8 123','Денис Петров')

ALTER VIEW [КлиентыView]
as
SELECT *
FROM КЛИЕНТЫ
WHERE	КЛИЕНТЫ.Телефон LIKE '+7 123%' WITH CHECK OPTION

INSERT КлиентыView(ID_клиента,Название_фирмы,Вид_собственности, Адрес, Телефон , Контактное_лицо)	
Values(8,'Фирма7',1,'ул. Пушкина, 7', '+8 123','Денис Петров')

CREATE VIEW [КредитыView2]
as
SELECT TOP 150 *
FROM КРЕДИТЫ
ORDER BY КРЕДИТЫ.Сумма

ALTER VIEW [Количество кредито] WITH SCHEMABINDING
AS SELECT КРЕДИТЫ.Наименование_кредита,COUNT(*)[Количество]
FROM dbo.КРЕДИТЫ
GROUP BY КРЕДИТЫ.Наименование_кредита