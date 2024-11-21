class Persona {
  var property efectivo // objeto
  var property tarjetasDeDebito = []
  var property tarjetasDeCredito = []
  var property formaDePagoPreferida = efectivo // Por defecto lo dejo en efectivo
  var property cosasCompradas = #{}
  var property salarioMensual
  
  method puedePagar(costo) = formaDePagoPreferida.puedePagar(costo)

  method comprar(cosa, costo){
    formaDePagoPreferida.comprar(costo)
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

  method pagarCuotas(){
    if()
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
  var compras = []

  method puedePagar(costo) = costo <= maximoPermitido

  method comprar(cosa, costo){
    compras.add(new CompraEnCredito(cosa = cosa, mesDeLaCompra = mes.mesActual(), mesAPagar = mes.mesSiguiente(), costoTotal = costo))
  }

  method 

  /*method pagarCuotas(){
    if(compras.any{compra => compra.mesAPagar() == mes.mesActual()}){
        compras.find{compra => compra.mesAPagar() == mes.mesActual()}
    }
  }*/
}

class CompraEnCredito{
  const cosa
  const mesDeLaCompra
  var property mesAPagar
  const costoTotal

  method costoDeLaCuota(){
    costoTotal + costoTotal * bancoCentral.interesActual()
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
    persona.pagarCuotas()
  }

  method pasanXMeses(cantidad){
    mesActual += cantidad
    if(mesActual > 12){
      mesActual -= 12
    }
  }
}

object bancoCentral {
  var property interesActual = 2
  method cambiarInteres(nuevoInteres){
    interesActual = nuevoInteres
  }
}

object grupo{
  method personaConMasCosasCompradas(grupoDePersonas){
    grupoDePersonas.max{persona => persona.cosasCompradas().size()}
  }
}

object trabajo{
  method cambiarSueldo(persona, nuevoSueldo){
    persona.salarioMensual(nuevoSueldo.max(persona.salarioMensual()))
  }
}
