-- 1. Sacar listado con códigos de empleados + nº de ventas realizadas

SELECT idEmp, acumuladoVentas
FROM empleados

-- 1.1. Sacar nombre del que ha hecho mas ventas

Select idEmp
From Ventas
Where unidades in (select  max (unidades);
				From Ventas);

-- 2. Código de proveedores + nº de artículos que suministran

SELECT idPro, idArt
FROM articulos

-- 2.1. Select empleados.idEmp

From empleados inner join (select idEmp, sum (unidades) as “total de unidades”
				From ventas
				Group by idEmp) as T1
		On empleados.idEmp = T1.idEmp

-- 3. Obtener el código de los proveedores y el número de artículos  que suministran

Select idPro, count (idArt) as “Articulos que suministran”
From articulos
Group by idPro

-- 4. Sacar los codigos de los artículos suministrados por proveedores de Granada

select DISTINCT idArt
FROM articulos INNER JOIN (SELECT ciudad FROM proveedores) AS T1
ON T1.ciudad = 'Granada'

-- 5. Saca el departamento con mayor objetivo anual de la empresa

Select top 1 objetivoAnual, idDep, ciudad
From departamentos 
Order by objetivoAnual desc