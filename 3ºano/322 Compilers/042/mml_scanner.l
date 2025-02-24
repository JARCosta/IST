%option c++ prefix="mml_scanner_" outfile="mml_scanner.cpp"
%option stack noyywrap yylineno 8bit debug
%{ 
// make relevant includes before including the parser's tab file
#include <string>
#include <cdk/ast/sequence_node.h>
#include <cdk/ast/expression_node.h>
#include <cdk/ast/lvalue_node.h>
#include "mml_parser.tab.h"

// don't change this
#define yyerror LexerError
%}
%x X_STRING X_COMMENT X_BACKSLASH X_IGNORE

IDENTIFIER [_a-zA-Z][0-9a-zA-Z_]*
SYMBOL [-()<>=+*/%;{}.[\]~?@,] 
SPACE [ \r\t\n]+

DIGIT [0-9]
EXPONENT [eE][+-]?{DIGIT}+
DOUBLE {DIGIT}+{EXPONENT}|({DIGIT}+"."{DIGIT}*|{DIGIT}*"."{DIGIT}+){EXPONENT}?
B10_INTEGER [1-9]{DIGIT}*|0
B8_INTEGER 0[0-7]+

%%
  yydebug=1; set_debug(1);

"//".*\n                      ; /* ignore comments */
"/*"                          yy_push_state(X_COMMENT);
<X_COMMENT>"/*"               yy_push_state(X_COMMENT);
<X_COMMENT>"*/"               yy_pop_state();
<X_COMMENT>.|\n               ; /* ignore content */

">="                   return tGE; 
"<="                   return tLE; 
"=="                   return tEQ; 
"!="                   return tNE;

"&&"                   return tAND;
"||"                   return tOR;

"!"                    return tPRINT;
"!!"                   return tPRINTNL;

"foreign"              return tFOREIGN;
"forward"              return tFORWARD;
"public"               return tPUBLIC;
"auto"			   	   		 return tAUTO;

"null"				   			 return tNULL;
"sizeof"			   			 return tSIZEOF;
"input"                return tREAD;

"int"			   	   			 return tTYPE_INT;		   
"double"			   			 return tTYPE_DOUBLE;
"string"			   			 return tTYPE_STRING;
"void"			   	   		 return tTYPE_VOID;

"while"                return tWHILE; 
"if"                   return tIF; 
"elif"           			 return tELIF; 
"else"                 return tELSE; 
"next"				         return tNEXT;
"stop"			      		 return tSTOP;
"return"			   			 return tRETURN;

"begin"                return tBEGIN; 
"end"                  return tEND; 

"->"                   return tARROW;

{IDENTIFIER}  yylval.s = new std::string(yytext); return tIDENTIFIER;
{SYMBOL} return *yytext;
{DOUBLE} yylval.d = strtod(yytext, nullptr); return tDOUBLE;
{B8_INTEGER}  yylval.i = strtol(yytext, nullptr, 8); if(errno == ERANGE) yyerror("Overflow"); return tINTEGER;
{B10_INTEGER} yylval.i = strtol(yytext, nullptr, 10); if(errno == ERANGE) yyerror("Overflow"); return tINTEGER;


\"                     		{ yy_push_state(X_STRING); yylval.s = new std::string("");}
<X_STRING,X_IGNORE>\"   	{ yy_pop_state(); return tSTRING;}
<X_STRING>\\		   		  	{ yy_push_state(X_BACKSLASH);}
<X_STRING>.|\n         		{ *yylval.s += yytext; }

<X_BACKSLASH>0		     	  { yy_pop_state(); 	 yy_pop_state(); yy_push_state(X_IGNORE);}
<X_BACKSLASH>r		        { *yylval.s += "\r"; yy_pop_state();}
<X_BACKSLASH>t		        { *yylval.s += "\t"; yy_pop_state();}
<X_BACKSLASH>n				    { *yylval.s += "\n"; yy_pop_state();}
<X_BACKSLASH>\"         	{ *yylval.s += "\""; yy_pop_state();}
<X_BACKSLASH>\\			      { *yylval.s += "\\"; yy_pop_state();}

<X_BACKSLASH>[0-7]{1,3}   { *yylval.s += std::string(1, strtol(yytext, nullptr, 8)); yy_pop_state();}
<X_BACKSLASH>.				    yyerror("Unknown character in string");

<X_IGNORE>\\\"        	{ ; /* ignore */}
<X_IGNORE>\\\\        	{ ; /* ignore */}
<X_IGNORE>.|\n 	     	  { ; /* ignore */}

{SPACE} ; /* ignore whitespace */

. yyerror("Unknown character");

%%
