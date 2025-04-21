package ggc.core.products;

import ggc.core.partners.Partner;

public class SimpleProduct extends Product{

  
  public SimpleProduct(String id){
    super(id);
  }

  boolean checkQuantity(int quantity, Partner p){
    return super.getQuantity(p) >= quantity;
  }

  public int getQuantity(){
    return super.getQuantity();
  }

  @Override
  public String toString(){
    return getId() + "|" + Math.round(getMaxPrice()) + "|" + getQuantity();
  }
}
