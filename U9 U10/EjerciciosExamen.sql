-- 1. Crear la tabla VENTAS, con sus correspondientes claves

create table VENTAS (
idEmp int references EMPLEADOS (idEmp),
idArt int references ARTICULOS (idArt),
fecha date,
unidades int,
constraint pk_ventas primary key (idEmp, idArt, fecha)
);

--2. Dar de baja aquellos proveedores que no suministran ningún artículo

delete from PROVEEDORES
where idPro not in (select distinct idPro
		        from ARTICULOS)
--3. Poner un 5, en la nota de GBD de la segunda evaluación, sólo aquellos alumnos de 1ASIRA que tienen sólo ese módulo suspenso y con nota mayor que 4

update EVALUACIONES
set nota = 5
where idAsig = ‘GBD’ and nota > 4 and eval = 2
and numExp in (select numExp
                              from (1ASIRA inner join 1 suspenso
		  ON)
t1 (select numExp
      from ALUMNOS
      where idCurso = ‘1ASIRA’) as T1
t2 (select numExp, count (*)
      from EVALUACIONES
      where nota < ‘5’
      group by numExp
      having count (*) = 1
ON t1.numExp = t2.numExp)

--4. Sacar un listado con el nombre de los alumnos del grupo 1ASIRA y su fecha de nacimiento, ordenador alfabéticamente por el nombre del alumno

select t1.numExp, suspensos
from (select numExp
           from alumnos inner join (select numExp, count (*) as suspensos
                                                          from EVALUACIONES
                                                          where eval = 1 and nota < 5)
                                                          group by numExp) as t1
           where idCurso = ‘1ASIR’) as T2
	ON t2.numExp = t1.numExp
order by suspensos desc;

--5. Sacar los números de expediente de los alumnos del curso 1ASIR y el número de suspensos en la primera evaluación, ordenados de mayor a menos número de suspensos

select alumnos.numExp
from alumnos inner join (select count(nota), numExp
			    from EVALUACIONES
                                              where eval = 1 and nota < 5) as t1
		ON alumnus.numExp = t1.numExp

--6. Sacar el nombre de la ciudad de aquellos proveedores que no suministran ningún artículo

select nombre, ciudad
from proveedores
where idPro not in (select distinct idPro
		        from ARTICULOS)

--?.1 Sacar los nombres de los alumnos con un solo suspenso en GBD, 1ASIRA, en la segunda evaluación
--?.2 Sacar el nombre del alumno que ha sacado la mayor nota en el segundo trimestre de gbd
--?.3 Sacar el nombre del alumno y nota del alumno que ha sacado la mayor nota en GBD, en caso de empate sacarlos todos

-- 6.Sacar la nota mayor de un alumno en gbd en una determinada evaluacion

CREATE FUNCTION mayorNota(@codAsig varchar(10), @nEval int)
RETURNS INT
AS
BEGIN
	DECLARE @maxNota INT
	SET @maxNota = (SELECT MAX(nota)
	FROM EVALUACIONES
	WHERE idAsig = @codAsig AND eval=@nEval)
RETURN @maxNota
END
PRINT 'La nota mayor de un alumno en GBD es ' + cast(dbo.mayorNota('GBD', 2) AS VARCHAR)


--EjRecu7: Funcion que devuelva el numero de suspensos de un determinado alumno. se le pasa el numero d expediente en una determinada evaluacion

CREATE FUNCTION fn_numSuspensos(@numExp INT, @nEval INT)
RETURNS INT
AS
BEGIN
DECLARE @numSuspensos INT
SET @numSuspensos = (SELECT COUNT(nota)
					FROM evaluaciones
					WHERE numExp = @nExp AND eval = @nEval AND nota < 5)
RETURN @numSuspensos
END


--ejrecu7.1: sacar la nota media de un determinado alumno en una determinada evaluacion mediante el expediente, siempre y cuando tenga todo aprobado.
--En caso contrario, sacar de nota media un 0

CREATE FUNCTION fn_notaMedia(@numExp VARCHAR(10), @nEval INT)
RETURNS INT
AS
BEGIN
DECLARE @salida INT
DECLARE @contador INT = 0
SET @contador = (SELECT COUNT(nota)
			FROM evaluaciones
			WHERE numExp = @numExp
			AND evaluacion = @nEval AND nota < 5)

IF @contador = 0 
BEGIN
	SET @salida = 0
	END
	RETURN @salida
END

--EjRecu8: Funcion que al darle un nombre devuelva el numero de suspensos de un numero de expediente de una evaluacion determinada.
-- no estaria mal comprobar previamente si ese alumno esta en esa tabla

CREATE FUNCTION fn_numeroSuspensos(@nombre VARCHAR(50), @nEval INT)
RETURNS INT
AS
BEGIN
DECLARE @numExpediente INT
DECLARE @numSuspensos INT
SET @numExpediente = (SELECT numExp
						FROM ALUMNOS
						WHERE Nombre = @nombre)
SET @numSuspensos = (SELECT COUNT(nota)
					FROM evaluaciones
					WHERE numExp = @numExpediente
					AND nombre = @nombre
					AND eval = @nEval)
RETURN @numSuspensos

--EjRecu9: Nombre de alumnos que solo han suspendido gbd en la segunda evaluacion

-- Diria que esta bien
CREATE FUNCTION fn_alumnosGBDsuspensa
RETURNS TABLE
AS
RETURN (SELECT nombre
		FROM ALUMNOS INNER JOIN (SELECT idAsig
									FROM asignaturas INNER JOIN (SELECT *
																	FROM evaluaciones
																	WHERE nota < 5) AS T1
														ON T1.idAsig = asignaturas.idAsig) AS T2
						ON T2.numExp = ALUMNOS.numExp)



--EjRecu10: Funcion que saque la mayor nota de alguien en una determinada asignatura y una determinada evaluacion.


CREATE FUNCTION fn_MayorNota (@idAsignatura VARCHAR(50), @nEval INT)
RETURNS TABLE
AS
	RETURN(SELECT nombre 
			FROM ALUMNOS INNER JOIN (SELECT nota, numExp
										FROM EVALUACIONES 
										WHERE eval = @nEval AND idAsig = @idAsignatura AND nota = MAX(nota)) AS T1
							ON T1.numExp = ALUMNOS.numExp) 


--EjRecu11: Algoritmia, decir cuantos suspensos hay en gbd en la primera evaluacion

CREATE FUNCTION fn_suspensosGBD()
RETURNS INT
AS
BEGIN
DECLARE @numSuspensos INT
SET @numSuspensos = (SELECT COUNT(nota)
					FROM evaluaciones INNER JOIN (SELECT idAsig
													FROM asignaturas
													WHERE denoAsig = 'GBD') AS T1
										ON T1.idAsig = evaluaciones.idAsig AND nota < 5 AND eval = 1)
RETURN @numSuspensos
END
GO






