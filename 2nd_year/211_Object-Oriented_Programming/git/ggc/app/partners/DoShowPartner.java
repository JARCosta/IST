package ggc.app.partners;

import ggc.app.exception.UnknownPartnerKeyException;
import ggc.core.WarehouseManager;
import ggc.core.exception.InvalidPartnerIdException;
import ggc.core.notifications.Notification;
import ggc.core.partners.Partner;
import pt.tecnico.uilib.menus.Command;
import pt.tecnico.uilib.menus.CommandException;

/**
 * Show partner.
 */
class DoShowPartner extends Command<WarehouseManager> {

  DoShowPartner(WarehouseManager receiver) {
    super(Label.SHOW_PARTNER, receiver);
    addStringField("partnerId", Message.requestPartnerKey());
  }

  @Override
  public void execute() throws CommandException {
    try{
      Partner partner = _receiver.getPartner(stringField("partnerId"));
      _display.popup(partner.toString());
      
      for(Notification i: _receiver.showNotifications(stringField("partnerId"))){
        _display.popup(i.toString());
      }
      ((Partner) partner).clearNotifications();  
    } catch (InvalidPartnerIdException upke){
      throw new UnknownPartnerKeyException(stringField("partnerId"));
    }  
  }
}
