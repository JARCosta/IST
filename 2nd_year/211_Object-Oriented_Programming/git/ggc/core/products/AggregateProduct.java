package ggc.core.products;

import java.util.List;

import ggc.core.partners.Partner;

public class AggregateProduct extends Product {
  private Recipe _recipe;
  
  public AggregateProduct(String id, double aggravation,List<Component> components){
    super(id);
    _recipe = new Recipe(aggravation, components);
  }

  boolean checkQuantity(int quantity, Partner p){
    return super.getQuantity(p) >= quantity;
  }
  
  public int getQuantity(){return super.getQuantity();}
  public Recipe getRecipe(){return _recipe;}

  @Override
  public String toString(){
    return getId() + "|" + Math.round(getMaxPrice()) + "|" + getQuantity() + "|" + _recipe.toString();
  }

}