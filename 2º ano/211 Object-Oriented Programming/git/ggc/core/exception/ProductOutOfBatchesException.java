package ggc.core.exception;

public class ProductOutOfBatchesException extends Exception {
  private String _invalidId;
  
  public ProductOutOfBatchesException(String id) {
    _invalidId = id;
  }
  
  public String getInvalidId() {
    return _invalidId;
  }
}
