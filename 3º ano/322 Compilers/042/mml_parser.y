%{
//-- don't change *any* of these: if you do, you'll break the compiler.
#include <algorithm>
#include <memory>
#include <cstring>
#include <cdk/compiler.h>
#include <cdk/types/types.h>
#include ".auto/all_nodes.h"
#define LINE                         compiler->scanner()->lineno()
#define yylex()                      compiler->scanner()->scan()
#define yyerror(compiler, s)         compiler->scanner()->error(s)
//-- don't change *any* of these --- END!
%}

%parse-param {std::shared_ptr<cdk::compiler> compiler}

%union {
  //--- don't change *any* of these: if you do, you'll break the compiler.
  YYSTYPE() : type(cdk::primitive_type::create(0, cdk::TYPE_VOID)) {}
  ~YYSTYPE() {}
  YYSTYPE(const YYSTYPE &other) { *this = other; }
  YYSTYPE& operator=(const YYSTYPE &other) { type = other.type; return *this; }

  std::shared_ptr<cdk::basic_type> type;        /* expression type */
  //-- don't change *any* of these --- END!

  int                   i;	/* integer value */
  double                d;	/* double value */
  std::string          *s;	/* symbol name or string literal */
  cdk::basic_node      *node;	/* node pointer */
  cdk::sequence_node   *sequence;
  cdk::expression_node *expression; /* expression nodes */
  cdk::lvalue_node     *lvalue;
  mml::block_node      *block;
  std::vector<std::shared_ptr<cdk::basic_type>> *types;
};

%token <i> tINTEGER tFORWARD tPUBLIC tFOREIGN tPRIVATE
%token <d> tDOUBLE
%token <s> tIDENTIFIER tSTRING
%token tWHILE tIF tPRINT tPRINTNL tREAD tBEGIN tEND tAUTO tNULL tSIZEOF tTYPE_INT tTYPE_STRING tTYPE_DOUBLE tTYPE_VOID tNEXT tSTOP tRETURN tARROW

%right '='
%left tAND
%left tOR
%nonassoc '~'
%left tEQ tNE
%left '<' '>' tLE tGE
%left '+' '-'
%left '*' '/' '%'
%nonassoc tUNARY
%nonassoc '[' ']' '(' ')'

%nonassoc tIFX
%nonassoc tELSE tELIF

%type <block> block main_block
%type <node> stmt program declaration if_stmt variable
%type <sequence> list declarations opt_declarations exprs variables
%type <expression> expr literal initializer
%type <lvalue> lval
%type <type> type function_type
%type <types> types
%type <s> string
%type <i> qualifier

%{
//-- The rules below will be included in yyparse, the main parsing function.
%}
%%

program : opt_declarations tBEGIN main_block tEND { compiler->ast(new mml::program_node(LINE, $1, $3)); }
	      ;

block : '{' main_block '}' { $$ = $2; }
           ;

main_block  :               { $$ = new mml::block_node(LINE, new cdk::sequence_node(LINE), new cdk::sequence_node(LINE));}
       |  declarations      { $$ = new mml::block_node(LINE, $1, new cdk::sequence_node(LINE));}
       |  list              { $$ = new mml::block_node(LINE, new cdk::sequence_node(LINE), $1);}
       |  declarations list { $$ = new mml::block_node(LINE, $1, $2);}
       ;

declarations : declaration                 { $$ = new cdk::sequence_node(LINE, $1); }
                | declarations declaration { $$ = new cdk::sequence_node(LINE, $2, $1); }
                ;

opt_declarations :            { $$ = new cdk::sequence_node(LINE); }
               | declarations { $$ = $1; }
               ;

