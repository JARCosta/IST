package pt.tecnico.distledger.server.domain;

import io.grpc.stub.StreamObserver;
import pt.tecnico.distledger.server.Debug;
import pt.ulisboa.tecnico.distledger.contract.user.UserDistLedger.*;
import pt.ulisboa.tecnico.distledger.contract.user.UserServiceGrpc.UserServiceImplBase;

import java.util.ArrayList;
import java.util.List;

public class UserServiceImpl extends UserServiceImplBase{
    private ServerState ledger;

    public UserServiceImpl(ServerState serverState) {
        this.ledger = serverState;
    }

    @Override
    public synchronized void balance(BalanceRequest request, StreamObserver<BalanceResponse> responseObserver) {
        Debug.debug("Received balance request for " + request.getUserId() + ".");

        try {
            List<Integer> res = ledger.getBalance(request.getUserId(), request.getPrevTSList());
            
            Integer balance = res.get(res.size()-1);
            res.remove(res.size()-1);
            BalanceResponse response;
            // if (balance != -1){
                response = BalanceResponse.newBuilder()
                        .setValue(balance)
                        .addAllValueTS(res)
                        .build();
            // } else {
            //     response = BalanceResponse.newBuilder()
            //             .addAllValueTS(res)
            //             .build();
            // }
            Debug.debug("Sending response.");
            responseObserver.onNext(response);
            responseObserver.onCompleted();
            Debug.debug("Request handled.");
        } catch (Exception e) {
            responseObserver.onError(e);
        }
    }
    
    @Override
    public synchronized void createAccount(CreateAccountRequest request,
                                           StreamObserver<CreateAccountResponse> responseObserver) {
        Debug.debug("Received create account request with name " + request.getUserId() + " and TS " + request.getPrevTSList() + ".");

        try {
                List<Integer> TS = ledger.createAccount(request.getUserId(), request.getPrevTSList());
                CreateAccountResponse response = CreateAccountResponse.newBuilder().addAllTS(TS).build();
                Debug.debug("Sending response.");
                responseObserver.onNext(response);
                responseObserver.onCompleted();
                Debug.debug("Request handled.");
        } catch (Exception e) {
            responseObserver.onError(e);
        }
    }


    @Override
    public synchronized void transferTo(TransferToRequest request,
                                        StreamObserver<TransferToResponse> responseObserver) {
        Debug.debug("Received transfer request of " + request.getAmount()
                + " from " + request.getAccountFrom() + " to " + request.getAccountTo() + ".");
        try {
            List<Integer> TS = ledger.transferTo(request.getAccountFrom(), request.getAccountTo(), request.getAmount(), request.getPrevTSList());
            TransferToResponse response = TransferToResponse.newBuilder().build();
            Debug.debug("Sending response.");
            responseObserver.onNext(response);
            responseObserver.onCompleted();
            Debug.debug("Request handled.");
        } catch (Exception e) {
            responseObserver.onError(e);
        }
    }

}
