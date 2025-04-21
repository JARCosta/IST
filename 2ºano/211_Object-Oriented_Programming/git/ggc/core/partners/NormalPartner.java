package ggc.core.partners;

import java.io.Serializable;

public class NormalPartner implements Status, Serializable {
    private static NormalPartner _normalPartner;
    private String _status = "NORMAL";
    
    private NormalPartner(){
    }
    public static NormalPartner getInstance(){
        if(_normalPartner == null){
            _normalPartner = new NormalPartner();
        }
        return _normalPartner;
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
        return 1;
    }
    @Override
    public double P3(int dateDifference) {
        return getTotalFine(dateDifference, 0.05);
    }
    @Override
    public double P4(int dateDifference) {
        return getTotalFine(dateDifference, 0.1);
    }
}