declaration : type tIDENTIFIER ';'                      { $$ = new mml::declaration_node(LINE, tPRIVATE, $1, *$2); }
          | type tIDENTIFIER initializer ';'            { $$ = new mml::declaration_node(LINE, tPRIVATE, $1, *$2, $3); }
          | qualifier type tIDENTIFIER ';'              { $$ = new mml::declaration_node(LINE, $1, $2, *$3, nullptr); }
          | qualifier type tIDENTIFIER initializer ';'  { $$ = new mml::declaration_node(LINE, $1, $2, *$3, $4); }
          | tAUTO tIDENTIFIER initializer ';'           { $$ = new mml::declaration_node(LINE, tPRIVATE, cdk::primitive_type::create(4, cdk::TYPE_UNSPEC), *$2, $3); }
          | qualifier tAUTO tIDENTIFIER initializer ';' { $$ = new mml::declaration_node(LINE, $1, cdk::primitive_type::create(4, cdk::TYPE_UNSPEC), *$3, $4); }
          | tPUBLIC tIDENTIFIER initializer ';'         { $$ = new mml::declaration_node(LINE, tPUBLIC, cdk::primitive_type::create(4, cdk::TYPE_UNSPEC), *$2, $3); }
          ;

initializer : '=' expr { $$ = $2; }
            ;

qualifier : tPUBLIC  { $$ = tPUBLIC; }
          | tFOREIGN { $$ = tFOREIGN; }
          | tFORWARD { $$ = tFORWARD; }
          ; 

type : tTYPE_INT     { $$ = cdk::primitive_type::create(4, cdk::TYPE_INT); }
     | tTYPE_STRING  { $$ = cdk::primitive_type::create(4, cdk::TYPE_STRING); }
     | tTYPE_DOUBLE  { $$ = cdk::primitive_type::create(8, cdk::TYPE_DOUBLE); }
     | tTYPE_VOID    { $$ = cdk::primitive_type::create(0, cdk::TYPE_VOID); }
     | '[' type ']'  { $$ = cdk::reference_type::create(4, $2); }
     | function_type { $$ = $1; }
     ;

types :                { $$ = new std::vector<std::shared_ptr<cdk::basic_type>>(); }
      | type           { $$ = new std::vector<std::shared_ptr<cdk::basic_type>>(); $$->push_back($1); }
      | types ',' type { $$ = $1; $$->push_back($3); }
      ;

function_type : type '<' types '>' {
                                     auto output = new std::vector<std::shared_ptr<cdk::basic_type>>();                                         
                                     output->push_back($1);
                                     $$ = cdk::functional_type::create(*$3, *output);
                                   }

list : stmt	     { $$ = new cdk::sequence_node(LINE, $1); }
	   | list stmt { $$ = new cdk::sequence_node(LINE, $2, $1); }
	   ;

stmt : expr ';'                 { $$ = new mml::evaluation_node(LINE, $1); }
     | exprs tPRINT             { $$ = new mml::print_node(LINE, $1); }
     | exprs tPRINTNL           { $$ = new mml::print_node(LINE, $1, true); }
     | tRETURN ';'              { $$ = new mml::return_node(LINE, nullptr); }
     | tRETURN expr ';'         { $$ = new mml::return_node(LINE, $2); }
     | tNEXT ';'                { $$ = new mml::next_node(LINE);}
     | tNEXT tINTEGER ';'       { $$ = new mml::next_node(LINE, $2);}
     | tSTOP ';'                { $$ = new mml::stop_node(LINE);}
     | tSTOP tINTEGER ';'       { $$ = new mml::stop_node(LINE, $2);}
     | tWHILE '(' expr ')' stmt { $$ = new mml::while_node(LINE, $3, $5); }
     | tIF if_stmt              { $$ = $2; }
     | block                    { $$ = $1; }
     ;

if_stmt : '(' expr ')' stmt              { $$ = new mml::if_node(LINE, $2, $4);}
       | '(' expr ')' stmt tELSE stmt    { $$ = new mml::if_else_node(LINE, $2, $4, $6);}
       | '(' expr ')' stmt tELIF if_stmt { $$ = new mml::if_else_node(LINE, $2, $4, $6);}
       ;

