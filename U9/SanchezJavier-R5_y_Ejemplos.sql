			


							--	RELACION 5   -  ALGORITMIA SQL



-- Ej 1: Declara una variable entera @empleadoBuscado que sea igual a 2, y obt�n
-- el n�mero de ventas que ha realizado el mismo.


DECLARE @empleadoBuscado_ej1 INT
SET @empleadoBuscado_ej1 = 2
SELECT acumuladoVentas FROM empleados WHERE idEmp = @empleadoBuscado_ej1


-- Ej2: Declara una variable entera y calcula el cuadrado de la misma.
-- Imprime el resultado como " El cuadrado de x es y"


DECLARE @var_ej2 INT = 5;
DECLARE @cuadrado_ej2 INT = @var_ej2 * @var_ej2;
PRINT('El cuadrado de ' + CAST(@var_ej2 AS VARCHAR) + ' es ' + CAST(@cuadrado_ej2 AS VARCHAR));


-- Ej3: Declara la variable @sueldomedio igual al sueldo medio de los trabajadores, 
-- y crea una consulta que muestre todos aquellos trabajadores cuyo sueldo sea igual 
-- o superior a la variable @sueldomedio

DECLARE @sueldomedio_ej3 INT;
SET @sueldomedio_ej3 = (SELECT AVG(sueldo) FROM empleados)
SELECT * 
FROM empleados
WHERE sueldo >= @sueldomedio_ej3

-- Ej4: Declara una variable @idDep , que sea igual al IdDep del empleado con
--idEmp3. A continuaci�n, imprime la ciudad y el objevito anual del mismo. 

DECLARE @idDep_ej4 INT
SET @idDep_ej4 = (SELECT idDep FROM empleados WHERE idEmp = 3)
SELECT ciudad, objetivoAnual FROM departamentos WHERE idDep = @idDep_ej4

-- Ej 5: Guardar el sueldo m�ximo de los empleados 
-- en una variable llamada SueldoMaximo e imprimela.

DECLARE @SueldoMaximo_ej5 INT
SET @SueldoMaximo_ej5 = (SELECT MAX(sueldo) FROM empleados)
PRINT @SueldoMaximo_ej5

-- Ej 6: Crear dos variables, nombre y ciudad, y asignarle 
--los valores del idProv 3.

DECLARE @nombre_ej6 VARCHAR(50)
DECLARE @ciudad_ej6 VARCHAR(50)
SET @nombre_ej6 = (SELECT nombre FROM proveedores WHERE idPro = 3)
SET @ciudad_ej6 = (SELECT ciudad FROM proveedores WHERE idPro = 3)
PRINT @nombre_ej6				-- Duda: Se pueden imprimir dos variables con un mismo print?
PRINT @ciudad_ej6

-- EJ 7:  Crear una variable @numero, entera. 
-- si el n�mero es mayor que 10, que imprima 'es mayor que 10'


declare @numero_ej7 INT = 30;
if @numero_ej7 > 10
	print('es mayor que 10');


-- EJ 9: . Crear una variable @numero, entera. 
-- si el n�mero es mayor que 10, que imprima 'es mayor que 10' y si es 
-- menor, que imprima que es menor.


declare @numero_ej9 INT = RAND()*20;
if 10 < @numero_ej9
	print('es mayor que 10');
else
	print('es menor que 10');


-- EJ 10: . Crear una variable @numero, entera. 
-- si el n�mero es mayor que 10, que imprima 'es mayor que 10' y si es 
-- menor, que imprima que es menor. Si el n�mero introducido es 10, que imprima
-- que es 10.

DECLARE @numero_ej10 INT = 20;
IF @numero_ej10 = 10
BEGIN
	PRINT 'El numero es 10';
	END
ELSE IF @numero_ej10 > 10
BEGIN
	PRINT 'El numero es mayor que 10';
	END
ELSE IF @numero_ej10 < 10
BEGIN
	PRINT 'El numero es menor que 10';
	END

-- Ej 11:: Crear la variable idEmp , igual a 3, y que 
-- imprima en pantalla si el tama�o del apellido es mayor que 5, menor que 5, o 5.

