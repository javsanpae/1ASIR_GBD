/*RELACION 2 SQL (JEFA/MUSICA)*/

/*1 Relacion de alumnos (nombre, apellido1 y apellido2) que estan matriculados en secundaria */

/*
USE JEFA
SELECT Nombre, Apellido1, Apellido2
FROM ALUMNOS
WHERE IdCurso LIKE '%ES'
*/

/*2 Alumnos con edades entre 12 y 15 años */

/*
USE JEFA
SELECT *
FROM ALUMNOS
WHERE Edad BETWEEN 12 AND 15;
*/

/*3 Sacar los grupos (identificador de curso y letra) donde el tutor sea ZBM, FOJ o ZPM */

/*
USE JEFA
SELECT IdCurso, Letra
FROM Grupos
WHERE TUTOR IN ('ZBM', 'FOJ', 'ZPM');
*/

/*3.2 Ademas, sacar el nombre del tutor */

/*4 Que lecciones se imparten en algun laboratorio? 
(Que el codigo del aula empiece por "L"). Sacar la leccion y aula.*/

/*
USE JEFA
SELECT *
FROM HORARIO
WHERE Aula LIKE 'L%'
*/

/*5 Que aulas estan ocupadas el lunes a sexta hora? */

/*
USE JEFA
SELECT Aula
FROM HORARIO
WHERE Hora = 6 AND Dia = 2
*/

/*6 Sacar los dias y las horas de ocupacion del aula 209 */

/*
USE JEFA
SELECT Dia, Hora
FROM HORARIO
WHERE Aula = '209'
*/

/*7 En que asignatura esta matriculada Cruz Martin, Susana? */

/*
USE JEFA
SELECT IdAsig
FROM ALUMNOS_MATERIAS
WHERE Nexp = (SELECT Nexp FROM ALUMNOS WHERE Apellido1 = 'Cruz' AND Apellido2 = 'Martin' AND Nombre = 'Susana' AND Estado = 'M')
*/

/*7.2 Sacar, ademas, el nombre (denominacion) de la asignatura.*/

/*
USE JEFA
SELECT DENO_ASIG
FROM ALUMNOS_MATERIAS, ASIGNATURAS, ALUMNOS
WHERE ALUMNOS_MATERIAS.IdAsig = ASIGNATURAS.COD_ASIG AND ALUMNOS_MATERIAS.Nexp = ALUMNOS.Nexp AND ALUMNOS.Nombre = 'Susana' AND ALUMNOS.Apellido1 = 'Cruz' 
*/

/*7 En que asignatura esta matriculada Cruz Martin, Susana? */ 
/* CON INNER JOIN!!! */

/*

use JEFA
SELECT IdAsig
FROM ALUMNOS_MATERIAS INNER JOIN (SELECT Nexp 
									FROM ALUMNOS
									WHERE Apellido1 = 'Cruz'
									AND Apellido2 = 'Martin' 
									AND Nombre = 'Susana') AS T1
					ON ALUMNOS_MATERIAS.Nexp = T1.Nexp

*/

/* 7.2. Sacar CODIGO y NOMBRE/DENOMINACION de ASIGNATURA */
/* CON INNER JOIN TAMB!!! */

/*
USE JEFA
SELECT COD_ASIG, ABREVIAT, DENO_ASIG
FROM ASIGNATURAS INNER JOIN (SELECT IdAsig
							FROM ALUMNOS_MATERIAS INNER JOIN (SELECT Nexp
																FROM ALUMNOS
																WHERE Apellido1 = 'Cruz'
																AND Apellido2 = 'Martin' 
																AND Nombre = 'Susana') AS T1
													ON ALUMNOS_MATERIAS.Nexp = T1.Nexp) AS T2
				ON ASIGNATURAS.COD_ASIG = T2.IdAsig
*/


/*8 Relacion de autores y albumes y duracion cuya duracion este entre los 40 y 60m */

/*
USE MUSICA
SELECT AUTOR, ALBUM, Duracion
FROM ALBUMES
WHERE Duracion BETWEEN 40 AND 60
*/

/*9 Relacion de CDs en los que haya musica de Cafe Quijano o de King Africa */

/*
USE MUSICA
SELECT CD
FROM ALBUMES
WHERE AUTOR = 'Cafe Quijano' OR AUTOR = 'King Africa'
*/

/*10 Obtener la edad media de los alumnos matriculados en cursos de la ESO */

/*
USE JEFA
SELECT AVG(Edad)
FROM ALUMNOS
WHERE IdCurso LIKE '%ES'
*/

/*11 Cuantos alumnos cursan estudios de Administrativo? */

/*
USE JEFA
SELECT COUNT(IdCurso)
FROM ALUMNOS
WHERE IdCurso LIKE '%AD'
*/

/* 11.2 Sacar nombre completo de los alumnos que cursan 
estudios de Administrativo, es decir, aquellos cuyo identificador 
del curso termine en AD ? */

/*

SELECT Nombre, Apellido1, Apellido2
FROM ALUMNOS
WHERE IdCurso LIKE ('%AD');

*/

/* 11.3 Ídem, con un formato más amigable*/

/*

SELECT Apellido1+' '+Apellido2+', '+Nombre
FROM ALUMNOS
WHERE IdCurso LIKE ('%AD');

*/

/*12 Cuantas horas de clase da el profesor VMR? */

