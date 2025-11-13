(define (problem ZTRAVEL-1-2)
(:domain zeno-travel)
(:objects

	pista_aterrizaje1 - aterrizaje
	pista_aterrizaje2 - aterrizaje
    
	pista_rodaje1 - rodaje
	pista_rodaje2 - rodaje
	pista_rodaje3 - rodaje

    terminal1 - terminal
    terminal2 - terminal
    terminal3 - terminal

    finger1 - finger
    finger2 - finger
    finger3 - finger
    finger4 - finger

    avion1 - avion
    avion2 - avion
    avion3 - avion
    avion4 - avion
    avion5 - avion
    avion6 - avion

    tractor1 - tractor
    tractor2 - tractor
	)
(:init
    (= (distancia pista_aterrizaje1 pista_rodaje1) 8)
    (= (distancia pista_aterrizaje1 pista_rodaje2) 12)
    (= (distancia pista_aterrizaje2 pista_rodaje1) 16)
    (= (distancia pista_aterrizaje2 pista_rodaje3) 8)
    (conectado pista_aterrizaje1 pista_rodaje1)
    (conectado pista_aterrizaje1 pista_rodaje2)
    (conectado pista_aterrizaje2 pista_rodaje1)
    (conectado pista_aterrizaje2 pista_rodaje3)

    (= (distancia pista_rodaje1 pista_rodaje2) 8)
    (= (distancia pista_rodaje2 pista_rodaje1) 8)
    (= (distancia pista_rodaje2 pista_rodaje3) 4)
    (= (distancia pista_rodaje3 pista_rodaje2) 4)
    (conectado pista_rodaje1 pista_rodaje2)
    (conectado pista_rodaje2 pista_rodaje1)
    (conectado pista_rodaje2 pista_rodaje3)
    (conectado pista_rodaje3 pista_rodaje2)

    (= (distancia pista_rodaje1 terminal1) 20)
    (= (distancia pista_rodaje1 terminal2) 20)
    (= (distancia pista_rodaje1 terminal3) 24)
    (= (distancia pista_rodaje2 terminal2) 12)
    (= (distancia pista_rodaje2 terminal3) 12)
    (= (distancia pista_rodaje3 terminal3) 20)
    (conectado pista_rodaje1 terminal1)
    (conectado pista_rodaje1 terminal2)
    (conectado pista_rodaje1 terminal3)
    (conectado pista_rodaje2 terminal2)
    (conectado pista_rodaje2 terminal3)
    (conectado pista_rodaje3 terminal3)

    (= (distancia terminal1 terminal2) 8)
    (= (distancia terminal2 terminal1) 8)
    (= (distancia terminal2 terminal3) 12)
    (= (distancia terminal3 terminal2) 12)
    (conectado terminal1 terminal2)
    (conectado terminal2 terminal1)
    (conectado terminal2 terminal3)
    (conectado terminal3 terminal2)

    (esta finger1 terminal1)
    (esta finger2 terminal2)
    (esta finger3 terminal3)
    (esta finger4 terminal3)

    (velocidad avion1 2)
    (velocidad avion2 2)
    (velocidad avion3 4)
    (velocidad avion4 4)
    (velocidad avion5 2)
    (velocidad avion6 2)

    (velocidad tractor1 1)
    (velocidad tractor2 1)

    (bateria tractor1 4)
    (bateria tractor2 2)

    (duracion_carga tractor1 10)
    (duracion_carga tractor2 14)

    (at avion1 pista_aterrizaje1)
    (at avion2 pista_aterrizaje2)
    (ocupado finger1)
    (ocupado finger2)
    (ocupado finger3)
    (ocupado finger4)
    (at tractor1 terminal2)
    (at tractor2 pista_rodaje2)
    
)

(:goal (and
	(at avion1 finger1)
	(at avion2 finger3)
	(at avion3 pista-aterrizaje1)
    (at avion4 pista-aterrizaje2)
    (at avion5 pista-aterrizaje2)
    (at avion6 pista-aterrizaje1)
    (at tractor1 terminal1)
    (at tractor2 terminal2)
	)
)

(:metric minimize (+ (* 0.5 (total-time)) (* 10 (numero-recargas))))
)
