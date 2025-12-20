#ifndef __OG_AST_TUPLE_INDEX_NODE_H__
#define __OG_AST_TUPLE_INDEX_NODE_H__

#include <cdk/ast/lvalue_node.h>
#include <cdk/ast/expression_node.h>

namespace og {

  class tuple_index_node: public cdk::lvalue_node {
    cdk::expression_node *_base;
    int _position;

  public:
    tuple_index_node(int lineno, cdk::expression_node *base, int position) :
        cdk::lvalue_node(lineno), _base(base), _position(position) {
    }

  public:
    cdk::expression_node *base() {
      return _base;
    }
    int position() {
      return _position;
    }

  public:
    void accept(basic_ast_visitor *sp, int level) {
      sp->do_tuple_index_node(this, level);
    }

  };

} // og

#endif
