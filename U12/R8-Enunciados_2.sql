-- 1. Crear una serie de tablas historicas donde se van a guardar todos los elementos
-- que borre en mi base de datos. 

-- Crear las tablas:
-- historicoEmpleados(nombre, direccion, telefono, fechaBaja)
-- historicoArticulos()
-- historicoDepartamentos()
-- historicoProveedores()
-- para que quiero historicoVentas? no quiero borrar ninguna venta!
-- en todo caso un trigger para que no se pueda borrar ninguna venta


-- 2. Dar de alta un empleado       NO HAY PROBLEMA
-- 3. Dar de baja un empleado       no hay problema PERO hay que guardarlo en su correspondiente tabla HISTORICOS
-- 4. Dar de alta un articulo       NO HAY PROBLEMA
-- 5. Dar de baja un articulo       no hay problema PERO hay que guardarlo en su correspondiente tabla HISTORICOS

-- 6. Dar de alta un departamento   NO HAY PROBLEMA
-- 7. Dar de baja un departamento   LLAVE EXTERNA EN EMPLEADOS

-- 8. Dar de alta un proveedor      NO HAY PROBLEMA
-- en general para cualquier alta el disparador comprobara que no este ya dado de alta mediante el identificador.

-- 9. Dar de baja un proveedor      LLAVE EXTERNA EN ARTICULOS

-- 10. hacer una venta: insertar en VENTAS, actualizar en ARTICULOS y quizas hacer un pedido a proveedores
-- cuando las existencias queden por debajo del stock minimo
-- habra que crear la tabla pedidoProveedores(idArt, idPro, cantidad, fechaPedido)