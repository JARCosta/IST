package ggc.app.transactions;

import pt.tecnico.uilib.menus.Command;
import pt.tecnico.uilib.menus.CommandException;
import ggc.app.exception.UnknownTransactionKeyException;
import ggc.core.WarehouseManager;
import ggc.core.exception.InvalidTransactionKeyException;

/**
 * Show specific transaction.
 */
public class DoShowTransaction extends Command<WarehouseManager> {

  public DoShowTransaction(WarehouseManager receiver) {
    super(Label.SHOW_TRANSACTION, receiver);
    addIntegerField("transactionId", Message.requestTransactionKey());
    //FIXME maybe add command fields
  }

  @Override
  public final void execute() throws CommandException {
    try {
      _display.popup(_receiver.getTransaction(integerField("transactionId")).toString(_receiver.getdate()));
    } catch (InvalidTransactionKeyException e) {
      throw new UnknownTransactionKeyException(e.getInvalidId());
    }
  }
}
