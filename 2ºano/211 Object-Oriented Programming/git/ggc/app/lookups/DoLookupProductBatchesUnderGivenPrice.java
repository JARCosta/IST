package ggc.app.lookups;

import pt.tecnico.uilib.menus.Command;
import pt.tecnico.uilib.menus.CommandException;
import ggc.core.Batch;
import ggc.core.WarehouseManager;
//FIXME import classes
import ggc.core.products.Product;

/**
 * Lookup products cheaper than a given price.
 */
public class DoLookupProductBatchesUnderGivenPrice extends Command<WarehouseManager> {

  public DoLookupProductBatchesUnderGivenPrice(WarehouseManager receiver) {
    super(Label.PRODUCTS_UNDER_PRICE, receiver);
    addRealField("price", Message.requestPriceLimit());
  }

  @Override
  public void execute() throws CommandException {
    for(Product i : _receiver.getProductSortedList())
      for(Batch j : i.getBatchSortedList())
        if(j.getPrice()<realField("price"))
          _display.popup(j);
  }
}