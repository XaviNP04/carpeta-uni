/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

#ifndef YY_YY_ASIN_H_INCLUDED
# define YY_YY_ASIN_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    YYEOF = 0,                     /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    INT_ = 258,                    /* INT_  */
    TREAD_ = 259,                  /* TREAD_  */
    TPRINT_ = 260,                 /* TPRINT_  */
    TRETURN_ = 261,                /* TRETURN_  */
    TIF_ = 262,                    /* TIF_  */
    TELSE_ = 263,                  /* TELSE_  */
    TFOR_ = 264,                   /* TFOR_  */
    TBOOL_ = 265,                  /* TBOOL_  */
    TRUE_ = 266,                   /* TRUE_  */
    FALSE_ = 267,                  /* FALSE_  */
    ID_ = 268,                     /* ID_  */
    CTE_ = 269,                    /* CTE_  */
    MAS_ = 270,                    /* MAS_  */
    MENOS_ = 271,                  /* MENOS_  */
    POR_ = 272,                    /* POR_  */
    DIV_ = 273,                    /* DIV_  */
    TIGUALDAD_ = 274,              /* TIGUALDAD_  */
    TASIG_ = 275,                  /* TASIG_  */
    PARA_ = 276,                   /* PARA_  */
    PARC_ = 277,                   /* PARC_  */
    TLLAI_ = 278,                  /* TLLAI_  */
    TLLAD_ = 279,                  /* TLLAD_  */
    TCORI_ = 280,                  /* TCORI_  */
    TCORD_ = 281,                  /* TCORD_  */
    PYC_ = 282,                    /* PYC_  */
    NOIG_ = 283,                   /* NOIG_  */
    MEN_ = 284,                    /* MEN_  */
    MAY_ = 285,                    /* MAY_  */
    MENIG_ = 286,                  /* MENIG_  */
    MAYIG_ = 287,                  /* MAYIG_  */
    AND_ = 288,                    /* AND_  */
    OR_ = 289,                     /* OR_  */
    NOT_ = 290,                    /* NOT_  */
    COMA_ = 291                    /* COMA_  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_ASIN_H_INCLUDED  */
