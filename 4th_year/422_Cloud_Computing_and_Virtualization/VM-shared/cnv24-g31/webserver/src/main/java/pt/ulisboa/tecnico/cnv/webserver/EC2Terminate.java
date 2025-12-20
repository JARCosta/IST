package pt.ulisboa.tecnico.cnv.webserver;

import com.amazonaws.AmazonServiceException;
import com.amazonaws.auth.EnvironmentVariableCredentialsProvider;
import com.amazonaws.services.ec2.AmazonEC2;
import com.amazonaws.services.ec2.AmazonEC2ClientBuilder;
import com.amazonaws.services.ec2.model.TerminateInstancesRequest;
import com.amazonaws.services.ec2.model.DescribeInstancesRequest;
import com.amazonaws.services.ec2.model.DescribeInstancesResult;
import com.amazonaws.services.ec2.model.Instance;
import com.amazonaws.services.ec2.model.Reservation;
import com.amazonaws.services.ec2.model.Filter;
import com.amazonaws.services.ec2.model.DescribeAvailabilityZonesResult;

public class EC2Terminate {

    private static String AWS_REGION = "eu-west-3";
    private static String AMI_ID = "ami-033bc3c782a0e1065";
    private static String KEY_NAME = "testest";
    private static String SEC_GROUP_ID = "launch-wizard-2";


    public static void main(String[] args) throws Exception {

        System.out.println("===========================================");
        System.out.println("Auto Scaler - Scale In");
        System.out.println("===========================================");


        try {
            AmazonEC2 ec2 = AmazonEC2ClientBuilder.standard().withRegion(AWS_REGION).withCredentials(new EnvironmentVariableCredentialsProvider()).build();
            
            // Create a filter for instances in the running state
            Filter runningInstancesFilter = new Filter()
                    .withName("instance-state-name")
                    .withValues("running");

            // Create DescribeInstancesRequest
            DescribeInstancesRequest request = new DescribeInstancesRequest().withFilters(runningInstancesFilter);

            // Get the response
            DescribeInstancesResult response = ec2.describeInstances(request);

            Instance instance = response.getReservations().get(0).getInstances().get(0);

            TerminateInstancesRequest termInstanceReq = new TerminateInstancesRequest().withInstanceIds(instance.getInstanceId());
            ec2.terminateInstances(termInstanceReq);  

            System.out.println("One instance is being shut down");

        } catch (AmazonServiceException ase) {
                System.out.println("Caught Exception: " + ase.getMessage());
                System.out.println("Reponse Status Code: " + ase.getStatusCode());
                System.out.println("Error Code: " + ase.getErrorCode());
                System.out.println("Request ID: " + ase.getRequestId());
        }
    }
}