/*
USE JEFA
SELECT DISTINCT Dia, Hora, Nombre
FROM LECCIONES, HORARIO, PROFESORES
WHERE LECCIONES.IdLeccion = HORARIO.IdLeccion AND PROFESORES.IdPro LIKE 'VMR' 
ORDER BY Dia, Hora
*/

/*12.2*/

/*
SELECT IdAsig, COUNT(*)AS 'Horas impartidas por VMR'
FROM HORARIO, LECCIONES
WHERE HORARIO.IdLeccion = LECCIONES.IdLeccion AND LECCIONES.IdLeccion IN (SELECT IdLeccion
																			FROM LECCIONES
																			WHERE IdPro = 'VMR')	
GROUP BY IdAsig																			

*/

/* Otra posible solución:*/

/*
SELECT IdAsig, COUNT(*)AS 'Horas impartidas por VMR'
FROM HORARIO, LECCIONES
WHERE HORARIO.IdLeccion = LECCIONES.IdLeccion 
		AND IdPro = 'VMR'
GROUP BY IdAsig	
*/


/*13 Como se llama al alumno de mayor edad que le da clase EME? */



/*14 Sacar los diez apellido1 y apellido2 que mas se repiten */



/*15 De que autores tenemos menos de 90 minutos de musica?  */

/*
USE MUSICA
SELECT AUTOR, Duracion
FROM ALBUMES, CDS
WHERE CDS.Longitud < 90;
*/

/*16 Sacar todos los CDs y su duracion total */

/*
USE MUSICA
SELECT CD
FROM CDS
SELECT SUM(Longitud)
FROM CDS
*/

/*17 Que autor y album es el mas repetido? */ 

/*

SELECT TOP 1 AUTOR, ALBUM, COUNT (*)
FROM ALBUMES
GROUP BY AUTOR, ALBUM
ORDER BY COUNT (*) DESC

*/

/*18 De que albumes hay solo una copia? */

/*
USE MUSICA
SELECT DISTINCT ALBUM
FROM ALBUMES
WHERE IdCasa = 1
*/

/*19 Cuantos autores diferentes tenemos? */

/*
USE MUSICA
SELECT COUNT(AUTOR)
FROM ALBUMES
*/

/*20 Cuantos autor mas album diferentes tenemos? */



/*21 Sacar el nombre de los albumes de Pink Floyd */

/*
USE MUSICA
SELECT ALBUM
FROM ALBUMES
WHERE AUTOR = 'Pink Floyd'
*/

/*22 Sacar los CDs donde haya musica de ABBA */

/*
USE MUSICA
SELECT CD 
FROM ALBUMES
WHERE AUTOR = 'ABBA'
*/

/*23 De que autores tenemos mas de 5 albumes? Sacar autor y numero de albumes. */

/*23.2 Y si nos piden que autores tienen mas de 5 albumes diferentes?*/

/*24 Cual es el numero de albumes de cada autor? */

/*
SELECT AUTOR, COUNT(*) AS 'Número de álbumes'
FROM ALBUMES
GROUP BY AUTOR
ORDER BY 2 DESC
*/

/*24.2 Ahora con albumes distintos. */

/*25 Media de albumes distintos, por autor
lo vamos a hacer por partes: */



/*26 Que CDs de 74 minutos de duracion tienen musica de Joaquin Sabina? */

/*
USE MUSICA
SELECT DISTINCT CDS.CD
FROM ALBUMES, CDS
WHERE CDS.Longitud = '74' AND AUTOR = 'Joaquin Sabina'
*/

/*26.2 Vamos a hacerlo bien, incluyendo cada condicion en su correspondiente tabla*/

/*27 Sacar la abreviatura y nombre de las asignaturas que imparten 
los profesores llamados Manuel */

/*
USE JEFA
SELECT DISTINCT ASIGNATURAS.ABREVIAT
FROM ASIGNATURAS, LECCIONES, PROFESORES
WHERE PROFESORES.IdPro = LECCIONES.IdPro AND PROFESORES.Nombre = 'Manuel'
*/

/*28 Sacar la lista de la clase de la asignatura 1102 (apellido1, apellido2 y nombre) 
ordenados alfabeticamente */

/*
USE JEFA
SELECT DISTINCT ALUMNOS.Apellido1, ALUMNOS.Apellido2, ALUMNOS.Nombre
FROM LECCIONES, ALUMNOS, GRUPOS
WHERE ALUMNOS.IdCurso = GRUPOS.IdCurso AND IdAsig = '1102'
ORDER BY Apellido1 ASC
*/

/* 28.2  Idem, pero de la asignatura SBD */

/*
USE JEFA
SELECT DISTINCT ALUMNOS.Apellido1, ALUMNOS.Apellido2, ALUMNOS.Nombre
FROM ALUMNOS, ASIGNATURAS, LECCIONES
WHERE ASIGNATURAS.COD_ASIG = LECCIONES.IdAsig AND ASIGNATURAS.ABREVIAT = 'SBD'
ORDER BY ALUMNOS.Apellido1 ASC
*/

/*29 Cual es la longitud total de los CDs donde hay musica de Mecano? */

/*
USE MUSICA
SELECT SUM(CDS.Longitud)
FROM CDS, ALBUMES
WHERE ALBUMES.AUTOR = 'Mecano' 
*/

/*30 Sacar aquellos albumes cuya duracion es mayor que la media */

/*
USE MUSICA
SELECT *
FROM ALBUMES
WHERE Duracion > (SELECT AVG(Duracion) FROM ALBUMES)
*/
