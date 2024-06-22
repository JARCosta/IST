package pt.tecnico.distledger.userclient;

import pt.tecnico.distledger.userclient.grpc.NamingServerService;
import pt.tecnico.distledger.userclient.grpc.UserService;
import java.util.*;

public class CommandParser {

    private static final String SPACE = " ";
    private static final String CREATE_ACCOUNT = "createAccount";
    private static final String TRANSFER_TO = "transferTo";
    private static final String BALANCE = "balance";
    private static final String HELP = "help";
    private static final String EXIT = "exit";
    
    private List<Integer> verctorClock;

    public CommandParser() {
        this.verctorClock = new ArrayList<>(3);
        verctorClock.add(0);
        verctorClock.add(0);
    }

    public static List<String> lookup(String qualifier){

        String host = "localhost";
        int namingServerPort = 5001;
        NamingServerService namingServerService = new NamingServerService(host, namingServerPort);

        String serviceName = "DistLedgerServerService";
        List<String> servers = namingServerService.lookup(serviceName, qualifier);
        namingServerService.shutdownNowChannel();
        return servers;
    }

    public UserService getUserService(String server){
        for (String ip : lookup(server)) {
            try{
                UserService userService = new UserService(ip);
                return userService;
            }catch (Exception e){
                System.err.println("Server not found");
            }
        }
        return null;
    }

    void parseInput() {

        Scanner scanner = new Scanner(System.in);
        boolean exit = false;

        while (!exit) {
            System.out.print("> ");
            String line = scanner.nextLine().trim();
            String cmd = line.split(SPACE)[0];

            try{
                switch (cmd) {
                    case CREATE_ACCOUNT:
                        this.createAccount(line);
                        break;

                    case TRANSFER_TO:
                        this.transferTo(line);
                        break;

                    case BALANCE:
                        this.balance(line);
                        break;

                    case HELP:
                        this.printUsage();
                        break;

                    case EXIT:
                        exit = true;
                        break;

                    default:
                        System.err.println("Invalid command");
                        break;
                }
            }
            catch (Exception e){
                System.err.println(e.getMessage());
            }
        }
    }

    private void createAccount(String line){
        String[] split = line.split(SPACE);

        if (split.length != 3){
            this.printUsage();
            return;
        }
        String server = split[1];
        String username = split[2];

        Debug.debug("Asking server '" + server +
                "' to create account with username '" + username + "'...");
        Debug.debug("User vetorClock: '" + verctorClock.get(0) + " " + verctorClock.get(1) + "'.");
        UserService userService = getUserService(server);
        try{
            List<Integer> valueTS = userService.createAccount(username, verctorClock);

            for (int i = 0; i < this.verctorClock.size();i++){
                this.verctorClock.set(i, Math.max(this.verctorClock.get(i), valueTS.get(i)));
            }

            Debug.debug("Server returned: " + verctorClock);
            userService.shutdownNowChannel();
        }catch (Exception e){
            userService = getUserService(server);
        }
        Debug.debug("Server completed the create account operation.");
    }

    private void balance(String line){
        String[] split = line.split(SPACE);

        if (split.length != 3){
            this.printUsage();
            return;
        }
        String server = split[1];
        String username = split[2];

        Debug.debug("Asking server '" + server + "' to see the balance of '" + username + "'...");
        UserService userService = getUserService(server);
        try{
            List<Integer> valueTS = userService.balance(username, verctorClock);

            for (int i = 0; i < this.verctorClock.size();i++){
                this.verctorClock.set(i, Math.max(this.verctorClock.get(i), valueTS.get(i)));
            }

            userService.shutdownNowChannel();
        }catch (Exception e){
            userService = getUserService(server);
        }
        Debug.debug("Server completed the balance operation.");
    }

    private void transferTo(String line){
        String[] split = line.split(SPACE);

        if (split.length != 5){
            this.printUsage();
            return;
        }
        String server = split[1];
        String from = split[2];
        String dest = split[3];
        Integer amount = Integer.valueOf(split[4]);

        Debug.debug("Asking server '" + server + "' to transfer " + amount +
                " from '" + from + "' to '" + dest + "...");
        UserService userService = getUserService(server);
        
        try{
            List<Integer> valueTS = userService.transferTo(from, dest, amount, verctorClock);
            
            for (int i = 0; i < this.verctorClock.size();i++){
                this.verctorClock.set(i, Math.max(this.verctorClock.get(i), valueTS.get(i)));
            }

            userService.shutdownNowChannel();
        }catch (Exception e){
            userService = getUserService(server);
        }
        Debug.debug("Server completed the transfer to operation.");
    }

    private void printUsage() {
        System.out.println("Usage:\n" +
                        "- createAccount <server> <username>\n" +
                        "- balance <server> <username>\n" +
                        "- transferTo <server> <username_from> <username_to> <amount>\n" +
                        "- exit\n");
    }
}
