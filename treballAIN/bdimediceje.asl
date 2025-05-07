//Inicia y espera ordenes del jefe y va a la posicion indicada
+flag (F): team(200) 
  <-
    .wait(1100);
    .get_service("jefe").

+jefe(A)
  <-
  .print("El jefe: ",A);
  .send(A,tell,asignaPosMed).

+ir(L)[source(_)]
  <-
  .print("Nos movemos gente");
  .goto(L).


//Cuando llega a la posicion se pone a girar para buscar enemigos
+target_reached(T):team(200) 
  <-
  .print("En posicion y paquete de cura");
  .cure;
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

