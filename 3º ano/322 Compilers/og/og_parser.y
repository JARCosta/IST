%{
//-- don't change *any* of these: if you do, you'll break the compiler.
#include <algorithm>
#include <memory>
#include <cstring>
#include <cdk/compiler.h>
#include <cdk/types/types.h>
#include "ast/all.h"
#define LINE                  compiler->scanner()->lineno()
#define yylex()               compiler->scanner()->scan()
#define yyerror(compiler, s)  compiler->scanner()->error(s)
//-- don't change *any* of these --- END!

#define NIL (new cdk::nil_node(LINE))
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

  int                   i;  /* integer value */
  double                d;  /* integer value */
  std::string          *s;  /* symbol name or string literal */

  cdk::basic_node      *node; /* node pointer */
  cdk::sequence_node   *sequence;
  cdk::expression_node *expression; /* expression nodes */
  cdk::lvalue_node     *lvalue;
  

  og::block_node       *block;
  og::tuple_node       *tuple;      /* tuple nodes */
  std::vector<std::string> *ids;
}

%token tAND tOR tNE tLE tGE tSIZEOF
%token tINPUT tWRITE tWRITELN
%token tPUBLIC tPRIVATE tREQUIRE
%token tTYPE_STRING tTYPE_INT tTYPE_REAL tTYPE_POINTER tTYPE_AUTO tPROCEDURE
%token tIF tTHEN tELIF tELSE
%token tFOR tDO
%token tBREAK tCONTINUE tRETURN

%token<i> tINTEGER
%token<d> tREAL
%token<s> tSTRING tID
%token<expression> tNULLPTR

%type<node> instruction return iffalse
%type<sequence> file instructions opt_instructions 
%type<sequence> expressions opt_expressions
%type<expression> expression integer real opt_initializer
%type<lvalue> lvalue
%type<block> block

%type<node>     declaration  argdec  fordec  vardec fundec fundef
%type<sequence> declarations argdecs fordecs vardecs opt_vardecs
%type<node>     opt_forinit

%type<s> string
%type<type> data_type void_type
%type<ids> identifiers

%nonassoc tIF
%nonassoc tTHEN
%nonassoc tELIF tELSE

%right '='
%left tOR
%left tAND
%right '~'
%left tNE tEQ
%left '<' tLE tGE '>'
%left '+' '-'
%left '*' '/' '%'
%right tUMINUS

%%
file         : /* empty */  { compiler->ast($$ = new cdk::sequence_node(LINE)); }
             | declarations { compiler->ast($$ = $1); }
             ;

declarations :              declaration { $$ = new cdk::sequence_node(LINE, $1);     }
             | declarations declaration { $$ = new cdk::sequence_node(LINE, $2, $1); }
             ;

declaration  : vardec ';' { $$ = $1; }
             | fundec     { $$ = $1; }
             | fundef     { $$ = $1; }
             ;

vardec       : tREQUIRE data_type  tID                         { $$ = new og::variable_declaration_node(LINE, tPUBLIC,  $2, *$3, nullptr); }
             | tPUBLIC  data_type  tID         opt_initializer { $$ = new og::variable_declaration_node(LINE, tPUBLIC,  $2, *$3, $4); }
             |          data_type  tID         opt_initializer { $$ = new og::variable_declaration_node(LINE, tPRIVATE, $1, *$2, $3); }
             | tPUBLIC  tTYPE_AUTO identifiers '=' expressions 
             {
               $$ = new og::tuple_declaration_node(LINE, tPUBLIC,  *$3, new og::tuple_node(LINE, $5));
               delete $3;
             }
             |          tTYPE_AUTO identifiers '=' expressions 
             {
               $$ = new og::tuple_declaration_node(LINE, tPRIVATE, *$2, new og::tuple_node(LINE, $4));
               delete $2;
             }
             ;