DECLARE @idEmp_ej11 INT = 3
DECLARE @totalLetras INT = (SELECT LEN(apellido) FROM empleados WHERE idEmp = @idEmp_ej11)
IF @totalLetras > 5
BEGIN
	PRINT('El apellido es mayor que 5')
	END
ELSE IF @totalLetras = 5
BEGIN
	PRINT('El apellido es igual a 5')
	END
ELSE
BEGIN
	PRINT('El apellido es menor que 5')
	END

SELECT apellido
FROM empleados
where idEmp = 3


-- Ej 12: declara la variable @sueldomedio igual al sueldo medio de los trabajadores, y 
--  @empleado igual a 3. A continaci�n, si el sueldo del empleado es menor que @sueldomedio,
-- imprime 'el sueldo es inferior a la media', si es igual , imprime 'el sueldo es igual a la media'
-- y si es mayor, imprime 'el sueldo es mayor a la media'

declare @sueldomedio numeric(6,2), @empleado int
set @sueldomedio = (select Avg(sueldo)
					from empleados)
set @empleado= 3
if (select sueldo 
	from empleados
	where idEmp= @empleado) < @sueldomedio
print 'El sueldo es inferior a la media '
if (select sueldo 
	from empleados
	where idEmp= @empleado) > @sueldomedio
print 'El sueldo es mayor a la media '
if (select sueldo 
	from empleados
	where idEmp= @empleado) = @sueldomedio
print 'El sueldo es igual a la media '

 -- EJ 13:   Declara las variables IdPro igual a 20, nombrePro igual a Marco y Ciudad Pro igual a Tenerife
--En caso de que ya exista el proveedor con IdPro 20, actualizarlo. En caso de que no, insertarlo.

 DECLARE @idPro_ej20 INT = 20
 DECLARE @nombrePro_ej20 VARCHAR(50) = 'Marco'
 DECLARE @ciudadPro_ej20 VARCHAR(50) = 'Tenerife'
 IF @idPro_ej20 IN (SELECT idPro FROM proveedores)
 BEGIN
	UPDATE proveedores
	SET nombre = 'Marco', ciudad = 'Tenerife'
	WHERE idPro = 20
	END
 ELSE
	INSERT INTO proveedores(idPro, nombre, ciudad) VALUES (20, 'Marco', 'Tenerife')

-- Ej 15: realiza una consulta en la que se imprima los n�meros del 
-- 0 al 10

DECLARE @contador_ej15 INT = 0
WHILE @contador_ej15 <= 10
BEGIN
	PRINT @contador_ej15
	SET @contador_ej15 = @contador_ej15 + 1
	END
	
-- Ej 15 B. realiza una consulta en la que se imprima los n�meros del 
-- 10 al 0

DECLARE @contador_ej16 INT = 10
WHILE @contador_ej16 >= 0
BEGIN
	PRINT @contador_ej16
	SET @contador_ej16 = @contador_ej16 - 1
	END
	
-- Ej 16: Declara una variable @numero y realiza una consula para realizar la 
-- sumatoria desde ese numero n hasta 0. Despu�s, imprimir el valor de la sumatoria



-- EJ 17: Realiza una consulta en la cu�l, si el precio promedio de un producto es inferior a 200�, 
-- el bucle WHILE dobla los precios y, a continuaci�n, selecciona el precio m�ximo de los productos. 
-- Si el precio m�ximo es menor o igual que 500�, el bucle WHILE se reinicia y vuelve a doblar los precios. 
-- Este bucle contin�a doblando los precios hasta que el precio m�ximo es mayor que 500�, despu�s de lo cual 
-- sale del bucle WHILE e imprime un mensaje.



						--			EJEMPLOS DE PROGRAMACION EN TRANSACT SQL		--

						-- contador que nos da 10 n�meros aleatorios del 1 al 100

declare @contador int=0;
declare @num int;
while @contador <= 10
begin
	set @num = RAND() * 100 - 1
	print @num;
	set @contador = @contador + 1
