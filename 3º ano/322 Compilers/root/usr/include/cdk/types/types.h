#ifndef __CDK17_TYPES_TYPES_H__
#define __CDK17_TYPES_TYPES_H__

#include <cdk/types/basic_type.h>
#include <cdk/types/primitive_type.h>
#include <cdk/types/reference_type.h>
#include <cdk/types/structured_type.h>
#include <cdk/types/functional_type.h>
#include <memory>

namespace cdk {

  inline std::string to_string(std::shared_ptr<basic_type> type) {
    return type->to_string();
  }

} // cdk

#endif
