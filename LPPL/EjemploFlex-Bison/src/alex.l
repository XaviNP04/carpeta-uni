/*****************************************************************************/
/**  Ejemplo de BISON-I: S E M - 2          <jbenedi@dsic.upv.es>   V.24    **/
/*****************************************************************************/
%{
#include "header.h"
#include "asin.h"

#define  retornar(x) {if (verbosidad) ECHO ; return (x) ; }
%}
/*----------------------------------------------------------------------
  Dado que las funciones "input()" y "unput(c)" son costosas y no las
  utilizaremos, evitaremos que se generen automaticamente sus rutinas
  correspondientes desactivandolas mediante las siguientes opciones:
----------------------------------------------------------------------*/
%option noinput
%option nounput
/*----------------------------------------------------------------------
  Para mantener el numero de linea actual en la variable global yylineno
----------------------------------------------------------------------*/
%option yylineno

delimitador     [ \t\n]+
digito          [0-9]
entero          {digito}+

%%

{delimitador}   {if (verbosidad) ECHO ; }
"+"             { retornar (MAS_) ;}
"-"             { retornar (MENOS_) ; }
"*"             { retornar (POR_) ; }
"/"             { retornar (DIV_) ; }
"("             { retornar (PARA_) ; }
")"             { retornar (PARC_) ; }
{entero}        { retornar (CTE_) ; }
.               { yyerror("Caracter desconocido") ;}
%%
