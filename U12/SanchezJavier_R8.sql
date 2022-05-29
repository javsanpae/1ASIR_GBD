-- RELACION 8 SQL: TRIGGERS Y CURSORES

/*
Crear las tablas:
historicoEmpleados(nombre, direccion, telefono, fechaBaja)
historicoArticulos()
historicoDepartamentos()
historicoProveedores()
para que quiero historicoVentas? no quiero borrar ninguna venta!
en todo caso un trigger para que no se pueda borrar ninguna venta
*/

-- en general para cualquier alta el disparador comprobara que no este ya dado de alta mediante el identificador.


-- 1. Crear una serie de tablas historicas donde se van a guardar todos los elementos
-- que borre en mi base de datos. 

CREATE TABLE empleadosHistorico (
    nombre VARCHAR(10),
    direccion VARCHAR(100),
    telefono INT,
    fechaBaja DATE,
)

CREATE TABLE articulosHistorico (
    nombre VARCHAR(10),
    ppu INT,
)

CREATE TABLE departamentosHistorico (
    ciudad VARCHAR(10)
)

CREATE TABLE proveedoresHistorico (
    nombre VARCHAR(10),
    ciudad VARCHAR(10),
    telefono INT,
    fechaBaja DATE,
)


-- 2. Dar de alta un empleado      

-- comprobaremos que el id no existe y que el departamento tambien existe

GO
ALTER TRIGGER tr_altaEmpleado
ON empleados
INSTEAD OF INSERT
AS BEGIN
IF (SELECT COUNT(*)
    FROM inserted) = 1
    BEGIN
        DECLARE @idEmp INT = (SELECT idEmp FROM inserted)
        DECLARE @idDep INT = (SELECT idDep FROM inserted)
        IF NOT EXISTS (SELECT idEmp FROM empleados WHERE idEmp = @idEmp)
            AND EXISTS (SELECT * FROM departamentos WHERE idDep = @idDep)
        BEGIN

            DECLARE @nombre VARCHAR(10), @apellido VARCHAR(10), @sueldo INT, @fecha_nacimiento DATE 
                
            SELECT @nombre = nombre, @apellido = apellido, @sueldo = sueldo, @fecha_nacimiento = fecha_nacimiento
            FROM inserted
                
            INSERT INTO empleados(idEmp, nombre, apellido, feAlta, sueldo, fecha_nacimiento) 
            VALUES(@idEmp, @nombre, @apellido, getdate(), @sueldo, @fecha_nacimiento)
            END
        END
    END
GO   

-- 3. Dar de baja un empleado       
-- comprobar que el empleado existe
GO
ALTER TRIGGER tr_bajaEmpleado
ON empleados
INSTEAD OF DELETE
AS BEGIN
    SET NOCOUNT ON
    IF (SELECT COUNT(*)
        FROM deleted) = 1
        BEGIN
            DECLARE @e INT
            IF EXISTS (SELECT *
                        FROM empleados
                        WHERE idEmp = @e)
                BEGIN
                DECLARE @n VARCHAR(10) = (SELECT nombre FROM deleted)
                DELETE FROM empleados WHERE idEmp = @e
                INSERT INTO empleadosHistorico(nombre, fechaBaja) VALUES(@n, getdate())
        END
    END
GO

-- 4. Dar de alta un articulo       
-- comprobar que el id de articulo no existe (o el nombre)
GO
ALTER TRIGGER tr_altaArticulo 
ON articulos
INSTEAD OF INSERT
AS BEGIN
    IF (SELECT COUNT(*)
        FROM inserted) = 1
        BEGIN
            DECLARE @idArt INT = (SELECT idArt FROM inserted)
            IF NOT EXISTS (SELECT idArt FROM articulos WHERE idArt = @idArt)
            BEGIN
                DECLARE @nombre VARCHAR(10), @ppu INT, @idPro INT, @unidadesPedir INT

                SELECT @nombre = nombre, @ppu = ppu, @idPro = idPro, @unidadesPedir = unidadesPedir
                FROM inserted

                INSERT INTO articulos(idArt, nombre, ppu, idPro, unidadesPedir) 
                VALUES(@idArt, @nombre, @ppu, @idPro, @unidadesPedir)

            END
        END
    END
