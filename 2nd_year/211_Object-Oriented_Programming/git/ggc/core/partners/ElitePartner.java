package ggc.core.partners;

import java.io.Serializable;

public class ElitePartner implements Status, Serializable{
    private String _status = "ELITE";
    private static ElitePartner _elitePartner;
    
    private ElitePartner(){
    }
    // should be static
    public static ElitePartner getInstance(){
        if(_elitePartner == null){
            _elitePartner = new ElitePartner();
        }
        return _elitePartner;
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
        return 0.9;
    }
    @Override
    public double P3(int dateDifference) {
        return 0.95;
    }
    @Override
    public double P4(int dateDifference) {
        return 1;
    }
    
}
