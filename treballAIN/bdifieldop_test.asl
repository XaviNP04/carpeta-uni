// mmmmmmmm   mmmmmm   mmmmmmmm  mm        mmmmm       mmmm    mmmmmm
// ##""""""   ""##""   ##""""""  ##        ##"""##    ##""##   ##""""#m
// ##           ##     ##        ##        ##    ##  ##    ##  ##    ##
// #######      ##     #######   ##        ##    ##  ##    ##  ######"
// ##           ##     ##        ##        ##    ##  ##    ##  ##
// ##         mm##mm   ##mmmmmm  ##mmmmmm  ##mmm##    ##mm##   ##
// ""         """"""   """"""""  """"""""  """""       """"    ""

//TEAM_AXIS

//TEAM_ALLIED 

+flag (F): team(100) 
  <-
  .print("OPERARIO").

+flag_taken: team(100) 
  <-
  .print("In ASL, TEAM_ALLIED flag_taken");
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
  ?flag(F);
  .look_at(F);
  .goto(F).

+formacion(Pos)
  <-
  +formando;
  .goto(Pos).

//░█▀█░█░█░▀▀█░█▀█
//░█▀▀░█░█░░░█░█▀█
//░▀░░░▀▀▀░▀▀░░▀░▀

//2
+necesito_municion(Pos)[source(A)]: not(proporcionando_municion(_,_))
  <-
  ?position(P);
  .send(A, tell, miMunicion(P));
  +proporcionando_municion(A,P);
  -necesito_municon(_);
  .print("enviada propuesta de municion").

//4
+aceptopropuesta[source(A)]: proporcionando_municion(A,P)
  <-
  .print("Aqui tienes el AMMOPACK");
  .reload;
  ?position(Pos);
  .send(A, tell, propuestaMunAceptada(Pos)).

//4
+niegopropuesta[source(A)]: proporcionando_municion(A,P)
  <-
  .print("Proposicion de municion cancelada");
  -proporcionando_municion(A,P).
