#ifndef __OG_AST_INDEX_NODE_H__
#define __OG_AST_INDEX_NODE_H__

#include <cdk/ast/lvalue_node.h>

namespace og {

  class index_node: public cdk::lvalue_node {
    cdk::expression_node *_base;
    cdk::expression_node *_index;

  public:
    index_node(int lineno, cdk::expression_node *base, cdk::expression_node *index) :
        cdk::lvalue_node(lineno), _base(base), _index(index) {
    }

  public:
    cdk::expression_node* base() {
      return _base;
    }
    cdk::expression_node* index() {
      return _index;
    }

  public:
    void accept(basic_ast_visitor *sp, int level) {
      sp->do_index_node(this, level);
    }

  };

} // og

#endif
