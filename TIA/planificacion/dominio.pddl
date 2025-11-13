(define (domain zeno-travel)
(:requirements :durative-actions :typing :fluents)
(:types
vehiculo
pista

avion tractor - vehiculo
aterrizaje rodaje - pista
terminal
finger

)

;; BOOLEANO
(:predicates    (at ?x - vehiculo ?l - (either terminal pista rodaje))
                (esta ?f - finger ?t - terminal)
                (tiene ?t - tractor ?a - avion)
                (disponible ?a - vehiculo)
                (ocupado ?f - finger)
                (remolcado ?a - avion)
                (conectado ?c1 - (either pista terminal rodaje) ?c2 - (either pista terminal rodaje))
                (aparcado ?a - avion ?f - finger)
                (libre ?c - cargador)
                (ubicado ?x - (either cargador finger) ?t - terminal)

)

;; NUMERICO
(:functions
    (velocidad ?v - vehiculo)
    (distancia ?d1 - (either pista terminal rodaje) ?d2 - (either pista terminal rodaje))
    (bateria ?t - tractor)
    (duracion_carga ?t - tractor)
    (num_recargas)
)

;; MOVER AVION
(:durative-action mover_avion
 :parameters (?a - avion ?p1 ?p2 - pista)
 :duration (= ?duration (/ (distancia ?p1 ?p2) (velocidad ?a)))
 :condition (and (at start (at ?a ?p1))
                 (disponible ?a)
                 (over all (conectado ?p1 ?p2)))
 :effect (and (at start (not (at ?a ?p1)))
              (at start (not (disponible ?a)))
              (at end (at ?a ?p2)))
              (at end (disponible ?a))
)

;; MOVER TRACTOR
(:durative-action mover_tractor
 :parameters (?t - tractor ?p1 ?p2 - (either rodaje terminal))
 :duration (= ?duration (/ (distancia ?p1 ?p2) (velocidad ?t)))
 :condition (and (at start (at ?t ?p1))
                 (disponible ?t)
                 (at start (>= (bateria ?t) 2))
                 (over all (conectado ?p1 ?p2)))
 :effect (and (at start (not (at ?t ?p1)))
              (at start (not (disponible ?t)))
              (at end (at ?t ?p2))
              (at end (decrease (bateria ?t) 2)))
              (at end (disponible ?t))
)

;; REMOLCAR
(:durative-action remolcar
 :parameters (?a - avion ?t - tractor ?p1 ?p2 - (either rodaje terminal))
 :duration (= ?duration (/ (* (distancia ?p1 ?p2) 2) (velocidad ?t)))
 :condition (and (at start (at ?t ?p1))
                (at start (at ?a ?p1))
                (at start (>= (bateria ?t) 4))
                (at start (disponible ?a))
                (at start (disponible ?t))
                (over all (tiene ?t ?a))
                (over all (conectado ?p1 ?p2)))
 :effect (and (at start (remolcado ?a))
              (at start (not (at ?t ?p1)))
              (at start (not (disponible ?a)))
              (at start (not (disponible ?t)))
              (at end (not (remolcado ?a)))
              (at end (not (at ?a ?p1)))
              (at end (at ?a ?p2))
              (at end (at ?t ?p2))
              (at end (decrease (bateria ?t) 4)))
              (at start (disponible ?a))
              (at start (disponible ?t))

)

;; DESPLEGAR FINGER
(:durative-action desplegar_finger
 :parameters (?f - finger ?a - avion ?t - terminal)
 :duration (= ?duration 2)
 :condition (and (at start (at ?a ?t))
                 (at start (ubicado ?f ?t))
                 (at start (not (ocupado ?f)))
                 (at start (not (remolcado ?a))))
 :effect (and (at start (ocupado ?f))
              (at start (not (ocupado ?a)))
              (at start (not (disponible ?a)))
              (at end (aparcado ?a ?f)))
)

;; REPLEGAR FINGER
(:durative-action replegar_finger
 :parameters (?f - finger ?a - avion ?t - terminal)
 :duration (= ?duration 2)
 :condition (and (at start (aparcado ?a ?f))
                 (over all (ubicado ?f ?t))
                 (over all (at ?a ?t)))
 :effect (and (at end (not (aparcado ?a ?f)))
              ()
              (at end (not (ocupado ?f))))
)

;; RECARGAR
(:durative-action recargar
 :parameters (?t - tractor ?c - cargador ?term - terminal)
 :duration (= ?duration (duracion_carga ?t))
 :condition (and (at start (at ?t ?term))
                 (at start (ubicado ?c ?term))
                 (at start (<= (bateria ?t) 6))
                 (at start (libre ?c)))
 :effect (and (at start (not (libre ?c)))
              (at end (libre ?c))
              (at end (assign (bateria ?t) 10))
              (at end (increase (num_recargas) 1)))
)

)