GO 

-- 5. Dar de baja un articulo      
-- comprobar que el articulo no esta pendiente de llegar
GO
ALTER TRIGGER tr_bajaArticulo
ON articulos
INSTEAD OF DELETE
AS BEGIN
SET NOCOUNT ON -- para que solo muestre una vez el mensaje de tabla afectada
    IF (SELECT COUNT(*)
        FROM deleted) = 1
        BEGIN
        DECLARE @a INT = (SELECT idArt 
                            FROM deleted)

        -- comprobamos que el articulo no esta pendiente de llegar
        IF NOT EXISTS (SELECT idArt 
                        FROM pedidoProveedores 
                        WHERE idArt = @a)

            BEGIN
            DECLARE @n VARCHAR(10), @p INT, @np VARCHAR(10), @c VARCHAR(10)
            
            -- guardar los datos necesarios del articulo para insertar en el historico de articulos
            SELECT @n = nombre, @p = ppu 
            FROM deleted

            -- insertaremos tambien el nombre y la ciudad del proveedor que provee este articulo por si es necesario.
            SELECT @np = p.nombre, @c = p.ciudad
            FROM proveedores p INNER JOIN articulos a
            ON a.idPro = p.idPro 
            WHERE a.idArt = @a

            -- borramos los datos de la tabla articulos
            DELETE FROM articulos 
            WHERE idArt = @a

            -- insertamos todos los datos que hemos guardado en la tabla articulosHistorico.
            INSERT INTO articulosHistorico
            VALUES(@n, @p, @np, @c)
        END
    END
END
GO

-- 6. Dar de alta un departamento   
-- comprobar que el id de departamento no existe

GO
ALTER TRIGGER tr_altaDepartamento
ON departamentos
INSTEAD OF INSERT
AS BEGIN
    IF (SELECT COUNT(*)
        FROM inserted) = 1
        BEGIN

            DECLARE @idDep INT = (SELECT idDep FROM inserted)

            IF NOT EXISTS (SELECT idDep FROM departamentos WHERE idDep = @idDep)
            BEGIN

                DECLARE @ciudad VARCHAR(10), @objetivoAnual INT

                SELECT @ciudad = ciudad, @objetivoAnual = objetivoAnual
                FROM inserted

                INSERT INTO departamentos VALUES(@idDep, @ciudad, @objetivoAnual)
                
            END
        END
    END
GO    

-- 7. Dar de baja un departamento   
-- comprobar que el departamento existe
GO
CREATE TRIGGER tr_bajaDepartamento
ON departamentos
INSTEAD OF DELETE
AS BEGIN
    SET NOCOUNT ON
    IF (SELECT COUNT(*)
        FROM deleted) = 1
        BEGIN
            DECLARE @d INT = (SELECT idDep FROM deleted)
            IF EXISTS (SELECT *
                        FROM departamentos
                        WHERE idDep = @d)
                BEGIN   
                DECLARE @c VARCHAR(10) = (SELECT ciudad FROM deleted)
                INSERT INTO departamentosHistorico VALUES(@c)
            END
        END
    END
GO

-- 8. Dar de alta un proveedor     
-- comprobar que el idpro no esta usado

GO
CREATE TRIGGER tr_altaProveedor
ON proveedores
INSTEAD OF INSERT
AS BEGIN
    IF (SELECT COUNT(*)
        FROM inserted) = 1
        BEGIN
            DECLARE @idPro INT = (SELECT idPro FROM inserted)
            IF NOT EXISTS (SELECT idPro FROM proveedores WHERE idPro = @idPro)
            BEGIN
                DECLARE @nombre VARCHAR(10), @ciudad VARCHAR(10)
                SELECT @nombre = nombre, @ciudad = ciudad 
                FROM inserted
                INSERT INTO proveedores VALUES(@idPro, @nombre, @ciudad)
            END
        END
    END
