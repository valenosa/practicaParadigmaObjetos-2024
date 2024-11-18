class ConsumidorFinal  {
  method impuesto(monto) {}
}

class ResponsableInscripto {
  method impuesto(monto) {}
}

class ResponsableNoInscripto {
  method impuesto(monto) {}
}

class Cliente {
  const condicionIVA = new ConsumidorFinal() 
  var saldo

  	method comprar(producto) {
    saldo += condicionIVA.impuesto(producto.precio())
  	}
}

class Producto {
method precio() = 0
}

class ProductoEspecial inherits Producto {
override method precio() {}
}



