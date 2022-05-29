/*

                                                        EXAMEN DE PROCEDIMIENTOS, FUNCIONES Y TRIGGER



En un Centro educativo se ha creado una bd con las siguientes tablas:

- CURSO (idCurso, nombre, numMaximoAlumnos)

- ALUMNO (numExped, nombre, fechaNacimiento, edad, idCurso)

- ASIGNATURAS (codAsig, nombre, horasSemanales)

- PROFESOR (codProfe, nombre, fechaAlta, sueldoBase, cargo) 

- MATRICULAS (numExped, codProfe, codAsig, nota), para matricular a un alumno el Centro necesita saber el nº de expediente, el código del profesor y el código de la asignatura, la nota Inicialmente será NULL

- historicoAlumnos (nombreAlumno, fechaBaja)

*/

-- (0.2) 1. Después del primer dia haciendo matrículas, se han planteado incluir un nuevo atributo en CURSO, para saber cuántos alumnos se están matriculando.
-- Añadir el atributo "numAlumnos", de tipo int

ALTER TABLE CURSO
ADD numAlumnos int

-- (2) 2. PROCEDIMIENTO pr_actualizarCurso
-- Para actualizar este atributo de todas las matriculas ya efectuadas 
-- Ejemplo de uso

GO
CREATE PROCEDURE pr_actualizarCurso @c VARCHAR(20)
AS
    UPDATE Curso
    SET numAlumnos = (SELECT COUNT(*)
                        FROM alumno
                        WHERE idCurso = @c)
    WHERE idCurso = @c
END
GO
EXEC pr_actualizarCurso '1ASIRA'

-- (1.4) 3. FUNCIÓN fn_AlumnosAsignaturaDelProfesor
-- Para que devuelva los datos de los alumnos a los que da clase un profesor (codProfe) dado de una asignatura dada (codAsig)
-- Ejemplo de uso

GO
CREATE FUNCTION fn_AlumnosAsignaturaDelProfesor (@cp VARCHAR(20), @ca VARCHAR(20))
RETURNS TABLE
AS
    RETURN (SELECT *
            FROM alumno INNER JOIN (SELECT *
                                    FROM matriculas
                                    WHERE codProfe = @cp
                                    AND codAsig = @ca) AS T1
                        ON T1.numExped = alumno.numExped)
END
GO
PRINT dbo.fn_AlumnosAsignaturaDelProfesor ('743MZB', '0008GBD')

-- (1.4) 4. FUNCIÓN fn_notaAlumnoEnAsignatura
-- Para recibir como parámetros el nombre de un alumno y el nombre de una asignatura, y que devuelva la nota de ese alumno en esa asignatura.

GO
CREATE FUNCTION fn_notaAlumnoEnAsignatura (@nAlu VARCHAR(20), @nAsig VARCHAR(20))
RETURNS INT
AS BEGIN
    DECLARE @nota INT = (SELECT matriculas.nota
                            FROM alumno INNER JOIN (SELECT *
                                                    FROM matriculas INNER JOIN (SELECT nombre
                                                                                FROM asignaturas
                                                                                WHERE nombre = @nAsig) AS T1
                                                                    ON T1.codAsig = matriculas.codAsig) AS T2
                                        ON T2.numExped = alumno.numExped
                            WHERE alumno.nombre = @nAlu)
    RETURN @nota
END
GO
PRINT dbo.fn_notaAlumnoEnAsignatura ('Javier Sanchez Paez', 'GBD')

-- (2.5) 5. TRIGGER tr_bajasAlumnos Para dar bajas masivas de alumnos.
-- Solo si está matriculado!
-- Para cada baja del alumno, hay que actualizar el atributo numAlumnos de la tabla CURSO, e insertarlo en la tabla historicoAlumnos! 
-- Ejemplo de uso

GO
CREATE TRIGGER tr_bajasAlumnos
ON alumnos
INSTEAD OF DELETE
AS BEGIN
    DECLARE @e INT
    DECLARE c_borrar CURSOR FOR
            SELECT numExped
            FROM deleted
    OPEN c_borrar
    FETCH c_borrar INTO @e
    WHILE (@@FETCH_STATUS = 0)
        BEGIN
        IF EXISTS (SELECT *
                    FROM matriculas
                    WHERE numExped = @e)
            BEGIN
            DECLARE @c VARCHAR(20) = (SELECT curso
                                        FROM alumno
                                        WHERE numExped = @e)
            UPDATE curso
            SET numAlumnos = numAlumnos - 1
            WHERE idCurso = @c
            DECLARE @n VARCHAR(100) = (SELECT nombre
                                        FROM curso
                                        WHERE numExped = @e)
            INSERT INTO historicoAlumnos
            VALUES(@n, getdate())
            
            DELETE FROM matriculas
            WHERE numExped = @e
        END
        FETCH c_borrar INTO @e
    END
    CLOSE c_borrar
    DEALLOCATE c_borrar
END
GO
DELETE FROM alumnos WHERE numExped = 23532


-- (2.5) 6. TRIGGER tr_hacerMatriculas
-- Para dar altas masiva de matrículas.
-- Para cada nueva matrícula, comprobar que ya no está dado de alta ese alumno (par numExped), que tenemos al profesor (por codProfe) y también esa asignatura (por codAsig). 
-- También hay que actualizar el atributo numAlumnos de la tabla CURSO. 
-- Ojo, no puede haber más alumnos matriculados que el nº máximo de alumnos permitido
-- Ejemplo de uso

GO
CREATE TRIGGER tr_hacerMatriculas
ON matriculas
INSTEAD OF INSERT
AS BEGIN
    DECLARE @e INT, @p VARCHAR(20), @a VARCHAR(20), @n INT
    DECLARE c_insertar CURSOR FOR
            SELECT *
            FROM inserted
    FETCH c_insertar INTO @e, @p, @a, @n
    WHILE (@@FETCH_STATUS = 0)
        BEGIN
        DECLARE @na INT, @nma INT
        SELECT @na = numAlumnos + 1, @nma = numMaximoAlumnos
        FROM curso
        IF NOT EXISTS (SELECT * 
                        FROM alumno
                        WHERE numExped = @e)
            AND EXISTS (SELECT *
                        FROM profesor
                        WHERE codProfe = @p)
            AND @na < @nma
            BEGIN

            INSERT INTO matriculas
            VALUES(@e, @p, @a, @n)
        END
        FETCH c_insertar INTO @e, @p, @a, @na
    END
    CLOSE c_insertar
    DEALLOCATE c_insertar
END
GO
INSERT INTO matriculas VALUES(24588, '743MZB', '0008GBD', 10)