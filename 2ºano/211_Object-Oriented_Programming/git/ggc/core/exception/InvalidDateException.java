package ggc.core.exception;

public class InvalidDateException extends Exception {
  private int _invalidDate;
  
  public InvalidDateException(int id) {
    _invalidDate = id;
  }
  
  public int getInvalidId() {
    return _invalidDate;
  }
}