vardecs      : vardec ';'          { $$ = new cdk::sequence_node(LINE, $1);     }
             | vardecs vardec ';' { $$ = new cdk::sequence_node(LINE, $2, $1); }
             ;
             
opt_vardecs  : /* empty */ { $$ = NULL; }
             | vardecs     { $$ = $1; }
             ;
             
identifiers  : tID { $$ = new std::vector<std::string>(); $$->push_back(*$1); delete $1; }
	           | identifiers ',' tID { $$ = $1; $$->push_back(*$3); delete $3; }
             ;
             
data_type    : tTYPE_STRING                     { $$ = cdk::primitive_type::create(4, cdk::TYPE_STRING);  }
             | tTYPE_INT                        { $$ = cdk::primitive_type::create(4, cdk::TYPE_INT);     }
             | tTYPE_REAL                       { $$ = cdk::primitive_type::create(8, cdk::TYPE_DOUBLE);  }
             | tTYPE_POINTER '<' data_type '>'  { $$ = cdk::reference_type::create(4, $3); }
             | tTYPE_POINTER '<' tTYPE_AUTO '>' { $$ = cdk::reference_type::create(4, nullptr); }
             ;
       
opt_initializer  : /* empty */         { $$ = nullptr; /* must be nullptr, not NIL */ }
                 | '=' expression      { $$ = $2; }
                 ;
       
void_type   : tPROCEDURE { $$ = cdk::primitive_type::create(0, cdk::TYPE_VOID);   }
            ;
             
fundec   :          data_type  tID '(' argdecs ')' { $$ = new og::function_declaration_node(LINE, tPRIVATE, $1, *$2, $4); }
         | tREQUIRE data_type  tID '(' argdecs ')' { $$ = new og::function_declaration_node(LINE, tPUBLIC,  $2, *$3, $5); }
         | tPUBLIC  data_type  tID '(' argdecs ')' { $$ = new og::function_declaration_node(LINE, tPUBLIC,  $2, *$3, $5); }
         |          tTYPE_AUTO tID '(' argdecs ')' { $$ = new og::function_declaration_node(LINE, tPRIVATE, nullptr, *$2, $4); }
         | tREQUIRE tTYPE_AUTO tID '(' argdecs ')' { $$ = new og::function_declaration_node(LINE, tPUBLIC,  nullptr, *$3, $5); }
         | tPUBLIC  tTYPE_AUTO tID '(' argdecs ')' { $$ = new og::function_declaration_node(LINE, tPUBLIC,  nullptr, *$3, $5); }
         |          void_type  tID '(' argdecs ')' { $$ = new og::function_declaration_node(LINE, tPRIVATE, $1, *$2, $4); }
         | tREQUIRE void_type  tID '(' argdecs ')' { $$ = new og::function_declaration_node(LINE, tPUBLIC,  $2, *$3, $5); }
         | tPUBLIC  void_type  tID '(' argdecs ')' { $$ = new og::function_declaration_node(LINE, tPUBLIC,  $2, *$3, $5); }
         ;

fundef   :         data_type  tID '(' argdecs ')' block { $$ = new og::function_definition_node(LINE, tPRIVATE, $1, *$2, $4, $6); }
         | tPUBLIC data_type  tID '(' argdecs ')' block { $$ = new og::function_definition_node(LINE, tPUBLIC,  $2, *$3, $5, $7); }
         |         tTYPE_AUTO tID '(' argdecs ')' block { $$ = new og::function_definition_node(LINE, tPRIVATE, nullptr, *$2, $4, $6); }
         | tPUBLIC tTYPE_AUTO tID '(' argdecs ')' block { $$ = new og::function_definition_node(LINE, tPUBLIC,  nullptr, *$3, $5, $7); }
         |         void_type  tID '(' argdecs ')' block { $$ = new og::function_definition_node(LINE, tPRIVATE, $1, *$2, $4, $6); }
         | tPUBLIC void_type  tID '(' argdecs ')' block { $$ = new og::function_definition_node(LINE, tPUBLIC,  $2, *$3, $5, $7); }
         ;

