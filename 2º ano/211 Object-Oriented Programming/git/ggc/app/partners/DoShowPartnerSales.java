package ggc.app.partners;

import pt.tecnico.uilib.menus.Command;
import pt.tecnico.uilib.menus.CommandException;
import ggc.app.exception.UnknownPartnerKeyException;
import ggc.core.WarehouseManager;
import ggc.core.exception.InvalidPartnerIdException;
import ggc.core.transactions.Transaction;

/**
 * Show all transactions for a specific partner.
 */
class DoShowPartnerSales extends Command<WarehouseManager> {

  DoShowPartnerSales(WarehouseManager receiver) {
    super(Label.SHOW_PARTNER_SALES, receiver);
    addStringField("partnerId", Message.requestPartnerKey());
  }

  @Override
  public void execute() throws CommandException {
    try {
      for(Transaction sale:_receiver.getSaleList(stringField("partnerId"))){
        _display.popup(_receiver.transactionToString(sale));
      }
    } catch (InvalidPartnerIdException e) {
      throw new UnknownPartnerKeyException(e.getInvalidId());
    }  
  }
}
