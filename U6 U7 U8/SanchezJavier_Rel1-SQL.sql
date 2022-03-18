
--RELACION 1  DE SQL (SPJ)

-- 1. Obtener todos los nombres de los proveedores

SELECT nombre
FROM Datos_S;

-- 2. Obtener aquellos proveedores cuyo status es mayor que 20

USE datos_SPJ
SELECT nombre
FROM Datos_S
WHERE Status > 20;

-- 3. Obtener el nombre de los proveedores que suministran la pieza P1


USE datos_SPJ
SELECT nombre
FROM Datos_S, Datos_SPJ
WHERE Datos_SPJ.IdS = Datos_S.IdS and IdP = 'P2';


USE datos_SPJ
SELECT Datos_S.nombre
FROM Datos_S INNER JOIN (SELECT IdS 
							FROM Datos_SPJ 
							WHERE IdP = 'P2') AS T1
			ON T1.IdS = Datos_S.IdS;


-- 4. Obtener el nombre de los proveedores cuyo nombre acabe en "ez"

USE datos_SPJ
SELECT nombre
FROM Datos_S
WHERE nombre like '%ez';

/* 5. Obtener el nombre de aquellos individuos que tienen el estatus maximo*/


USE datos_SPJ
SELECT nombre
FROM Datos_S
WHERE Status = (SELECT Max(Status) FROM Datos_S);

/* 6. Obtener aquellos proveedores cuya ciudad es la ciudad de S1 o S2 */


-- Manera Simple

USE datos_SPJ
SELECT nombre
FROM Datos_S
WHERE Ciudad IN ('Madrid', 'Londres');


-- Manera Idonea

USE datos_SPJ
SELECT *
FROM Datos_S
WHERE Ciudad = (SELECT ciudad FROM Datos_S WHERE IdS = 'S1') 
	OR Ciudad = (SELECT ciudad FROM Datos_S WHERE IdS = 'S2');


/* 7. Encontrar aquellos proveedores, cuyas piezas que suministran estan
incluidas en el conjunto de piezas de J1 */


USE datos_SPJ
SELECT Datos_S.nombre
FROM Datos_S, Datos_SPJ
WHERE Datos_S.IdS = Datos_SPJ.IdS AND IdJ = 'J1';

USE datos_SPJ
SELECT nombre
FROM Datos_S INNER JOIN (SELECT IdS, IdJ 
							FROM Datos_SPJ) AS T1
			ON Datos_S.IdS = T1.IdS AND IdJ = 'J1';


/* 8. Encontrar aquellos proyectos que no reciben ningun suministro cantidad mayor o igual a 300 */


USE datos_SPJ
SELECT *
FROM Datos_SPJ
WHERE cantidad >= 300;


/* 9. Encontrar aquellos proveedores que tienen un status mayor que el de S7 */


USE datos_SPJ
SELECT *
FROM Datos_S
WHERE Status > (SELECT Status FROM Datos_S WHERE IdS = 'S7');


/* 10. Encontrar aquellos proveedores que tienen un status mayor que el de todos los proveedores de Madrid*/


USE datos_SPJ
SELECT *
FROM Datos_S
WHERE Status > (SELECT Status FROM Datos_S WHERE Ciudad = 'Madrid');


/* 11. Encontrar aquellas piezas cuyo color es rojo, gris o blanco */


USE datos_SPJ
SELECT *
FROM Datos_P
WHERE color IN ('Rojo', 'Gris', 'Blanco');


/* 12. Encontrar aquellos proveedores (solo el codigo de proveedor!) 
que viven en la misma ciudad que el proveedor que suministra papel*/


USE datos_SPJ
SELECT IdS
FROM Datos_S
WHERE ciudad = (SELECT ciudad FROM Datos_P WHERE Nombre = 'Papel');


/* 13. Encontrar aquellos proveedores que no suministran papel */


USE datos_SPJ
SELECT DISTINCT Datos_S.nombre
FROM Datos_P, Datos_S, Datos_SPJ
WHERE Datos_S.IdS = Datos_SPJ.IdS AND Datos_SPJ.IdP = Datos_P.IdP AND Datos_P.Nombre != 'Papel';



/* 14. Encontrar aquel proveedor que suministra todas las piezas rojas */

/*
USE datos_SPJ
SELECT Datos_SPJ.IdS
FROM Datos_P, Datos_SPJ
WHERE Datos_P.IdP = Datos_SPJ.IdP AND Datos_P.Color = 'Rojo'
*/

/* 15. Numero de suministros realizados al proyecto J2 por S5 */

/*
USE datos_SPJ
SELECT IdS, IdJ, Cantidad 
FROM Datos_SPJ
WHERE IdS = 'S5' AND IdJ = 'J2'
*/

/* 16. Calcular la media de peso de las piezas cuyo nombre comience 
por "Estuche" */

/*
USE datos_SPJ
SELECT AVG(peso)
FROM Datos_P
WHERE Nombre LIKE 'Estuche%'
*/


/* 16.1 Calcular la media de peso de las piezas cuyo nombre comience 
por "L" */

/*
USE datos_SPJ
SELECT AVG(peso)
FROM Datos_P
WHERE Nombre LIKE 'L%'
*/

/*17. Encontrar los codigos y las cantidades (de envios) maximas de 
aquellos proveedores que han enviado piezas blancas, agrupados por el 
codigo de empleado y el codigo de pieza */

/*
USE datos_SPJ
SELECT MAX(cantidad)  
FROM Datos_SPJ, Datos_P
WHERE Datos_SPJ.IdP = Datos_P.IdP AND Datos_P.Color = 'Blanco'
*/

/* 19. Obtener el nombre de todas las piezas en orden ascendente */

/*
USE datos_SPJ
SELECT Nombre
FROM Datos_P
ORDER BY Nombre ASC
*/

/* 20. Obtener la tabla resumen del numero de suministros realizados a 
cada uno de los proyectos realizados por cada vendedor */

/* Sacar IdS de los nombres */

/*
USE datos_SPJ
SELECT Datos_S.IdS, Nombre
FROM Datos_S INNER JOIN (select IdS
						from Datos_SPJ
						where IdP = 'P4') as Tabla1
			ON Datos_S.IdS = Tabla1.IdS
*/

/* 21. Borrar todos los suministros asociados a J3 */

	/*Borrar aquellos proveedores cuya ciudad empiece por B*/
	
/*

DELETE 
FROM Datos_S
WHERE Ciudad LIKE 'B%'

SELECT *
FROM Datos_S

*/

/* 22. Insertar en la tabla de proveedores el siguiente proveedor:
S19 José Fernandez 2 Barcelona */

/*

INSERT INTO Datos_S (IdS, Nombre, Status, Ciudad)
VALUES ('S19', 'José Fernández', 2, 'Barcelona')

*/

/* 23. Modifica la ciudad de S1 a Paris*/

/*
UPDATE Datos_S
SET Ciudad = 'Paris'
WHERE IdS = 'S1'
*/

