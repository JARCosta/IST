#ifndef __OG_AST_FOR_H__
#define __OG_AST_FOR_H__

#include <cdk/ast/basic_node.h>
#include <cdk/ast/sequence_node.h>

namespace og {

  class for_node: public cdk::basic_node {
  protected:
    cdk::basic_node *_init;
    cdk::sequence_node *_condition;
    cdk::sequence_node *_step;
    cdk::basic_node *_instruction;

  public:
    for_node(int lineno, cdk::basic_node *init, cdk::sequence_node *condition, cdk::sequence_node *step,
             cdk::basic_node *instruction) :
        cdk::basic_node(lineno), _init(init), _condition(condition), _step(step), _instruction(instruction) {
    }

  public:
    cdk::basic_node* init() {
      return _init;
    }
    cdk::sequence_node* condition() {
      return _condition;
    }
    cdk::sequence_node* step() {
      return _step;
    }
    cdk::basic_node* instruction() {
      return _instruction;
    }

    void accept(basic_ast_visitor *sp, int level) {
      sp->do_for_node(this, level);
    }

  };

} // og

#endif
