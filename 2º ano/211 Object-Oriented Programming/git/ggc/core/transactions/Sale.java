package ggc.core.transactions;

import ggc.core.Date;
import ggc.core.partners.Partner;
import ggc.core.products.Product;

public abstract class Sale extends Transaction {
  private Partner _Partner;
  
  Sale(Product product, int quantity, Partner partner, int transactionId){
    super(product, quantity,transactionId);
    _Partner = partner;
  }
  public double getTotalPrice(){
    return super.getQuantity()*super.getBaseValue();
  }
  public Partner getPartner(){
    return _Partner;
  }
  public double getAmountToPay(Date _date){return 0;}
  public double getPricePaid(){return 0;}
}
