/*****************************************************************************/
/**  Ejemplo de BISON-I: S E M - 2          jbenedi@dsic.upv.es>     V. 24  **/
/*****************************************************************************/
%{
#include <stdio.h>
#include "header.h"
%}

%token INT_ TREAD_ TPRINT_ TRETURN_
%token TIF_ TELSE_ TFOR_
%token TBOOL_ TRUE_ FALSE_
%token ID_ CTE_
%token MAS_ MENOS_ POR_ DIV_
%token TIGUALDAD_ TASIG_
%token PARA_ PARC_ TLLAI_ TLLAD_ TCORI_ TCORD_ PYC_
%token NOIG_ MEN_ MAY_ MENIG_ MAYIG_
%token AND_ OR_ NOT_
%token COMA_

%start programa

%% 

programa: listDecla
        ;

listDecla: decla
         | listDecla decla
         ;

decla: declaVar
     | declaFunc
     ;

declaVar: tipoSimp ID_ PYC_
        | tipoSimp ID_ TASIG_ const PYC_
        | tipoSimp ID_ TCORI_ CTE_ TCORD_ PYC_
        ;

const: CTE_
     | TRUE_
     | FALSE_
     ;

tipoSimp: INT_
        | TBOOL_
        ;

declaFunc: tipoSimp ID_ PARA_ paramForm PARC_ bloque
        ;

paramForm:
        | listParamForm
        ;

listParamForm: tipoSimp ID_
                | tipoSimp ID_ COMA_ listParamForm
                ;

bloque: TLLAI_ declaVarLocal listInst TRETURN_ expre PYC_ TLLAD_

declaVarLocal:
        | declaVarLocal declaVar
        ;

listInst: 
        | listInst inst
        ;

inst: TLLAI_ listInst TLLAD_
    | instExpre
    | instEntSal
    | instSelec
    | instIter
    ;

instExpre: expre PYC_
         | PYC_
         ;

instEntSal: TREAD_ PARA_ ID_ PARC_ PYC_
        | TPRINT_ PARA_ expre PARC_ PYC_
        ;

instSelec: TIF_ PARA_ expre PARC_ inst TELSE_ inst
        ;






instIter : TFOR_ PARA_ expreOP PYC_ expre PYC_ expreOP PARC_ inst

expreOP :
        | expre
        ;

expre : expreLogic 
        | ID_ TASIG_ expre 
        | ID_ TCORI_ expre TCORD_ TASIG_ expre
        ;

expreLogic : expreIgual 
           | expreLogic opLogic expreIgual
           ;

expreIgual : expreRel 
           | expreIgual opIgual expreRel
           ;

expreRel : expreAd 
         | expreRel opRel expreAd
         ;

expreAd : expreMul 
        | expreAd opAd expreMul
        ;

expreMul : expreUna 
         | expreMul opMul expreUna
         ;
expreUna : expreSufi 
         | opUna expreUna
         ;

expreSufi: const 
        | PARA_ expre PARC_ 
        | ID_ 
        | ID_ TCORI_ expre TCORD_ 
        | ID_ PARA_ paramAct PARC_
        ;

paramAct:
        | listParamAct
        ;

listParamAct    : expre 
                | expre COMA_ listParamAct
                ;

opLogic : AND_ 
        | OR_
        ;

opIgual : TIGUALDAD_ 
        | NOIG_
        ;

opRel   : MAY_
        | MEN_
        | MAYIG_
        | MENIG_
        ;

opAd    : MAS_ 
        | MENOS_
        ;

opMul   : POR_ 
        | DIV_
        ;

opUna   : MAS_
        | MENOS_
        | NOT_
        ;


%%