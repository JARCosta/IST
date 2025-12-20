#ifndef __OG_TUPLE_NODE_H__
#define __OG_TUPLE_NODE_H__

#include <cdk/ast/expression_node.h>
#include <cdk/ast/sequence_node.h>

namespace og {

  class tuple_node: public cdk::expression_node {
    cdk::sequence_node *_fields;

  public:
    inline tuple_node(int lineno, cdk::sequence_node *fields) :
        cdk::expression_node(lineno), _fields(fields) {
    }

  public:
    inline cdk::expression_node* field(size_t ix) {
      //DAVID dirty hack, but always correct
      return (cdk::expression_node*)_fields->node(ix);
    }

    inline cdk::sequence_node* fields() {
      return _fields;
    }

    inline size_t length() {
      return _fields->size();
    }

  public:
    inline void accept(basic_ast_visitor *sp, int level) {
      sp->do_tuple_node(this, level);
    }

  }; // class tuple_node

}// namespace og

#endif
