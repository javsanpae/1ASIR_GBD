


-- RELACION 1:
-- Ejercicios 3, 12 y 18


-- 3. Obtener el nombre de los proveedores que suministran la pieza P1

/*

USE datos_SPJ
SELECT Nombre
FROM Datos_S INNER JOIN (SELECT IdS 
						 FROM datos_SPJ
						 WHERE IdP = 'P1') AS T1

			  ON Datos_S.IdS = T1.IdS

*/

/* 12. Encontrar aquellos proveedores (solo el codigo de proveedor!) 
que viven en la misma ciudad que el proveedor que suministra papel*/

/*

use datos_SPJ
SELECT IdS
FROM Datos_S INNER JOIN (SELECT ciudad
						 FROM Datos_P
						 WHERE Nombre = 'Papel') AS T1
			 ON Datos_S.Ciudad = T1.Ciudad

*/



/*
USE datos_SPJ
SELECT IdS
FROM Datos_S
WHERE ciudad = (SELECT ciudad FROM Datos_P WHERE Nombre = 'Papel')
*/