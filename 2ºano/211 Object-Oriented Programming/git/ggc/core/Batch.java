package ggc.core;

import java.io.Serializable;

import ggc.core.partners.Partner;
import ggc.core.products.Product;

public class Batch implements Serializable{
  /**
   * Batch's price per Product unit
   */
  private double _price;
  /**
   * Batch's quantity of product
   */
  private int _quantity;
  /**
   * Batch's product
   */
  private Product _product;
    /**
   * Batch's partner
   */
  private Partner _partner;

  /**
   * Default constructor of Batch which creates a batch with the given price, quantity, partner and product
   * @param price price per unit
   * @param stock quantity of the product
   * @param partner owner
   * @param product product
   */
  public Batch(double price, int stock,Partner partner, Product product){
    _price = price;
    _quantity = stock;
    _product = product;
    _partner = partner;
  }

  @Override
  public String toString(){
    return _product.getId() + "|" + _partner.getId() + "|" + (int)_price + "|" + _quantity;
  }

  /**
   * Obtain the quantity of this batch
   * @return returns the quantity of this product
   */
  public int getQuantity(){
    return _quantity;
  }

  /**
   * Obtain the price per unit of this batch
   * @return returns the price of product
   */
  public double getPrice(){
    return _price;
  }

  /**
   * Obtain the owner of this batch
   * @return returns the partner owner of this batch
   */
  public Partner getPartner(){
    return _partner;
  }
  /**
   * Obtain the product of which this batch is contained of
   * @return returns the product of this batch
   */
  public Product getProduct(){
    return _product;
  }
  public void removeQuantity(int quantity){
    _quantity -= quantity;
  }
}
