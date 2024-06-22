#include <string>
#include <iostream>
#include <memory>
#include <cdk/types/types.h>
#include "targets/type_checker.h"
#include "targets/xml_writer.h"
#include "targets/symbol.h"
#include "ast/all.h"
// must come after other #includes
#include "og_parser.tab.h"

static std::string qualifier_name(int qualifier) {
  if (qualifier == tPUBLIC) return "public";
  if (qualifier == tPRIVATE)
    return "private";
  else
    return "unknown qualifier";
}

//---------------------------------------------------------------------------

void og::xml_writer::do_data_node(cdk::data_node *const node, int lvl) {
  // EMPTY
}

void og::xml_writer::do_nil_node(cdk::nil_node *const node, int lvl) {
  openTag(node, lvl);
  closeTag(node, lvl);
}

void og::xml_writer::do_sequence_node(cdk::sequence_node *const node, int lvl) {
  os() << std::string(lvl, ' ') << "<" << node->label() << " size='" << node->size() << "'>" << std::endl;
  for (size_t i = 0; i < node->size(); i++) {
    cdk::basic_node *n = node->node(i);
    if (n == NULL) break;
    n->accept(this, lvl + 2);
  }
  closeTag(node, lvl);
}

//---------------------------------------------------------------------------

void og::xml_writer::do_double_node(cdk::double_node *const node, int lvl) {
  do_literal_node(node, lvl);
}

void og::xml_writer::do_integer_node(cdk::integer_node *const node, int lvl) {
  do_literal_node(node, lvl);
}

void og::xml_writer::do_string_node(cdk::string_node *const node, int lvl) {
  do_literal_node(node, lvl);
}

//---------------------------------------------------------------------------
//protected:
void og::xml_writer::do_unary_operation_node(cdk::unary_operation_node *const node, int lvl) {
  openTag(node, lvl);
  node->argument()->accept(this, lvl + 2);
  closeTag(node, lvl);
}

void og::xml_writer::do_binary_operation_node(cdk::binary_operation_node *const node, int lvl) {
  openTag(node, lvl);
  node->left()->accept(this, lvl + 2);
  node->right()->accept(this, lvl + 2);
  closeTag(node, lvl);
}

//---------------------------------------------------------------------------

void og::xml_writer::do_neg_node(cdk::neg_node *const node, int lvl) {
  do_unary_operation_node(node, lvl);
}

//---------------------------------------------------------------------------

void og::xml_writer::do_add_node(cdk::add_node *const node, int lvl) {
  do_binary_operation_node(node, lvl);
}
void og::xml_writer::do_sub_node(cdk::sub_node *const node, int lvl) {
  do_binary_operation_node(node, lvl);
}
void og::xml_writer::do_div_node(cdk::div_node *const node, int lvl) {
  do_binary_operation_node(node, lvl);
}
void og::xml_writer::do_mod_node(cdk::mod_node *const node, int lvl) {
  do_binary_operation_node(node, lvl);
}
void og::xml_writer::do_mul_node(cdk::mul_node *const node, int lvl) {
  do_binary_operation_node(node, lvl);
}
void og::xml_writer::do_eq_node(cdk::eq_node *const node, int lvl) {
  do_binary_operation_node(node, lvl);
}
void og::xml_writer::do_ge_node(cdk::ge_node *const node, int lvl) {
  do_binary_operation_node(node, lvl);
}
void og::xml_writer::do_gt_node(cdk::gt_node *const node, int lvl) {
  do_binary_operation_node(node, lvl);
}
void og::xml_writer::do_le_node(cdk::le_node *const node, int lvl) {
  do_binary_operation_node(node, lvl);
}
void og::xml_writer::do_lt_node(cdk::lt_node *const node, int lvl) {
  do_binary_operation_node(node, lvl);
}
void og::xml_writer::do_ne_node(cdk::ne_node *const node, int lvl) {
  do_binary_operation_node(node, lvl);
}

//===========================================================================

void og::xml_writer::do_variable_node(cdk::variable_node *const node, int lvl) {
  os() << std::string(lvl, ' ') << "<" << node->label() << ">" << node->name() << "</" << node->label() << ">" << std::endl;
}

void og::xml_writer::do_rvalue_node(cdk::rvalue_node *const node, int lvl) {
  ASSERT_SAFE
  ;
  openTag(node, lvl);
  node->lvalue()->accept(this, lvl + 4);
  closeTag(node, lvl);
}

void og::xml_writer::do_assignment_node(cdk::assignment_node *const node, int lvl) {
  ASSERT_SAFE
  ;
  openTag(node, lvl);
  node->lvalue()->accept(this, lvl + 2);
  node->rvalue()->accept(this, lvl + 2);
  closeTag(node, lvl);
}

