
-- Ejercicios PROCEDIMIENTOS


-- 1. Procedimiento que saque por pantalla la sumatoria desde
-- 0 hasta un valor que se la pasa como parametro de entrada 

GO
CREATE PROCEDURE pr_sumatoriaNumero @n INT 
AS
    DECLARE @resultado INT = 0
    DECLARE @contador INT = 0
    WHILE @n >= @contador
        BEGIN
            SET @resultado = @resultado + @contador
            SET @contador = @contador + 1
        END
    PRINT @resultado
GO
EXEC pr_sumatoriaNumero 8

-- 2. Incrementar el sueldo de todos los empleados un 5%

GO
CREATE PROCEDURE pr_subirSueldo
AS
    BEGIN
        UPDATE empleados
        SET sueldo = sueldo * 1.05
    END
GO
EXEC pr_subirSueldo


-- 3. Incrementar en un 5% el sueldo de un determinado empleado

GO
CREATE PROCEDURE pr_subirSueldoV2 @nombre VARCHAR(20)
AS
    BEGIN
        UPDATE empleados
        SET sueldo = sueldo * 1.05
        WHERE @nombre = nombre
    END
GO
EXEC pr_subirSueldoV2 'pepe'


-- 4. Incrementar en un x% el sueldo de un determinado empleado

GO
ALTER PROCEDURE pr_subirSueldoV3 @nombre VARCHAR(20), 
                                    @aumento FLOAT
AS
    BEGIN
        UPDATE empleados
        SET sueldo = sueldo * (1+(@aumento/100))
        WHERE nombre = @nombre
    END
GO
EXEC pr_subirSueldoV3 'luis', 100

-- 5. Incrementar la fecha de alta de un determinado empleado 
-- en tres meses 

-- tambien podemos pasarle como parametro de entrada el id del empleado

SELECT * 
FROM empleados

GO
ALTER PROCEDURE pr_fechaAlta @nombre VARCHAR(20)
AS
    BEGIN
        UPDATE empleados
        SET feAlta = DATEADD(month, 3, feAlta) 
        WHERE nombre = @nombre 
    END
GO

EXEC pr_fechaAlta 'pepe'

-- 6. Procedimiento que actualice el total de ventas de
-- cada empleado (todos los empleados)

SELECT * 
FROM empleados 

GO
CREATE PROCEDURE pr_ventasEmpleado
AS
    BEGIN
        SELECT idEmp, SUM(unidades) AS ventasTotales
        FROM ventas
        GROUP by idEmp
    END
GO

EXEC pr_ventasEmpleado

-- 6.2. actualizar el atributo acumuladoVentas del empleado que pasemos por parametro ..
-- ejemplo: exec pr_actualizarVentasEmpleado 2

GO
CREATE PROCEDURE pr_actualizarVentasEmpleado @codigoEmpleado INT
AS
BEGIN
    UPDATE
END
GO 

-- 6.3. Vamos a hacer el ejercicio 6 utilizando CURSOR



-- 7. Procedimiento  que añada  datos a la columna "antigüedad" de la tabla
-- EMPLEADOS con el tiempo (en años) que llevan trabajando
-- los empleados para la empresa.

ALTER TABLE empleados
ADD antiguedad INT

GO
ALTER PROCEDURE pr_antiguedadEmpleados @idEmp INT
AS 
BEGIN
    UPDATE empleados
    SET antiguedad = DATEDIFF(day, feAlta, GETDATE())/365
    WHERE idEmp = @idEmp
    END
GO
EXEC pr_antiguedadEmpleados 10

SELECT *
FROM empleados

INSERT INTO empleados 
VALUES (10, 'luis', 'perez', '2017-05-23', 2500, 4000, 3, NULL, NULL)
	

-- 8. Procedimiento que complete la columna "stock" de la tabla
-- ARTICULOS con el stock disponible.
-- (Para ello hay que modificar previamente la tabla ARTICULOS 
-- añadiendo la columna "Stock")

ALTER TABLE articulos
ADD stock INT;

SELECT *
FROM articulos

GO
CREATE PROCEDURE pr_columnaStock
AS
    BEGIN
        UPDATE articulos
        SET stock = existencias
    END
GO
EXEC pr_columnaStock

-- 8 3/4: procedimiento para añadir existencias de los articulos del 1 al 7 (de uno en uno) indicando como parametro las existencias de cada uno
-- el stock min. va a ser el 10% de dichas existencias

SELECT *
FROM articulos

GO
ALTER PROCEDURE pr_addExistencias @idArti INT, @existencias INT
AS
BEGIN
    UPDATE articulos
    SET existencias = @existencias, stock = existencias/10   
    WHERE idArt = @idArti