end





							--funcion que devuelva si un numero es par o no

go
create function comprobar(@numero int)
returns int
as
begin
	declare @resultado int
	if (@numero % 2 = 0)
		begin
			set @resultado = 0
		end
	else
		begin
			set @resultado = 1
		end
	return @resultado
end
go

print dbo.comprobar(3)


	
				--funcion que diga el equivalente de una nota (EJ: 6 bien, 7 notable)

go
create function equivalente(@nota int)
returns varchar(50)
as
begin
declare @dictar varchar(50)
declare @suficiente int = 5
declare @bien int = 6
declare @notable int = 7
declare @sobresaliente int = 9
if (@nota >= @sobresaliente)
	begin
		set @dictar = 'Enhorabuena! Tienes un sobresaliente.'
	end
else if (@sobresaliente > @nota) AND (@nota >= @notable)
	begin
		set @dictar = 'Muy bien! Tienes un notable.'
	end
else if (@notable > @nota) AND (@nota >= @bien)
	begin
		set @dictar = 'Tienes un bien.'
	end
else if (@bien > @nota) AND (@nota >= @suficiente)
	begin
		set @dictar = 'Tienes un suficiente.'
	end
else if (@suficiente > @nota)
	begin
		set @dictar = 'Est�s suspenso.'
	end
	return @dictar
end
go

print dbo.equivalente(5)

							--	contar letras de una frase

declare @frase varchar(100) = 'Fin de fiestas, catetos a su pueblo';
declare @contador INT=0;
declare @contadorvocales int;
print len(@frase);

while @contador <= LEN(@frase)
begin
	if SUBSTRING(@frase, @contador, 1) in ('A','E','I','O','U')
		set @contadorvocales = @contadorvocales + 1
	set @contador = @contador + 1
end
print @contadorvocales


										/* Factoriales */


DECLARE @factorial int=1;
declare @numero int=40;
declare @contador INT=1;
while @contador <= @numero
begin
	set @factorial = @factorial * @contador;
	set @contador = @contador + 1;
end
print 'El factorial de ' + cast(@numero as varchar) + ' es: ' + cast(@factorial as varchar)



							-- generar un numero al azar entre el 15 y el 28

declare @numero INT;
declare @cont INT=0;

while @cont < 100
begin
	set @numero = RAND()*13+15
	print  @numero;
	set @cont = @cont + 1
end
print @numero;


--declare @nu INT;
--set @nu = RAND()*98
--print @nu;

DECLARE @NU FLOAT;
SET @NU = RAND()
PRINT @NU;

									-- FUNCION QUE DEVUELVA EL ARTICULO MAS BARATO. SACAR
									-- CODIGO DE ARTICULO, NOMBRE Y PRECIO.

GO
CREATE FUNCTION fartBarato()
RETURNS TABLE
AS
	RETURN (SELECT idArt, nombre, ppu
			FROM articulos
			WHERE ppu= (SELECT MIN(PPU)
						FROM articulos))
GO
SELECT *
FROM dbo.fartBarato()


										--primos:

declare @num int = 45 , @cont int = 2;

while (@cont < @num)
	begin
		if (@num % @cont = 0)
			print 'El número ' + cast(@num as varchar) + ' no es primo'
			break
		set @cont = @cont + 1;	
	end

if (@cont = @num)		
			print 'El número ' + cast(@num as varchar) + ' es un número primo'


											--divisores:

declare @num int = 8954, @contador int = 1;

while (@contador <= @num)
begin

		if (@num % @contador = 0)
			begin
	
				print 'El número ' + cast(@contador as varchar) + ' es divisor        
                                               de ' +    cast(@num as varchar);
		
			end
	
		set @contador = @contador + 1;

end


							--Para que devuelva un numero entre el 1 y el 6

declare @num int, @contador int;
set @contador=0
while (@contador<100)
begin 
	set @num= rand()*6+1;
	print @num;
	set @contador=@contador +1
end

							--Para que devuelva un numero al azar entre el 15 y el 28

