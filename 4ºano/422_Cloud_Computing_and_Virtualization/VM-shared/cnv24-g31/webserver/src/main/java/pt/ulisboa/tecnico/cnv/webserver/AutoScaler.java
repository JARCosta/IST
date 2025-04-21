package pt.ulisboa.tecnico.cnv.webserver;

import java.util.ArrayList;
import com.amazonaws.AmazonServiceException;
import com.amazonaws.auth.EnvironmentVariableCredentialsProvider;
import com.amazonaws.services.ec2.AmazonEC2;
import com.amazonaws.services.ec2.AmazonEC2ClientBuilder;
import com.amazonaws.services.ec2.model.Instance;
import com.amazonaws.services.ec2.model.Reservation;

public class AutoScaler {
    private static final double CPU_THRESHOLD_HIGH = 70.0; // High CPU threshold
    private static final double CPU_THRESHOLD_LOW = 30.0;  // Low CPU threshold
    private static final int MAX_INSTANCES = 3;
    private static final int MIN_INSTANCES = 1;

    private static String AWS_REGION = "eu-west-3";

    public static void main(String[] args) throws Exception {
        EC2MeasureCPU.main(null);
        Double avgCPUPercentage = EC2MeasureCPU.getAverageCPUUtilization();
        ArrayList<String> instanceIds = new ArrayList<String>();

        AmazonEC2 ec2 = AmazonEC2ClientBuilder.standard()
                .withRegion(AWS_REGION)
                .withCredentials(new EnvironmentVariableCredentialsProvider())
                .build();

        for (Instance i: EC2MeasureCPU.getInstances(ec2)) {
            instanceIds.add(i.getInstanceId());
        }

        if (instanceIds.isEmpty()) {
            System.out.println("No running instances found. Lauching first instance.");
            EC2Launch.main(null);
            return;
        }

        int instanceCount = instanceIds.size();
        System.out.println(instanceCount);
        System.out.println(avgCPUPercentage);

        if (avgCPUPercentage > CPU_THRESHOLD_HIGH && instanceCount < MAX_INSTANCES) {
            System.out.println("lauching new inst");
            EC2Launch.main(null);
        } else if (avgCPUPercentage < CPU_THRESHOLD_LOW && instanceCount > MIN_INSTANCES) {
            System.out.println("terminating new inst");
            EC2Terminate.main(null);
        } else {
            System.out.println("No scaling action required.");
        }

    }
}

