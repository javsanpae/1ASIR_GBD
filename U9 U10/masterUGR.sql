-- Relaci�n de ejercicios  -  JUANLU

-- 1. Realiza una funci�n que calcule el factorial de un n�mero pasado por par�metro. En caso de que el 
-- n�mero pasado por par�metro sea 0, devolver� 1, y si es negativo, devolver� -1.

CREATE FUNCTION fn_factorial(@num INT)
RETURNS INT
AS
BEGIN
	IF (@num > 0)
		BEGIN
			DECLARE @cont INT, @factorial INT
			SET @cont = @num
			SET @factorial = @num
			WHILE (@cont > 0)
				BEGIN
					SET @factorial = @factorial * @cont
					SET @cont = @cont - 1
				END
			END
	ELSE
			BEGIN
				IF (@num = 0)
					SET @factorial = 1
				ELSE
					SET @factorial = -1
			END
			RETURN @factorial
END
GO
PRINT CAST(dbo.fn_factorial(4) AS VARCHAR)


			

-- 2. Funcion que calcule cuantos pares hay desde 0 hasta un numero que se indica como parametro
-- de entrada

GO
CREATE FUNCTION fn_pares(@n INT)
RETURNS INT
AS
	BEGIN
		DECLARE @cont INT = 0
		DECLARE @contPares INT = 0
		WHILE (@cont <= @n)
			BEGIN
				IF (@cont % 2 = 0)
					BEGIN
						SET @contPares = @contPares + 1
					END
				SET @cont = @cont + 1
			END
	RETURN @contPares
END
GO

PRINT dbo.fn_pares(5)


-- 3. Funcion que calcule la sumatoria de n (parametro
-- de entrada) int

-- arreglado! thx juanlu
GO
ALTER FUNCTION fn_sumatoria(@n INT)
RETURNS INT
AS
BEGIN
DECLARE @sum INT=0
DECLARE @contador INT = @n
WHILE @contador != 0
BEGIN
	SET @sum = @sum + @contador
	SET @contador = @contador - 1
	END
RETURN @sum
END
GO

PRINT dbo.fn_sumatoria(5)


-- 4. Funci�n que nos diga el total de ventas de un determinado empleado/
-- se le pasa el c�dido del empleado como par�metro.

-- funcionando!!!
CREATE FUNCTION fn_totalVentas(@codEmpleado INT)
RETURNS INT
AS
BEGIN
DECLARE @totalVentas INT
SET @totalVentas = (SELECT acumuladoVentas
					FROM empleados
					WHERE idEmp = @codEmpleado)
	RETURN @totalVentas
END
GO

PRINT dbo.fn_totalVentas(1)

--  v2 (tipo tabla)
go
CREATE FUNCTION fn_acumuladoVentas(@empleado INT)
RETURNS TABLE
AS
	RETURN (SELECT SUM(unidadesTotales * ppu) as ventasTotales
				FROM articulos INNER JOIN (SELECT idArt, SUM(unidades) AS unidadesTotales
											FROM ventas
											WHERE idEmp = @empleado
											GROUP BY idArt) AS T1
								ON articulos.idArt = T1.idArt)
go
PRINT dbo.fn_acumuladoVentas(4)



-- 5. Funcion que nos diga el emplado que mayor 
-- numero de ventas ha realizado (muestre empleado y ventas totales).

