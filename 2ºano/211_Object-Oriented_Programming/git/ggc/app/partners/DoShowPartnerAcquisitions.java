package ggc.app.partners;

import pt.tecnico.uilib.menus.Command;
import pt.tecnico.uilib.menus.CommandException;
import ggc.app.exception.UnknownPartnerKeyException;
import ggc.core.WarehouseManager;
import ggc.core.exception.InvalidPartnerIdException;
import ggc.core.transactions.Acquisition;

/**
 * Show all transactions for a specific partner.
 */
class DoShowPartnerAcquisitions extends Command<WarehouseManager> {

  DoShowPartnerAcquisitions(WarehouseManager receiver) {
    super(Label.SHOW_PARTNER_ACQUISITIONS, receiver);
    addStringField("partnerId", Message.requestPartnerKey());
  }

  @Override
  public void execute() throws CommandException {
    try {
      for(Acquisition acq:_receiver.getAcquisitionList(stringField("partnerId"))){
        _display.popup(_receiver.transactionToString(acq));
      }
    } catch (InvalidPartnerIdException e) {
      throw new UnknownPartnerKeyException(e.getInvalidId());
    }
    
  }

}
