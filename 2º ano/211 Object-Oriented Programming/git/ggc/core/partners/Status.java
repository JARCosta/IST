package ggc.core.partners;

public interface Status{
  //public Status getInstance();
  public String getStatus();
  public double P1(int dateDifference);
  public double P2(int dateDifference);
  public double P3(int dateDifference);
  public double P4(int dateDifference);
  public default double getTotalFine(int dateDifference, double fine){
    double ret = 1;
    if(dateDifference>0){
        for(int i=dateDifference;i>0;i--){
            ret+=fine;
        }
    }
    return ret;
}
}