-- no funciona. arreglar para el viernes!!
GO
CREATE FUNCTION fn_mayorVentas()
RETURNS TABLE
AS
BEGIN
DECLARE @empleado VARCHAR(50)
SET @empleado = (SELECT nombre
					FROM empleados
					WHERE acumuladoVentas = (SELECT MAX(acumuladoVentas)
												FROM empleados)
	RETURN @empleado
END
GO
PRINT dbo.fn_mayorVentas() 

USE depempprueba
GO
CREATE FUNCTION fAcumVentas()
returns TABLE
AS
	return(select TOP 1 idEmp, SUM(unidadesVendidas*ppu) as acumuladoVentas
			from articulos  inner join(select idEmp, idArt,	SUM(unidades) as unidadesVendidas					
										   from ventas 
										   group by idArt,idEmp)as t1
										   on articulos.idArt = t1.idArt
			group by idEmp
			ORDER BY acumuladoVentas DESC)
GO

select * from dbo.fAcumVentas()


GO


-- 6. Funci�n que devuelva el valor del IRPF de cada
-- empleado sobre su sueldo. Para ello, supongamos 
-- que es el 21% para todos los empleados. 

-- version que devuelve tabla
CREATE FUNCTION fn_irpf_vtabla()
RETURNS TABLE
AS
	RETURN (SELECT idEmp, (sueldo*0.21) AS IRPF
			FROM empleados)
GO

SELECT * FROM dbo.fn_irpf_vtabla()

-- funciona 
CREATE FUNCTION fn_irpf_v2(@idEmp INT)
RETURNS FLOAT
AS
BEGIN
	DECLARE @tasaIRPF float = 21
	RETURN ((@tasaIRPF / 100) * (SELECT sueldo
									FROM empleados
									WHERE idEmp = @idEmp))
END
GO
PRINT dbo.fn_irpf_v2(1)

-- 7. Funcion que devuelva los articulos que empiecen
-- por 'me'

CREATE FUNCTION fn_articulosme()
RETURNS TABLE
AS
	RETURN (SELECT nombre
			FROM articulos
			WHERE nombre LIKE 'me%')
SELECT * FROM fn_articulosme()

GO
CREATE FUNCTION fn_artMeV2()	-- solo nos da las dos primeras letras del nombre
RETURNS TABLE
AS
RETURN (SELECT *
		FROM articulos
		WHERE SUBSTRING(nombre,1,2) LIKE 'me%')
	GO

	SELECT * FROM dbo.fn_artMeV2

-- 8. Funci�n que devuelva el art�culo m�s barato. Sacar c�digo del
--art�culo, nombre y precio. En caso de empate, sacar todos.

GO
CREATE FUNCTION fn_articuloBarato()
RETURNS TABLE
AS
	RETURN (SELECT TOP 1 WITH TIES idArt, nombre, ppu as 'precio'
			FROM articulos 
			ORDER BY ppu);
GO
	SELECT * FROM dbo.fn_articuloBarato()

-- 9. Funcion que nos muestre el nombre y las unidades
-- del articulo m�s vendido  

CREATE FUNCTION fn_masVendido()
RETURNS TABLE
AS
	RETURN (SELECT nombre, suma AS 'unidades totales vendidas'
			FROM articulos INNER JOIN (SELECT TOP 1 WITH TIES idArt, SUM(unidades) AS suma
										FROM ventas
										GROUP BY idArt
										ORDER BY 2 desc) AS T1
							ON articulos.idArt = T1.idArt);
GO

SELECT * FROM fn_masVendido()

CREATE FUNCTION fn_masVendido_v2()
RETURNS TABLE
AS
	RETURN (SELECT nombre, SUM(unidades) AS unidadesVendidas
			FROM ventas INNER JOIN (SELECT *
										FROM articulos) AS T1
							ON ventas.idArt = T1.idArt
							GROUP BY T1.nombre)
GO

SELECT * FROM fn_masVendido_v2()

-- 10. Funcion que calcule las ventas totales que han
-- realizado todos los empleados

-- funcionando!

GO
CREATE FUNCTION fn_ventasTotales()
RETURNS INT
AS
BEGIN
DECLARE @ventasTotales INT
SET @ventasTotales = (SELECT SUM(acumuladoVentas)
						FROM empleados)
		RETURN @ventasTotales
END
GO
PRINT dbo.fn_ventasTotales()



--HACER V2 (recalculando el acumulado ventas) para el viernes!!

USE depempprueba
GO
CREATE FUNCTION fAcumEmple()
returns TABLE
AS
	return(select idEmp, SUM(unidadesVendidas*ppu) as acumuladoVentas
						from articulos  inner join(select idEmp, idArt,	SUM(unidades) as unidadesVendidas
												from ventas
												group by idArt, idEmp)as t1
												on articulos.idArt = t1.idArt
			GROUP BY t1.idEmp)
GO

select * FROM dbo.fAcumEmple()


-- 11. Funci�n que nos saque el n�mero total de unidades pedidas de
-- la pieza que le pasemos como par�metro (c�digo de la pieza).
-- fUnidadesPedidasDe --> int

-- funcionando!!
CREATE FUNCTION fn_unidadesPedidas(@codPieza INT)
RETURNS INT
AS
BEGIN
DECLARE @unidadesPedidas INT
SET @unidadesPedidas = (SELECT SUM(unidades)
						FROM ventas
						WHERE idArt = @codPieza)
			RETURN @unidadesPedidas
END
GO
PRINT dbo.fn_unidadesPedidas(1)

-- 12. Igual que el ejercicio 10, pero ahora le pasamos como par�metro el nombre de 
-- la pieza. ??????????


GO
CREATE FUNCTION fn_unidadesPedidasNombre(@nomPieza VARCHAR(45))
RETURNS INT
AS
BEGIN
	DECLARE @total INT;
	SELECT @total = SUM(cantidad)
	FROM datos_SPJ INNER JOIN (SELECT *
							FROM datos_p
							WHERE NOMBRE = @nomPieza) AS T1
						ON T1.IdP = Datos_SPJ.IdP
RETURN @total
END
GO

PRINT dbo.fn_unidadesPedidasNombre('Impresora')