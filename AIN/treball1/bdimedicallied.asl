// mmm  mmm  mmmmmmmm  mmmmm      mmmmmm      mmmm
// ###  ###  ##""""""  ##"""##    ""##""    ##""""#
// ########  ##        ##    ##     ##     ##"
// ## ## ##  #######   ##    ##     ##     ##
// ## "" ##  ##        ##    ##     ##     ##m
// ##    ##  ##mmmmmm  ##mmm##    mm##mm    ##mmmm#
// ""    ""  """"""""  """""      """"""      """"

//TEAM_ALLIED 

+flag (F): team(100) 
  <-
  .print("MEDIC").

+flag_taken: team(100) 
  <-
  .print("TENGO LA BANDERA");
  ?base(B);
  +returning;
  .goto(B);
  -exploring.

+enemies_in_fov(ID,Type,Angle,Distance,Health,Position)
  <- 
  .shoot(3,Position).

+target_reached(T): ayuda_pedida
  <-
  -ayuda_pedida;
  ?flag(F);
  .goto(F).

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

//░█▀█░█░█░▀▀█░█▀█
//░█▀▀░█░█░░░█░█▀█
//░▀░░░▀▀▀░▀▀░░▀░▀

//2
+necesito_ayuda(Pos)[source(A)]: not(ayudando(_,_))
  <-
  ?position(MiPos);
  .send(A, tell, miPosicion(MiPos));
  +ayudando(A,Pos);
  .print("enviada propuesta ayuda").

//4
+aceptopropuesta[source(A)]: ayudando(A,Pos)
  <-
  .print("Aqui tienes un MEDICPACK");
  .cure;
  ?position(P);
  .send(A, tell, propuestaAceptada(P));
  -ayudando(A,Pos).

//4
+niegopropuesta[source(A)]: ayudando(A,Pos)
  <-
  .print("Me cancelan mi propuesta");
  -ayudando(A,Pos).

