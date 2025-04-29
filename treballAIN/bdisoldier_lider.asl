//   mmmm      mmmm    mm        mmmmm      mmmmmm   mmmmmmmm  mmmmmm
// m#""""#    ##""##   ##        ##"""##    ""##""   ##""""""  ##""""##
// ##m       ##    ##  ##        ##    ##     ##     ##        ##    ##
//  "####m   ##    ##  ##        ##    ##     ##     #######   #######
//      "##  ##    ##  ##        ##    ##     ##     ##        ##  "##m
// #mmmmm#"   ##mm##   ##mmmmmm  ##mmm##    mm##mm   ##mmmmmm  ##    ##
//  """""      """"    """"""""  """""      """"""   """"""""  ""    """

//TEAM_AXIS ############################################
+flag (F): team(200)
  <-
  .create_control_points(F,50,5,C);
  +control_points(C);
  .length(C,L);
  +total_control_points(L);
  +patrolling;
  +patroll_point(0).

+target_reached(T): patrolling & team(200)
  <-
  ?patroll_point(P);
  -+patroll_point(P+1);
  -target_reached(T).

+patroll_point(P): total_control_points(T) & P<T
  <-
  ?control_points(C);
  .nth(P,C,A);
  .goto(A).

+patroll_point(P): total_control_points(T) & P==T
  <-
  -patroll_point(P);
  +patroll_point(0).


//TEAM_ALLIED ############################################

// 1. Enviar mensaje a todos para que sepan quien es el lider
// 2. Recibir mensaje de todos los soldados
// 3. Usar codigo python para calcular posiciones
//    separar las de soldados, medicos y operarios para facilitar distribución
// 4. Enviar mensaje a soldados con las posciones

// Enviar 'lider' quant estiguen les posicions calculaes o antes

+flag(F): team(100)
  <-
  .goto(F);
  .print("LIDER");
  +unidades([]);
  +contando;
  .get_medics;
  .get_fieldops;
  .get_backups;
  .register_service("organizar");
  .get_service("organizar").

+myMedics(M): contando
  <-
  .print("CONTANDO MEDICOS");
  ?unidades(U);
  .concat(M, U, U1);
  -+unidades(U1);
  +medicos;
  -myMedics(M).

+myFieldops(F): contando
  <-
  .print("CONTANDO OPERARIOS");
  ?unidades(U);
  .concat(F, U, U1);
  -+unidades(U1);
  +fieldops;
  -myFieldops(F).

+myBackups(B): contando
  <-
  .print("CONTANDO SOLDADOS");
  ?unidades(U);
  .concat(B, U, U1);
  -+unidades(U1);
  +soldados;
  -myBackups(B).

+organizar(L): medicos & fieldops & soldados
  <-
  -contando;
  ?unidades(Unidades);
  .length(Unidades,C);
  .print(C);
  ?base(Base);
  ?flag(Flag);
  .code(Flag, Base, C, Unidades,H);
  +enviadas(0);
  +enviarPosiciones(H).

+enviarPosiciones(H): enviadas(E) & E<6
  <-
  .nth(E, H, AgPos);
  .nth(0, AgPos, Ag);
  .nth(1, AgPos, Pos);
  .print(Ag);
  .print(Pos);
  .send(Ag, tell,formacion(Pos));
  +enviadas(E+1);
  -enviadas(E);
  -+enviarPosiciones(H).
