%option c++ prefix="og_scanner_" outfile="og_scanner.cpp"
%option stack noyywrap yylineno 8bit debug
%{ 
// make relevant includes before including the parser's tab file
#include <string>
#include <cstring>
#include <vector>
#include <sstream>
#include <cdk/ast/sequence_node.h>
#include <cdk/ast/expression_node.h>
#include <cdk/ast/lvalue_node.h>
#include "ast/tuple_node.h"
#include "og_parser.tab.h"

static std::vector<int> deferred;  // deferred tokens

// output stream for building string literals
static std::ostringstream strlit;

// don't change this
#define yyerror LexerError
%}

SPACE     ([ \t\r]|\n)
INT       [[:digit:]]+

LETTER  [A-Za-z_]
IDENTIFIER   {LETTER}({LETTER}|[[:digit:]])*

%x X_COMMENT
%x X_STRING  X_BACKSLASH   X_CHAR    X_CHAR_END
%x X_OCTAL   X_HEXADECIMAL X_HEX_INT X_BIN_INT

%%

  /* ====================================================================== */
  /* ====[                      2.2 - COMMENTS                        ]==== */
  /* ====================================================================== */

"//".*$                /* match the whole line (it is ignored) */

"/*"                   yy_push_state(X_COMMENT);
<X_COMMENT>"*/"        yy_pop_state();
<X_COMMENT>.|"\n"      ;  /* ignore inside comments */

  /* ====================================================================== */
  /* ====[                  1.1   - Tipos de dados                    ]==== */
  /* ====[                  1.1   - Null pointers                     ]==== */
  /* ====[                  1.1   - Procedures                        ]==== */
  /* ====================================================================== */

"auto"                   return tTYPE_AUTO;
"int"                    return tTYPE_INT;
"real"                   return tTYPE_REAL;
"string"                 return tTYPE_STRING;
"ptr"                    return tTYPE_POINTER;
[<>]                     return *yytext;

"nullptr"                return tNULLPTR;
"procedure"              return tPROCEDURE;
"sizeof"                 return tSIZEOF;

  /* ====================================================================== */
  /* ====[                  3.4.2 - Símbolos globais                  ]==== */
  /* ====================================================================== */

"public"                 return tPUBLIC;
"require"                return tREQUIRE;

  /* ====================================================================== */
  /* ====[                 5.5 - Instrução condicional                ]==== */
  /* ====================================================================== */

"if"                   return tIF;
"then"                 return tTHEN;
"elif"                 return tELIF;
"else"                 return tELSE;

  /* ====================================================================== */
  /* ====[                 5.5 - Instrução de iteração                ]==== */
  /* ====[                 5.5 - Instrução de terminação              ]==== */
  /* ====[                 5.4 - Instrução de continuação             ]==== */
  /* ====================================================================== */

"for"                   return tFOR;
"do"                    return tDO;
"break"                 return tBREAK;
"continue"              return tCONTINUE;

  /* ====================================================================== */
  /* ====[                 6 - Operadores de expressões               ]==== */
  /* ====================================================================== */

[\[\](),?]       return *yytext;
[-+*/%~<>@?=]        return *yytext;
"=="                   return tEQ;
"!="                   return tNE;
"<="                   return tLE;
">="                   return tGE;
"&&"                   return tAND;
"||"                   return tOR;
"input"                return tINPUT;

  /* ====================================================================== */
  /* ====[              3   - Delimitadores e separadores             ]==== */
  /* ====[              4.3 - Corpo (de função)                       ]==== */
  /* ====[                 5.3 - Instrução de retorno                 ]==== */
  /* ====================================================================== */

[#\[\](){};:!,]                return *yytext;
"return"                       return tRETURN;
"write"                           return tWRITE;
"writeln"                           return tWRITELN;

  /* ====================================================================== */
  /* ====[                   2.7.1 - inteiros                         ]==== */
  /* ====================================================================== */

"0x"                   yy_push_state(X_HEX_INT);

<X_HEX_INT>[[:xdigit:]]+      { yylval.i = strtoul(yytext, NULL, 16); yy_pop_state(); return tINTEGER; }
<X_HEX_INT>.|\n               std::cerr << "WARNING: line " << lineno() << ": bad hexadecimal data!" << std::endl; exit(1);

{INT}                  yylval.i = strtoul(yytext, NULL, 10); return tINTEGER;

  /* ====================================================================== */
  /* ====[                   2.7.2 - reais                            ]==== */
  /* ====================================================================== */

([0-9]*\.[0-9]+|[0-9]+\.[0-9]*)([eE][-+]?[0-9]+)? { yylval.d = strtod(yytext, NULL); return tREAL; }

  /* ====================================================================== */
  /* ====[                2.6 - Identificadores (nomes)               ]==== */
  /* ====================================================================== */

{IDENTIFIER}  yylval.s = new std::string(yytext); return tID;

  /* ====================================================================== */
  /* ====[              2.7.3 - Cadeias de caracteres                 ]==== */
  /* ====================================================================== */

"\""                           yy_push_state(X_STRING);
<X_STRING>\\                   yy_push_state(X_BACKSLASH);
<X_STRING>"\""                 {
                                 yylval.s = new std::string(strlit.str());
                                 strlit.str("");
                                 yy_pop_state();
                                 return tSTRING;
                               }
<X_STRING>.                    strlit << *yytext;

<X_BACKSLASH>n                 strlit << '\n'; yy_pop_state();
<X_BACKSLASH>r                 strlit << '\r'; yy_pop_state();
<X_BACKSLASH>t                 strlit << '\t'; yy_pop_state();
<X_BACKSLASH>\\                strlit << '\\'; yy_pop_state();

<X_BACKSLASH>[[:xdigit:]]{1,2} {
                                 strlit << (char)(unsigned char)strtoul(yytext, NULL, 16);
                                 yy_pop_state();
                               }
<X_BACKSLASH>.                 strlit << *yytext; yy_pop_state();

  /* ====================================================================== */
  /* ====[                    (other characters)                      ]==== */
  /* ====================================================================== */

[[:space:]]         /* ignore remaining white space inside the program */
.                      yyerror(yytext);    /* all other chars: error! */

  /* ====================================================================== */
  /* ====[                           THE END                          ]==== */
  /* ====================================================================== */

%%