argdecs  : /* empty */         { $$ = new cdk::sequence_node(LINE);  }
         |             argdec  { $$ = new cdk::sequence_node(LINE, $1);     }
         | argdecs ',' argdec  { $$ = new cdk::sequence_node(LINE, $3, $1); }
         ;

argdec   : data_type tID { $$ = new og::variable_declaration_node(LINE, tPRIVATE, $1, *$2, nullptr); }
         ;

block    : '{' opt_vardecs opt_instructions '}' { $$ = new og::block_node(LINE, $2, $3); }
         ;

fordec          : data_type tID '=' expression { $$ = new og::variable_declaration_node(LINE, tPRIVATE,  $1, *$2, $4); }
                ;
              
fordecs         :             fordec { $$ = new cdk::sequence_node(LINE, $1);     }
                | fordecs ',' fordec { $$ = new cdk::sequence_node(LINE, $3, $1); }
                ;

opt_forinit     : /**/     { $$ = new cdk::sequence_node(LINE, NIL); }
                | fordecs  { $$ = $1; }
                | tTYPE_AUTO identifiers '=' expressions {
                   $$ = new og::tuple_declaration_node(LINE, tPRIVATE, *$2, new og::tuple_node(LINE, $4));
                   delete $2;
                }
                | expressions { $$ = new og::tuple_node(LINE, $1); }
                ;

return          : tRETURN             ';' { $$ = new og::return_node(LINE, nullptr); }
                | tRETURN expressions ';' { $$ = new og::return_node(LINE, new og::tuple_node(LINE, $2)); }
                ;

instructions    : instruction                { $$ = new cdk::sequence_node(LINE, $1);     }
                | instructions instruction   { $$ = new cdk::sequence_node(LINE, $2, $1); }
                ;

opt_instructions: /* empty */  { $$ = new cdk::sequence_node(LINE); }
                | instructions { $$ = $1; }
                ;

instruction     : tIF expression tTHEN instruction                                          { $$ = new og::if_node(LINE, $2, $4); }
                | tIF expression tTHEN instruction iffalse                                  { $$ = new og::if_else_node(LINE, $2, $4, $5); }
                | tFOR opt_forinit ';' opt_expressions ';' opt_expressions tDO instruction  { $$ = new og::for_node(LINE, $2, $4, $6, $8); }
                | expression ';'                                                            { $$ = new og::evaluation_node(LINE, $1); }
                | tWRITE   expressions ';'                                                  { $$ = new og::print_node(LINE, $2, false); }
                | tWRITELN expressions ';'                                                  { $$ = new og::print_node(LINE, $2, true); }
                | tBREAK                                                                    { $$ = new og::break_node(LINE);  }
                | tCONTINUE                                                                 { $$ = new og::continue_node(LINE); }
                | return     { $$ = $1; }
                | block                                                                     { $$ = $1; }
                ;

iffalse         : tELSE instruction                             { $$ = $2; }
                | tELIF expression tTHEN instruction            { $$ = new og::if_node(LINE, $2, $4); }
                | tELIF expression tTHEN instruction iffalse    { $$ = new og::if_else_node(LINE, $2, $4, $5); }
                ;

lvalue          : tID                                            { $$ = new cdk::variable_node(LINE, *$1); delete $1; }
                | tID '@' tINTEGER
                {
                  $$ = new og::tuple_index_node(LINE, new cdk::rvalue_node(LINE, new cdk::variable_node(LINE, *$1)), $3);
                  delete $1;
                }
                | '(' expression ')' '@' tINTEGER
                {
                  $$ = new og::tuple_index_node(LINE, $2, $5);
                }
                | tID '(' opt_expressions ')' '@' tINTEGER
                { 
                  $$ = new og::tuple_index_node(LINE, new og::function_call_node(LINE, *$1, $3), $6); 
                }
                | lvalue             '[' expression ']'          { $$ = new og::index_node(LINE, new cdk::rvalue_node(LINE, $1), $3); }
                | '(' expression ')' '[' expression ']'          { $$ = new og::index_node(LINE, $2, $5); }
                | tID '(' opt_expressions ')' '[' expression ']' { $$ = new og::index_node(LINE, new og::function_call_node(LINE, *$1, $3), $6); }
                ;