//===========================================================================

void og::xml_writer::do_or_node(cdk::or_node *const node, int lvl) {
  do_binary_operation_node(node, lvl);
}
void og::xml_writer::do_and_node(cdk::and_node *const node, int lvl) {
  do_binary_operation_node(node, lvl);
}
void og::xml_writer::do_not_node(cdk::not_node *const node, int lvl) {
  do_unary_operation_node(node, lvl);
}

void og::xml_writer::do_print_node(og::print_node *const node, int lvl) {
  ASSERT_SAFE
  ;
  openTag(node, lvl);
  node->arguments()->accept(this, lvl + 2);
  closeTag(node, lvl);
}

void og::xml_writer::do_input_node(og::input_node *const node, int lvl) {
  openTag(node, lvl);
  closeTag(node, lvl);
}

//---------------------------------------------------------------------------

void og::xml_writer::do_evaluation_node(og::evaluation_node *const node, int lvl) {
  openTag(node, lvl);
  node->expression()->accept(this, lvl);
  closeTag(node, lvl);
}

void og::xml_writer::do_block_node(og::block_node *const node, int lvl) {
  openTag(node, lvl);
  openTag("declarations", lvl);
  if (node->declarations()) {
    node->declarations()->accept(this, lvl + 4);
  }
  closeTag("declarations", lvl);
  openTag("instructions", lvl);
  if (node->instructions()) {
    node->instructions()->accept(this, lvl + 4);
  }
  closeTag("instructions", lvl);
  closeTag(node, lvl);
}

void og::xml_writer::do_index_node(og::index_node *const node, int lvl) {
  openTag(node, lvl);
  openTag("base", lvl);
  node->base()->accept(this, lvl + 2);
  closeTag("base", lvl);
  openTag("index", lvl);
  node->index()->accept(this, lvl + 2);
  closeTag("index", lvl);
  closeTag(node, lvl);
}

void og::xml_writer::do_tuple_index_node(og::tuple_index_node *const node, int lvl) {
  os() << std::string(lvl, ' ') << "<" << node->label() << " position='" << node->position() << "'>" << std::endl;
  openTag("base", lvl);
  node->base()->accept(this, lvl + 2);
  closeTag("base", lvl);
  closeTag(node, lvl);
}

void og::xml_writer::do_address_of_node(og::address_of_node *const node, int lvl) {
  openTag(node, lvl);
  node->lvalue()->accept(this, lvl + 2);
  closeTag(node, lvl);
}

void og::xml_writer::do_stack_alloc_node(og::stack_alloc_node *const node, int lvl) {
  openTag(node, lvl);
  node->argument()->accept(this, lvl + 2);
  closeTag(node, lvl);
}

void og::xml_writer::do_nullptr_node(og::nullptr_node *const node, int lvl) {
  openTag(node, lvl);
  closeTag(node, lvl);
}

void og::xml_writer::do_for_node(og::for_node *const node, int lvl) {
  os() << std::string(lvl, ' ') << "<" << node->label() << ">" << std::endl;
  openTag("init", lvl);
  node->init()->accept(this, lvl + 4);
  closeTag("init", lvl);
  openTag("condition", lvl);
  node->condition()->accept(this, lvl + 4);
  closeTag("condition", lvl);
  openTag("step", lvl);
  node->step()->accept(this, lvl + 4);
  closeTag("step", lvl);
  openTag("instruction", lvl);
  node->instruction()->accept(this, lvl + 4);
  closeTag("instruction", lvl);
  closeTag(node, lvl);
}

void og::xml_writer::do_break_node(og::break_node *const node, int lvl) {
  openTag(node, lvl);
  closeTag(node, lvl);
}

void og::xml_writer::do_continue_node(og::continue_node *const node, int lvl) {
  openTag(node, lvl);
  closeTag(node, lvl);
}

//---------------------------------------------------------------------------

void og::xml_writer::do_if_node(og::if_node *const node, int lvl) {
  openTag(node, lvl);
  openTag("condition", lvl);
  node->condition()->accept(this, lvl + 4);
  closeTag("condition", lvl);
  openTag("then", lvl);
  node->block()->accept(this, lvl + 4);
  closeTag("then", lvl);
  closeTag(node, lvl);
}

void og::xml_writer::do_if_else_node(og::if_else_node *const node, int lvl) {
  openTag(node, lvl);
  openTag("condition", lvl);
  node->condition()->accept(this, lvl + 4);
  closeTag("condition", lvl);
  openTag("then", lvl);
  node->thenblock()->accept(this, lvl + 4);
  closeTag("then", lvl);
  if (node->elseblock()) {
    openTag("else", lvl);
    node->elseblock()->accept(this, lvl + 4);
    closeTag("else", lvl);
  }
  closeTag(node, lvl);
}

