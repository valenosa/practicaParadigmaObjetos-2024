class Empleado{
    var tipoEmpleado

    const habilidades = #{}

    const empleados = #{}

    var salud = 75

    method estaIncapacitado() = salud < tipoEmpleado.saludCritica()

    method puedeUsar(habilidad) = (!self.estaIncapacitado() && habilidades.contains(habilidad)) || self.empleadoPuedeUsar(habilidad)

    method empleadoPuedeUsar(habilidad) = empleados.any({empleado => empleado.puedeUsar(habilidad)})

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

    method recompensar(nuevasHabilidades){
        if (salud > 0)
        {
        tipoEmpleado.recompensar(self, nuevasHabilidades)
        }
    }

    method aprender(nuevasHabilidades){
        habilidades.addAll(nuevasHabilidades)
    }

    method promover(){
        tipoEmpleado = espia
    }

}

object espia{
    method saludCritica() = 15

    method recompensar(empleado, nuevasHabilidades){
        empleado.aprender(nuevasHabilidades)
    }
}

class Oficinista{
    var estrellas = 0

    method saludCritica() = 40 - 5 * estrellas

    method recompensar(empleado, _){
        estrellas += 1

        if(estrellas >= 3){
            empleado.promover()
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

    method recompensar(nuevasHabilidades){
    integrantes.forEach({integrante => integrante.recompensar(nuevasHabilidades)})
    }

    method agregarIntegrante(integrante){
        integrantes.add(integrante)
    }
}

class Mision{
    const habilidadesNecesarias = #{}

    const peligrosidad = 30

    method cumplir(participante){
        if (habilidadesNecesarias.all({habilidad => participante.puedeUsar(habilidad)})){
            participante.daniar(self.danio())
            participante.recompensar(habilidadesNecesarias) //completan la mision
        }
        else {
            throw new DomainException(message = "No se pudo cumplir la misión")
        }
    }

    method danio() = peligrosidad //Se entiende que la intención del enunciado es que se pierda la cantidad de vida equivalente a la peligrosidad, pero se delega para que en caso de ser necesario se pueda modificar facilmente
}

const jacinto = new Empleado(tipoEmpleado = espia, habilidades = #{"a", "b", "c"})
const roberto = new Empleado(tipoEmpleado = new Oficinista(), habilidades = #{"d", "e", "f"})
const carlos = new Empleado(tipoEmpleado = new Oficinista(), habilidades = #{"g", "h", "i"})

const mision2 = new Mision(habilidadesNecesarias = #{"d", "g"})
const misionj = new Mision(habilidadesNecesarias = #{"c"})
const misionr = new Mision(habilidadesNecesarias = #{"d"})


const equipo1 = new Equipo(integrantes = #{jacinto, roberto})
const equipo2 = new Equipo(integrantes = #{carlos, roberto})