package ggc.core;

import java.io.Serializable;
import java.util.List;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Map;

import java.util.HashMap;
import java.io.IOException;

import ggc.core.exception.BadEntryException;
import ggc.core.exception.DuplicatePartnerIdException;
import ggc.core.exception.InvalidDateException;
import ggc.core.exception.InvalidPartnerIdException;
import ggc.core.exception.InvalidProductIdException;
import ggc.core.exception.InvalidTransactionKeyException;
import ggc.core.exception.ProductAmountException;
import ggc.core.notifications.Notification;
import ggc.core.partners.ElitePartner;
import ggc.core.partners.NormalPartner;
import ggc.core.partners.Partner;
import ggc.core.partners.PartnerComparator;
import ggc.core.partners.SelectionPartner;
import ggc.core.products.AggregateProduct;
import ggc.core.products.Component;
import ggc.core.products.Product;
import ggc.core.products.ProductComparator;
import ggc.core.products.SimpleProduct;
import ggc.core.transactions.Acquisition;
import ggc.core.transactions.Sale;
import ggc.core.transactions.SaleByCredit;
import ggc.core.transactions.BreakdownSale;
import ggc.core.transactions.Transaction;


public class Warehouse implements Serializable {
  private static final long serialVersionUID = 202109192006L;
  private Date _date;
  private Map<String, Partner> _partners;
  private Map<String, Product> _products;
  private Map<Integer,Transaction> _transactions;
  private int _nextTransctionId;
  private Partner _nullPartner;

  public Warehouse(){
    _date = new Date(0);
    _partners = new HashMap<String, Partner>();
    _products = new HashMap<String, Product>();
    _transactions = new HashMap<>();
    _nullPartner = new Partner(null, null, null);
  }
  

//DATE

  public int currentDate(){
    return _date.getDate();
  }
  public Date getDate(){
    return _date;
  }
  public void advanceDate(int days) throws InvalidDateException{
    _date.advanceDate(days);
    for(Partner p : getPartnerList())
      p.updateStatus();
  }


  //PRODUCT

  public Product registerSimpleProduct(String id){
    SimpleProduct product = new SimpleProduct(id);
    _products.put(id, product);
    for(Partner i:getPartnerList()){
      if(!product.getObservers().contains(i))
        product.add(i);
    }
    return product;
  }

  public Product registerAggregateProduct(String id, double aggravation, List<Component> comps){
    AggregateProduct product = new AggregateProduct(id, aggravation, comps);
    _products.put(id, product);
    for(Partner i:getPartnerList()){
      if(!product.getObservers().contains(i))
        product.add(i);
    }
    return product;
  }

  public Product registerAggregateProduct(String id, double aggravation,List<String> ids, List<Integer> qnts) throws InvalidProductIdException{
    ArrayList<Component> comps = new ArrayList<>();
    for(int i=0;i<ids.size();i++){
        comps.add(new Component(getProduct(ids.get(i)), (int)qnts.get(i)));
    }
    AggregateProduct product = new AggregateProduct(id, aggravation, comps);
    _products.put(id, product);
    return product;
  }
  
  public Product getProduct(String id) throws InvalidProductIdException{
    if(!_products.containsKey(id)){
      throw new InvalidProductIdException(id);
    }
    return _products.get(id);
  }
  public Collection<Product> getProductMap(){
    return _products.values();
  }

  public boolean productsContains(String productId) {
    return _products.containsKey(productId);
  }

  public List<Product> getProductList(){
    return new ArrayList<Product>(_products.values());
  }
  public List<Product> getProductSortedList(){
    List<Product> productList = new ArrayList<>(_products.values());
    productList.sort(new ProductComparator());
    return productList;
  }

//PARTNER
  
