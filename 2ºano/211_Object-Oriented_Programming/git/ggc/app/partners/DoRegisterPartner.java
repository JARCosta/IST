package ggc.app.partners;

import pt.tecnico.uilib.menus.Command;
import pt.tecnico.uilib.menus.CommandException;
import ggc.app.exception.DuplicatePartnerKeyException;
import ggc.core.WarehouseManager;
import ggc.core.exception.BadEntryException;
import ggc.core.exception.DuplicatePartnerIdException;

/**
 * Register new partner.
 */
class DoRegisterPartner extends Command<WarehouseManager> {

  DoRegisterPartner(WarehouseManager receiver) {
    super(Label.REGISTER_PARTNER, receiver);

    addStringField("key", Message.requestPartnerKey());
    addStringField("name", Message.requestPartnerName()); 
    addStringField("adress", Message.requestPartnerAddress()); 
  }

  @Override
  public void execute() throws CommandException {
    try{
      _receiver.registerPartner(stringField("key"), stringField("name"), stringField("adress"));
    } catch(DuplicatePartnerIdException | BadEntryException PartnerAlreadyexists){
      throw new DuplicatePartnerKeyException(stringField("key"));
    }

  }

}
