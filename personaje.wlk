import wollok.game.*

object personaje {


	var property position = game.center()
	const property image = "fplayer.png"

	method sembrar() {
		self.puedeCultivar()
	}

	method puedeCultivar() {
		if (not game.colliders(self).isEmpty()){
			self.error("Ya hay algo cultivado")
		}
	}

	method regar() {
		self.puedeRegar()
	}

	method puedeRegar() {
		if (game.colliders(self).isEmpty()){
			self.error("No se puede regar")
		}
	}

	method cosechar() {
		self.puedeCosechar()
	}

	method puedeCosechar() {
		if (game.colliders(self).isEmpty()){
			self.error("no se puede cosechar")
		}
	}
}