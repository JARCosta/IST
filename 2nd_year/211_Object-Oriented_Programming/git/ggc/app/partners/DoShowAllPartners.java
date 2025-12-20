package ggc.app.partners;

import ggc.core.WarehouseManager;
import ggc.core.partners.Partner;
import pt.tecnico.uilib.menus.Command;
import pt.tecnico.uilib.menus.CommandException;

/**
 * Show all partners.
 */
class DoShowAllPartners extends Command<WarehouseManager> {

  DoShowAllPartners(WarehouseManager receiver) {
    super(Label.SHOW_ALL_PARTNERS, receiver);
  }

  @Override
  public void execute() throws CommandException {
    
    for(Partner partner : _receiver.getPartnerSortedList()){
      _display.addLine(partner.toString());
    }
    _display.display();
  }
}
