package ggc.core.partners;

import java.io.Serializable;

public class SelectionPartner implements Status, Serializable{
    private static SelectionPartner _selectionPartner;
    private String _status = "SELECTION";
    
    private SelectionPartner(){
    }
    // should be static
    public static SelectionPartner getInstance(){
        if(_selectionPartner == null){
            _selectionPartner = new SelectionPartner();
        }
        return _selectionPartner;
    }

    @Override
    public String getStatus() {
        return _status;
    }

    @Override
    public double P1(int dateDifference) {
        return 0.9;
    }
    @Override
    public double P2(int dateDifference) {
        if(dateDifference>=2)return 0.95;
        else return 1;
    }
    @Override
    public double P3(int dateDifference) {
        if(dateDifference<1)
            return 1;
        else
            return getTotalFine(dateDifference, 0.02);
    }
    @Override
    public double P4(int dateDifference) {
        return getTotalFine(dateDifference, 0.05);
    }
    
}
