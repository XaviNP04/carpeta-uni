//Cuando empieza busca al jefe y va a la posicion asignada
+flag (F): team(200) 
  <-
  .wait(1100);
  .get_service("jefe").

+jefe(A)
  <-
  .print("El jefe: ",A);
  .send(A,tell,asignaPosField).

+ir(L)[source(_)]
  <-
  .print("Nos movemos gente");
  .goto(L).

//Cuando llega deja un paquete de municion y se pone a girar para busacr enemigos
+target_reached(T):team(200) 
  <-
  .print("En posicion y paquete de municion");
  .reload;
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
  .look_at(Position);
  .shoot(3,Position).

+enemies_in_fov(ID,Type,Angle,Distance,Health,Position)
  <- 
  .look_at(Position);
  .shoot(3,Position).


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
