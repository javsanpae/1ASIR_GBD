--RELACION 3  Actualizaciones SQL    (11.02.22)


--1. Sacar todos los albumes del autor Alejandro Sanz

/*
USE MUSICA
SELECT DISTINCT ALBUM
FROM ALBUMES
WHERE AUTOR = 'Alejandro Sanz';
*/
--2. En que cds se encuentra la musica de ABBA?

/*
USE MUSICA
SELECT CD
FROM ALBUMES
WHERE AUTOR = 'ABBA';
*/

--3. De que autores tenemos mas de 5 albumes?



--4. Añadir una casa discografica que se llame "varios", de tipo A y con Idcasa 12



--5. Colocar a todos los albumes con idcasa null el valor 0 (cero)



--6. Colocar a todos los albumes con 0, el valor correspondiente al idcasa de la casa EMI

/*
UPDATE ALBUMES
SET IdCasa = (SELECT IdCasa
					FROM CASAS
					WHERE Nombre = 'EMI')
WHERE IdCasa = 0;
*/

--7. A�adir un atributo a la tabla Autores llamado NumCasas de tipo entero.

/*
ALTER TABLE Autores
ADD NumCasas INT
*/

--8. Actualizar el atributo NumCasas de la tabla Autores Con el numero de casas discograficas diferentes en las que el autor ha editado albumes //--Hay que ejecutar el ejercicio 7 antes.

/*
SELECT *
FROM Autores;
*/

--9. Crear una vista llamada duraCds, con los nombres de los cds y la duracion de toda la musica que llevan dentro.

/*
CREATE VIEW duraCds AS 
SELECT CD, SUM(Duracion) AS T1
FROM ALBUMES
GROUP BY CD
*/

--10. Insertar un album con los siguientes valores: (701, 'mp3_nuevo','juan','nuevo_album', 80)	



--11. Borrar todos aquellos �lbumes que tengan como autor a juan.



--12. Borrar aquellos �lbumes con id casa null.


