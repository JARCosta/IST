#ifndef __OG_AST_EVALUATION_H__
#define __OG_AST_EVALUATION_H__

#include <cdk/ast/basic_node.h>
#include <cdk/ast/expression_node.h>

namespace og {

  class evaluation_node: public cdk::basic_node {
    cdk::expression_node *_expression;

  public:
    evaluation_node(int lineno, cdk::expression_node *expression) :
        cdk::basic_node(lineno), _expression(expression) {
    }

  public:
    cdk::expression_node* expression() {
      return _expression;
    }

    void accept(basic_ast_visitor *sp, int level) {
      sp->do_evaluation_node(this, level);
    }

  };

} // og

#endif