  public void registerPartner(String id, String name, String adress) throws DuplicatePartnerIdException{
    if(_partners.containsKey(id.toLowerCase())){
      throw new DuplicatePartnerIdException(id);
    }
    Partner partner = new Partner(id, name, adress);
    for(Product i:getProductList()){
      if(!i.getObservers().contains(partner))
        i.add(partner);
    }
// transfer notifications from _nullPartner to partner
    partner.setNotifications(_nullPartner.showNotifications());

    _partners.put(id.toLowerCase(),partner);
  }
  public Partner getPartner(String id) throws InvalidPartnerIdException{
    if(_partners.containsKey(id.toLowerCase())){
      return _partners.get(id.toLowerCase());
    } else{
      throw new InvalidPartnerIdException(id);
    }
  }
  public Map<String, Partner> getPartnerMap(){
    return _partners;
  }
  public List<Partner> getPartnerList(){
    return new ArrayList<>(_partners.values());
  }
  public List<Partner> getPartnerSortedList(){
    List<Partner> partnerList = getPartnerList();
    partnerList.sort(new PartnerComparator());
    return partnerList;
  }
  
  
//BATCH
  
  public void registerBatch(double price, int quantity,Partner partner,Product product){
    Batch batch = new Batch(price, quantity, partner, product);
    product.updateMaxPrice();
    partner.registerBatch(batch);
    product.addBatch(batch);
    product.updateMaxPrice();
    /*System.out.println("");
    int quant = 0;
    for(Batch b : product.getBatchSortedList()){
      quant+= b.getQuantity();
    }
    System.out.println(quant);
    System.out.println(product.getId()+ " "+ product.getQuantity());
    System.out.println("");
    */
  }
  
  public List<Batch> getBatchList(){
    List<Batch> batches= new ArrayList<>();
    for(Product product : new ArrayList<>(_products.values()))
      for(Batch batch : product.getBatches())
        batches.add(batch);
    return batches;
  }
  public List<Batch> sortBatches(List<Batch> batches){
    batches.sort(new BatchComparator());
    return batches;
  }
  public List<Batch> getBatchSortedList(){
    return sortBatches(getBatchList());
  }
  public List<Batch> getBatchSortedList(Product product){
    return sortBatches(product.getBatches());
  }
  
  public List<Batch> getBatchSortedList(Partner partner){
    return sortBatches(partner.getBatches());
  }

  public List<Batch> getBatchSortedByPrice(Product product){
    return null;
  }



//TRANSACTION
  public int getTransactionId(){
    return _nextTransctionId;
  }
  public void advanceTransactionId(){
    _nextTransctionId++;
  }

  public String transactionToString(Transaction sale){
    return sale.toString(getDate());
  }

  public List<Acquisition> getAcquisitionList(String partnerId) throws InvalidPartnerIdException{
    return getPartner(partnerId).getAcquisitionList();
  }

  public List<Sale> getSaleList(String partnerId) throws InvalidPartnerIdException{
    return getPartner(partnerId).getSaleList();
  }

  public void registerAcquisition(Partner partner, Product product, int quantity, double price){
    int quantInit = product.getQuantity();
    double priceInit = product.getMinPrice();

    registerBatch(price, quantity, partner, product);


    int quanFin = product.getQuantity();
    double priceFin = product.getMinPrice();
    //System.out.println(""+ quantInit + "<" + quanFin  );
    boolean hasTransaction=false;
    if(quantInit == 0 && quanFin > 0){
      for(Transaction i : _transactions.values())
      if(i.getProduct().equals(product))
      hasTransaction = true;
      if(hasTransaction)
      product.notifyObservers("NEW");
    }
    //System.out.println(""+ priceFin +"<"+priceInit  );
    if(priceFin<priceInit){
      product.notifyObservers("BARGAIN");
    }
    Acquisition acq = new Acquisition(partner,product, quantity, _nextTransctionId);
    acq.setPaied(new Date(_date.getDate()));
    partner.registerAcquisition(acq, price);
    _transactions.put(_nextTransctionId,acq);
    advanceTransactionId();
  }

