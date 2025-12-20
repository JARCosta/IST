#ifndef __MML_AST_BLOCK_H__
#define __MML_AST_BLOCK_H__

#include <cdk/ast/basic_node.h>

namespace mml {

  class block_node: public cdk::basic_node {
    cdk::sequence_node *_declarations, *_instructions;

  public:
    block_node(int lineno, cdk::sequence_node *declarations, cdk::sequence_node *instructions) :
        cdk::basic_node(lineno), _declarations(declarations), _instructions(instructions) {
    }

  public:
    cdk::sequence_node* declarations() {
      return _declarations;
    }
    cdk::sequence_node* instructions() {
      return _instructions;
    }

    void accept(basic_ast_visitor *sp, int level) {
      sp->do_block_node(this, level);
    }

  };

} // mml

#endif
