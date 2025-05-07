// mm         mmmmmm   mmmmm     mmmmmmmm  mmmmmm   
// ##         ""##""   ##"""##   ##""""""  ##""""## 
// ##           ##     ##    ##  ##        ##    ## 
// ##           ##     ##    ##  #######   #######  
// ##           ##     ##    ##  ##        ##  "##m 
// ##mmmmmm   mm##mm   ##mmm##   ##mmmmmm  ##    ## 
// """"""""   """"""   """""     """"""""  ""    """

// Lider que proporciona a las unidades las posiciones para la formacion

//TEAM_ALLIED ############################################

+flag(F): team(100)
  <-
  .print("LIDER");
  +unidades([]);
  +contando;
  .get_medics;
  .get_fieldops;
  .get_backups;
  .wait(1000);
  +organizar;
//  .register_service("organizar");
//  .get_service("organizar");
  .stop.

+myMedics(M): contando
  <-
  ?unidades(U);
  .concat(M, U, U1);
  -+unidades(U1);
  +medicos;
  -myMedics(M).

+myFieldops(F): contando
  <-
  ?unidades(U);
  .concat(F, U, U1);
  -+unidades(U1);
  +fieldops;
  -myFieldops(F).

+myBackups(B): contando
  <-
  ?unidades(U);
  .concat(B, U, U1);
  -+unidades(U1);
  +soldados;
  -myBackups(B).

+organizar: medicos & fieldops & soldados
  <-
  -contando;
  ?unidades(Unidades);
  .length(Unidades,C);
  .print(C);
  +numero(C);
  ?base(Base);
  ?flag(Flag);
  .code(Flag, Base, C, Unidades,H);
  +aenviar([]);
  +enviadas(0);
  +enviarPosiciones(H);
  .length(H, P);
  +numposiciones(P);
  +recibidas([]).

+enviarPosiciones(H): enviadas(E) & numero(C) & E < C
  <-
  ?aenviar(A);
  .nth(E, H, AgPos);
  .nth(0, AgPos, Ag);
  .concat([Ag], A, A1);
  -+aenviar(A1);
  .nth(1, AgPos, Pos);
  .send(Ag, tell,formacion(Pos));
  +enviadas(E+1);
  -enviadas(E);
  -+enviarPosiciones(H).

+llegadafinal
  <-
  ?aenviar(A);
  .send(A, tell, mover);
  ?flag(F);
  .goto(F);
  -llegada.
  
+llegada[source(Ag)]
  <-
  ?recibidas(R);
  .concat([Ag], R, R1);
  -recibidas(R);
  +recibidas(R1);
  .length(R1, C);
  -contador(C-1);
  +contador(C);
  ?numposiciones(L);
  if (C = L){
    +llegadafinal;
    .print("IGUAL");
  } else {.print("NO FINAL");}.
