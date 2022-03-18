
--RELACION 1  DE SQL (SPJ)

-- 1. Obtener todos los nombres de los proveedores

select nombre
from Datos_S

-- 2. Obtener aquellos proveedores cuyo status es mayor que 20

select nombre
from Datos_S
where Status > 20;

-- 3. Obtener el nombre de los proveedores que suministran la pieza P1

select Nombre
from Datos_S INNER JOIN (SELECT ciudad FROM Datos_P WHERE IdP = 'P1') AS T1
ON Datos_S.Ciudad = T1.Ciudad

-- 4. Obtener el nombre de los proveedores cuyo nombre acabe en "ez"

select Nombre
from Datos_S
WHERE Nombre LIKE '%EZ'

/* 5. Obtener el nombre de aquellos individuos que tienen el estatus maximo*/

select nombre
from Datos_S
where Status = (SELECT MAX(Status) FROM Datos_S)

/* 6. Obtener aquellos proveedores cuya ciudad es la ciudad de S1 o S2 */

select nombre
FROM Datos_S
WHERE Ciudad = (SELECT Ciudad FROM Datos_S WHERE IdS = 'S1') 
	OR Ciudad = (SELECT Ciudad FROM Datos_S WHERE IdS = 'S2')

/* 7. Encontrar aquellos proveedores, cuyas piezas que suministran estan
incluidas en el conjunto de piezas de J1 */

select nombre
from Datos_S INNER JOIN (select IdS 
							from Datos_SPJ 
							where IdJ = 'J1') as T1
	on Datos_S.IdS = T1.IdS;


/* 8. Encontrar aquellos proyectos que no reciben ningun suministro cantidad mayor 
o igual a 300 */

SELECT *
FROM Datos_SPJ
WHERE Cantidad <= 300;

/* 9. Encontrar aquellos proveedores que tienen un status mayor que el de S7 */

select 

/* 10. Encontrar aquellos proveedores que tienen un status mayor que el de todos los proveedores de Madrid*/



/* 11. Encontrar aquellas piezas cuyo color es rojo, gris o blanco */



/* 12. Encontrar aquellos proveedores (solo el codigo de proveedor!) 
que viven en la misma ciudad que el proveedor que suministra papel*/



/* 13. Encontrar aquellos proveedores que no suministran papel */



/* 14. Encontrar aquel proveedor que suministra todas las piezas rojas */



/* 15. Numero de suministros realizados al proyecto J2 por S5 */



/* 16. Calcular la media de peso de las piezas cuyo nombre comience 
por "Estuche" */



/* 16.1 Calcular la media de peso de las piezas cuyo nombre comience 
por "L" */



/*17. Encontrar los codigos y las cantidades (de envios) maximas de 
aquellos proveedores que han enviado piezas blancas, agrupados por el 
codigo de empleado y el codigo de pieza */



/* 19. Obtener el nombre de todas las piezas en orden ascendente */



/* 20. Obtener la tabla resumen del numero de suministros realizados a 
cada uno de los proyectos realizados por cada vendedor */

/* Sacar IdS de los nombres */


/* 21. Borrar todos los suministros asociados a J3 */

	/*Borrar aquellos proveedores cuya ciudad empiece por B*/
	


/* 22. Insertar en la tabla de proveedores el siguiente proveedor:
S19 José Fernandez 2 Barcelona */



/* 23. Modifica la ciudad de S1 a Paris*/



