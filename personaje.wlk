import wollok.game.*
import cultivos.*


object personaje {
	const property cultivosCosechados = []
	var billetera = 0

	var property position = game.center()
	const property image = "fplayer.png"

	method sembrar(cultivo) {
		self.puedeCultivar()
		//cultivo.position(self.position())
		game.addVisual(cultivo)
	}

	method puedeCultivar() {
		if (not game.colliders(self).isEmpty()){
			self.error("Ya hay algo cultivado")
		}
	}

	method regar() {
		self.puedeRegar()

	// OPCION SI SOLO HAY UNA PLANTA
		//const cultivo = game.uniqueCollider(self)
		//cultivo.serRegada()
	// OPCION SI SON MAS DE UN CULTIVO EN LA MISMA POSICION (RIEGA A CADA PLANTA DE LA CELDA)
		game.colliders(self).forEach({ cultivo => cultivo.serRegada() })
	}

	method puedeRegar() {
		if (game.colliders(self).isEmpty()){
			self.error("No se puede regar")
		}
	}

	method cosechar() {
		self.puedeCosechar()
	
	// se cosecha una
		const cultivo = game.uniqueCollider(self)
		self.verificarSiSePuedeCosechar(cultivo)
	}

	method verificarSiSePuedeCosechar(cultivo) {
		if (cultivo.sePuedeCosechar()){
			self.cultivosCosechados().add(cultivo)
			game.removeVisual(cultivo)
		}
	}

	method puedeCosechar() {
		if (game.colliders(self).isEmpty()){
			self.error("no se puede cosechar")
		}
	}

	method vender() {
		self.tieneCultivos()
		self.estaEnMercado()
		
		const mercado = game.uniqueCollider(self)
		const valorDecultivos = self.valorDeCultivosCosechados()

		mercado.compraMercaderia(cultivosCosechados, valorDecultivos)
		billetera = billetera + valorDecultivos
		cultivosCosechados.clear()
	}

	method valorDeCultivosCosechados() = cultivosCosechados.sum({cultivo => cultivo.valorDeVenta()}) 

	method tieneCultivos() {
		if (cultivosCosechados.isEmpty()){
			self.error("No tengo para vender")
		}
	}

	method estaEnMercado() {
		if (not game.colliders(self).any({m => m.esMercado()})){
			self.error("no esta en el mercado")
		}
	}

	///prueba de mercado

	method ponerMercado(mercado) {
		self.puedePonerMercado()
		game.addVisual(mercado)
	}

	method puedePonerMercado() {
		if (not game.colliders(self).isEmpty()){
			self.error("No puede poner mercado")
		}
	}

	method declarar() {
		game.say(self, "Mi patrimonio es" + billetera.toString() + "monedas, y mis cosechas son" + cultivosCosechados.size() + "plantas por vender")
	}
}