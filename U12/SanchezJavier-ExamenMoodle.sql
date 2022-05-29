
-- EXAMEN PARA ENTREGAR CON ENUNCIADOS DE:
---1 PROCEDIMIENTO
-- 1 FUNCION
-- TRIGGERS CON CURSORES

-- USAREMOS LA BASE DE DATOS DE MUSICA

-- ejercicio 1: Procedimiento que borre uno a uno los autores que pertenezcan a la casa que se pase como parametro de entrada.

GO
CREATE PROCEDURE pr_borrarAutoresCasa @nc VARCHAR(30)
AS BEGIN 

    DELETE FROM AUTORES
    WHERE AUTOR = (SELECT AUTOR
                    FROM ALBUMES INNER JOIN (SELECT IdCasa
                                                FROM CASAS
                                                WHERE Nombre = @nc) AS T1
                                    ON T1.IdCasa = ALBUMES.IdCasa)

    END
GO
EXEC pr_borrarAutoresCasa 'Virgin'

-- ejercicio 2: Función que nos devuelva el número de álbumes de entre 30 y 45 min del autor que demos como parametro de entrada

GO
ALTER FUNCTION fn_numeroAlbumes(@na VARCHAR(20))
RETURNS INT
AS BEGIN
    DECLARE @n INT = (SELECT DISTINCT COUNT(*)
                        FROM ALBUMES
                        WHERE Duracion BETWEEN 30 AND 45
                        AND AUTOR = @na)
    RETURN @n
END
GO
PRINT dbo.fn_numeroAlbumes('Queen')

-- ejercicio 3: Baja masiva de CDs. Borraremos los que tengan duracion nula o de 80 minutos.
-- crear una tabla historica donde guardaremos los valores que teniamos en la tabla CDS ademas de la fecha de baja.

CREATE TABLE historicoCDS (
    CD NVARCHAR(50),
    Longitud SMALLINT,
    fechaBaja DATE
)

GO
CREATE TRIGGER tr_bajaMasivaCDS
ON CDS
INSTEAD OF DELETE
AS BEGIN
    DECLARE @long INT
    DECLARE c_borrar CURSOR FOR
            SELECT longitud
            FROM deleted
    OPEN c_borrar
    FETCH c_borrar INTO @long
    WHILE (@@FETCH_STATUS = 0)
        BEGIN
        IF @long = 74 
            OR @long IS NULL
            BEGIN
            DECLARE @cd NVARCHAR(50) = (SELECT cd
                                        FROM deleted)
            INSERT INTO historicoCDS
            VALUES(@cd, @long, getdate())

            DELETE FROM CDS
            WHERE @long = 74 
                OR @long IS NULL
        END
        FETCH c_borrar INTO @long
    END
    CLOSE c_borrar
    DEALLOCATE c_borrar
END
GO
DELETE FROM CDS WHERE longitud = 74

-- ejercicio 4. alta masiva de casas
-- comprobar que el id de casa ni el nombre este ya insertado y que la casa que vamos a meter sea del tipo A al F

GO
CREATE TRIGGER tr_altaMasivaCasas
ON casas
INSTEAD OF INSERT
AS BEGIN
    DECLARE @c INT, @n NVARCHAR(25), @t NVARCHAR(1)
    DECLARE c_insertar CURSOR FOR
            SELECT * FROM inserted
    OPEN c_insertar
    FETCH c_insertar INTO @c, @n, @t
    WHILE (@@FETCH_STATUS = 0)
        BEGIN
        IF NOT EXISTS (SELECT *
                        FROM CASAS
                        WHERE IdCasa = @c)
            AND NOT EXISTS (SELECT *
                            FROM CASAS
                            WHERE Nombre = @n)

            AND @t = 'A'
            OR @t = 'B'
            OR @t = 'C'
            OR @t = 'D'
            OR @t = 'E'
            OR @t = 'F'

            BEGIN

            INSERT INTO CASAS
            VALUES(@c, @n, @t)
        END
        FETCH c_insertar INTO @c, @n, @t
    END
    CLOSE c_insertar
    DEALLOCATE c_insertar
END
GO
INSERT INTO CASAS VALUES(12, 'Republic Records', 'D')


