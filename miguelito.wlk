class Plato {
  method peso()
  method aptoCeliaco()
  method valoracion()
  method esEspecial() = self.peso() > 250
  // method precio() = if (self.aptoCeliaco()) {self.valoracion()*300 + 1200} else {self.valoracion()*300}
  method precio() {
    var p = self.valoracion()*300

    if (self.aptoCeliaco()) {
      p += 1200
    }
    return p
  }
}

class Provoleta inherits Plato {

  const peso

  const tieneEmpanado
  
  override method peso() = peso

  override method aptoCeliaco() = !tieneEmpanado

  override method esEspecial() = super() && tieneEmpanado //que pasa si uso una constante numerica como condicional? y una lista?

  override method valoracion() = if(self.esEspecial()) {120} else {80}
}

const provo = new Provoleta(peso = 300, tieneEmpanado = false)

class Hamburguesa inherits Plato {

  const pesoMedallonCarne
  const pan

  override method peso() = pesoMedallonCarne + pan.peso()

  override method aptoCeliaco() = pan.aptoCeliaco()

  override method valoracion() = self.peso() / 10
}

class Pan{
  const peso
  const aptoCeliaco

  method peso() = peso 
  method aptoCeliaco() = aptoCeliaco
}

const industrial = new Pan(peso = 60, aptoCeliaco = false)

const casero = new Pan(peso = 100, aptoCeliaco = false)

const maiz = new Pan(peso = 30, aptoCeliaco = true)

const burga = new Hamburguesa(pesoMedallonCarne = 150, pan = industrial)

class HamburguesaDoble inherits Hamburguesa{

  override method peso() = super() + pesoMedallonCarne

  override method esEspecial() = self.peso() > 500
}

const burga2 = new HamburguesaDoble(pesoMedallonCarne = 150, pan = industrial)

class CorteCarne inherits Plato{

  const estaAPunto

  const peso

  override method esEspecial() = super() && estaAPunto

  override method aptoCeliaco() = true

  override method valoracion() = 100

  override method peso() = peso
}

const corte = new CorteCarne(estaAPunto = false, peso = 300)

class Parrillada inherits Plato{

  const platos = []

  override method peso() = platos.sum({plato => plato.peso()})

  override method esEspecial() = super() && platos.size() >= 3 

  override method aptoCeliaco() = platos.all({plato => plato.aptoCeliaco()})

  override method valoracion() = (platos.max({plato => plato.valoracion()})).valoracion()
}

const parri = new Parrillada(platos = [provo,burga, burga2, corte])

//2 Comensales

class Comensal{

  var tipo

  var dinero

  method dinero() = dinero

  method tipo(nuevoTipo) {
    tipo = nuevoTipo
  }

  method leAgrada(comida) = tipo.leAgrada(comida)

  method darGusto() {
    const platosElegidos = (parrillaMiguelito.platos()).filter({plato => parrillaMiguelito.esElMasCaro(plato) && self.leAgrada(plato) && self.puedePagar(plato)})

    if(platosElegidos.isEmpty())
    {
      throw new DomainException(message="No hay platos para darse un gusto")
    }
    else {
    parrillaMiguelito.vender(platosElegidos.anyOne(), self) //En caso de haber más de una posibilidad elijo cualquiera
    }
  }

  method puedePagar(plato) = dinero >= plato.valoracion()

  method cobrar(plato) { //Le cobran a él
    dinero -= plato.valoracion()
  }

  method pagar(plata) { //Le pagan a él
    dinero += plata
  }

//3

  method tieneProblemasGastricos(){
    tipo = celiaco
  } 

  method seCambiaALaUADE(){
    tipo = finuli
  }

  method esFinuli() = tipo.esFinuli()

  method empobrecer(){
    tipo = cuatroXcuatro
  }
}

object celiaco{ //Debería hacer clases u objetos como en lo panes?
  method leAgrada(comida) = comida.aptoCeliaco()
  method esFinuli() = false
}

object finuli{
  method leAgrada(comida) = comida.esEspecial() || comida.valoracion() > 100
  method esFinuli() = true 
}

object cuatroXcuatro{
  method leAgrada(comida) = true
  method esFinuli() = false
}

const jacinto = new Comensal(tipo = finuli, dinero = 19999)

object parrillaMiguelito{
  const platos = #{provo, burga, burga2, parri}

  const comensales = #{}

  var ingresos = 0

  method platos() = platos

  method precioMasCaro() = platos.max({plato => plato.valoracion()}).valoracion()

  method esElMasCaro(plato) = plato.valoracion() == self.precioMasCaro() //Me baso en el precio y no en un plato particular porque puede haber más de un plato con el mismo caso (es decir, pueden haber más de un plato más caro). Necesito pasarle todos porque puede haber un plato más caro que no le guste y otro que si

  method vender(plato, comensal) {
    comensal.cobrar(plato)
    ingresos += plato.valoracion()
    comensales.add(comensal)
  }

  method hacerPromocion(dinero){
    comensales.forEach({comensal => comensal.pagar(dinero)})
  }

}

//3

object gobierno{
  const ciudadanos = #{jacinto} //Como no se aclara, considero que solo se guarda la informacion de los comensales finos y por tanto no es necesario filtrar entre quienes son finos y quienes no

  method decision(){
    self.comensalesFinos().forEach({comensal => comensal.empobrecer()})
  }

  method comensalesFinos() = ciudadanos.filter({ciudadano => ciudadano.esFinuli()})
}