//---------------------------------------------------------------------------

void og::xml_writer::do_function_call_node(og::function_call_node *const node, int lvl) {
  os() << std::string(lvl, ' ') << "<" << node->label() << " name='" << node->identifier() << "'>" << std::endl;
  openTag("arguments", lvl);
  if (node->arguments()) node->arguments()->accept(this, lvl + 4);
  closeTag("arguments", lvl);
  closeTag(node, lvl);
}

void og::xml_writer::do_function_declaration_node(og::function_declaration_node *const node, int lvl) {
  if (_inFunctionBody || _inFunctionArgs) {
    error(node->lineno(), "cannot declare function in body or in args");
    return;
  }

  //DAVID: FIXME: should be at the beginning
  ASSERT_SAFE;
  reset_new_symbol();

  os() << std::string(lvl, ' ') << "<" << node->label() << " name='" << node->identifier() << "' qualifier='"
      << qualifier_name(node->qualifier()) << "' type='" << cdk::to_string(node->type()) << "'>" << std::endl;

  openTag("arguments", lvl);
  if (node->arguments()) {
    _symtab.push();
    node->arguments()->accept(this, lvl + 4);
    _symtab.pop();
  }
  closeTag("arguments", lvl);
  closeTag(node, lvl);
}

void og::xml_writer::do_function_definition_node(og::function_definition_node *const node, int lvl) {
  if (_inFunctionBody || _inFunctionArgs) {
    error(node->lineno(), "cannot define function in body or in args");
    return;
  }

  //DAVID: FIXME: should be at the beginning
  ASSERT_SAFE
  ;

  // remember symbol so that args and body know
  _function = new_symbol();
  reset_new_symbol();

  _inFunctionBody = true;
  _symtab.push(); // scope of args

  os() << std::string(lvl, ' ') << "<" << node->label() << " name='" << node->identifier() << "' qualifier='"
      << qualifier_name(node->qualifier()) << "' type='" << cdk::to_string(node->type()) << "'>" << std::endl;

  openTag("arguments", lvl);
  if (node->arguments()) {
    _inFunctionArgs = true; //FIXME really needed?
    node->arguments()->accept(this, lvl + 4);
    _inFunctionArgs = false; //FIXME really needed?
  }
  closeTag("arguments", lvl);
  node->block()->accept(this, lvl + 2);
  closeTag(node, lvl);

  _symtab.pop(); // scope of args
  _inFunctionBody = false;
}

void og::xml_writer::do_return_node(og::return_node *const node, int lvl) {
  ASSERT_SAFE
  ;

  openTag(node, lvl);
  if (node->retval()) node->retval()->accept(this, lvl + 4);
  closeTag(node, lvl);
}

//---------------------------------------------------------------------------

void og::xml_writer::do_variable_declaration_node(og::variable_declaration_node *const node, int lvl) {
  ASSERT_SAFE;
  reset_new_symbol();

  os() << std::string(lvl, ' ') << "<" << node->label() << " name='" << node->identifier() << "' qualifier='"
      << qualifier_name(node->qualifier()) << "' type='" << cdk::to_string(node->type()) << "'>" << std::endl;

  if (node->initializer()) {
    openTag("initializer", lvl);
    node->initializer()->accept(this, lvl + 4);
    closeTag("initializer", lvl);
  }
  closeTag(node, lvl);
}

void og::xml_writer::do_tuple_declaration_node(og::tuple_declaration_node *const node, int lvl) {
  ASSERT_SAFE
  ;
  reset_new_symbol();

  openTag(node, lvl);
  os() << std::string(lvl, ' ') << "<qualifier value='" << qualifier_name(node->qualifier()) << "'/>" << std::endl;

  openTag("identifiers", lvl);
  for (auto id : node->identifiers())
    os() << std::string(lvl, ' ') << "<identifier name='" << id << "'/>" << std::endl;
  closeTag("identifiers", lvl);

  openTag("initializers", lvl);
  node->initializers()->accept(this, lvl + 4);
  closeTag("initializers", lvl);

  closeTag(node, lvl);
}

//---------------------------------------------------------------------------

void og::xml_writer::do_tuple_node(og::tuple_node *const node, int lvl) {
  openTag(node, lvl);
  node->fields()->accept(this, lvl + 2);
  closeTag(node, lvl);
}

//---------------------------------------------------------------------------

void og::xml_writer::do_sizeof_node(og::sizeof_node *const node, int lvl) {
  openTag(node, lvl);
  node->expression()->accept(this, lvl + 2);
  closeTag(node, lvl);
}

//---------------------------------------------------------------------------