GO


-- 9. Dar de baja un proveedor      

-- una solucion mas completa seria comprobar TAMBIEN que ese proveedor no 
-- tiene pendiente traer un pedido

GO
CREATE TRIGGER tr_borrarProveedor
ON proveedores
INSTEAD OF DELETE
AS BEGIN
    IF (SELECT COUNT(*)
        FROM deleted) = 1
        BEGIN
        DECLARE @p INT = (SELECT idPro
                            FROM proveedores)
        IF EXISTS (SELECT *
                    FROM proveedores
                    WHERE idPro = @p)
            AND NOT EXISTS (SELECT *
                            FROM pedidoProveedores
                            WHERE idPro = @d)
                BEGIN
                DECLARE @n VARCHAR(10), @c VARCHAR(10)
                SELECT @n = nombre, @c = ciudad
                FROM deleted
                -- insertar en el historico los datos que tenemos
                INSERT INTO proveedoresHistorico
                VALUES(@p, @n, @c)
                -- finalmente borramos los datos de la tabla proveedores
                DELETE FROM proveedores
                WHERE idPro = @p
            END
        END
    END
GO


-- 10. hacer una venta: insertar en VENTAS, actualizar en ARTICULOS y quizas hacer un pedido a proveedores
-- cuando las existencias queden por debajo del stock minimo

-- habra que crear la tabla pedidoProveedores(idArt, idPro, cantidad, fechaPedido)

CREATE TABLE pedidoProveedores(
    idPro INT,
    idArt INT,
    cantidad INT,
    fechaPedido DATE,
    fechaEntrada DATE DEFAULT NULL,
    nombre VARCHAR(20)        
)

GO
CREATE TRIGGER tr_insertarVenta
ON ventas
INSTEAD OF INSERT
AS BEGIN
    IF (SELECT COUNT(*)
        FROM inserted) = 1
        BEGIN
        DECLARE @e INT, @a INT, @u INT
        SELECT @e = idEmp, @a = idArt, @u = unidades
        FROM inserted
        IF @e IN (SELECT idEmp FROM empleados)
            AND @a IN (SELECT idArt FROM articulos)
                AND @u <= (SELECT existencias FROM articulos WHERE idArt = @a)
                BEGIN
                INSERT INTO ventas VALUES(@e, @a, getdate(), @u)
                UPDATE articulos
                SET existencias = existencias - @u
                IF (SELECT stock
                    FROM articulos WHERE idArt = @a) > (SELECT existencias FROM articulos WHERE idArt = @a)
                    BEGIN
                    DECLARE @p INT = (SELECT idPro FROM articulos WHERE idArt = @a)
                    DECLARE @up INT = (SELECT unidadesPedir FROM articulos WHERE idArt = @a)

                    -- Comprobar que el pedido que vamos a hacer no se ha repetido.
                    IF NOT EXISTS (SELECT *
                                    FROM pedidoProveedores
                                    WHERE idArt = @a 
                                    AND fechaEntrada IS NULL)     


                    INSERT INTO pedidoProveedores
                    VALUES(@p, @a, @up, getdate())
                END
            END
        END
    END
GO

-- en el procedimiento de estadoArticulos, si llegan nuevos productos comprobar que se han pedido (es decir, que todavia sea NULL) y modificar el
-- valor existencias de la tabla articulos



-- 11. BAJA MASIVA de PROVEEDORES
-- comprobaremos que no hay ningun articulo asociado al proveedor, que ese id existe y que no hay ningun pedido pendiente de ese proveedor

