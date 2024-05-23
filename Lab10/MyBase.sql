exec sp_helpindex 'Кредиты' 
CREATE CLUSTERED INDEX #index2 on Кредиты(Сумма);

SELECT * FROM КРЕДИТЫ 
WHERE Кредиты.Сумма between 10000 and 100000

CREATE INDEX #index3 on Кредиты(ID,Сумма)

SELECT * FROM КРЕДИТЫ 
WHERE Кредиты.Сумма between 10000 and 100000
order by ID

CREATE INDEX #index4 on Кредиты(Сумма) where(Сумма>=10000 and Сумма<=100000)

SELECT * FROM КРЕДИТЫ 
WHERE Кредиты.Сумма between 10000 and 100000
order by ID

