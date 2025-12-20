#ifndef __CDK17_TYPES_FUNCTIONAL_TYPE_H__
#define __CDK17_TYPES_FUNCTIONAL_TYPE_H__

#include <vector>
#include <numeric>
#include <cdk/types/basic_type.h>
#include <cdk/types/structured_type.h>

namespace cdk {

  /**
   * This class represents a functional type concept.
   */
  class functional_type: public basic_type {
    std::shared_ptr<structured_type> _input;
    std::shared_ptr<structured_type> _output;

  public:

    // DAVID size 4 is because this is actually just a pointer
    explicit functional_type(explicit_call_disabled, const std::vector<std::shared_ptr<basic_type>> &input, const std::vector<std::shared_ptr<basic_type>> &output) :
        basic_type(4, TYPE_FUNCTIONAL), _input(structured_type::create(input)), _output(structured_type::create(output)) {
      // EMPTY
    }

    ~functional_type() = default;

  public:

    std::shared_ptr<basic_type> input(size_t ix) {
      return _input->component(ix);
    }
    const std::shared_ptr<structured_type> &input() const {
      return _input;
    }
    size_t input_length() const {
      return _input->length();
    }

    std::shared_ptr<basic_type> output(size_t ix) {
      return _output->component(ix);
    }
    const std::shared_ptr<structured_type> &output() const {
      return _output;
    }
    size_t output_length() const {
      return _output->length();
    }

  public:

    std::string to_string() const {
      return _input->to_string() + ":" + _output->to_string();
    }

  public:

    static auto create(const std::vector<std::shared_ptr<basic_type>> &input_types, const std::vector<std::shared_ptr<basic_type>> &output_types) {
      return std::make_shared<functional_type>(explicit_call_disabled(), input_types, output_types);
    }

    static auto create(const std::vector<std::shared_ptr<basic_type>> &input_types, const std::shared_ptr<basic_type> &output_type) {
      std::vector<std::shared_ptr<basic_type>> output_types = { output_type };
      return std::make_shared<functional_type>(explicit_call_disabled(), input_types, output_types);
    }

    static auto create(const std::vector<std::shared_ptr<basic_type>> &output_types) {
      std::vector<std::shared_ptr<basic_type>> input_types;
      return std::make_shared<functional_type>(explicit_call_disabled(), input_types, output_types);
    }

    static auto create(const std::shared_ptr<basic_type> &output_type) {
      std::vector<std::shared_ptr<basic_type>> output_types = { output_type };
      return create(output_types);
    }

    static auto cast(std::shared_ptr<basic_type> type) {
      return std::dynamic_pointer_cast<functional_type>(type);
    }

  };

} // cdk

#endif
