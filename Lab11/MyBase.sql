use SES_MyBase
SELECT * FROM КРЕДИТЫ
DECLARE newcursor CURSOR FOR SELECT КРЕДИТЫ.Наименование_кредита, КРЕДИТЫ.Сумма FROM КРЕДИТЫ WHERE КРЕДИТЫ.Наименование_кредита='Автокредит'

DECLARE	@name nvarchar(20), @sum nvarchar(20)
OPEN newcursor
FETCH newcursor into @name, @sum
print 'Кредиты'
WHILE @@FETCH_STATUS = 0
	begin
		print @name+'-'+@sum
		FETCH newcursor into @name,@sum
	end
CLOSE newcursor

DECLARE newcursor2 CURSOR FOR SELECT КЛИЕНТЫ.Контактное_лицо,КРЕДИТЫ.Сумма, ВИДЫ_КРЕДИТОВ.Ставка FROM КЛИЕНТЫ INNER JOIN КРЕДИТЫ
									on КЛИЕНТЫ.ID_клиента=КРЕДИТЫ.ID_клиента	INNER JOIN ВИДЫ_КРЕДИТОВ
									on КРЕДИТЫ.Наименование_кредита=ВИДЫ_КРЕДИТОВ.Название_кредита
DECLARE	@name nvarchar(20), @sum nvarchar(20), @stavka nvarchar(20), @result nvarchar(400)=''
OPEN newcursor2
FETCH newcursor2 into @name,@sum,@stavka
WHILE @@FETCH_STATUS=0
	BEGIN
		set @result=@result+RTRIM(@name)+'-'+RTRIM(@sum)+@stavka;
		FETCH newcursor2 into @name,@sum,@stavka;
	END
print @result
CLOSE newcursor2

DECLARE newcursor3 CURSOR LOCAL DYNAMIC FOR SELECT КРЕДИТЫ.Сумма FROM КРЕДИТЫ WHERE КРЕДИТЫ.Наименование_кредита='Автокредит'

OPEN newcursor3
FETCH newcursor3
while @@FETCH_STATUS=0
	begin
		UPDATE КРЕДИТЫ SET КРЕДИТЫ.Сумма=Сумма+1000
		FETCH newcursor3
	end
CLOSE newcursor3
