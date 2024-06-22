package ggc.core.partners;

import java.util.Comparator;

public class PartnerComparator implements Comparator<Partner> {
  public int compare(Partner a, Partner b){
    return a.getId().toLowerCase().compareTo(b.getId().toLowerCase());
  }

}