declare @num int, @contador int;
set @contador=0
while (@contador < 100)
begin
	set @num= RAND()*14+15;
	print @num
	set @contador = @contador + 1
end

								--3. Generar una tirada de dados al azar.

declare @numero int
set @numero = RAND ()*6 + 1
print @numero

--3.1 Idem, 20 tiradas!
declare @num int, @contador int;
set @contador=0
while (@contador<=20)
begin 
	set @num= rand()*6+1;
	print @num;
	set @contador=@contador +1
end

							--7. Sacar el factorial de un número entero mayor que 1.
												--Ejemplo: 4!=4*3*2*1=24
												--Tb 4!=4*3! , ok?	

declare @factorial bigint;
declare @numero int=5;
declare @a int=1;

set @factorial=1

while @a<=@numero
begin
	set @factorial=@factorial*@a;
	set @a=@a+1
end
print 'El factorial de ' + cast(@numero as varchar)+ 
		' es: ' + cast(@factorial as varchar)

		--Genera un random entre 0 y 0,99 y al multiplicarlo sale entre 0 y 99.

		declare @num int;
set @num=RAND()*100 +1;
print @num


declare @num float; --Float coge 4 decimales
set @num=RAND()*100 +1;
print @num

--Con bucle
declare @contador int=31;
 -- set @contador=31
declare @num int;
while @contador<41
begin
	set @num=RAND()*100+1;
	print @num;
	set @contador=@contador+1;
end



						--1. Generar 13 números al azar (entre el 1 y el 100) 
						--¿Cuántos son pares y cuántos son múltiplos de 5?

declare @contPares int = 0, @contCinco int, @contador int;
declare @num int;
--set @contPares=0;
set @contCinco=0;
set @contador=1;
while @contador<=13
begin
	set @num=RAND()*100 + 1
	--A partir del 1.
	print @num
	if @num%2=0
		set @contPares=@contPares+1
	if @num%5=0
		set @contCinco=@contCinco+1
	set @contador=@contador+1		
end
print 'Hay '+ cast(@contPares as varchar)+' pares'
print 'Hay '+ cast(@contCinco  as varchar)+' múltiplos de cinco'
–
	

						
						--Generar un número entre el 1 y el 1000 y decir si es primo o no.
declare @num int = rand()*1000 + 1 , @cont int = 2, @bandera bit = 0;
while (@cont < @num)
	begin
		if (@num % @cont =0)
			begin
				print 'El número ' + cast (@num as varchar) + ' no es primo'
				set @bandera=1
				break
			end
		set @cont = @cont + 1;
	end
if (@bandera = 0)
	begin
		print 'El número ' + cast (@num as varchar) + ' es un número primo'
	end

	
-- Para sacar un numero entre el 1 y el 6.
declare @num int;
set @num= RAND()*6+1;
print @num;

--Para que devuelva un número al azar entre el 15 y el 28
declare @num int;
set @num= RAND()*13+15;
print @num


--La secuencia divide 27 entre 4 y nos da el resto
print 27%4

declare @a int =rand()*100 + 1
print  @a
–
–Iteración del bucle
DECLARE @contador int
    SET @contador = 0
    WHILE (@contador < 10)
    BEGIN
     	SET @contador = @contador + 1
    	PRINT 'Iteracion del bucle ' + cast(@contador AS varchar)
    END
-- Iteración del bucle de 5 en 5
    DECLARE @contador int
    SET @contador = 0
    WHILE (@contador < 100)
    BEGIN
     	SET @contador = @contador + 1
		IF (@contador % 5 != 0)
       	    CONTINUE
    	PRINT 'Iteracion del bucle ' + cast(@contador AS varchar)
    END
---
DECLARE @contador int;
SET @contador = 0
WHILE (1 = 1) 
BEGIN
  	SET @contador = @contador + 1
	IF (@contador % 50 = 0)
      	    BREAK
   	PRINT 'Iteracion del bucle ' + cast(@contador AS varchar)
