
;------------------------------- VARIABLES DIFUSASA ---------------------------------------

(deftemplate carga-actual 0 100 % 	;VARIABLE DIFUSA Y UNIVERSO
	( 				;VALORES DIFUSOS
	 (vacio (0 1) (20 1) (30 0))
	 (medio (20 0) (40 1) (50 1) (60 0))
	 (recomendado (50 0) (60 1) (70 1) (90 0))
	 (completo (80 0) (90 1))
	)
)

(deftemplate proximo-viaje 0 400 km 	;VARIABLE DIFUSA Y UNIVERSO
	(				;VALORES DIFUSOS
	 (breve (100 1) (150 0))
	 (estandar (100 0) (150 1) (200 1) (300 0))
	 (largo (200 0) (300 1))
	)
)

(deftemplate tipo-carga 2 20 kW 	;VARIABLE DIFUSA Y UNIVERSO
	(				;VALORES DIFUSOS
	 (lenta (2 0) (4 1) (8 0))
	 (media (6 0) (10 1) (14 1) (16 0))
	 (rapida (14 0) (16 1))
	)
)

(deftemplate tiempo-carga 10 480 min 	;VARIABLE DIFUSA Y UNIVERSO
	(				;VALORES DIFUSOS
	 (corta-duracion (10 0) (40 1) (60 0))
	 (media-duracion (40 0) (90 1) (120 1) (180 0))
	 (larga-duracion (120 0) (240 1))
	)
)

;------------------------------- REGLAS DIFUSAS ---------------------------------------

(defrule tipo-carga-media1
	(carga-actual vacio) (proximo-viaje breve)  =>  (assert (tipo-carga media))
)

(defrule tipo-carga-media2
	(carga-actual medio) (proximo-viaje largo)  =>  (assert (tipo-carga media))
)

(defrule tipo-carga-lenta1
	(carga-actual medio) (proximo-viaje breve)  =>  (assert (tipo-carga lenta))
)

(defrule tipo-carga-lenta2
	(carga-actual recomendado) (proximo-viaje largo)  =>  (assert (tipo-carga lenta))
)

(defrule tipo-carga-very-lenta1
	(carga-actual recomendado) (proximo-viaje breve)  =>  (assert (tipo-carga very lenta))
)

(defrule tipo-carga-very-lenta2
	(carga-actual recomendado) (proximo-viaje estandar)  =>  (assert (tipo-carga very lenta))
)

(defrule tipo-carga-very-lenta3
	(carga-actual completo) (proximo-viaje largo)  =>  (assert (tipo-carga very lenta))
)

(defrule tipo-carga-extremely-lenta1
	(carga-actual completo) (proximo-viaje breve)  =>  (assert (tipo-carga extremely lenta))
)

(defrule tipo-carga-extremely-lenta2
	(carga-actual completo) (proximo-viaje estandar)  =>  (assert (tipo-carga extremely lenta))
)

(defrule tipo-carga-somewhat-media
	(carga-actual medio ) (proximo-viaje estandar ) =>  (assert (tipo-carga somewhat media))
)

(defrule tipo-carga-more-or-less-rapida
	(carga-actual vacio ) (proximo-viaje estandar ) =>  (assert (tipo-carga more-or-less rapida))
)

(defrule tipo-carga-very-rapida
	(carga-actual vacio ) (proximo-viaje largo ) =>  (assert (tipo-carga very rapida))
)


(defrule tiempo-carga-extremely-media-duracion
	(carga-actual vacio) (proximo-viaje breve)  => (assert (tiempo-carga extremely media-duracion))
)

(defrule tiempo-carga-somewhat-larga-duracion
	(carga-actual medio ) (proximo-viaje breve )  =>  (assert (tiempo-carga somewhat larga-duracion))
)

(defrule tiempo-carga-media-duracion1
    (carga-actual recomendado ) (proximo-viaje breve)  =>  (assert (tiempo-carga media-duracion))
)

(defrule tiempo-carga-media-duracion2
    (carga-actual medio ) (proximo-viaje estandar)  =>  (assert (tiempo-carga media-duracion))
)

(defrule tiempo-carga-media-duracion3
	(carga-actual recomendado ) (proximo-viaje estandar )  =>  (assert (tiempo-carga media-duracion))
)

(defrule tiempo-carga-media-duracion4
	(carga-actual vacio ) (proximo-viaje largo )  =>  (assert (tiempo-carga media-duracion))
)

(defrule tiempo-carga-extremely-corta-duracion
	(carga-actual completo ) (proximo-viaje breve ) => (assert (tiempo-carga extremely corta-duracion))
)

(defrule tiempo-carga-larga-duracion
	(carga-actual vacio ) (proximo-viaje estandar )	=> (assert (tiempo-carga larga-duracion))
)

