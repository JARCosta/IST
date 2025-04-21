package ggc.core.products;

import java.io.Serializable;
import java.util.List;

public class Recipe implements Serializable{
  private double _alpha;
  List<Component> _components;



  public Recipe(double alpha, List<Component> components){
    _alpha = alpha;
    _components = components;
  }

/* may be useless
  public Recipe(double alpha,ArrayList<Product> products, ArrayList<Integer> quantities){
    _alpha = alpha;
    _components = new ArrayList<Component>();
    for(int i = 0;i < products.size(); i++){
      Product prod = products.get(i);
      int quan = quantities.get(i);
      Component comp = new Component(prod, quan);
      _components.add( comp );
    }
  }
*/

public List<Component> getComponents(){
  return _components;
}

public double getAggravaton(){
  return _alpha;
}

@Override
public String toString(){
  String ret = "";
  for( Component i : _components){
    Product p = i.getProduct();
    if(!ret.equals(""))
      ret += "#";
    ret += "" + p.getId() + ":" + i.getQuantity();
  }
  return ret;
  }
  
}
