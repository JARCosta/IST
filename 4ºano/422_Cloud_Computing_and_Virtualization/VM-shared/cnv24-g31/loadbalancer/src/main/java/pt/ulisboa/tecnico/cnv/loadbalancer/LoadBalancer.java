package pt.ulisboa.tecnico.cnv.loadbalancer;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.InetSocketAddress;
import java.net.URL;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.HashSet;
import java.util.concurrent.Future;
import java.util.concurrent.ThreadLocalRandom;

import com.amazonaws.auth.AWSStaticCredentialsProvider;
import com.amazonaws.auth.BasicAWSCredentials;
import com.amazonaws.regions.Regions;
import com.amazonaws.services.ec2.AmazonEC2Async;
import com.amazonaws.services.ec2.AmazonEC2AsyncClientBuilder;
import com.amazonaws.services.ec2.model.DescribeInstancesRequest;
import com.amazonaws.services.ec2.model.DescribeInstancesResult;
import com.amazonaws.services.ec2.model.Instance;
import com.amazonaws.services.ec2.model.Reservation;
import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import com.sun.net.httpserver.HttpServer;

import pt.ulisboa.tecnico.cnv.imageproc.BlurImageHandler;
import pt.ulisboa.tecnico.cnv.imageproc.EnhanceImageHandler;
import pt.ulisboa.tecnico.cnv.raytracer.RaytracerHandler;

public class LoadBalancer {

    private static Map<String, Integer> instances = Collections.synchronizedMap(new HashMap<>());

    public static void main(String[] args) throws Exception {

        HttpServer server = HttpServer.create(new InetSocketAddress(8000), 0);
        server.setExecutor(java.util.concurrent.Executors.newCachedThreadPool());
        server.createContext("/", new LoadBalancingHandler());
        server.createContext("/raytracer", new LoadBalancingHandler());
        server.createContext("/blurimage", new LoadBalancingHandler());
        server.createContext("/enhanceimage", new LoadBalancingHandler());
        server.start();

        new Thread(() -> {
            // AWS credentials
            String accessKey = "AKIA3FLDZ6T7TPYD4GPF";
            String secretKey = "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";

            // Create AWS credentials object
            var awsCreds = new BasicAWSCredentials(accessKey, secretKey);

            var awsClient = AmazonEC2AsyncClientBuilder.standard()
                    .withRegion(Regions.EU_WEST_3)
                    .withCredentials(new AWSStaticCredentialsProvider(awsCreds))
                    .build();

            while (true) {
                var instancesRequest = new DescribeInstancesRequest();
                DescribeInstancesResult instancesResponse = null;

                try {
                    instancesResponse = awsClient.describeInstancesAsync(instancesRequest).get();
                } catch (Exception e) {
                    e.printStackTrace();
                    System.exit(1);
                }

                // used to remove dead/layed-off workers
                var seenInstances = new HashSet<String>();
                HashMap<String, Integer> newInstances;

                newInstances = new HashMap<String, Integer>(instances);

                instancesResponse.getReservations()
                        .forEach(reservation -> reservation.getInstances()
                                .stream()
                                .filter(i -> i.getState().getName().contains("running"))
                                .map(i -> i.getPublicIpAddress())
                                .forEach(ip -> {
                                    if (!newInstances.containsKey(ip)) {
                                        newInstances.put(ip, 0);
                                    }
                                    seenInstances.add(ip);
                                }));

                for (String instance : newInstances.keySet()) {
                    System.out.println("Instance: " + instance);
                }

                newInstances.keySet()
                        .stream()
                        .filter(i -> !seenInstances.contains(i))
                        .forEach(i -> newInstances.remove(i));

                if (newInstances.isEmpty()) {
                    System.out.println("No running instances found in the specified region.");
                    return;
                }

                instances = Collections.synchronizedMap(newInstances);

                try {
                    Thread.sleep(60 * 1000);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                    System.exit(1);
                }
            }
        }).start();
    }

    static class LoadBalancingHandler implements HttpHandler {
        @Override
        public void handle(HttpExchange exchange) throws IOException {

            Integer minumum = -1;
            String instanceIp = null;

            for (String ip : instances.keySet()) {
                if (minumum == -1 || instances.get(ip) < minumum) {
                    minumum = instances.get(ip);
                    instanceIp = ip;
                }
            }

            instances.put(instanceIp, instances.get(instanceIp) + 1);

            String targetUrl = "http://" + instanceIp + exchange.getRequestURI().toString();
            System.out.println("Forwarding request to: " + isnatnceIp);
            // Forward the request to the selected instance
            HttpURLConnection connection = (HttpURLConnection) new URL(targetUrl).openConnection();
            connection.setRequestMethod(exchange.getRequestMethod());
            connection.setDoOutput(true);

            // Copy request headers
            for (Map.Entry<String, List<String>> header : exchange.getRequestHeaders().entrySet()) {
                for (String value : header.getValue()) {
                    connection.addRequestProperty(header.getKey(), value);
                }
            }

            // Copy request body
            try (OutputStream os = connection.getOutputStream();
                    InputStream is = exchange.getRequestBody()) {
                byte[] buffer = new byte[1024];
                int length;
                while ((length = is.read(buffer)) != -1) {
                    os.write(buffer, 0, length);
                }
            }

            // Copy response headers
            exchange.getResponseHeaders().putAll(connection.getHeaderFields());

            // Copy response body
            exchange.sendResponseHeaders(connection.getResponseCode(), connection.getContentLengthLong());
            try (InputStream is = connection.getInputStream();
                    OutputStream os = exchange.getResponseBody()) {
                byte[] buffer = new byte[1024];
                int length;
                while ((length = is.read(buffer)) != -1) {
                    os.write(buffer, 0, length);
                }
            }

            connection.disconnect();
        }
    }
}
