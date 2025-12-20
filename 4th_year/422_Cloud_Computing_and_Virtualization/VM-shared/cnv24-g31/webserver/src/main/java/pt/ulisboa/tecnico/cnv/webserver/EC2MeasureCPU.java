package pt.ulisboa.tecnico.cnv.webserver;

import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.ArrayList;
import java.util.Date;
import com.amazonaws.AmazonServiceException;
import com.amazonaws.auth.EnvironmentVariableCredentialsProvider;
import com.amazonaws.services.ec2.AmazonEC2;
import com.amazonaws.services.ec2.AmazonEC2ClientBuilder;
import com.amazonaws.services.ec2.model.Instance;
import com.amazonaws.services.ec2.model.Reservation;
import com.amazonaws.services.cloudwatch.AmazonCloudWatch;
import com.amazonaws.services.cloudwatch.AmazonCloudWatchClientBuilder;
import com.amazonaws.services.cloudwatch.model.Dimension;
import com.amazonaws.services.cloudwatch.model.Datapoint;
import com.amazonaws.services.cloudwatch.model.GetMetricStatisticsRequest;
import com.amazonaws.services.cloudwatch.model.GetMetricStatisticsResult;

public class EC2MeasureCPU {

    private static String AWS_REGION = "eu-west-3";
    private static long OBS_TIME = 1000 * 60 * 1; // Total observation time in milliseconds.
    private static Double avgTotalCPUPercentage = 0.0;

    public static Double getAverageCPUUtilization() {
        return avgTotalCPUPercentage;
    }

    public static Set<Instance> getInstances(AmazonEC2 ec2) throws Exception {
        Set<Instance> instances = new HashSet<Instance>();
        for (Reservation reservation : ec2.describeInstances().getReservations()) {
            instances.addAll(reservation.getInstances());
        }
        return instances;
    }

    public static Double getAverageCPUUtilizationByInstanceId(String instanceId, AmazonCloudWatch cloudWatch) {
        Dimension instanceDimension = new Dimension();
        instanceDimension.setName("InstanceId");
        instanceDimension.setValue(instanceId);

        GetMetricStatisticsRequest request = new GetMetricStatisticsRequest()
                .withStartTime(new Date(new Date().getTime() - OBS_TIME))
                .withNamespace("AWS/EC2")
                .withPeriod(60)
                .withMetricName("CPUUtilization")
                .withStatistics("Average")
                .withDimensions(instanceDimension)
                .withEndTime(new Date());

        Double totalCpuUtilization = 0.0;
        Double numberOfDataPoints = 0.0;
        for (Datapoint dp : cloudWatch.getMetricStatistics(request).getDatapoints()) {
            totalCpuUtilization += dp.getAverage();
            numberOfDataPoints += 1;
        }

        return (numberOfDataPoints > 0) ? totalCpuUtilization / numberOfDataPoints : null;
    }

    public static void main(String[] args) throws Exception {
        System.out.println("===========================================");
        System.out.println("Measuring EC2's CPU Usage");
        System.out.println("===========================================");

        AmazonEC2 ec2 = AmazonEC2ClientBuilder.standard()
                .withRegion(AWS_REGION)
                .withCredentials(new EnvironmentVariableCredentialsProvider())
                .build();
        AmazonCloudWatch cloudWatch = AmazonCloudWatchClientBuilder.standard()
                .withRegion(AWS_REGION)
                .withCredentials(new EnvironmentVariableCredentialsProvider())
                .build();

        try {
            Set<Instance> instances = getInstances(ec2);
            System.out.println("Total instances = " + instances.size());
            Double avgTotalCPUUtilization = 0.0;
            Integer numberOfInstances = 0;

            for (Instance instance : instances) {
                String iid = instance.getInstanceId();
                String state = instance.getState().getName();
                System.out.println("Instance ID: " + iid + " - State: " + state);

                if ("running".equals(state)) {
                    Double averageCPUUtilization = getAverageCPUUtilizationByInstanceId(iid, cloudWatch);
                    if (averageCPUUtilization != null) {
                        System.out.println("CPU utilization for instance " + iid + " = " + averageCPUUtilization);
                        avgTotalCPUUtilization += averageCPUUtilization;
                        numberOfInstances += 1;
                    } else {
                        System.out.println("No data points available for instance " + iid);
                    }
                }
            }

            if (avgTotalCPUUtilization.equals(0.0)) {
                System.out.println("Average Total CPU Usage in %: 0");
            }
            else {
                avgTotalCPUPercentage = avgTotalCPUUtilization/numberOfInstances;
                System.out.println("Average Total CPU Usage in %: " + avgTotalCPUPercentage);
            }

        } catch (AmazonServiceException ase) {
            System.out.println("Caught Exception: " + ase.getMessage());
            System.out.println("Response Status Code: " + ase.getStatusCode());
            System.out.println("Error Code: " + ase.getErrorCode());
            System.out.println("Request ID: " + ase.getRequestId());
        }
    }
}
