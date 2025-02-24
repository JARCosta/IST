package pt.tecnico.uilib.forms;

/**
 * Interaction messages.
 */
interface Messages {

  /**
   * @param form
   * @param key
   * @return message text.
   */
  static String keyAlreadyExists(String form, String key) {
    return String.format("O campo '%s' está duplicado do formulário '%s'.", key, form);
  }

  /**
   * @param form
   * @param key
   * @return message text.
   */
  static String keyNotFound(String form, String key) {
    return String.format("O campo '%s' não existe no formulário '%s'.", key, form);
  }

  /**
   * @param form
   * @param key
   * @param actualType
   * @param requestedType
   * @return message text.
   */
  static String typeMismatch(String form, String key, String actualType, String requestedType) {
    return String.format("O campo '%s' do formulário '%s' tem o tipo '%s' e não '%s'.", key, form, actualType, requestedType);
  }

}
