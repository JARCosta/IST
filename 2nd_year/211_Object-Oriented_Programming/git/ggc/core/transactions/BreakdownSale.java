package ggc.core.transactions;

import java.util.List;

import ggc.core.Batch;
import ggc.core.Date;
import ggc.core.partners.Partner;
import ggc.core.products.AggregateProduct;
import ggc.core.products.Component;
import ggc.core.products.Product;

public class BreakdownSale extends Sale{
  private List<Batch> _batches;

  public BreakdownSale(Product product, int quantity, Partner partner, int transactionId){
    super(product, quantity, partner,transactionId);
    _batches = product.getBatchSortedList(partner);
  }
  public List<Batch> getBatchList(){
    return _batches;
  }
  public void setPaymentDate(Date now){
    super.setPaymentDate(now);
  }
  public double getPricePaid(){
    if(getBaseValue()<0) return 0;
    return getBaseValue();
  }

  @Override
  //DESAGREGAÇÃO|id|idParceiro|idProduto|quantidade|valor-base|valor-pago|data-pagamento|idC1:q1:v1#...#idCN:qN:vN
  public String toString(Date now) {
    String ret = "";
    AggregateProduct prod = (AggregateProduct)getProduct();
    for(Component c : prod.getRecipe().getComponents()){
      if(ret != "")
        ret += "#";
      ret += c.getProduct().getId() + ":" + c.getQuantity()*super.getQuantity() + ":" + (int)c.getProduct().getMinPrice()*super.getQuantity()*c.getQuantity();
    }
    return"DESAGREGAÇÃO|" + super.getId() + "|" + super.getPartner().getId() + "|" + super.getProduct().getId() + "|" + super.getQuantity() + "|" + (int)super.getBaseValue() + "|" + (int)getPricePaid() + "|" + super.getPaymentDate() + "|" + ret;
  }
}