END
GO

EXEC pr_addExistencias 1, 45

-- 9. Procedimiento que inserte nuevos articulos en la tabla ARTICULOS 

GO
CREATE PROCEDURE pr_nuevosArticulos @idArt INT, @nombre VARCHAR(20), @existencias INT, @ppu INT, @idPro INT
AS
    BEGIN
        INSERT INTO articulos VALUES (@idArt, @nombre, @existencias, @ppu, @idPro)
    END
GO
EXEC pr_nuevosArticulos 30, 'escalera', 30, 800.00, 20


-- 10. Procedimiento que borre el artículo que se le indique 

GO
CREATE PROCEDURE pr_borrarArticulo @nombre VARCHAR(20)
AS
    BEGIN
        DELETE FROM articulos
        WHERE nombre = @nombre
    END
GO
EXEC pr_borrarArticulo 'producto'

-- 11. Procedimiento que inserte un empleado

GO
CREATE PROCEDURE pr_insertarEmpleado @idEmp INT, @nombre VARCHAR(20), @apellido VARCHAR(20), @feAlta DATE, @sueldo FLOAT, @acumuladoVentas INT, @idDep INT
AS
    BEGIN
        INSERT INTO empleados 
        VALUES (@idEmp, @nombre, @apellido, @feAlta, @sueldo, @acumuladoVentas, @idDep)
    END
GO
EXEC pr_insertarEmpleado 40, 'Javier', 'Sanchez', '20210515', 3000, 400, 24

-- 12. Procedimiento que inserte una venta

GO
CREATE PROCEDURE pr_insertarVenta @idEmp INT, @idArt INT, @fecha DATE, @unidades INT
AS
    BEGIN
        INSERT INTO ventas VALUES (@idEmp, @idArt, @fecha, @unidades)
    END
GO
EXEC pr_insertarVenta 8, 7, '2021-05-15', 50  -- ??????

-- 13. Procedimiento que inserte la fecha de nacimiento de cada 
-- empleado.
-- (Para ello hay que modificar la tabla EMPLEADOS añadiendo
-- una nueva columna que se llame fecha de nacimiento)


ALTER TABLE empleados
ADD fecha_nacimiento DATE;

GO
CREATE PROCEDURE pr_insertarNacimiento @fecnac DATE, @nombre VARCHAR(20)
AS
    BEGIN
        UPDATE empleados
        SET fecha_nacimiento = @fecnac
        WHERE nombre = @nombre
    END
GO
EXEC pr_insertarNacimiento '1978-09-24', 'pepe'

-- 14. Bajar el precio de los articulos que no se hayan vendido
-- en los ultimos tres meses (en los últimos 5 meses se han 
-- vendido sólo dos!) en un porcentaje que reciba como parametro

SELECT *
FROM articulos

SELECT *
FROM ventas

GO
CREATE PROCEDURE pr_PrecioArticulosSinVender @rebaja INT
AS
    BEGIN
        UPDATE articulos
        SET ppu = ppu*((100-@rebaja)/100)
        WHERE DATEDIFF(month, (SELECT MAX(fecha) FROM ventas), GETDATE()) = 3 


        
-- 15. Procedimiento que actualice el total de ventas de                    MIRAR BIEN
-- cada empleado que pase como parámetro de entrada

-- idEmp del empleado
GO
CREATE PROCEDURE pr_totalVentas @idEmp INT
AS
    BEGIN
        SELECT idEmp, SUM(unidades) AS totalVentas
        FROM ventas
        WHERE idEmp = @idEmp 
        GROUP BY idEmp
    END
GO 
EXEC pr_totalVentas 1

-- nombre
GO
CREATE PROCEDURE pr_totalVentasV2 @nombre VARCHAR(50)
AS
    BEGIN
        SELECT empleados.nombre, ventas.idEmp, SUM(unidades) AS totalVentas
        FROM ventas INNER JOIN empleados
        ON ventas.idEmp = empleados.idEmp
        WHERE nombre = @nombre 
        GROUP BY empleados.nombre, ventas.idEmp
    END
GO 
EXEC pr_totalVentasV2 'pepe'

-- Ej 15.2: Sacar la cantidad o número de unidades vendidas de un
-- determinado artículo, que se le pasa como parámetro...
--(es más fácil! )

GO
CREATE PROCEDURE pr_unidadesVendidasV3 @articulo VARCHAR(50)
AS
    BEGIN
        SELECT SUM(unidades) AS totalVentas
        FROM ventas INNER JOIN articulos
        ON nombre = @articulo
    END
GO
EXEC pr_unidadesVendidasV3 'mesilla'

