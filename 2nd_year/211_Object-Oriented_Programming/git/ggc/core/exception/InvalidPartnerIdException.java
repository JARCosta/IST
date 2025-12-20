package ggc.core.exception;

public class InvalidPartnerIdException extends Exception {
  private String _invalidId;
  
  public InvalidPartnerIdException(String id) {
    _invalidId = id;
  }
  
  public String getInvalidId() {
    return _invalidId;
  }
}
