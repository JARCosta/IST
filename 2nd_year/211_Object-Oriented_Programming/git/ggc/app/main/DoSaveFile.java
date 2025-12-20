package ggc.app.main;

import java.io.IOException;

import ggc.core.WarehouseManager;
import pt.tecnico.uilib.menus.Command;
import pt.tecnico.uilib.menus.CommandException;
import pt.tecnico.uilib.forms.Form;
/**
 * Save current state to file under current name (if unnamed, query for name).
 */
class DoSaveFile extends Command<WarehouseManager> {

  /** @param receiver */
  DoSaveFile(WarehouseManager receiver) {
    super(Label.SAVE, receiver);    
  }

  @Override
  public final void execute() throws CommandException {
    try{
      _receiver.save();
    } catch (IOException noFile){
      String name = Form.requestString(Message.newSaveAs());
      try {
        _receiver.saveAs(name);
      } catch (IOException fileError) {
        System.out.println("DoSaveFile.execute()");
      }
    }
  }
}