END 
print 'Estoy fuera!'
--		----------------
 BEGIN TRY

     DECLARE @divisor int, @dividendo int, @resultado int 

     SET @dividendo = 100;
     SET @divisor = 0

     -- Esta línea provoca un error de división por 0
     SET @resultado = @dividendo/@divisor
     PRINT 'No hay error'
 END TRY
 BEGIN CATCH
     PRINT 'Se ha producido un error.'
 END CATCH 
-- Generar un número entre el 15 y el 100.
declare @num int;
set @num= RAND()*85+15;
print @num 

--2. Sacar los divisores de un número, entre el 1 y el 1000, por ejemplo.
--Asignado o generado al azar, me da igual! !!
declare @num int = 751, @contador int = 1;
print 'Los divisores de ' + cast(@num as varchar) + ' son: '
while (@contador <= @num)
	begin
	if (@num % @contador = 0)
		begin
			print 'El numero ' + cast(@contador as varchar) + ' es divisor de ' + cast(@num as varchar)
		end
	set @contador = @contador + 1;
	end;

--3. Generar una tirada de dados al azar. 
declare @num int;
set @num=RAND()*6+1;
print @num
-- Idem, 20 tiradas!
declare @num int, @contador int;
set @contador = 0
while (@contador<=20)
begin
	set @num= RAND()*6+1;
	print @num;
	set @contador=@contador+1
end

-- ¿Cuantos numeros salen de los 6 numeros en 6000 dados?
declare @num int, @contador int;
set @contador = 0
while (@contador<=6000)
begin
	set @num= RAND()*6+1;
	print @num;
	set @contador=@contador+1
end

--3.2 Si tiro 6000 dados, ¿Cuántas veces se repite cada uno de ellos? (CASA)

--4. Generar 15 notas y decir cuantos suspensos, el número de sobresalientes 
--y si hay, o no, algun 10!

declare @nota int
declare @suspenso int = 0
declare @sobresaliente int = 0
declare @cont int = 0
while @cont <= 100
	begin
	set @nota = RAND()*11
	set @cont = @cont + 1
	print @nota
	if @nota < 5
		set @suspenso = @suspenso + 1
	if @nota >9
		set @sobresaliente = @sobresaliente + 1
	end
print 'Hay ' + cast(@suspenso as varchar) + ' suspensos y ' + cast(@sobresaliente as varchar) + ' sobresaliente'


--5. Decir si un número es, o no, primo.
--Idem...
declare @num int = 97, @cont int = 2, @bandera bit = 0;
while (@cont < @num)
	begin
		if (@num % @cont = 0)
			begin
				print 'El número ' + cast (@num as varchar) + ' no es primo'
				set @bandera=1
				break
			end
		set @cont = @cont + 1;	
	end
if (@bandera = 0)
	begin
		print 'El número ' + cast (@num as varchar) + ' es un número primo'
	end

--6. Sacar los números primos entre n1 (inicio) y n2 (fin)...
--O bien entre el 1 y otro número (tope)



--7. Sacar el factorial de un número entero mayor que 1.
--Ejemplo: 4!=4*3*2*1=24
--Tb 4!=4*3! , ok?	

declare @factorial smallint;
declare @numero int=5;
declare @contador int=1;

set @factorial=1

while @contador<=@numero
begin
	print 'hola'
	set @factorial=@factorial*@contador;
	set @contador=@contador+1
end
print 'El factorial de ' + cast(@numero as varchar)+ 
		' es: ' + cast(@factorial as varchar)

--Idem con la sumatoria
declare @antonio int;
declare @numero int=200;
declare @contador int=0;

set @antonio=0

while @contador<=@numero
begin
	set @antonio=@antonio+@contador;
	set @contador=@contador+1
end
print 'La sumatoria de ' + cast(@numero as varchar)+ 
		' es: ' + cast(@antonio as varchar)

--Declarar una variable tipo varchar y que nos diga cuántas vocales tiene
declare @frase varchar(40)='Fin de fiestas, catetos a su pueblo';
--len (cadena)
--substring (cadena,inicio,numero)
declare @contador int=0;
declare @contadorVocales int=0;
--print len(@frase)
while @contador<=LEN(@frase)
begin
	if SUBSTRING(@frase, @contador,1) in ('A','E','I','O','U','a','e','i','o','u')
		set @contadorVocales=@contadorVocales+1;
	set @contador=@contador+1