ALTER TRIGGER tr_borrarProveedores
ON proveedores
INSTEAD OF DELETE
AS BEGIN
    DECLARE @p INT
    DECLARE c_borrar CURSOR FOR
            SELECT idPro
            FROM deleted
    OPEN c_borrar
    FETCH c_borrar INTO @p
    WHILE (@@FETCH_STATUS = 0)
    BEGIN
        IF NOT EXISTS (SELECT *
                        FROM articulos WHERE idPro = @p)
            AND EXISTS (SELECT * 
                        FROM proveedores WHERE idPro = @p)
            AND NOT EXISTS (SELECT * 
                            FROM pedidoProveedores WHERE idPro = @p)
        BEGIN
            DELETE FROM proveedores
            WHERE idPro = @p
        END
        FETCH c_borrar INTO @p
    END
    CLOSE c_borrar
    DEALLOCATE c_borrar
END


-- 12. Idem de ARTICULOS
-- importante comprobar que el articulo no esta por llegar en la tabla pedidoProveedores y que el articulo en cuestion existe

GO
ALTER TRIGGER tr_bajaArticulo
ON articulos
INSTEAD OF DELETE
AS BEGIN
SET NOCOUNT ON -- para que solo muestre una vez el mensaje de tabla afectada

    DECLARE @a INT

    DECLARE c_borrar CURSOR FOR 
            SELECT idArt
            FROM deleted

    OPEN c_borrar
    FETCH c_borrar INTO @a
    WHILE (@@FETCH_STATUS = 0)
    BEGIN
        IF NOT EXISTS (SELECT * 
                    FROM pedidoProveedores 
                    WHERE idArt = @a)
            AND EXISTS (SELECT *
                        FROM articulos
                        WHERE idArt = @a)
            BEGIN
            DECLARE @n VARCHAR(10), @p INT, @np VARCHAR(10), @c VARCHAR(10)
        
            -- guardar los datos necesarios del articulo para insertar en el historico de articulos
            SELECT @n = nombre, @p = ppu 
            FROM deleted

            -- insertaremos tambien el nombre y la ciudad del proveedor que provee este articulo por si es necesario.
            SELECT @np = p.nombre, @c = p.ciudad
            FROM proveedores p INNER JOIN articulos a
            ON a.idPro = p.idPro 
            WHERE a.idArt = @a

            -- borramos los datos de la tabla articulos
            DELETE FROM articulos 
            WHERE idArt = @a

            -- insertamos todos los datos que hemos guardado en la tabla articulosHistorico.
            INSERT INTO articulosHistorico
            VALUES(@n, @p, @np, @c)
        END
        FETCH c_borrar INTO @a
    END
    CLOSE c_borrar
    DEALLOCATE c_borrar
END
GO


-- 13. Idem de EMPLEADOS

GO
CREATE TRIGGER tr_borrarEmpleados
ON empleados
INSTEAD OF DELETE
AS BEGIN
    DECLARE @e INT
    DECLARE c_borrar CURSOR FOR
            SELECT idEmp
            FROM deleted
    OPEN c_borrar
    FETCH c_borrar INTO @e
    WHILE (@@FETCH_STATUS = 0)
    BEGIN
        -- se podria comprobar que el empleado no pertenezca a ningun departamento
        IF EXISTS (SELECT *
                    FROM deleted
                    WHERE idDep IS NULL)
            -- y que el empleado que queremos borrar existe 
            AND EXISTS (SELECT *
                        FROM empleados
                        WHERE idEmp = @e)
            BEGIN
            -- declaramos el nombre del empleado, el cual usaremos para la tabla historico
                DECLARE @n VARCHAR(20) = (SELECT nombre
                                            FROM empleados
                                            WHERE idEmp = @e)

                -- borramos de la tabla de empleados
                DELETE FROM empleados
                WHERE idEmp = @e

                -- insertamos los datos en la tabla historicos (no se insertan el telefono y la direccion porque no existen en la tabla articulos)
                -- si queremos añadirlo, podemos hacer un procedimiento o bien un update empleadosHistoricos set...
                INSERT INTO empleadosHistorico(nombre, fechaBaja)
                VALUES(@n, getdate())
        END
        FETCH c_borrar INTO @e
    END
    CLOSE c_borrar
    DEALLOCATE c_borrar
