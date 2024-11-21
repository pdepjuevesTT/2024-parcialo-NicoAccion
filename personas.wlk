class Persona {
  var property efectivo
  var property tarjetasDeDebito = []
  var property tarjetasDeCredito = []
  var property formaDePagoPreferida = efectivo // Por defecto lo dejo en efectivo
  var property cosasCompradas = #{}
  var property salarioMensual
  
  method puedePagar(costo) = formaDePagoPreferida.puedePagar(costo)

  method comprar(cosa, costo){
    formaDePagoPreferida.comprar(cosa, costo)
    cosasCompradas.add(cosa)
  }

  method nuevaTarjetaDeDebito(tarjeta){
    tarjetasDeDebito.add(tarjeta)
    tarjeta.titulares().add(self)
  }

  method nuevaTarjetaDeCredito(tarjeta){
    tarjetasDeCredito.add(tarjeta)
  }

  method cambiarPreferido(nuevoPreferido){
    if(efectivo == nuevoPreferido || tarjetasDeDebito.contains(nuevoPreferido) || tarjetasDeCredito.contains(nuevoPreferido)){
      formaDePagoPreferida = nuevoPreferido
    }
  }
  
}

class Efectivo {
  var property efectivoDisponible
  
  method puedePagar(costo) = costo <= efectivoDisponible
  
  method comprar(cosa, costo) {
    if (self.puedePagar(costo)) {
      efectivoDisponible -= costo
    }
  }

  method pagarCuota(cuota) {
      efectivoDisponible -= cuota
  }
}

class Debito {
  var property saldoDisponible
  var property titulares = #{}
  
  method puedePagar(costo) = costo <= saldoDisponible
  
  method comprar(cosa, costo) {
    if (self.puedePagar(costo)) {
      saldoDisponible -= costo
    }
  }
}

class Credito {
  const maximoPermitido
  const cantidadDeCuotas
  var comprasAPagar = []

  method puedePagar(costo) = costo <= maximoPermitido

  method comprar(cosa, costo){
    comprasAPagar.add(new CompraEnCredito(cosa = cosa, 
                                         mesDeLaCompra = mes.mesActual(), 
                                         mesAPagar = mes.mesSiguiente(), 
                                         costoTotal = costo, 
                                         cuotasRestantes = cantidadDeCuotas,
                                         cantidadDeCuotas = cantidadDeCuotas))
  }

  method tieneCuotasImpagas() = comprasAPagar.size() > 0

}

class CompraEnCredito{
  const cosa
  const mesDeLaCompra
  const cantidadDeCuotas
  var cuotasRestantes
  var cuotasImpagas = []
  var property mesAPagar = mesDeLaCompra + 1
  const costoTotal

  method costoDeLaCuota() = costoTotal / cantidadDeCuotas * bancoCentral.interesActual()

  method pagarCuota(persona){
    if(mes.mesActual() == mesAPagar){
      if(persona.efectivo().puedePagar(self.costoDeLaCuota())){
        persona.efectivo().pagarCuota(self.costoDeLaCuota())
        mesAPagar = mes.mesSiguiente()
        cuotasRestantes -= 1
      } else {
        cuotasImpagas.add(self.costoDeLaCuota())
      }
    }
  }

}

object mes {
  var property mesActual = 1
  
  method mesSiguiente(){
    if(mesActual == 12){
      return 1
    } else {
      return mesActual + 1
    }
  }

  method cambiarMes(persona){
    mesActual = self.mesSiguiente()
    persona.efectivo().efectivoDisponible(persona.efectivo().efectivoDisponible() + persona.salarioMensual())
    persona.efectivo().pagarCuota()
  }

  method pasanXMeses(cantidad){
    mesActual += cantidad
    if(mesActual > 12){
      mesActual -= 12
    }
  }
}

object bancoCentral {
  var property interesActual = 1.2
  method cambiarInteres(nuevoInteres){
    interesActual = nuevoInteres
  }
}

object grupo{
  method personaConMasCosasCompradas(grupoDePersonas) = grupoDePersonas.max{persona => persona.cosasCompradas().size()}
}

object trabajo{
  method cambiarSueldo(persona, nuevoSueldo){
    persona.salarioMensual(nuevoSueldo.max(persona.salarioMensual()))
  }
}
