%{
#include <stdio.h>
#include "asin.h"
#include "header.h"
#define retornar(x) {if (verbosidad) ECHO; return x;}
%}

%option noinput
%option noinput
%option yylineno

delimitador   [ \t\n]+
digito        [0-9]
entero        {digito}+
letra         [A-Za-z]
ident         {letra}+({letra}|{entero})*

%%
"//".*                {}

"int"                 { retornar(INT_); }
"read"                { retornar(TREAD_); }
"print"               { retornar(TPRINT_); }
"return"              { retornar(TRETURN_); }

"if"                  { retornar(TIF_); }
"else"                { retornar(TELSE_); }

"for"                 { retornar(TFOR_); }

"bool"                { retornar(TBOOL_); }
"true"                { retornar(TRUE_); }
"false"               { retornar(FALSE_); }

"="                   { retornar(TASIG_); }
"!"                   { retornar(NOT_); }
"!="                  { retornar(NOIG_); }
"=="                  { retornar(TIGUALDAD_); }
"+"                   { retornar(MAS_); }
"-"                   { retornar(MENOS_); }
"*"                   { retornar(POR_); }
"/"                   { retornar(DIV_); }
"<"                   { retornar(MEN_); }
">"                   { retornar(MAY_); }
"<="                  { retornar(MENIG_); }
">="                  { retornar(MAYIG_); }
"&&"                  { retornar(AND_); }
"||"                  { retornar(OR_); }
"("                   { retornar(PARA_); }
")"                   { retornar(PARC_); }
"{"                   { retornar(TLLAI_); }
"}"                   { retornar(TLLAD_); }
"["                   { retornar(TCORI_); }
"]"                   { retornar(TCORD_); }
","                   { retornar(COMA_)}
";"                   { retornar(PYC_); }

{entero}              { retornar(CTE_); }
{ident}               { retornar(ID_); }

{delimitador}         {}
.             {yyerror("Caracter desconocido");}
%%
