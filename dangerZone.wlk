class Empleado{
    var tipoEmpleado

    const habilidades = #{}

    var salud = 100

    method estaIncapacitado() = salud < tipoEmpleado.saludCritica()

    method puedeUsar(habilidad) = (!self.estaIncapacitado() && self.poseeHabilidad(habilidad))

    method poseeHabilidad(habilidad) = habilidades.contains(habilidad)


    

    method unirseA(equipo){//?
        equipo.agregarIntegrante(self)
    }

    method cumplir(mision){
        mision.cumplir(self)
    }

    method daniar(danio){
        const saludFinal = salud - danio

        salud = saludFinal.min(0) 

    }

    method finalizarMision(nuevasHabilidades){
        if (salud > 0)
        {
        tipoEmpleado.completarMision(self, nuevasHabilidades)
        }
    }

    method aprender(nuevasHabilidades){
        habilidades.addAll(nuevasHabilidades)
    }

    method promover(){
        tipoEmpleado = espia
    }

}

class Jefe inherits Empleado{
    const empleados = #{}

    override method puedeUsar(habilidad) = super(habilidad) || self.empleadoPuedeUsar(habilidad)

    method empleadoPuedeUsar(habilidad) = empleados.any({empleado => empleado.puedeUsar(habilidad)})
}

object espia{
    method saludCritica() = 15

    method completarMision(empleado, nuevasHabilidades){
        empleado.aprender(nuevasHabilidades)
    }
}

class Oficinista{
    var estrellas = 0

    method saludCritica() = 40 - 5 * estrellas

    method completarMision(empleado, _){
        estrellas += 1

        if(estrellas >= 3){
            empleado.promover() //poría directamente modificar el puesto desde acá porque el puesto ES parte del Empleado (está acoplado)
        }
    }
}

class Equipo{
    const integrantes = #{}

    method cumplir(mision){
        mision.cumplir(self)
    }

    method puedeUsar(habilidad) = integrantes.any({integrante => integrante.puedeUsar(habilidad)})

    method daniar(danio){
        integrantes.forEach({integrante => integrante.daniar(danio / 3)})
    }

    method finalizarMision(nuevasHabilidades){
    integrantes.forEach({integrante => integrante.finalizarMision(nuevasHabilidades)})
    }

    method agregarIntegrante(integrante){
        integrantes.add(integrante)
    }
}

class Mision{
    const habilidadesNecesarias = #{}

    const peligrosidad = 30

    method cumplir(asignado){
        if (! self.reuneHabilidades(asignado)){
            throw new DomainException(message = "No se pudo cumplir la misión")
        }
            asignado.daniar(self.danio())
            asignado.finalizarMision(habilidadesNecesarias) //finalizan la mision
    }

    method reuneHabilidades(asignado) = habilidadesNecesarias.all({habilidad => asignado.puedeUsar(habilidad)})

    method danio() = peligrosidad //Se delega porque no queda claro como se calcula el danio total, solo se sabe que si es un solo individuo sufre todo el danio total y si es un equipo sufren 1/3 del danio total (funionalidad delegada al equipo). Se implementa que el anio total sea la peligrosidad, pero al estar delegado se puede modificar facilmente
}

const jacinto = new Empleado(tipoEmpleado = espia, habilidades = #{"a", "b", "c"})
const roberto = new Empleado(tipoEmpleado = new Oficinista(), habilidades = #{"d", "e", "f"})
const carlos = new Empleado(tipoEmpleado = new Oficinista(), habilidades = #{"g", "h", "i"})

const mision2 = new Mision(habilidadesNecesarias = #{"d", "g"})
const misionj = new Mision(habilidadesNecesarias = #{"c"})
const misionr = new Mision(habilidadesNecesarias = #{"d"})


const equipo1 = new Equipo(integrantes = #{jacinto, roberto})
const equipo2 = new Equipo(integrantes = #{carlos, roberto})