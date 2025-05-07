//   mmmm      mmmm    mm        mmmmm      mmmmmm   mmmmmmmm  mmmmmm
// m#""""#    ##""##   ##        ##"""##    ""##""   ##""""""  ##""""##
// ##m       ##    ##  ##        ##    ##     ##     ##        ##    ##
//  "####m   ##    ##  ##        ##    ##     ##     #######   #######
//      "##  ##    ##  ##        ##    ##     ##     ##        ##  "##m
// #mmmmm#"   ##mm##   ##mmmmmm  ##mmm##    mm##mm   ##mmmmmm  ##    ##
//  """""      """"    """"""""  """""      """"""   """"""""  ""    """

//TEAM_ALLIED ############################################

+flag (F): team(100)
  <-
  .print("SOLDADO").

+flag_taken: team(100)
  <-
  .print("In ASL, TEAM_ALLIED flag_taken");
  ?base(B);
  +returning;
  .goto(B);
  -exploring.

+target_reached(T): ayuda_pedida
  <-
  -ayuda_pedida;
  ?flag(F);
  .goto(F).

+enemies_in_fov(ID,Type,Angle,Distance,Health,Position)
  <- 
  .shoot(3,Position).

+target_reached(T): formando
  <-
  -formando;
  ?flag(F);
  .look_at(F);
  ?lider(L);
  .send(L, tell, llegada).

+mover
  <-
  .print("mover");
  ?flag(F);
  .goto(F).

+target_reached(T)
  <-
  ?base(B);
  .goto(B).

+formacion(Pos)[source(A)]
  <-
  +lider(A);
  +formando;
  .goto(Pos).

// NUEVAS FUNCIONES

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
  -+agentes(Ag1);
  -miPosicion(Pos).

+!elegirAgente
  <-
  ?agentes(Ag);
  .length(Ag, L);
  if(L > 0){
  .print("Selecciono el mejor: ", Ag);
  .nth(0, Ag, A);
  .send(A, tell, aceptopropuesta);
  .delete(0, Ag, Ag1);
  .send(Ag1, tell, niegopropuesta);
  -+agentes([]);
  } else {
  -ayuda_pedida;
  .print("NADIE ME PUEDE AYUDAR");
  }.

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
  -+agentesMun(Am1);
  -miMunicion(Pos).

//3
+!elegirMunicion
  <-
  ?agentesMun(Am);
  .length(Am, L);
  if(L > 0) {
  .print("Selecciono operario: ", Am);
  .nth(0, Am, A);
  .send(A, tell, aceptopropuesta);
  .delete(0, Am, Am1);
  .send(Am1, tell, niegopropuesta);
  -+agentes([]);
  } else {
  -municion_pedida;
  .print("NADIE ME PUEDE DAR MUNICION");
  }.

