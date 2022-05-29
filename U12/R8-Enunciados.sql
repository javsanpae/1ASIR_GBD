
-- antecedentes de hecho ejercicios 9 10 11 y 12 de la relacion 7 y otros similares

-- cual es el problema fundamental al insertar en una tabla? que ya exista algo que queremos crear, por lo que da error

-- si quiero insertar un empleado y ese codigo ya es usado, da error

-- disparador que verifique que se puede borrar, bien porque ya esta ese elemento y (muy importante) porque la organizacion me lo permita borrar

-- no se podra borrar un proveedor si algun articulo se quedara sin dicho proveedor

-- como norma, todos aquellos elementos que se borren los vamos a guardar en un historico, por lo tanto tenemos que crear las siguientes tablas:
-- historicoArticulos
-- historicoEmpleados
-- historicoProveedores

-- por otra parte, tambien en este ejercicio vamos a crear la tabla pedidos a proveedores 
-- (idProveedor, idArticulo, cantidad, fechaPedido, fechaEntradaArticulo)

-- cuando se va a insertar una tupla? se va a insertar cuando una venta y la cantidad resultante que este por debajo del stock minimo

-- aparte, habra que decidir que cantidad vamos a pedir de articulos

-- que es para ti hacer una venta?

-- hacer una venta es insertar en ventas.

-- antes tengo que comprobar que tengo suficientes unidades para vender. si no hay, no hago el insert

-- todo eso lo controlan los disparadores (triggers)




                                        -- RELACION 8 TRIGGERS

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

-- tambien vamos a tener la tabla pedidosAproveedores, donde se insertara una tupla
-- cada vez que las existencias de un determinado articulo queden por debajo de su stock minimo
-- despues de una venta