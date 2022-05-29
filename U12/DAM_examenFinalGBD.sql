-- ejercicio 1

GO
CREATE FUNCTION fn_calculaCosteMesSueldos()
RETURNS INT
AS BEGIN
    DECLARE @media INT = (SELECT SUM(sueldo)
                            FROM empleados)
    RETURN @media
END
GO
PRINT dbo.fn_calculaCosteMesSueldos()

-- ejercicio 2

GO
ALTER FUNCTION fn_costeArticulosAlmacen()
RETURNS INT
AS BEGIN
    DECLARE @total INT = (SELECT SUM(ppu*stock)
                                    FROM articulos
                                    WHERE stock >= 1)
    RETURN @total
END
GO
PRINT dbo.fn_costeArticulosAlmacen()

-- ejercicio 3

ALTER TABLE empleados
ADD long_nombre VARCHAR(20)

GO
ALTER PROCEDURE pr_actualizaLongitudNombre @e INT
AS BEGIN
    DECLARE @longitudNombre INT = (SELECT LEN(nombre)
                                    FROM empleados
                                    WHERE idEmp = @e)
    IF @longitudNombre < 3
        BEGIN
        UPDATE empleados
        SET long_nombre = 'menor'
        WHERE idEmp = @e
    END

    IF @longitudNombre > 8
        BEGIN
        UPDATE empleados
        SET long_nombre = 'mayor'
        WHERE idEmp = @e
    END

    ELSE
        BEGIN
        UPDATE empleados
        SET long_nombre = 'en_rango'
        WHERE idEmp = @e
    END
END
GO
EXEC pr_actualizaLongitudNombre 2

-- ejercicio 4

CREATE TABLE hist_articulos (
    codArt INT,
    codRef INT,
    precio INT
)

GO
CREATE TRIGGER tr_historicoPrecios
ON articulos
INSTEAD OF UPDATE 
AS BEGIN
    IF (SELECT COUNT(*)
        FROM inserted) = 1
        BEGIN
    
        DECLARE @a INT, @r INT, @p INT
        SELECT @a = codArt, @r = codRef, @p = ppu
        FROM deleted

        INSERT INTO hist_articulos VALUES(@a, @r, @p)
    END
END
GO

-- ejercicio 5

-- no lo hemos dado¿

-- ejercicio 6

GO
CREATE TRIGGER tr_ventas 
ON ventas
INSTEAD OF INSERT
AS BEGIN
    IF (SELECT COUNT(*)
        FROM inserted) = 1
        BEGIN

        DECLARE @e INT, @a INT, @u INT
        SELECT @e = idEmp, @a = idArt, @u = unidades
        FROM inserted

        IF (SELECT stock
            FROM articulos
            WHERE idArt = @a) >= @u
            
            AND (SELECT stock
                FROM articulos
                WHERE idArt = @a) > (SELECT stockMinimo
                                    FROM articulos
                                    WHERE idArt = @a)

            BEGIN
            INSERT INTO ventas VALUES(@e, @a, getdate(), @u)
            
            UPDATE articulos
            SET stock = stock - @u

            IF (SELECT stock
                FROM articulos
                WHERE idArt = @a) < (SELECT unidadesPedir
                                    FROM articulos
                                    WHERE idArt = @a)
                BEGIN

                IF NOT EXISTS (SELECT *
                                FROM pedidoProveedores
                                WHERE fechaEntrada IS NULL
                                AND idArt = @a)
                    BEGIN

                    DECLARE @p INT, @c INT, @n VARCHAR(20)
                    SELECT @p = idPro, @c = unidadesPedir, @n = nombre
                    FROM articulos
                    WHERE idArt = @a

                    INSERT INTO pedidoProveedores
                    VALUES(@p, @a, @c, getdate(), NULL, @n)

                    END
                END
            END
        END
    END
GO



                

