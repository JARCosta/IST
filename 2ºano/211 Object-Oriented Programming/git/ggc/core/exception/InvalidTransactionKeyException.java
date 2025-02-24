package ggc.core.exception;

public class InvalidTransactionKeyException extends Exception {
  private int _invalidId;
  
  public InvalidTransactionKeyException(int id) {
    _invalidId = id;
  }
  
  public int getInvalidId() {
    return _invalidId;
  }
}
