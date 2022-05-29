    -- ESTRUCTURA DE UN TRIGGER

--CREATE TRIGGER
--ON --tabla
--AFTER / INSTEAD OF -- INSERT, UPDATE y DELETE
--AS
--BEGIN
--END

    -- Ejemplo: Crar un trigger / nunca se borren articulos de Granada

-- aqui no se borrara ningun articulo, sino que se podra ejecutar la sentencia ROLLBACK
--DELETE FROM articulos
--WHERE ppu < 100

--OR
--WHERE nombre LIKE 's%'
--OR
--WHERE idPro = 5


    -- Solucion con Instead Of

GO
CREATE TRIGGER tr_borrarArticulos
ON articulos
INSTEAD OF DELETE 
AS
BEGIN
    -- tengo que ir uno a uno en la tabla DELETED para saber si se puede borrar ese articulo o no!
    -- si tengo algo borrado que no quiero, rollback
    -- y esto se puede hacer utilizando un CURSOR(Proximamente)
END


-- Veamos otro ejemplo mas facil / no necesito ningun cursor

INSERT INTO proveedores
VALUES ()

GO
ALTER TRIGGER tr_insertarUnProveedor
ON proveedores
INSTEAD OF INSERT
AS
BEGIN
    -- restriccion: condicion de la empresa
    -- lo normal sera ver si esta ya ese proveedor,
    -- ademas de asegurarnos que solo se quiere insertar un unico proveedor y no varios
    IF (SELECT COUNT(*) FROM INSERTED) = 1
    BEGIN
        DECLARE @codigo INT 
        SET @codigo = (SELECT idPro FROM inserted)
        IF NOT EXISTS (SELECT idPro FROM proveedores WHERE idPro = @codigo)
        BEGIN
            DECLARE @nom VARCHAR(20)
            DECLARE @ciu VARCHAR(20)
            SELECT @nom = nombre, @ciu = ciudad
            FROM inserted
            INSERT INTO proveedores 
            VALUES (@codigo, @nom, @ciu)
        END
    END
END

SELECT *
FROM proveedores

INSERT INTO proveedores 
VALUES (5, 'jose', 'madrid')