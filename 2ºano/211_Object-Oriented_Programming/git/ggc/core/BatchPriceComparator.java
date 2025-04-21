package ggc.core;

import java.util.Comparator;

public class BatchPriceComparator implements Comparator<Batch> {
  public int compare(Batch b1, Batch b2){
    int diff;

    diff = b1.getProduct().getId().toLowerCase().compareTo(b2.getProduct().getId().toLowerCase());
    if(diff == 0)    
        diff = (int)(b1.getPrice() - b2.getPrice());
        if(diff == 0)
          diff = b1.getQuantity() - b2.getQuantity();
          
    return diff;
  }
}
