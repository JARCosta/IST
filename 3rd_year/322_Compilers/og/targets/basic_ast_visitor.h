#ifndef __OG_TARGETS_BASIC_AST_VISITOR_H__
#define __OG_TARGETS_BASIC_AST_VISITOR_H__

#include <string>
#include <memory>
#include <iostream>
#include <cdk/compiler.h>
#include <cdk/symbol_table.h>
#include "targets/symbol.h"

/* include node forward declarations */
#define __NODE_DECLARATIONS_ONLY__
#include "ast/all.h"  // automatically generated
#undef __NODE_DECLARATIONS_ONLY__

/**
 * Base class of the hierarchy of node visitors.
 */
class basic_ast_visitor {
protected:
  //! The owner compiler
  std::shared_ptr<cdk::compiler> _compiler;

private:

  // last symbol inserted in symbol table
  std::shared_ptr<og::symbol> _new_symbol;

protected:
  basic_ast_visitor(std::shared_ptr<cdk::compiler> compiler) :
      _compiler(compiler) {
  }

  bool debug() {
    return _compiler->debug();
  }

  std::ostream &os() {
    return *_compiler->ostream();
  }

public:
  virtual ~basic_ast_visitor() {
  }

public:
  std::shared_ptr<og::symbol> new_symbol() {
    return _new_symbol;
  }

  void set_new_symbol(std::shared_ptr<og::symbol> symbol) {
    _new_symbol = symbol;
  }

  void reset_new_symbol() {
    _new_symbol = nullptr;
  }

public:
  // do not edit these lines
#define __IN_VISITOR_HEADER__
#define __PURE_VIRTUAL_DECLARATIONS_ONLY__
#include "ast/visitor_decls.h"       // automatically generated
#undef __PURE_VIRTUAL_DECLARATIONS_ONLY__
#undef __IN_VISITOR_HEADER__
  // do not edit these lines: end

};

#endif