  public void registerSaleByCredit(String partnerId, String productId, int quantity, int deadline) throws ProductAmountException, InvalidProductIdException, InvalidPartnerIdException{
    double pricee=0;
    if(getProduct(productId).getQuantity()<quantity){
      if(getProduct(productId) instanceof AggregateProduct){
        for(Batch i : getProduct(productId).getBatches()){   pricee += i.getPrice()*i.getQuantity(); }
        //pricee = getProduct(productId).getQuantity() * getProduct(productId).getMinPrice();
        double unitPrice = registerAggregation(partnerId, productId, quantity - getProduct(productId).getQuantity());
        registerBatch(unitPrice, quantity-getProduct(productId).getQuantity(), getPartner(partnerId), getProduct(productId));
        
        getProduct(productId).updateMaxPrice();

      }else{
        throw new ProductAmountException(productId,getProduct(productId).getQuantity(),quantity);
      }
    }
    SaleByCredit sale = new SaleByCredit(getPartner(partnerId),getProduct(productId), quantity, deadline,_nextTransctionId);
    _transactions.put(_nextTransctionId,sale);
    getPartner(partnerId).registerSaleByCredit(sale);
    advanceTransactionId();
  }

  public double registerAggregation(String partnerId, String productId, int quantity) throws InvalidProductIdException, ProductAmountException, InvalidPartnerIdException{
    double price=0;
    double aggravation=1;
    if(getProduct(productId) instanceof AggregateProduct){
      aggravation += ((AggregateProduct)getProduct(productId)).getRecipe().getAggravaton();
      for(Component c : ((AggregateProduct)getProduct(productId)).getRecipe().getComponents() ){
        price += c.getProduct().getMinPrice()*c.getQuantity();
        if(!(c.getProduct().getQuantity()>quantity*c.getQuantity())){
          if(c.getProduct() instanceof AggregateProduct)
            price = registerAggregation(partnerId, c.getProduct().getId(), quantity-c.getProduct().getQuantity()*c.getQuantity());
          else
            throw new ProductAmountException(c.getProduct().getId(), c.getProduct().getQuantity(), quantity*c.getQuantity());
        }else{
          c.getProduct().removeQuantity(quantity*c.getQuantity(),getPartner(partnerId));
        }
      }
    }else{
      if(getProduct(productId).getQuantity()<quantity) throw new ProductAmountException(productId, getProduct(productId).getQuantity(), quantity);
      else{
        int quant = quantity;
        while (quant>0){
          Batch b = getProduct(productId).searchCheapestBatch();
          if(b.getQuantity()>quant){
            price += quant*b.getPrice();
            b.removeQuantity(quant);
          }else{
            price += b.getQuantity()*b.getPrice();
            quant -= b.getQuantity();
            getProduct(productId).removeBatch(b);
            getPartner(partnerId).removeBatch(b);
          }
        }
      }
    }
    return price*aggravation;
  }

  public void registerBreakDownSale(String partnerId, String productId, int quantity) throws ProductAmountException, InvalidPartnerIdException, InvalidProductIdException{
    try{
      Partner partner = getPartner(partnerId);
      AggregateProduct product = (AggregateProduct) getProduct(productId);
      if(product.getQuantity()<quantity){
        throw new ProductAmountException(productId,product.getQuantity(),quantity);
      }
      int quant = quantity;
      double saleValue=0;
      double buyValue=0;
      while(quant > 0){
        Batch removingBatch = product.searchCheapestBatch();
        buyValue = removingBatch.getPrice();
        for(Component i : product.getRecipe().getComponents()){
          saleValue += i.getProduct().getMinPrice()*i.getQuantity();
          if(i.getProduct().getBatches().size()>0)
            registerBatch(i.getProduct().getMinPrice(), quant*i.getQuantity(), partner, i.getProduct());
          else
            registerBatch(i.getProduct().getMaxPrice(), quant*i.getQuantity(), partner, i.getProduct());
        }
        if(removingBatch.getQuantity() <= quantity){
          quant -= removingBatch.getQuantity();
          partner.removeBatch(removingBatch);
          product.removeBatch(removingBatch);
        }else{
          removingBatch.removeQuantity(quant);
          quant = 0;
        }
      BreakdownSale sale =  new BreakdownSale((AggregateProduct)getProduct(productId), quantity, getPartner(partnerId), getTransactionId());
      //System.out.println(buyValue + " " + saleValue);
      sale.setBaseValue(buyValue - saleValue);
      sale.setPaymentDate(_date);
      _transactions.put(_nextTransctionId,sale);
      getPartner(partnerId).registerBreakSownSale(sale);
      getPartner(partnerId).addPoints(sale.getBaseValue()*10);
      //System.out.println(getTransaction(getTransactionId()).toString(_date) + " " + getTransaction(getTransactionId()).isPaid());
      advanceTransactionId();
      }
    } catch (ClassCastException e){
      System.out.println("Warehouse.registerBreakDownSale()");
    }
  }
  