exprs : expr           { $$ = new cdk::sequence_node(LINE, $1); }
      | exprs ',' expr { $$ = new cdk::sequence_node(LINE, $3, $1); }
      ;

expr : tREAD                               { $$ = new mml::read_node(LINE); }
     | tSIZEOF '(' expr ')'                { $$ = new mml::sizeof_node(LINE, $3); }
     | literal                             { $$ = $1; }
     | '-' expr %prec tUNARY               { $$ = new cdk::neg_node(LINE, $2); }
     | '+' expr %prec tUNARY               { $$ = $2; }
     | expr '+' expr	                  { $$ = new cdk::add_node(LINE, $1, $3); }
     | expr '-' expr	                  { $$ = new cdk::sub_node(LINE, $1, $3); }
     | expr '*' expr	                  { $$ = new cdk::mul_node(LINE, $1, $3); }
     | expr '/' expr	                  { $$ = new cdk::div_node(LINE, $1, $3); }
     | expr '%' expr	                  { $$ = new cdk::mod_node(LINE, $1, $3); }
     | expr '<' expr	                  { $$ = new cdk::lt_node(LINE, $1, $3); }
     | expr '>' expr	                  { $$ = new cdk::gt_node(LINE, $1, $3); }
     | '~' expr                            { $$ = new cdk::not_node(LINE, $2);}
     | expr tAND expr	                  { $$ = new cdk::and_node(LINE, $1, $3); }
     | expr tOR expr	                  { $$ = new cdk::or_node(LINE, $1, $3); }
     | expr tGE expr	                  { $$ = new cdk::ge_node(LINE, $1, $3); }
     | expr tLE expr                       { $$ = new cdk::le_node(LINE, $1, $3); }
     | expr tNE expr	                  { $$ = new cdk::ne_node(LINE, $1, $3); }
     | expr tEQ expr	                  { $$ = new cdk::eq_node(LINE, $1, $3); }
     | '(' expr ')'                        { $$ = $2; }
     | lval                                { $$ = new cdk::rvalue_node(LINE, $1); }  //FIXME
     | lval '?'                            { $$ = new mml::address_of_node(LINE, $1);}
     | lval '=' expr                       { $$ = new cdk::assignment_node(LINE, $1, $3);}
     | '[' expr ']'                        { $$ = new mml::stack_alloc_node(LINE, $2);}
     | '(' variables ')' tARROW type block { $$ = new mml::function_node(LINE, $5, $2, $6);}
     | expr '(' exprs ')'                  { $$ = new mml::function_call_node(LINE, $1, $3);}
     | expr '(' ')'                        { $$ = new mml::function_call_node(LINE, $1);}
     | '@' '(' exprs ')'                   { $$ = new mml::function_call_node(LINE, nullptr, $3);}
     | '@' '(' ')'                         { $$ = new mml::function_call_node(LINE, nullptr);}
     ;

variable : type tIDENTIFIER { $$ = new mml::declaration_node(LINE, tPRIVATE, $1, *$2);}

variables :                        { $$ = new cdk::sequence_node(LINE);}
          | variable               { $$ = new cdk::sequence_node(LINE, $1);}
          | variables ',' variable { $$ = new cdk::sequence_node(LINE, $3, $1);}
          ;

lval : expr '[' expr ']' { $$ = new mml::index_node(LINE, $1, $3); }
     | tIDENTIFIER       { $$ = new cdk::variable_node(LINE, $1); }
     ;

literal: tINTEGER { $$ = new cdk::integer_node(LINE, $1);}
       | tDOUBLE  { $$ = new cdk::double_node(LINE, $1);}
       | string   { $$ = new cdk::string_node(LINE, $1);}
       | tNULL    { $$ = new mml::nullptr_node(LINE);}
       ;

string : string tSTRING { $$ = new std::string(*$1 + *$2); delete $1; delete $2;}
       | tSTRING        { $$ = $1;}
       ;   

%%