END         


-- 14. Idem de DEPARTAMENTOS
-- vamos a comprobar que ningun empleado pertenece al departamento que queremos borrar

GO
CREATE TRIGGER tr_borrarDepartamentos
ON departamentos
INSTEAD OF DELETE
AS BEGIN
    DECLARE @d INT
    DECLARE c_borrar CURSOR FOR 
            SELECT idDep
            FROM deleted
    OPEN c_borrar
    FETCH c_borrar INTO @d
    WHILE (@@FETCH_STATUS = 0)
        BEGIN

        IF NOT EXISTS (SELECT *
                        FROM empleados
                        WHERE idDep = @d)

            AND EXISTS (SELECT *
                        FROM departamentos
                        WHERE idDep = @d)

            BEGIN

            -- guardar los datos que queramos en el historico
            -- en este caso no hacemos select para escribir la info porque solo vamos a guardar un dato
            DECLARE @c VARCHAR(20) = (SELECT ciudad
                                        FROM departamentos
                                        WHERE idDep = @d)
            
            -- borramos los datos del departamento
            DELETE FROM departamentos 
            WHERE idDep = @d

            -- insertamos los datos guardados en el historico
            INSERT INTO departamentosHistorico
            VALUES(@c)
        END
        FETCH c_borrar INTO @d
    END
    CLOSE c_borrar
    DEALLOCATE c_borrar
END



-- 15. ALTA MASIVA de PROVEEDORES
-- comprobaremos que el proveedor existe 

GO
CREATE TRIGGER tr_insertarProveedores
ON proveedores
INSTEAD OF INSERT
AS BEGIN
    DECLARE @p INT, @n VARCHAR(10), @c VARCHAR(10)
    DECLARE c_insertar CURSOR FOR 
            SELECT *
            FROM inserted
    OPEN c_insertar
    FETCH c_insertar INTO @p, @n, @c
    WHILE (@@FETCH_STATUS = 0)
    BEGIN
        IF NOT EXISTS (SELECT *
                    FROM proveedores
                    WHERE idPro = @p)
        BEGIN
            INSERT INTO proveedores
            VALUES(@p, @n, @c)
        END
        FETCH c_insertar INTO @p, @n, @c
    END
    CLOSE c_borrar
    DEALLOCATE c_borrar
END
GO

-- 16. Idem de ARTICULOS

GO
ALTER TRIGGER tr_insertarArticulos
ON articulos
INSTEAD OF INSERT
AS BEGIN
    DECLARE @a INT, @n VARCHAR(10), @e INT, @p INT, @ip INT, @s INT, @up INT
    DECLARE c_insertar CURSOR FOR 
        SELECT *
        FROM inserted
    OPEN c_insertar
    FETCH c_insertar INTO @a, @n, @e, @p, @ip, @s, @up
    WHILE (@@FETCH_STATUS = 0)
    BEGIN
        IF EXISTS (SELECT idPro
                    FROM proveedores
                    WHERE idPro = @ip)
            AND NOT EXISTS (SELECT idArt
                            FROM articulos
                            WHERE idArt = @a)
            INSERT INTO articulos
            VALUES(@a, @n, @e, @p, @ip, @s, @up)
        END
        FETCH c_insertar INTO @a, @n, @e, @p, @ip, @s, @up
    END
    CLOSE c_insertar
    DEALLOCATE c_insertar
END
GO

-- 17. Idem de EMPLEADOS
-- comprobaremos que ese empleado no existe y que el departamento tambien existe 