end
print 'La frase ' + @frase + ' tiene ' + cast(@contadorVocales as varchar) + ' vocales'

print getdate()

--CREAR FUNCIONES
GO
CREATE FUNCTION fMayor(@num1 float, @num2 float)
returns float
AS
BEGIN
	declare @almacen float
	if (@num1>=@num2)
		BEGIN
			set @almacen = @num1	
		END
	ELSE 
		BEGIN
			set @almacen = @num2	
		END
	return @almacen
END
GO

print dbo.fMayor(2.5, 3)
print dbo.fMayor(5.7, 1)
print dbo.fMayor(8, 2)

--------------------------------------------------------
-------------------------------------------

--Función que devuelva si un número es par o no
-- fEsPar --> 0/1

GO
CREATE FUNCTION fEsPar(@num1 int)
returns int
AS
BEGIN
	declare @resultado int
	if (@num1 % 2 = 0)
		BEGIN
			set @resultado =0
		END
	ELSE 
		BEGIN
			set @resultado=1
		END
	return @resultado
END
GO

print dbo.fEsPar(4)
print dbo.fEsPar(3)

--1.1 Algoritmo que diga si un número es par y devuelva "es par", "es impar"
if (dbo.fEsPar(8) =0)
	begin
		print 'Es par'
	end
else
	begin
		print 'Es impar'
	end
--1.2 Generar 10 números entre el 1 y el 100 e indicar cuáles de esos son pares.



--2. Funcion que devuelva los proveedores de la ciudad que se indique
use depempprueba
go
create function fDevolverPro(@ciudad varchar (50))
returns table
as
	return (select *
			from proveedores
			where ciudad = @ciudad)
go

select *
from dbo.fDevolverPro('Granada')

--3. Necesitamos una funcion que devuelva articulos que queden menos de 5 unidades
use depempprueba
go
create function fDevolverArt (@existencias int)
returns table
as
	return (select *
			from articulos
			where existencias < @existencias)
go


-- Función que devuelva los articulos que contengan al menos una 'a' en su nombre. 

go
create function fletraArt (@letra varchar(40))
returns table
as
	return (select *
			from articulos
			where charindex (@letra, nombre)>0)
go


select *
from fletraArt('m')

select *
from articulos

-- Función que devuelva el artículo mas barato. Sacar código del artículo, nombre y precio.
go
create function fartBarato()
returns table
as
	return (select idArt, nombre, ppu
			from articulos
			where ppu=(select min (ppu)
					  from articulos))
go

select *
from dbo.fartBarato() 

--Sacar los articulos que valen más que el parámetro de entrada que indique una cantidad--
go
create function fartMas(@masCaros int)
returns table
as
	return (select *
			from articulos
			where ppu>(@masCaros))
go

select *
from articulos

select *
from dbo.fartMas(40)

-- Funcion que devuelva el nombre completo de un empleado que se le pase como parametro de entrada (id del empleado)
go
create function fnombreCompleto (@idEmp int)
returns table
as
	return (select nombre + ' ' + apellido as NombreCompleto
			from empleados
			where idEmp=idEmp)
go

select *
from dbo.fnombreCompleto(1)

select *
from empleados

-- Funcion que nos diga cuántos minutos de música tengo de un determinado cantante (se le pasa como parámetro)
go
create function fminMusica (@cantante varchar(40))
returns table
as
	return (select sum(Duracion) as duracionTotal
			from ALBUMES
			where AUTOR = @cantante)
go

select *
from dbo.fminMusica('Bon Jovi')
-- Función que devuelva el factorial de un número
GO
CREATE FUNCTION fFactorial(@num1 int)
returns bigint
as
BEGIN

declare @factorial bigint;
declare @contador int=1;

set @factorial=1

while @contador<=@num1
begin
	set @factorial=@factorial*@contador;
	set @contador=@contador+1
end
return @factorial

END

GO

print dbo.fFactorial (10)




		