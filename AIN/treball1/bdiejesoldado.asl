//Cuando empieza busca al jefe para que le de indicaciones y se dirige al objetivo
+flag(F): team(200)
<-
  .register_service("soldado");
  .wait(1100);
  .get_service("jefe").


//Si esta atacando envia mensaje al jefe para que acudan refuerzos
+jefe(A): ataque
  <-
    .print("Enviando mensaje al jefe");
    ?position(P);
    .send(A,tell, meAtacan(P));
    -jefe(A).

+jefe(A)
  <-
  .print("El jefe: ",A);
  .send(A,tell,asignaPos);
  -jefe(A).

+ir(L)[source(_)]: ataque
  <-
  .print("No voy q estoy peleando").

+ir(L)[source(_)]
  <-
  +movimiento;
  .goto(L).


//Llega a posicion indicada y se pone a girar para encontrar enemigos
+target_reached(T): team(200)
  <-
  .print("En posicion");
  -target_reached(T);
  +mirando([[0,0,0],[250,0,0],[250,0,250],[0,0,250]]);
  +estado(0);
  +girando;
  !agirar.

+!agirar: estado(E) & E<4 & girando
    <-
    ?mirando(L);
    .nth(E, L, P);
    .look_at(P);
    .wait(1000);
    -estado(_);
    +estado(E+1);
    !agirar.

+!agirar: estado(E) & E=4 & girando
    <-
    -estado(_);
    +estado(0);
    !agirar.

+!agirar.

//Disparos
+enemies_in_fov(ID,Type,Angle,Distance,Health,Position): girando
  <-
    -girando;
    +ataque;
    .look_at(Position);
    .print("Enemigo detectado, paro de girar y ataco");
    .get_service("jefe").

+enemies_in_fov(ID,Type,Angle,Distance,Health,Position):movimiento
  <-
  .print("me paro y disparo");
  .stop;
  -movimiento;
  .look_at(Position);
  .shoot(3,Position).

+enemies_in_fov(ID,Type,Angle,Distance,Health,Position)
  <-
  .look_at(Position);
  .shoot(3,Position).


//Pedir ayuda a medicos y fieldops
+health(H): team(100) & H < 50 & not(ayuda_pedida)
  <-
  .print("POCA VIDA");
  +ayuda_pedida;
  .get_medics.

+ammo(A): team(100) & A < 50 & not(municion_pedida)
  <-
  .print("POCA MUNICION");
  +municion_pedida;
  .get_fieldops.


//░█▀█░█░█░▀▀█░█▀█░░░█▄█░█▀▀░█▀▄░▀█▀░█▀▀░█▀█
//░█▀▀░█░█░░░█░█▀█░░░█░█░█▀▀░█░█░░█░░█░░░█░█
//░▀░░░▀▀▀░▀▀░░▀░▀░░░▀░▀░▀▀▀░▀▀░░▀▀▀░▀▀▀░▀▀▀

+propuestaAceptada(P)[source(A)]: ayuda_pedida
  <-
  .print("De camino a por ayuda");
  .goto(P).

+myMedics(M): ayuda_pedida
  <-
  .print("Pido ayuda medica");
  ?position(Pos);
  +agentes([]);
  .send(M, tell, necesito_ayuda(Pos));
  .wait(1000);
  !!elegirAgente;
  -myMedics(_).

+miPosicion(Pos)[source(A)]: ayuda_pedida
  <-
  .print("Recibo propuesta");
  ?agentes(Ag);
  .concat(Ag,[A], Ag1);
  .length(Ag1, C);
  +numMedicos(C);
  -+agentes(Ag1);
  -miPosicion(Pos).

+!elegirAgente: agentes(Ag) & numMedicos(C)
  <-
  if(C > 0){
  .print("Selecciono el mejor: ", Ag);
  .nth(0, Ag, A);
  .send(A, tell, aceptopropuesta);
  .delete(0, Ag, Ag1);
  .send(Ag1, tell, niegopropuesta);
  -+agentes([]);
  }
  else{.print("NO QUEDAN MEDICOS");}.

+!elegirAgente
  <-
  .print("nadie me puede ayudar");
  -ayuda_pedida.

//░█▀█░█░█░▀▀█░█▀█░░░█▀█░█▀█░█▀▀░█▀▄░█▀█░█▀▄░▀█▀░█▀█
//░█▀▀░█░█░░░█░█▀█░░░█░█░█▀▀░█▀▀░█▀▄░█▀█░█▀▄░░█░░█░█
//░▀░░░▀▀▀░▀▀░░▀░▀░░░▀▀▀░▀░░░▀▀▀░▀░▀░▀░▀░▀░▀░▀▀▀░▀▀▀

+propuestaMunAceptada(P)[source(A)]: municion_pedida
  <-
  .print("Voy a por municion");
  .goto(P).

//1
+myFieldops(F): municion_pedida
  <-
  .print("Pido ayuda operario");
  ?position(Pos);
  +agentesMun([]);
  .send(F, tell, necesito_municion(Pos));
  .wait(1000);
  !!elegirMunicion;
  -myFieldops(_).

//2
+miMunicion(Pos)[source(A)]: municion_pedida
  <-
  .print("RECIBO PROPUESTA DE MUNICION");
  ?agentesMun(Am);
  .concat(Am, [A], Am1);
  .length(Am1, C);
  +numOperarios(C);
  -+agentesMun(Am1);
  -miMunicion(Pos).

//3 propuestasMun(Pm) &
+!elegirMunicion:  agentesMun(Am) & numOperarios(C)
  <-
  if(C > 0){
  .print("Selecciono operario: ", Am);
  .nth(0, Am, A);
  .send(A, tell, aceptopropuesta);
  .delete(0, Am, Am1);
  .send(Am1, tell, niegopropuesta);
  -+propuestas([]);
  -+agentes([]);
  }
  else{.print("NO QUEDAN OPERARIOS");}.

+!elegirMunicion
  <-
  .print("nadie me puede ayudar");
  -municion_pedida.
