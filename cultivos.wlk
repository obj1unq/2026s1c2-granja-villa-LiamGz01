import wollok.game.*
import personaje.*


class Maiz {
	var property position
	var property estadoMaiz = cornBaby
	
	method esCultivo() = true 

	method image() = estadoMaiz.image()
	method serRegada() {
		estadoMaiz = cornAdult
	}	
	
	method sePuedeCosechar() = estadoMaiz.esCosechable()

	method valorDeVenta() = 150

	method esMercado() = false
}

object cornBaby {
	method image() = "corn_baby.png" 

	method esCosechable() = false
}

object cornAdult {
	method image() = "corn_adult.png"

	method esCosechable() = true
}

class Trigo {
	var property position
	var property estadoTrigo = trigo00

	method esCultivo() = true
	
	method image() = estadoTrigo.image()
	method serRegada() {
		estadoTrigo = estadoTrigo.siguiente()
	}

	method sePuedeCosechar() = estadoTrigo.esCosechable()

	method valorDeVenta() = estadoTrigo.valorDeVenta()

	method esMercado() = false
}

object trigo00 {
	method image() = "wheat_0.png"

	method siguiente() = trigo01

	method esCosechable() = false

	method valorDeVenta() = 0
}
object trigo01 {
	method image() = "wheat_1.png"

	method siguiente() = trigo02

	method esCosechable() = false

	method valorDeVenta() = 0
}
object trigo02 {
	method image() = "wheat_2.png"

	method siguiente() = trigo03

	method esCosechable() = true

	method valorDeVenta() = 100
}
object trigo03 {
	method image() = "wheat_3.png"

	method siguiente() = trigo00

	method esCosechable() = true

	method valorDeVenta() = 200
}

class Tomaco {
	var property position

	method esCultivo() = true

	method image() = "tomaco.png"

	method sePuedeCosechar() = true

	method valorDeVenta() = 80

	method serRegada() {
		const destino = self.posicionSiguiente()

		if (self.estaLibre(destino)){
			self.position(destino)
		}else{
			self.error("Hay un cultivo arriba")
		}
	}

	method posicionSiguiente() {
		return if(self.position().y() == game.height() - 1 ){
			game.at(self.position().x(),0)
		}else{
			self.position().up(1)
		}
	}

	method estaLibre(posicion) {
		return game.getObjectsIn(posicion).isEmpty()
	}

	method esMercado() = false
}

class Mercado {
	var property position
	var property monedas = 0
	const mercadeciaComprada = []  

	//prueba de mercado
	method image() = "market.png"

	method esMercado() = true 
	method esCultivo() = false

	method compraMercaderia(mercaderia, valorDeVenta) {
		self.tieneMonedas(valorDeVenta)
		monedas = monedas - valorDeVenta
		mercadeciaComprada.addAll(mercaderia)
	}

	method tieneMonedas(valorDeVenta) {
		if (not self.puedeComprar(valorDeVenta)){
			self.error("Mercado tiene monedas para comprar")
		}
	} 

	method puedeComprar(valorDeVenta) = monedas >= valorDeVenta 
}

class Aspersor {
	var property position

	method image() = "aspersor.png"
	method esMercado() = false
	method esCultivo() = false

	method activar() {
		const nombreAspersor = "aspersor_" + position.toString()

		game.onTick(3000, nombreAspersor, {=> self.regarAlrededor()})

	}

	method regarAlrededor() {
        const centro = self.position()
        const posicionesVecinas = [centro.up(1), centro.down(1), centro.left(1), centro.right(1)]

	
		const objetosAlRededor = posicionesVecinas.flatMap({ p => game.getObjectsIn(p) })
		const cultivosEncontrados = objetosAlRededor.filter({c => c.esCultivo()})
		cultivosEncontrados.forEach({c => c.serRegada()})
	
        // posicionesVecinas.forEach({ pos => game.getObjectsIn(pos).forEach({ objeto => 
        //         if (objeto.esUnCultivo()) {
        //             objeto.serRegada() // Delega la acción polimórficamente a la planta
        //         }
        //     })
        // })
    }

}