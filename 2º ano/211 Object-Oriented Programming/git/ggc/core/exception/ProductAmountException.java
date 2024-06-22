package ggc.core.exception;

public class ProductAmountException extends Exception {
  private String _productId;
  private int _quantity;
  private int _quantityAsked;
  
  public ProductAmountException(String productId,int quantity, int quantityAsked) {
    _productId = productId;
    _quantity = quantity;
    _quantityAsked=quantityAsked;
  }
  public int getQuantity() {
    return _quantity;
  }
  public String getProductId(){
    return _productId;
  }
  public int getQuantityAsked(){
    return _quantityAsked;
  }

}
