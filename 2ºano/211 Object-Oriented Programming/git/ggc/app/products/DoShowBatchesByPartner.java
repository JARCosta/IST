package ggc.app.products;

import pt.tecnico.uilib.menus.Command;
import pt.tecnico.uilib.menus.CommandException;
import ggc.app.exception.UnknownPartnerKeyException;
import ggc.core.Batch;
import ggc.core.WarehouseManager;
import ggc.core.exception.InvalidPartnerIdException;

/**
 * Show batches supplied by partner.
 */
class DoShowBatchesByPartner extends Command<WarehouseManager> {

  DoShowBatchesByPartner(WarehouseManager receiver) {
    super(Label.SHOW_BATCHES_SUPPLIED_BY_PARTNER, receiver);
    addStringField("partner", Message.requestPartnerKey());
  }

  @Override
  public final void execute() throws CommandException {
    try{
      for(Batch batch : _receiver.getBatchSortedList(_receiver.getPartner(stringField("partner")))){
        _display.addLine(batch.toString());
      }
    } catch(InvalidPartnerIdException UnknowPartnerId){
      throw new UnknownPartnerKeyException(UnknowPartnerId.getInvalidId());
    }
    _display.display();  }

}
