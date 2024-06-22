#ifndef __MML_AST_PROGRAM_NODE_H__
#define __MML_AST_PROGRAM_NODE_H__

#include <cdk/ast/basic_node.h>
#include "ast/block_node.h"

namespace mml {

  /**
   * Class for describing program nodes.
   */
  class program_node: public cdk::basic_node {
    cdk::sequence_node *_file_declarations;
    mml::block_node *_block;

  public:
    inline program_node(int lineno, cdk::sequence_node *file_declarations, mml::block_node *block = nullptr) :
        cdk::basic_node(lineno), _file_declarations(file_declarations), _block(block) {
    }

  public:
    inline cdk::sequence_node *file_declarations() {
      return _file_declarations;
    }

    inline mml::block_node *block() {
      return _block;
    }

    void accept(basic_ast_visitor *sp, int level) {
      sp->do_program_node(this, level);
    }

  };

} // mml

#endif