(defrule tiempo-carga-very-corta-duracion
	(carga-actual completo ) (proximo-viaje estandar ) => (assert (tiempo-carga very corta-duracion))
)

(defrule tiempo-carga-more-or-less-larga-duracion
	(carga-actual medio ) (proximo-viaje largo )  =>  (assert (tiempo-carga more-or-less larga-duracion))
)

(defrule tiempo-carga-corta-duracion1
	(carga-actual recomendado ) (proximo-viaje largo)  =>  (assert (tiempo-carga corta-duracion))
)

(defrule tiempo-carga-corta-duracion2
	(carga-actual completo ) (proximo-viaje largo )  =>  (assert (tiempo-carga corta-duracion))
)

;------------------------------- TEMPLATE/CLASE BATERIA ---------------------------------------

(deftemplate bateria
	(slot carga-actual-crisp (type FLOAT))
	(slot proximo-viaje-crisp (type FLOAT))  
	(slot mom-tipo-carga-crisp (type FLOAT))  
	(slot max-tipo-carga-crisp (type FLOAT))  
	(slot mom-tiempo-carga-crisp (type FLOAT))
	(slot max-tiempo-carga-crisp (type FLOAT))
)

; INSTANCIA 

(deffacts bateria-inicial
   (bateria   
   (carga-actual-crisp 0.0) 
   (proximo-viaje-crisp 0.0) 
   (mom-tipo-carga-crisp 0.0) 
   (max-tipo-carga-crisp 0.0) 
   (mom-tiempo-carga-crisp 0.0) 
   (max-tiempo-carga-crisp 0.0)
   )
)

; ------------------ REGLA: PEDIR DATOS AL USUARIO ------------------

(defrule pedir-datos
   (initial-fact)
   ?b <- (bateria)
   =>
   (printout t "Introduce carga actual de la bateria (0-100): " )
   (bind ?carga (read))
   (printout t crlf)
   (printout t "Introduce distancia del proximo viaje (km): " )
   (bind ?viaje (read))
   (printout t crlf)
   (modify ?b (carga-actual-crisp ?carga) (proximo-viaje-crisp ?viaje))
   (printout t "Valores almacenados: carga-actual-crisp=" ?carga "  proximo-viaje-crisp=" ?viaje crlf)
)
; ------------------ REGLA: FUZZIFICAR ------------------

(deffunction fuzzify (?fztemplate ?value ?delta)
  (bind ?low (get-u-from ?fztemplate))
  (bind ?hi  (get-u-to   ?fztemplate))

  (if (<= ?value ?low)
    then
      (assert-string
         (format nil "(%s (%g 1.0) (%g 0.0))" ?fztemplate ?low ?delta))
    else
      (if (>= ?value ?hi)
        then
          (assert-string
             (format nil "(%s (%g 0.0) (%g 1.0))"
                     ?fztemplate (- ?hi ?delta) ?hi))
        else
          (assert-string
             (format nil "(%s (%g 0.0) (%g 1.0) (%g 0.0))"
                     ?fztemplate (max ?low (- ?value ?delta))
                                 ?value (min ?hi (+ ?value ?delta)) )))))


(defrule fuzzificar-valores
   ?b <- (bateria (carga-actual-crisp ?c) (proximo-viaje-crisp ?v))
   =>
   (fuzzify carga-actual ?c 5)    ; delta = 5 (porcentaje)
   (fuzzify proximo-viaje ?v 10)  ; delta = 10 (km)
)

; ------------------ REGLA: DEFUSIFICAR, GUARDAR Y MOSTRAR RESULTADOS ------------------

(defrule defusificar-y-guardar
   (declare (salience -100))
   ?b <- (bateria)
   ?tc <- (tipo-carga ?ft)
   ?ti <- (tiempo-carga ?fi)
   (not (evaluated))
   =>
   (bind ?mom-tipo (moment-defuzzify ?ft))
   (bind ?max-tipo (maximum-defuzzify ?ft))
   (bind ?mom-tiempo (moment-defuzzify ?fi))
   (bind ?max-tiempo (maximum-defuzzify ?fi))

   (modify ?b 
       (mom-tipo-carga-crisp ?mom-tipo)
       (max-tipo-carga-crisp ?max-tipo)
       (mom-tiempo-carga-crisp ?mom-tiempo)
       (max-tiempo-carga-crisp ?max-tiempo)
   )

   (printout t crlf "=== RESULTADOS ===" crlf
             "mom-tipo-carga-crisp: " ?mom-tipo crlf
             "max-tipo-carga-crisp: " ?max-tipo crlf
             "mom-tiempo-carga-crisp: " ?mom-tiempo crlf
             "max-tiempo-carga-crisp: " ?max-tiempo crlf crlf)

   (assert (evaluated))
   (halt)
)