  public Transaction getTransaction(int transactionId) throws InvalidTransactionKeyException{
    if(!_transactions.containsKey(transactionId))
      throw new InvalidTransactionKeyException(transactionId);
    return _transactions.get(transactionId);
  }
  

  public List<Transaction> getTransactionList(){
    return (List<Transaction>) _transactions.values();
  }
  public void pay(int transactionId)throws IndexOutOfBoundsException, InvalidTransactionKeyException{
    try{
      SaleByCredit trans = (SaleByCredit)getTransaction(transactionId);
      if(trans.getPartner().getStatus().getClass().equals(NormalPartner.class))
        if(_date.getDate() - trans.getDeadline().getDate() > 0) 
          trans.getPartner().multiplyPoints(0);
      if(trans.getPartner().getStatus().getClass().equals(SelectionPartner.class))
        if(_date.getDate() - trans.getDeadline().getDate() > 2) 
          trans.getPartner().multiplyPoints(0.90);
      if(trans.getPartner().getStatus().getClass().equals(ElitePartner.class))
        if(_date.getDate() - trans.getDeadline().getDate() > 15) 
          trans.getPartner().multiplyPoints(0.75);
      ((SaleByCredit)trans).pay(new Date(_date.getDate()));
    } catch (ClassCastException e){
      throw new InvalidTransactionKeyException(transactionId);
    }

  }
  
  
  //NOTIFICATION

  public Collection<Notification> showNotifications(String partnerId) throws InvalidPartnerIdException{
    return getPartner(partnerId).showNotifications();
  }

  public void toggleNotifications(String partnerId, String productId) throws InvalidPartnerIdException, InvalidProductIdException {
    if(getProduct(productId).getObservers().contains(getPartner(partnerId)))
      getProduct(productId).remove(getPartner(partnerId));
    else{ getProduct(productId).add(getPartner(partnerId)); }
    //getPartner(partnerId).toggleNotifications(getProduct(productId));
  }


  /**
   * @param txtfile filename to be loaded.
   * @throws IOException
   * @throws BadEntryException
   * @throws InvalidProductIdException
   * @throws InvalidPartnerIdException
   * @throws DuplicatePartnerIdException
   */
  void importFile(String txtfile) throws IOException, BadEntryException, DuplicatePartnerIdException, InvalidPartnerIdException, InvalidProductIdException {
    Parser parser = new Parser(this);
    parser.parseFile(txtfile);
  }


public List<Transaction> getTransactionsPayed(String partnerId) throws InvalidPartnerIdException {
  List<Transaction> sales = new ArrayList<>();
  for(Transaction s : getPartner(partnerId).getSaleList()){
    if(s.isPaid())
      sales.add(s);
  }
  return sales;
}


public double getBalance() {
  double ret = 0;
  for(Partner i : getPartnerList()){
    for(Acquisition j: i.getAcquisitionList()){
      ret -= j.getBaseValue();
    }
    for(Sale j : i.getSaleList()){
      ret += j.getAmountToPay(_date);
    }
  }
  return ret;
}


  public double getAccountingBalance() {
    double ret = 0;
    for(Partner i : getPartnerList()){
      for(Acquisition j: i.getAcquisitionList()){
        if(j.isPaid())
          ret -= j.getBaseValue();
      }
      for(Sale j : i.getSaleList()){
        if(j.isPaid())

          ret += j.getAmountToPay(_date);
      }
    }
    return ret;
  }
}
