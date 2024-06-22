package ggc.core.transactions;

import ggc.core.Date;
import ggc.core.partners.Partner;
import ggc.core.products.Product;

public class Acquisition extends Transaction{
  private Partner _partner;

  @Override
  public boolean isPaid(){ return true;}

  public Acquisition(Partner partner, Product product, int quantity, int transactionId){
    super(product, quantity,transactionId);
    _partner = partner;
  }
  public double getTotalPrice(){
    return getBaseValue()*getQuantity();
  }

  public void setPaied(Date date){
    super.setPaymentDate(date);
  }

  @Override
  public String toString(Date now) {
    //COMPRA|id|idParceiro|idProduto|quantidade|valor-pago|data-pagamento
    return "COMPRA|" + super.getId() + "|" + _partner.getId() + "|" + super.getProduct().getId() + "|" + super.getQuantity() + "|" + (int)getBaseValue() + "|" + super.getPaymentDate();
  }
}