package ggc.core;

import java.io.IOException;
import java.util.ArrayList;

import java.io.FileReader;
import java.io.BufferedReader;

import ggc.core.exception.BadEntryException;
import ggc.core.exception.DuplicatePartnerIdException;
import ggc.core.exception.InvalidPartnerIdException;
import ggc.core.exception.InvalidProductIdException;
import ggc.core.partners.Partner;
import ggc.core.products.Component;
import ggc.core.products.Product;

public class Parser {
  private Warehouse _warehouse;

  public Parser(Warehouse w) {
    _warehouse = w;
  }

  void parseFile(String filename) throws IOException, BadEntryException, DuplicatePartnerIdException, InvalidPartnerIdException, InvalidProductIdException {
    try (BufferedReader reader = new BufferedReader(new FileReader(filename))) {
      String line;

      while ((line = reader.readLine()) != null)
        parseLine(line);
    }
  }

  private void parseLine(String line) throws BadEntryException, InvalidPartnerIdException, InvalidProductIdException, DuplicatePartnerIdException {
    String[] components = line.split("\\|");

    switch (components[0]) {
      case "PARTNER":
        parsePartner(components, line);
        break;
      case "BATCH_S":
        parseSimpleProduct(components, line);
        break;

      case "BATCH_M":
        parseAggregateProduct(components, line);
        break;
        
      default:
        throw new BadEntryException("Invalid type element: " + components[0]);
    }
  }

  //PARTNER|id|nome|endereço
  private void parsePartner(String[] components, String line) throws BadEntryException, DuplicatePartnerIdException {
    if (components.length != 4)
      throw new BadEntryException("Invalid partner with wrong number of fields (4): " + line);
    
    String id = components[1];
    String name = components[2];
    String address = components[3];
    _warehouse.registerPartner(id, name, address);
  }

  //BATCH_S|idProduto|idParceiro|prec ̧o|stock-actual
  private void parseSimpleProduct(String[] components, String line) throws BadEntryException, InvalidPartnerIdException, InvalidProductIdException {
    if (components.length != 5)
      throw new BadEntryException("Invalid number of fields (4) in simple batch description: " + line);
    
    String idProduct = components[1];
    String idPartner = components[2];
    double price = Double.parseDouble(components[3]);
    int stock = Integer.parseInt(components[4]);
    
    if(!_warehouse.productsContains(idProduct)){
      _warehouse.registerSimpleProduct(idProduct);
    }
    
    Product product = _warehouse.getProduct(idProduct);
    Partner partner = _warehouse.getPartner(idPartner);
    _warehouse.registerBatch(price, stock, partner, product);
  }
  
  
  //BATCH_M|idProduto|idParceiro|prec ̧o|stock-actual|agravamento|componente-1:quantidade-1#...#componente-n:quantidade-n
  private void parseAggregateProduct(String[] components, String line) throws BadEntryException, InvalidPartnerIdException, InvalidProductIdException {
    if (components.length != 7)
      throw new BadEntryException("Invalid number of fields (7) in aggregate batch description: " + line);
    
    String idProduct = components[1];
    String idPartner = components[2];

    if (!_warehouse.productsContains(idProduct)){
      //System.out.println(idProduct);
      ArrayList<Product> products = new ArrayList<>();
      ArrayList<Integer> quantities = new ArrayList<>();
      
      for (String component : components[6].split("#")) {
        String[] recipeComponent = component.split(":");
        products.add(_warehouse.getProduct(recipeComponent[0]));
        quantities.add(Integer.parseInt(recipeComponent[1]));
      }

      ArrayList<Component> comps = new ArrayList<Component>();
      for(int i = 0;i < products.size(); i++){
        Product prod = products.get(i);
        int quan = quantities.get(i);
        Component comp = new Component(prod, quan);
        comps.add( comp );
      }
       
      double aggravation=Double.parseDouble(components[5]);
      _warehouse.registerAggregateProduct(idProduct, aggravation, comps);
    }
    
    Product product = _warehouse.getProduct(idProduct);

    Partner partner = _warehouse.getPartner(idPartner);
    double price = Double.parseDouble(components[3]);
    int stock = Integer.parseInt(components[4]);

    _warehouse.registerBatch(price, stock, partner, product);
  }
}
