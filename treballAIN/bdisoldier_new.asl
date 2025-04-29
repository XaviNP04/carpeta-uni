//   mmmm      mmmm    mm        mmmmm      mmmmmm   mmmmmmmm  mmmmmm
// m#""""#    ##""##   ##        ##"""##    ""##""   ##""""""  ##""""##
// ##m       ##    ##  ##        ##    ##     ##     ##        ##    ##
//  "####m   ##    ##  ##        ##    ##     ##     #######   #######
//      "##  ##    ##  ##        ##    ##     ##     ##        ##  "##m
// #mmmmm#"   ##mm##   ##mmmmmm  ##mmm##    mm##mm   ##mmmmmm  ##    ##
//  """""      """"    """"""""  """""      """"""   """"""""  ""    """

//TEAM_AXIS ############################################

//TEAM_ALLIED ############################################

+flag (F): team(100)
  <-
  .print("SOLDADO").

// enviar mensaje a lider

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

// COM COLLONS LI DONE UNA POSICIÓ A CADA UN

+target_reached(T): formando
  <-
  ?flag(F);
  .look_at(F);
  .goto(F).

+formacion(Pos)
  <-
  +formando;
  .goto(Pos).

// NUEVAS FUNCIONES
// ayuda_pedida: 
// enemigos_encontrados:
//
// ACABAR DE COMPLETAR

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
  +propuestas([]);
  +agentes([]);
  .send(M, tell, necesito_ayuda(Pos));
  .wait(1000);
  !!elegirAgente;
  -myMedics(_).

+miPosicion(Pos)[source(A)]: ayuda_pedida
  <-
  .print("Recibo propuesta");
  ?propuestas(B);
  .concat(B,[Pos], B1);
  -+propuestas(B1);
  ?agentes(Ag);
  .concat(Ag,[A], Ag1);
  -+agentes(Ag1);
  -miPosicion(Pos).

+!elegirAgente: propuestas(Pr) & agentes(Ag)
  <-
  .print("Selecciono el mejor: ", Pr, Ag);
  .nth(0, Pr, Pos); // seguramente no necesito la posicion
  .nth(0, Ag, A);
  .send(A, tell, aceptopropuesta);
  .delete(0, Ag, Ag1);
  .send(Ag1, tell, niegopropuesta);
  -+propuestas([]);
  -+agentes([]).

+!elegirAgente: not(propuestas(Pr))
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
  +propuestasMun([]);
  +agentesMun([]);
  .send(F, tell, necesito_municion(Pos));
  .wait(1000);
  !!elegirMunicion;
  -myFieldops(_).

//2
+miMunicion(Pos)[source(A)]: municion_pedida
  <-
  .print("RECIBO PROPUESTA DE MUNICION");
  ?propuestasMun(Pm);
  .concat(Pm, [Pos], Pm1);
  -+propuestasMun(Pm1);
  ?agentesMun(Am);
  .concat(Am, [A], Am1);
  -+agentesMun(Am1);
  -miMunicion(Pos).

//3
+!elegirMunicion: propuestasMun(Pm) & agentesMun(Am)
  <-
  .print("Selecciono operario: ", Pm, Am);
  .nth(0, Pm, Pos);
  .nth(0, Am, A);
  .send(A, tell, aceptopropuesta);
  .delete(0, Am, Am1);
  .send(Am1, tell, niegopropuesta);
  -+propuestas([]);
  -+agentes([]).

+!elegirMunicion: not(propuestasMun(Pm))
  <-
  .print("nadie me puede ayudar");
  -municion_pedida.
