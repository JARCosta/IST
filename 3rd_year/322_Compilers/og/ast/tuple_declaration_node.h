#ifndef __OG_AST_TUPLE_DECLARATION_H__
#define __OG_AST_TUPLE_DECLARATION_H__

#include <vector>
#include <cdk/ast/basic_node.h>
#include <cdk/ast/sequence_node.h>
#include <cdk/types/basic_type.h>
#include "ast/tuple_node.h"

namespace og {

  class tuple_declaration_node: public cdk::typed_node {
    int _qualifier;
    std::vector<std::string> _identifiers;
    og::tuple_node *_initializers;

  public:
    tuple_declaration_node(int lineno, int qualifier, const std::vector<std::string> &identifiers, og::tuple_node *initializers) :
        cdk::typed_node(lineno), _qualifier(qualifier), _identifiers(identifiers), _initializers(initializers) {
    }

  public:
    bool constant() const {
      return false;
    }
    int qualifier() const {
      return _qualifier;
    }
    size_t length() const {
      return _identifiers.size();
    }
    const std::string& identifier(size_t ix) const {
      return _identifiers[ix];
    }
    const std::vector<std::string>& identifiers() const {
      return _identifiers;
    }
    og::tuple_node *initializers() {
      return _initializers;
    }

    void accept(basic_ast_visitor *sp, int level) {
      sp->do_tuple_declaration_node(this, level);
    }

  };

} // og

#endif
