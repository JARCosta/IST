package ggc.app.lookups;

import pt.tecnico.uilib.menus.Command;
import pt.tecnico.uilib.menus.CommandException;
import ggc.app.exception.UnknownPartnerKeyException;
import ggc.core.WarehouseManager;
import ggc.core.exception.InvalidPartnerIdException;
//FIXME import classes
import ggc.core.transactions.Transaction;

/**
 * Lookup payments by given partner.
 */
public class DoLookupPaymentsByPartner extends Command<WarehouseManager> {

  public DoLookupPaymentsByPartner(WarehouseManager receiver) {
    super(Label.PAID_BY_PARTNER, receiver);
    addStringField("partnerId", Message.requestPartnerKey());
  }

  @Override
  public void execute() throws CommandException {
    try{
      for(Transaction t : _receiver.getTransactionsPayed(stringField("partnerId"))){
        _display.popup(t.toString(_receiver.getdate()));
      }
    } catch (InvalidPartnerIdException e){
      throw new UnknownPartnerKeyException(e.getInvalidId());
    }
  }
}