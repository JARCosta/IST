package ggc.app.transactions;

import pt.tecnico.uilib.menus.Command;
import pt.tecnico.uilib.menus.CommandException;
import ggc.app.exception.UnavailableProductException;
import ggc.app.exception.UnknownPartnerKeyException;
import ggc.app.exception.UnknownProductKeyException;
import ggc.core.WarehouseManager;
import ggc.core.exception.InvalidPartnerIdException;
import ggc.core.exception.InvalidProductIdException;
import ggc.core.exception.ProductAmountException;

/**
 * 
 */
public class DoRegisterSaleTransaction extends Command<WarehouseManager> {

  public DoRegisterSaleTransaction(WarehouseManager receiver) {
    super(Label.REGISTER_SALE_TRANSACTION, receiver);
    addStringField("partnerId", Message.requestPartnerKey());
    addIntegerField("deadline", Message.requestPaymentDeadline());
    addStringField("productId", Message.requestProductKey());
    addIntegerField("quantity", Message.requestAmount());
  }

  @Override
  public final void execute() throws CommandException {
    try {
      _receiver.registerSaleByCredit(stringField("partnerId"), stringField("productId"), integerField("deadline"), integerField("quantity"));
    } catch (InvalidPartnerIdException e) {
      throw new UnknownPartnerKeyException(stringField("partnerId"));
    } catch (InvalidProductIdException e) {
      throw new UnknownProductKeyException(stringField("productId"));
    } catch (ProductAmountException e) {
      throw new UnavailableProductException(e.getProductId(), e.getQuantityAsked(), e.getQuantity());
    }
  }
}
