package ggc.core.products;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

import ggc.core.Batch;
import ggc.core.BatchComparator;
import ggc.core.BatchPriceComparator;
import ggc.core.notifications.Observer;
import ggc.core.partners.Partner;
import ggc.core.notifications.Notification;
/**
* @author Joao Andre Costa 99088 & Jose Maria Vilar Gomes 100598
*
*/

public abstract class Product implements Serializable{
  /**
  * Highest price for a product in all batches
  */
  private double _maxPrice;

  /**
  * Product's id
  */
  private String _id;

  /**
  * List of Batches that contain this product
  */
  private List<Batch> _batches;

  private List<Observer> _observers = new ArrayList<>();

  /**
  * Constructor: Inicialize a product
  * @param id the input value. 
  */
  Product(String id){
    _id = id;
    _maxPrice = 0;
    _batches = new ArrayList<Batch>();
  }

  /**
  * Visual representation of a product 
  */
  @Override
  public String toString(){
    return _id + "|" + Math.round(_maxPrice) + "|" + getQuantity();
  }

  /**
  * Checks if the partner p has enough quantity of this product
  * @param quantity quantity of a product
  * @param Partner a partner 
  * @return true or false to if the total quantity of a product 
  *        is greater than the quantity inserted
  */
  boolean checkQuantity(int quantity, Partner p){
    int total = 0;
    for(Batch batch : p.getBatches()){
      total += batch.getQuantity();
    }
    return total >= quantity;
  }
  
  /**
  * Get the product's id
  * @return id 
  */
  public String getId(){
    return _id;
  }

  /**
  * Obtains the highest price per unit of all batches
  * This method iterates through every batch this product is in 
  *and updates the maxPrice every time it finds a new highest price
  * @return changes the actual maxPrice(highest price) of a product for the new highest price
  */
  public double getMaxPrice(){
    updateMaxPrice();
    return _maxPrice;
  }

  public void updateMaxPrice(){
    for(Batch i : _batches){
      if(_maxPrice<i.getPrice())
        _maxPrice = i.getPrice();
    }
  }

  public double getMinPrice(){
    double minprice = -1;
    for(Batch i : _batches){
      //System.out.println(""+i.getProduct().toString()+ " "+ i.toString() +" "+ i.getPrice());
      if(minprice == -1){ minprice = i.getPrice(); }
      if(minprice>i.getPrice()){ minprice = i.getPrice(); }
    }
    return minprice;
  }

  public Batch searchCheapestBatch() {
    Batch cheapestBatch = null;
    for(Batch batch : getBatchSortedByPriceList()){
      if(/*(batch.getPartner()).equals(partner) &&*/ batch.getProduct().equals(this))
        if(cheapestBatch == null)
          return batch;
    }
    return cheapestBatch;
  }
  public void removeQuantity(int quantity, Partner partner){
    Batch batch = searchCheapestBatch();
    if(quantity>batch.getQuantity()){
      partner.removeBatch(batch);
      removeBatch(batch);
    } else{
      batch.removeQuantity(quantity);
    }
  }

  /**
  * Sum quantity of a product in all batches
  * @return total quantity
  */
  public int getQuantity(){
    int quantity = 0;
    for( Batch i : _batches){
      quantity += i.getQuantity();
    }
    return quantity;
  }

  /**
   * Sum quantity of a porduct in every batch owned by a partner
   * @param p selected partner
   * @return total quantity of this product
   */
  public int getQuantity(Partner p){
    int quantity = 0;
    for( Batch i: _batches){
      if(i.getPartner() == p){
        quantity += i.getQuantity();
      }
    }
    return quantity;
  }

  /**
  * Get the batches this product is in
  * @return list of batches 
  */
  public List<Batch> getBatches(){
    return _batches;
  }
  public List<Batch> getBatchSortedList(Partner partner){
    ArrayList<Batch> batches = new ArrayList<>();

    for(Batch i : getBatchSortedList()){
      if(i.getPartner().equals(partner))
        batches.add(i);
    }

    return batches;
  }

  /**
  * Sort the list of batches this product is in
  * @return sorted list
  */
  public ArrayList<Batch> getBatchSortedList(){
    ArrayList<Batch> batchSorted = (ArrayList<Batch>) _batches;
    batchSorted.sort(new BatchComparator());
    return batchSorted;
  }
  public ArrayList<Batch> getBatchSortedByPriceList(){
    ArrayList<Batch> batchSorted = (ArrayList<Batch>) _batches;
    batchSorted.sort(new BatchPriceComparator());
    return batchSorted;
  }

  /**
  * Associate a new batch to this product 
  */
  public void addBatch(Batch batch){
    _batches.add(batch);
  }

  public void removeBatch(Batch batch){
    _batches.remove(batch);
  }

  
  @Override
  public int hashCode(){
    return Objects.hash(_id);
  }

  @Override
  public boolean equals(Object p2){
    return p2 instanceof Product && _id.equals(((Product) p2).getId());
  }



//OBSERVER

  public boolean add(Observer obs) {
    // adiciona partner interessado
    return _observers.add(obs);
  }
  public boolean remove(Observer obs) {
    // remove partner interessado
    return _observers.remove(obs);
  }
  
  public void notifyObservers(String type) {
    // notifica partners
    //System.out.println("aaaaaaaaaaa");
    for (Observer obs : _observers){
      //System.out.println(obs.toString());
      if(type.equals("NEW"))
        obs.notify(new Notification("NEW", this, getMinPrice()));
      else{
        obs.notify(new Notification("BARGAIN", this, getMinPrice()));
    }
    }
  }
  public List<Observer> getObservers(){
    return _observers;
  }
}