expression      : integer                       { $$ = $1; }
                | real                          { $$ = $1; }
                | string                        { $$ = new cdk::string_node(LINE, $1); }
                | tNULLPTR                      { $$ = new og::nullptr_node(LINE); }
                /* LEFT VALUES */
                | lvalue                        { $$ = new cdk::rvalue_node(LINE, $1); }
                /* ASSIGNMENTS */
                | lvalue '=' expression         { $$ = new cdk::assignment_node(LINE, $1, $3); }
                /* ARITHMETIC EXPRESSIONS */
                | expression '+' expression    { $$ = new cdk::add_node(LINE, $1, $3); }
                | expression '-' expression    { $$ = new cdk::sub_node(LINE, $1, $3); }
                | expression '*' expression    { $$ = new cdk::mul_node(LINE, $1, $3); }
                | expression '/' expression    { $$ = new cdk::div_node(LINE, $1, $3); }
                | expression '%' expression    { $$ = new cdk::mod_node(LINE, $1, $3); }
                /* LOGICAL EXPRESSIONS */
                | expression  '<' expression    { $$ = new cdk::lt_node(LINE, $1, $3); }
                | expression tLE  expression    { $$ = new cdk::le_node(LINE, $1, $3); }
                | expression tEQ  expression    { $$ = new cdk::eq_node(LINE, $1, $3); }
                | expression tGE  expression    { $$ = new cdk::ge_node(LINE, $1, $3); }
                | expression  '>' expression    { $$ = new cdk::gt_node(LINE, $1, $3); }
                | expression tNE  expression    { $$ = new cdk::ne_node(LINE, $1, $3); }
                /* LOGICAL EXPRESSIONS */
                | expression tAND  expression    { $$ = new cdk::and_node(LINE, $1, $3); }
                | expression tOR   expression    { $$ = new cdk::or_node (LINE, $1, $3); }
                /* UNARY EXPRESSION */
                | '-' expression %prec tUMINUS  { $$ = new cdk::neg_node(LINE, $2); }
                | '+' expression %prec tUMINUS  { $$ = $2; }
                | '~' expression                { $$ = new cdk::not_node(LINE, $2); }
                /* OTHER EXPRESSION */
                | tINPUT                        { $$ = new og::input_node(LINE); }
                /* OTHER EXPRESSION */
                | tID '(' opt_expressions ')'   { $$ = new og::function_call_node(LINE, *$1, $3); delete $1; }
                | tSIZEOF '(' expressions ')'   { $$ = new og::sizeof_node(LINE, new og::tuple_node(LINE, $3)); }
                /* OTHER EXPRESSION */
                | '(' expression ')'            { $$ = $2; }
                | '[' expression ']'            { $$ = new og::stack_alloc_node(LINE, $2); }
                | lvalue '?'                    { $$ = new og::address_of_node(LINE, $1); }
                ;

expressions     : expression                     { $$ = new cdk::sequence_node(LINE, $1);     }
                | expressions ',' expression     { $$ = new cdk::sequence_node(LINE, $3, $1); }
                ;

opt_expressions : /* empty */         { $$ = new cdk::sequence_node(LINE); }
                | expressions         { $$ = $1; }
                ;

integer         : tINTEGER                      { $$ = new cdk::integer_node(LINE, $1); };
real            : tREAL                         { $$ = new cdk::double_node(LINE, $1); };
string          : tSTRING                       { $$ = $1; }
                | string tSTRING                { $$ = $1; $$->append(*$2); delete $2; }
                ;

%%