-- 16. Funcion/Procedimiento ?? que devuelva el nº de vocales de una cadena. 

GO
CREATE FUNCTION pr_numeroVocales (@texto VARCHAR(50))
RETURNS INT
AS
    BEGIN
        DECLARE @cont INT = 1
        DECLARE @contVocales INT = 0
        WHILE @cont <= LEN(@texto)
            BEGIN
                IF SUBSTRING(@texto, @cont, 1) IN ('a', 'e', 'i', 'o', 'u', 'A', 'E', 'I', 'O', 'U')
                SET @contVocales = @contVocales + 1
                SET @cont = @cont + 1
            END
        RETURN @contVocales 
    END
GO

--16.2. idem, pero conventirlo a procedimiento



-- 17. Funcion/Procedimiento ?? que devuelva la longitud de dicha cadena.

-- procedimiento
GO
CREATE PROCEDURE pr_longitudCadena @texto VARCHAR(60)
AS
    BEGIN
        PRINT LEN(@text)
    END
GO
EXEC pr_longitudCadena 'Hello, World!'

--funcion
GO
CREATE FUNCTION fn_longitudCadena (@texto VARCHAR(60))
RETURNS INT
AS
    BEGIN
    RETURN LEN(@texto)
    END
GO
PRINT dbo.fn_longitudCadena('Hello, World!')


-- 18. Funcion/Procedimiento ?? que pase todas las vocales de una 
-- cadena a mayÚscula y lo muestre por pantalla (PROCEDURE).

GO
CREATE PROCEDURE pr_minusculaMAYUSCULA @texto VARCHAR(50)
AS
    BEGIN

    END
GO

-- 19. procedimiento/funcion que nos de la letra de nuestro dni

-- 0 1 2 3 4 5 6 7 8 9 10 11
-- T R W A G M Y F P D X  B
-- --------------------------------
-- 12 13 14 15 16 17 18 19 20 21 22
-- N  J  Z  S  Q  V  H  L  C  K  E

GO
ALTER FUNCTION fn_letraDNI (@numero INT)
RETURNS VARCHAR(1)
AS
BEGIN
    DECLARE @restoDivision INT = @numero % 23
    RETURN SUBSTRING('TRWAGMYFPDXBNJZSQVHLCKE', @restoDivision+1, 1)
    END
GO
PRINT dbo.fn_letraDNI (26303328)

--19.2. funcion que convierta los 8 numeros del dni en el dni completo

GO
CREATE FUNCTION fn_letraDNIV2 (@numero INT)
RETURNS VARCHAR(9)
AS
BEGIN
    DECLARE @restoDivision INT = @numero % 23
    DECLARE @letraDNI VARCHAR(1) = SUBSTRING('TRWAGMYFPDXBNJZSQVHLCKE', @restoDivision+1, 1)
    RETURN CAST(@numero AS VARCHAR(8)) + @letraDNI
    END
GO
PRINT dbo.fn_letraDNIV2 (26303328)

--19.3. idem que el 19.2, pero con procedimiento

GO
ALTER PROCEDURE pr_letraDNIV3 @numero INT, @dniCompleto VARCHAR(9) OUTPUT
AS
BEGIN
    DECLARE @restoDivision INT = @numero % 23
    DECLARE @letraDNI VARCHAR(1) = SUBSTRING('TRWAGMYFPDXBNJZSQVHLCKE', @restoDivision+1, 1)
    SET @dniCompleto = CAST(@numero AS VARCHAR(8)) + @letraDNI
    RETURN @dniCompleto
    END
GO

DECLARE @dni VARCHAR(9)
EXEC pr_letraDNIV3 25320785, @dni OUTPUT
PRINT @dni


-- solucion: hay que utilizar variable de salida

-- 20. PROCEDIMIENTO QUE CALCULA LA RAIZ CUADRADA EN UN PARAMETRO DE SALIDA

GO
CREATE PROCEDURE pr_raizCuadrada @entrada FLOAT, @salida FLOAT OUTPUT
AS
BEGIN
    SET @salida = SQRT(@entrada)
END 
GO

DECLARE @raizCuadradaDe FLOAT 
EXEC pr_raizCuadrada 25, @raizCuadradaDe OUTPUT
PRINT @raizCuadradaDe

-- con funcion (MUCHO mas facil)
GO
CREATE FUNCTION fn_raizCuadrada (@numero FLOAT)
RETURNS FLOAT
AS BEGIN
    RETURN SQRT(@numero)
END
GO

PRINT dbo.fn_raizCuadrada (25)

-- examen

-- caen procedimientos con varios valores
-- procedimientos con update, insert y deletes
-- puede pedir cualquier funcion como procedimiento y a la inversa
-- 