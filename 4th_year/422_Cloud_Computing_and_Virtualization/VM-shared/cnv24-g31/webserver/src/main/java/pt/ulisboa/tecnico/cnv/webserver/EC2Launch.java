package pt.ulisboa.tecnico.cnv.webserver;

import com.amazonaws.AmazonServiceException;
import com.amazonaws.auth.EnvironmentVariableCredentialsProvider;
import com.amazonaws.services.ec2.AmazonEC2;
import com.amazonaws.services.ec2.AmazonEC2ClientBuilder;
import com.amazonaws.services.ec2.model.TerminateInstancesRequest;
import com.amazonaws.services.ec2.model.RunInstancesRequest;
import com.amazonaws.services.ec2.model.RunInstancesResult;
import com.amazonaws.services.ec2.model.Instance;

public class EC2Launch {

    private static String AWS_REGION = "eu-west-3";
    private static String AMI_ID = "ami-033bc3c782a0e1065";
    private static String KEY_NAME = "testest";
    private static String SEC_GROUP_ID = "launch-wizard-2";


    public static void main(String[] args) throws Exception {

        System.out.println("===========================================");
        System.out.println("Auto Scaler - Scale Out");
        System.out.println("===========================================");

        try {
            AmazonEC2 ec2 = AmazonEC2ClientBuilder.standard().withRegion(AWS_REGION).withCredentials(new EnvironmentVariableCredentialsProvider()).build();

            System.out.println("You have " + ec2.describeInstances().getReservations().size() + " Amazon EC2 instance(s) running.");
            
            System.out.println("Launching a new instance.");
            RunInstancesRequest runInstancesRequest = new RunInstancesRequest();
            runInstancesRequest.withImageId(AMI_ID)
                               .withInstanceType("t2.micro")
                               .withMinCount(1)
                               .withMaxCount(1)
                               .withKeyName(KEY_NAME)
                               .withSecurityGroupIds(SEC_GROUP_ID);
            RunInstancesResult runInstancesResult = ec2.runInstances(runInstancesRequest);

            System.out.println(ec2.describeInstances().getReservations().size() + " Amazon EC2 instance(s) running.");
         
        } catch (AmazonServiceException ase) {
                System.out.println("Caught Exception: " + ase.getMessage());
                System.out.println("Reponse Status Code: " + ase.getStatusCode());
                System.out.println("Error Code: " + ase.getErrorCode());
                System.out.println("Request ID: " + ase.getRequestId());
        }
    }
}
