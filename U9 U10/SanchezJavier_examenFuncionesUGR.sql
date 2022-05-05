

--						EXAMEN TRANSACT-SQL - 08/04/2022


-- 1. (2 puntos) Dise�a una funcion que calcule cuantos numeros impares
-- hay desde 0 hasta un numero entero que se pase como parametro de entrada. 
-- Muestra un ejemplo que como usarias la funcion.

GO
ALTER FUNCTION fn_impares(@n INT)
RETURNS INT
AS
	BEGIN
		DECLARE @iteracion INT = 0
		DECLARE @contador INT = 0
		WHILE (@iteracion <= @n)
			BEGIN
				IF (@iteracion % 2 = 1)
					BEGIN
						SET @contador = @contador + 1
					END
				SET @iteracion = @iteracion + 1
			END
		RETURN @contador
	END
GO
PRINT dbo.fn_impares(-5)

-- 1.2. Idem, pero le paso dos numeros 

GO
CREATE FUNCTION fn_impares_v2(@x INT, @y INT)
RETURNS INT
AS
	BEGIN
		DECLARE @contadorImpares INT = @x
		DECLARE @salida INT = 0
		WHILE (@contadorImpares <= @y)
			BEGIN
				IF (@contadorImpares % 2 = 1)
					BEGIN
						SET @salida = @salida + 1
					END
				SET @contadorImpares = @contadorImpares + 1
			END
		RETURN @salida
	END
GO
PRINT dbo.fn_impares_v2(40, 70)

-- 2. (1 puntos) Dise�a una funcion que devuelva el nombre y el IVA (del precio) 
-- de todos los articulos.
-- Muestra un ejemplo que como usarias la funcion.

GO
CREATE FUNCTION fn_nombreIVA(@iva FLOAT)
RETURNS TABLE
AS
	RETURN (SELECT nombre, (ppu*@iva/100) AS IVA
			FROM articulos)
GO
SELECT * FROM dbo.fn_nombreIVA(21)

--2.2. Idem, pero sacar nombre, ppu (es sin iva), iva, y precio con iva

GO
ALTER FUNCTION fn_nombreIVA_v2(@iva FLOAT)
RETURNS TABLE
AS
	RETURN (SELECT nombre, ppu AS 'Precio (sin IVA)', (ppu*@iva/100) AS IVA, ppu+(ppu*@iva/100) AS 'Precio (con IVA)'
			FROM articulos)
GO
SELECT * FROM dbo.fn_nombreIVA_v2(21)

-- 3. (3 puntos) Dise�a una funcion que devuelva el numero total de 
-- unidades vendidas de un articulo determinado. Mostrar tambien el id y 
-- el nombre del articulo. Usar el nombre del articulo, no el id. 
-- Muestra un ejemplo que como usarias la funcion.

GO
ALTER FUNCTION fn_ventasTotales(@nombreArticulo VARCHAR(50))
RETURNS TABLE
AS
	RETURN (SELECT art.idArt, nombre, ventasTotales
			FROM articulos art INNER JOIN (SELECT idArt, SUM(unidades) AS ventasTotales
										FROM ventas
										GROUP BY idArt) AS T1
								ON art.idArt = T1.idArt
					WHERE nombre = @nombreArticulo)
GO
SELECT * FROM dbo.fn_ventasTotales('silla')

--3.2. IDEM sin inner join

GO
CREATE FUNCTION fn_totalVendidasV2(@nombre VARCHAR(20))
RETURNS TABLE
AS
	RETURN (SELECT idArt, @nombre, COUNT(*)
			FROM ventas
			WHERE idArt = (SELECT idArt
							FROM articulos
							WHERE nombre = @nombre))
GO

SELECT * FROM dbo.fn_totalVendidasV2('mesa')

-- 4. (3 puntos) Dise�a una funcion de tipo tabla que calcule cual es el empleado que menos
-- ventas totales ha realizado. Devolver el id del empleado y las ventas totales realizadas
-- Muestra un ejemplo que como usarias la funcion.

GO
CREATE FUNCTION fn_menosVentas()
RETURNS TABLE
AS
	RETURN (SELECT TOP 1 WITH TIES idEmp, COUNT(*) AS ventasTotales
			FROM ventas 
			GROUP BY idEmp
			ORDER BY ventasTotales)
GO

SELECT * FROM dbo.fn_menosVentas()

--4.2. Qué empleado ha realizado menor numero de ventas. Se parece.

GO
ALTER FUNCTION fn_menosVentas_v2()
RETURNS TABLE
AS
	RETURN (SELECT TOP 1 idEmp, SUM(unidades*ppu) AS ventasTotales
			FROM ventas v INNER JOIN articulos a
							ON v.idArt = a.idArt
			GROUP BY idEmp
			ORDER BY ventasTotales)
			
GO
SELECT * FROM dbo.fn_menosVentas_v2()

-- 5. (1 punto) Dise�a una funcion que devuelva el id, nombre y precio 
-- de los articulos de los que queden menos unidades de las indicadas.

GO
CREATE FUNCTION fn_menosUnidades_v2(@n INT)
RETURNS TABLE
AS
	RETURN (SELECT idArt, nombre, ppu
			FROM articulos
			WHERE existencias < @n )
GO
SELECT * FROM dbo.fn_menosUnidades_v2(40)

--5.2. Idem, que saque articulos que tengan menos existencias

GO
CREATE FUNCTION fn_menosUnidades()
RETURNS TABLE
AS
	RETURN (SELECT idArt, nombre, ppu
			FROM articulos
			WHERE existencias = (SELECT MIN(existencias)
									FROM articulos))
GO
SELECT * FROM dbo.fn_menosUnidades()