GO
CREATE TRIGGER tr_insertarEmpleados 
ON empleados
INSTEAD OF INSERT
AS BEGIN
    DECLARE @e INT, @n VARCHAR(10), @a VARCHAR(20), @fa DATE, @s INT, @av INT, @d INT, @fn DATE, @an INT
    DECLARE c_insertar CURSOR FOR
            SELECT *
            FROM inserted
    OPEN c_insertar
    FETCH c_insertar INTO @e, @n, @a, @fa, @s, @av, @d, @fn, @an
    WHILE (@@FETCH_STATUS = 0)
    BEGIN
        IF NOT EXISTS (SELECT *
                        FROM empleados
                        WHERE idEmp = @e)
                AND EXISTS (SELECT *
                        FROM departamentos
                        WHERE idDep = @d)
            BEGIN
            INSERT INTO empleados
            VALUES(@e, @n, @a, @fa, @s, @av, @d, @fn, @an)
        END
        FETCH c_insertar INTO @e, @n, @a, @fa, @s, @av, @d, @fn, @an
    END
    CLOSE c_insertar
    DEALLOCATE c_insertar
END
GO

-- 18. Idem de DEPARTAMENTOS
-- comprobar que el departamento que vamos a insertar no existe

GO
CREATE TRIGGER tr_insertarDepartamentos
ON departamentos
INSTEAD OF INSERT
AS BEGIN
    DECLARE @d INT, @c VARCHAR(10), @oa NUMERIC(8,2)
    DECLARE c_insertar CURSOR FOR 
            SELECT *
            FROM inserted
    OPEN c_insertar
    FETCH c_insertar INTO @d, @c, @oa
    WHILE (@@FETCH_STATUS = 0)
    BEGIN
        IF NOT EXISTS (SELECT *
                        FROM departamentos
                        WHERE idDep = @d)
            BEGIN
            INSERT INTO departamentos
            VALUES(@d, @c, @oa)
        END
        FETCH c_insertar INTO @d, @c, @oa
    END
    CLOSE c_insertar
    DEALLOCATE c_insertar
END
GO


-- 19. procedimiento entrada articulos

GO
ALTER PROCEDURE pr_entradaMercancia @p INT, @cantidad INT, @nomArt VARCHAR(20)
AS 
BEGIN
  IF EXISTS (SELECT *
            FROM pedidoProveedores
            WHERE idPro = @p
            AND nombre = @nomArt
            AND fechaEntrada IS NULL)
     BEGIN
        UPDATE pedidoProveedores
        SET fechaEntrada = getdate() 
        WHERE fechaEntrada IS NULL
            AND nombre = @nomArt
        
        UPDATE articulos
        SET existencias = existencias + @cantidad 
        WHERE nombre = @nomArt
     END
END 
GO

-- 20. procedure que pida a proveedores
-- este ejercicio es pocho, mejor el 10 porque unifica todos los pasos en un unico trigger

GO
CREATE PROCEDURE pr_pedidoProveedores @nombre VARCHAR(20)
AS 
BEGIN
    IF NOT EXISTS (SELECT *
                    FROM pedidoProveedores
                    WHERE fechaEntrada IS NULL
                    AND nombre = @nombre)

        BEGIN

            DECLARE @idPro INT, @idArt INT
            SELECT @idPro = idPro, @idArt = idArt
            FROM articulos 
            WHERE existencias < stock 

            DECLARE @cantidad INT = (SELECT unidadesPedir
                                        FROM articulos
                                        WHERE idArt = @idArt)
            
            INSERT INTO pedidoProveedores
            VALUES(@idPro, @idArt, @cantidad, getdate(), NULL, @nombre)
        END
    END
GO


-- 21. procedimiento para cambiar de departamento a un empleado que tenga cierto acumuladoVentas.

GO
CREATE PROCEDURE pr_cambiarDepartamentoEmpleado @e INT, @d INT, @av INT
AS BEGIN
    IF EXISTS (SELECT *
                FROM empleados
                WHERE idDep = @d)
    BEGIN
        UPDATE empleados
        SET idDep = @d
        WHERE idEmp = @e
        AND acumuladoVentas >= @av
    END
END
GO