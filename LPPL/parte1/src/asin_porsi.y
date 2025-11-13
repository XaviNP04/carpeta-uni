/*****************************************************************************/
/**  Ejemplo de BISON-I: S E M - 2          jbenedi@dsic.upv.es>     V. 24  **/
/*****************************************************************************/
%{
#include <stdio.h>
#include "header.h"
%}

%token INT_ MAIN_ TREAD_ TPRINT_ TRETURN_
%token TIF_ TELSE_ TFOR_
%token TBOOL_ TRUE_ FALSE_
%token ID_ CTE_
%token MAS_ MENOS_ POR_ DIV_
%token TIGUALDAD_ TASIG_
%token PARA_ PARC_ TLLAI_ TLLAD_ TCORI_ TCORC_ PYC_
%token NOIG_ MEN_ MAY_ MENIG_ MAYIG_
%token AND_ OR_ NOT_
%token COMA_

%start program

%% 

program : globals function_main
        ;
globals :
        | globals codigo PYC_
        ;

function_main   : INT_ MAIN_ PARA_ PARC_ TLLAI_ codigo TLLAD_
                ;

codigo  :
        | codigo sentencia
        ;

sentencia : declaracion PYC_
          | asignacion PYC_
          | leer PYC_
          | imprimir PYC_
          | retornar PYC_
          | funcion_for
          | funcion_if
          | funcion_general
          | TLLAI_ codigo TLLAD_
          ;

funcion_if: TIF_ PARA_ comparacion PARC_ sentencia
          | TIF_ PARA_ comparacion PARC_ sentencia TELSE_ sentencia
                ;

funcion_for     : TFOR_ PARA_ opcion_asig PYC_ comparacion PYC_ opcion_asig PARC_ sentencia
                ;

funcion_general : INT_ ID_ PARA_  PARC_ sentencia
                ;


declaracion : INT_ ID_
            | INT_ ID_ TASIG_ asignacion
            | INT_ ID_ TCORI_ expresion TCORC_
            | INT_ ID_ TCORI_ expresion TCORC_ TASIG_ asignacion
            | TBOOL_ ID_
            | TBOOL_ ID_ TASIG_ TRUE_
            | TBOOL_ ID_ TASIG_ FALSE_
            | declaracion COMA_ declaracion
            ;

asignacion: ID_ TASIG_ asignacion
          | ID_ TCORI_ expresion TCORC_ TASIG_ asignacion
          | comparacion
          ;

comparacion : comparacion OR_ comparacion
            | comparacion AND_ comparacion
            | NOT_ comparacion
            | expresion comparador expresion
            | expresion
            ;

expresion : expresion MAS_ term
          | expresion MENOS_ term
          | term
          ;

term: term POR_ factor
    | term DIV_ factor
    | factor
    ;

factor  :PARA_ asignacion PARC_
        | ID_
        | ID_ TCORI_ expresion TCORC_
        | CTE_
        | TRUE_
        | FALSE_
        ;

opcion_asig :
            | asignacion
            ;

leer: TREAD_ PARA_ ID_ PARC_
    ;

imprimir: TPRINT_ PARA_ asignacion PARC_
        ;

retornar: TRETURN_ asignacion
        ;

comparador: TIGUALDAD_
          | NOIG_
          | MEN_
          | MAY_
          | MENIG_
          | MAYIG_
          ;
%%