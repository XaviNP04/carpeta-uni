//Creencias iniciales para asignar posiciones alrededor de la bandera
valorSold(5).
valorMed(3).
valorField(2).
valorVSold(0).
valorVMed(0).
valorVField(0).


//Cuando empieza asigna posiciones en el mapa para crear dos pentagonos uno interior y otro exterior
//Evalua los puntos para ver cuales son accesibles
+flag([X,Y,Z]): team(200)
    <-
    .register_service("jefe");

    +vertice(1,X+25,0,Z);
    +vertice(2,X+20,0,Z+25);
    +vertice(3,X-24,0,Z+21);
    +vertice(4,X-24,0,Z-17);
    +vertice(5,X+19,0,Z-25);

    +verticeMed(1,X+11, 0, Z-7);  
    +verticeMed(2, X-19, 0, Z+8);
    +verticeMed(3,X+11, 0, Z-19);

    +verticeField(2,X-14, 0, Z-13);
    +verticeField(1,X+3, 0, Z+14); 
    
    !evaluarVerticesSold;
    !evaluarVerticesMed;
    !evaluarVerticesField;


    ?verticeValS(_,A,B,C);
    .goto([A,B,C]).

+!evaluarVerticesSold: valorSold(A) & A >0
<-
?vertice(A,X,Y,Z);
.round(X, X_int);
.round(Z, Z_int);
.round(Y, Y_int);
.puedeir(X_int,Y_int,Z_int,R);
if(R){
    .print("Se puede ir a vertice:",A);
    ?valorVSold(V);
    -+valorVSold(V+1);
    +verticeValS(V+1,X,Y,Z);
    -+valorSold(A-1);
    !evaluarVerticesSold;
}else{
    .print("VerticeSold No valido: ",A);
    -+valorSold(A-1);
    !evaluarVerticesSold;
}.

+!evaluarVerticesSold.

+!evaluarVerticesMed: valorMed(A) & A>0
<-
?verticeMed(A,X,Y,Z);
.round(X, X_int);
.round(Z, Z_int);
.round(Y, Y_int);
.puedeir(X_int,Y_int,Z_int,R);
if(R){
    .print("Se puede ir a vertice:",A);
    ?valorVMed(V);
    -+valorVMed(V+1);
    +verticeValM(V+1,X,Y,Z);
    -+valorMed(A-1);
    !evaluarVerticesMed;
}else{
    .print("VerticeMed No valido: ",A);
    -+valorMed(A-1);
    !evaluarVerticesMed;
}.

+!evaluarVerticesMed.

+!evaluarVerticesField: valorField(A) & A>0
<-
    ?verticeField(A,X,Y,Z);
    .round(X, X_int);
    .round(Z, Z_int);
    .round(Y, Y_int);
    .puedeir(X_int,Y_int,Z_int,R);
    if(R){
        .print("Se puede ir a vertice:",A);
        ?valorVField(V);
        -+valorVField(V+1);
        +verticeValF(V+1,X,Y,Z);
        -+valorField(A-1);
        !evaluarVerticesField;
    }else{
        .print("VerticeField No valido: ",A);
        -+valorField(A-1);
        !evaluarVerticesField;
    }.

+!evaluarVerticesField.


//Asigna posiciones a los soldados, medicos y fieldops de forma dinamica segun las posiciones disponibles

+asignaPos[source(A)]
    <-
    ?valorVSold(X);
    ?verticeValS(X,F,G,H);

    if(X = 1){
        .send(A, tell, ir([F,G,H]) );
    }else{-+valorVSold(X-1);
        .send(A, tell, ir([F,G,H]) );
    }.
    
    
+asignaPosMed[source(A)]
    <-
    ?valorVMed(X);
    if(X = 0){
        ?valorVSold(Y);
        ?verticeValS(Y,F,G,H);
        .send(A, tell, ir([F,G,H]));
    }
    else{
        ?verticeValM(X,F,G,H);
        if(X = 1){
            .send(A, tell, ir([F,G,H]) );
        }else{-+valorMedVal(X-1);
            .send(A, tell, ir([F,G,H]) );
        };
    }.
    

+asignaPosField[source(A)]
    <-
    ?valorVField(X);
    if(X = 0){
        ?valorVSold(Y);
        ?verticeValS(Y,F,G,H);
        .send(A, tell, ir([F,G,H]));
    }else{
        ?verticeValF(X,F,G,H);
        if(X = 1){
            .send(A, tell, ir([F,G,H]) );
        }else{-+valorFieldVal(X-1);
            .send(A, tell, ir([F,G,H]) );
        };
    }.


//Cuando llega a su destino se pone a girar si no esta apoyando a nadie 
+target_reached(T): team(200) & not apoyando
  <-
  .print("En posicion");
  -target_reached(T);
  +mirando([[0,0,0],[250,0,0],[250,0,250],[0,0,250]]);
  +estado(0);
  +girando;
  !agirar.

+target_reached(T): team(200)
    <-
    .print("En posicion2");
    -target_reached(T).

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


//Si recibe un mensaje de que estan atacando manda ayuda a su posicion
+meAtacan(P)[source(A)]: not apoyando
    <-
    .print("Atacan en la posicion:",P);
    +apoyando;
    .goto(P);
    .get_service("soldado").



+soldado(List): meAtacan(P)
    <-
    .print("Pidiendo ayuda a:",List);
    .send(List, tell, ir(P)).

+soldado(List): ataque(P)
    <-
    .print("Pidiendo ayuda a:",List);
    .send(List, tell, ir(P)).

//Disparos
+enemies_in_fov(ID,Type,Angle,Distance,Health,Position): apoyando
    <-
    .stop;
    -apoyando;
    .look_at(Position);
    .shoot(3,Position).

+enemies_in_fov(ID,Type,Angle,Distance,Health,Position): not ataque & not apoyando
    <-
    .look_at(Position);
    +ataque(Position);
    .get_service("soldado");
    .shoot(3,Position).

+enemies_in_fov(ID,Type,Angle,Distance,Health,Position)
    <-
    .look_at(Position);
    .shoot(3,Position).


//Pedir ayuda a medicos y fieldops
+health(H): team(100) & H < 60 & not(ayuda_pedida)
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