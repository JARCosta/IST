package ggc.core.products;

import java.io.Serializable;

public class Component implements Serializable{
  private int _quantity;
  private Product _product;
  
  public Component(Product product, int quantity){
    _quantity = quantity;
    _product = product;
  }

  public Product getProduct(){
    return _product;
  }

  public int getQuantity(){
    return _quantity;
  }
}
