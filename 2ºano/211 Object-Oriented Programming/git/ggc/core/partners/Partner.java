package ggc.core.partners;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Objects;
import java.util.Map;

import ggc.core.Batch;
import ggc.core.Date;
import ggc.core.notifications.Notification;
import ggc.core.notifications.Observer;
import ggc.core.products.Product;
import ggc.core.products.SimpleProduct;
import ggc.core.transactions.Acquisition;
import ggc.core.transactions.BreakdownSale;
import ggc.core.transactions.Sale;
import ggc.core.transactions.SaleByCredit;

public class Partner implements Serializable, Observer{
  private String _name;
  private String _adress;
  private String _id;
  private Status _status;

  private double _points;
  private double _valorCompras;
  private double _valorVendas;
  private double _valorVendasPagas;
  private ArrayList<Batch> _batches;
  private List<Acquisition> _acquisitions;
  private List<Sale> _sales;
  private List<Notification> _relevantNotifications;
  private Map<Product, String> _relevantProducts;

  public Partner(String id, String name, String adress){
    _name = name;
    _adress = adress;
    _id = id;
    _status= NormalPartner.getInstance();
    _points = 0;
    _batches = new ArrayList<Batch>();
    _acquisitions = new ArrayList<Acquisition>();
    _sales = new ArrayList<Sale>();
    _relevantNotifications = new ArrayList<>();
    _relevantProducts = new HashMap<Product, String>();
  }

  public String getId(){
    return _id;
  }
  public void notify(Notification notification){
    //System.out.println("aaaaaaaaaaaaaaaaaaaaaaaaaaa");
    _relevantNotifications.add(notification);
  }

//BATCHES--------------------------------------------------------------------------------------------------------
  
  public void registerBatch(double price, int stock, Product product){
    Batch batch = new Batch(price, stock, this, product);
    _batches.add(batch);
  }
  public void registerBatch(Batch batch){
    _batches.add(batch);
  }
  public void removeBatch(Batch batch){
    _batches.remove(batch);
  }
  public List<Batch> getBatches(){
    return _batches;
  }
  public List<Batch> getBatches(Product p){
    ArrayList<Batch> ret = new ArrayList<>();
    for(Batch b : _batches){
      if(b.getProduct().equals(p)){
        ret.add(b);
      }
    }
    return ret;
  }


//TRANSACTION--------------------------------------------------------------------------------------------------------

  public void registerAcquisition(Acquisition acq,double price){
    //System.out.println(price);
    _acquisitions.add(acq);
    acq.setBaseValue(price);
    _valorCompras += acq.getBaseValue();
    //System.out.println("A"+price + " "+ acq.getQuantity());
  }
  public void registerSaleByCredit(SaleByCredit sale){
    //System.out.println(sale.getAmountToPay());
    _sales.add(sale);
  }
  public void registerBreakSownSale(BreakdownSale sale){
    _sales.add(sale);
  }

  public List<Acquisition> getAcquisitionList(){
    return _acquisitions;
  }

  public List<Sale> getSaleList(){
    return _sales;
  }


// NOTIFICATION--------------------------------------------------------------------------------------------------------

public void clearNotifications(){
    _relevantNotifications.clear();
  }

  public Collection<Notification> showNotifications(){
    return _relevantNotifications;
  }

  public void setNotifications(Collection<Notification> notifs){
    for(Notification notif: notifs){
      _relevantNotifications.add(notif);
    }
  }

//STATUS--------------------------------------------------------------------------------------------------------

  public Status getStatus(){
    return _status;
  }
  public double getPoints(){
    return _points;
  }
  public void addPoints(double adding){
    _points += adding;
  }
  public void multiplyPoints(double value){
    _points = _points*value;
  }

  public double calculateP(Date deadline,Date now, Product product) {
    int n;
    if(product instanceof SimpleProduct)
      n = 5;
    else
      n = 3;
    int diff = now.difference(deadline);
    //System.out.println(diff);
    if(diff >= n){
      //System.out.println("P1");
        return _status.P1(diff);
    }
    else if(0 <= diff && diff < n){
      //System.out.println("P2");
      return _status.P2(diff);
    }
    else if(0<-diff && -diff <= n){
      //System.out.println("P3");
      return _status.P3(-diff);
    }
    else{
      //System.out.println("P4");
      return _status.P4(-diff);
    }
  }

  // desenho: state + singleton
  public void updateStatus(){
    if(_points>2000)
      if(_points>25000)
      _status = ElitePartner.getInstance();
      else
      _status = SelectionPartner.getInstance();
    else
    _status = NormalPartner.getInstance();
  }

//---------------------------------------------------------------------------------------------------------------------

  @Override
  public int hashCode(){
    return Objects.hash(_id);
  }
  @Override
  public boolean equals(Object p2){
    return p2 instanceof Partner && _id.equals(((Partner) p2).getId());
  }
  
  @Override
  public String toString() {
    return _id + "|" + _name + "|" + _adress + "|" + _status.getStatus() + "|" + (int)_points + "|" + Math.round(_valorCompras) + "|" + Math.round(getVendas()) + "|" + Math.round(getVendasPagas());
  }

  public double getVendas(){
    _valorVendas = 0;
    for(Sale i :_sales){
      if(i.getClass().equals(SaleByCredit.class))
        _valorVendas+= i.getBaseValue();
    }
    return _valorVendas;
  }
  public double getVendasPagas(){
    _valorVendasPagas = 0;
    for(Sale i :_sales){
      if(i.getClass().equals(SaleByCredit.class))
        if(i.isPaid())
          _valorVendasPagas+= i.getPricePaid();
    }
    return _valorVendasPagas;
  }


}