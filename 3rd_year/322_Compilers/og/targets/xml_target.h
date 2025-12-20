#ifndef __OG_TARGET_XML_TARGET_H__
#define __OG_TARGET_XML_TARGET_H__

#include <iostream>
#include <memory>
#include <cdk/targets/basic_target.h>
#include <cdk/symbol_table.h>
#include <cdk/ast/basic_node.h>
#include <cdk/compiler.h>
#include <cdk/emitters/postfix_ix86_emitter.h>
#include "targets/xml_writer.h"
#include "targets/symbol.h"

namespace og {

  class xml_target: public cdk::basic_target {
    static xml_target _self;

  protected:
    xml_target(const char *target = "xml") :
        cdk::basic_target(target) {
    }

  public:
    bool evaluate(std::shared_ptr<cdk::compiler> compiler) {
      cdk::symbol_table<symbol> symtab; // will be used to check identifiers
      xml_writer sp(compiler, symtab);
      compiler->ast()->accept(&sp, 0);
      return true;
    }

  };

} // og

#endif
