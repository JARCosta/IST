package ggc.core.exception;

public class DuplicatePartnerIdException extends Exception {
  private String _duplicateId;
  
  public DuplicatePartnerIdException(String id) {
  _duplicateId = id;
  }

  public String getInvalidId() {
  return _duplicateId;
  }
}