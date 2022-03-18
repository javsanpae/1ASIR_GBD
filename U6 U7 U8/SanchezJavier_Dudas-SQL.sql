USE DEP_SANCHEZ

-- 1. Cantidad de articulos vendidos por todos los proveedores de jaen

/* Sin inner join */
SELECT COUNT(idArt)
FROM articulos, proveedores 
WHERE articulos.idPro = proveedores.idPro and proveedores.ciudad = 'jaen';


/* Inner join */
SELECT COUNT(idArt)
FROM articulos INNER JOIN (SELECT idPro
							FROM proveedores 
							WHERE ciudad = 'jaen') AS T1
				ON articulos.idPro = T1.idPro


-- 2. Numero de ventas efectuadas el 2021-10-25

SELECT COUNT(fecha)
FROM ventas
WHERE fecha LIKE '2021-10-25';

-- 3. Nombre de los proveedores que NO sean de Granada

SELECT nombre
FROM proveedores
WHERE ciudad != 'granada';

-- 4. Quien distribuye el producto "silla"? (nombre del distribuidor)

/* Sin inner join */
SELECT proveedores.nombre
FROM proveedores, articulos
WHERE proveedores.idPro = articulos.idPro AND articulos.nombre = 'silla';

/* Inner join */
SELECT nombre
FROM proveedores INNER JOIN (SELECT idPro 
							FROM articulos
							WHERE nombre = 'silla') AS T1
				ON proveedores.idPro = T1.idPro

-- 5. Mostrar el sueldo de media de los empleados

SELECT AVG(sueldo)
FROM empleados;

-- 6. De donde es el departamento que busca un objetivo anual mayor o igual a 200?

SELECT ciudad
FROM departamentos
WHERE objetivoAnual >= 200;

-- 7. Proveedores que sean de la misma ciudad que el departamento 1

SELECT nombre
FROM proveedores, departamentos
WHERE proveedores.ciudad = departamentos.ciudad;

SELECT nombre
FROM proveedores INNER JOIN (SELECT ciudad 
							FROM departamentos) AS T1
				ON proveedores.ciudad = T1.ciudad


-- 8. Empleados con ventas superiores a 2000 cuyo apellido acabe por -ez 

SELECT nombre
FROM empleados
WHERE apellido LIKE '%EZ' AND acumuladoVentas > 2000;

-- 9. Muestrame todos los datos de los artículos y departamentos

SELECT *
FROM articulos, departamentos;


-- 10. Nombre del producto y del distribuidor que vendio más de 2 unidades en el 2021 

SELECT articulos.nombre, proveedores.nombre
FROM articulos, proveedores, ventas
WHERE ventas.fecha LIKE '2021%';
