package ggc.core.exception;

public class InvalidProductIdException extends Exception {
  private String _invalidId;
  
  public InvalidProductIdException(String id) {
    _invalidId = id;
  }
  
  public String getInvalidId() {
    return _invalidId;
  }
}
