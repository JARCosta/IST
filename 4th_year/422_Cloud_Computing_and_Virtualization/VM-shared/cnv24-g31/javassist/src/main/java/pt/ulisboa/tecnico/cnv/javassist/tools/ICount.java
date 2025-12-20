package pt.ulisboa.tecnico.cnv.javassist.tools;

import java.util.List;
import java.util.HashMap;
import java.util.Map;

import javassist.CannotCompileException;
import javassist.CtBehavior;
import java.lang.management.ManagementFactory;
import java.lang.management.OperatingSystemMXBean;
import com.amazonaws.AmazonClientException;
import com.amazonaws.AmazonServiceException;
import com.amazonaws.auth.EnvironmentVariableCredentialsProvider;
import com.amazonaws.auth.AWSCredentials;
import com.amazonaws.auth.profile.ProfileCredentialsProvider;
import com.amazonaws.regions.Region;
import com.amazonaws.regions.Regions;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDB;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClientBuilder;
import com.amazonaws.services.dynamodbv2.model.AttributeDefinition;
import com.amazonaws.services.dynamodbv2.model.AttributeValue;
import com.amazonaws.services.dynamodbv2.model.ComparisonOperator;
import com.amazonaws.services.dynamodbv2.model.Condition;
import com.amazonaws.services.dynamodbv2.model.CreateTableRequest;
import com.amazonaws.services.dynamodbv2.model.DescribeTableRequest;
import com.amazonaws.services.dynamodbv2.model.KeySchemaElement;
import com.amazonaws.services.dynamodbv2.model.KeyType;
import com.amazonaws.services.dynamodbv2.model.ProvisionedThroughput;
import com.amazonaws.services.dynamodbv2.model.PutItemRequest;
import com.amazonaws.services.dynamodbv2.model.PutItemResult;
import com.amazonaws.services.dynamodbv2.model.ScalarAttributeType;
import com.amazonaws.services.dynamodbv2.model.ScanRequest;
import com.amazonaws.services.dynamodbv2.model.ScanResult;
import com.amazonaws.services.dynamodbv2.model.TableDescription;
import com.amazonaws.services.dynamodbv2.util.TableUtils;



public class ICount extends CodeDumper {

    /**
     * Number of executed basic blocks.
     */
    private static long nblocks = 0;

    /**
     * Number of executed methods.
     */
    private static long nmethods = 0;

    /**
     * Number of executed instructions.
     */
    private static long ninsts = 0;

    private static String AWS_REGION = "eu-west-3";
    private static AmazonDynamoDB dynamoDB;

    public ICount(List<String> packageNameList, String writeDestination) {
        super(packageNameList, writeDestination);
        initializeDynamoDB();
    }

    private void initializeDynamoDB() {
        dynamoDB = AmazonDynamoDBClientBuilder.standard()
            .withCredentials(new EnvironmentVariableCredentialsProvider())
            .withRegion(AWS_REGION)
            .build();
    }


    public static void incBasicBlock(int position, int length) {
        nblocks++;
        ninsts += length;
    }

    public static void incBehavior(String name) {
        nmethods++;
    }

    public static void printStatistics() throws Exception {
        System.out.println("PRINT STATISTICS --------------------");
        // Collect and log CPU Average Usage
        OperatingSystemMXBean osBean = ManagementFactory.getOperatingSystemMXBean();
        double systemLoadAverage = osBean.getSystemLoadAverage();
        System.out.println("System Load Average: " + systemLoadAverage + " (1CPU core => 1.0)");

        System.out.println(String.format("[%s] Number of executed methods: %s", ICount.class.getSimpleName(), nmethods));
        System.out.println(String.format("[%s] Number of executed basic blocks: %s", ICount.class.getSimpleName(), nblocks));
        System.out.println(String.format("[%s] Number of executed instructions: %s", ICount.class.getSimpleName(), ninsts));

        // Add metrics to DynamoDB
        try {
            System.out.println("We will enter dynamo function");
            putMetricsToDynamoDB(systemLoadAverage, nmethods, nblocks, ninsts);
        } catch (Exception exe) {
            System.out.println("Exception occured");
        }
    }

    private static void putMetricsToDynamoDB(double systemLoadAverage, long nmethods, long nblocks, long ninsts) throws Exception {
        try {
            String tableName = "JavassistMetrics";

            // Create a table with a primary hash key named 'name', which holds a string
            CreateTableRequest createTableRequest = new CreateTableRequest().withTableName(tableName)
                .withKeySchema(new KeySchemaElement().withAttributeName("name").withKeyType(KeyType.HASH))
                .withAttributeDefinitions(new AttributeDefinition().withAttributeName("name").withAttributeType(ScalarAttributeType.S))
                .withProvisionedThroughput(new ProvisionedThroughput().withReadCapacityUnits(1L).withWriteCapacityUnits(1L));

            // Create table if it does not exist yet
            TableUtils.createTableIfNotExists(dynamoDB, createTableRequest);
            // wait for the table to move into ACTIVE state
            TableUtils.waitUntilActive(dynamoDB, tableName);

            // Describe our new table
            DescribeTableRequest describeTableRequest = new DescribeTableRequest().withTableName(tableName);
            TableDescription tableDescription = dynamoDB.describeTable(describeTableRequest).getTable();
            System.out.println("Table Description: " + tableDescription);

            // Add an item
            dynamoDB.putItem(new PutItemRequest(tableName, newItem(systemLoadAverage, nmethods, nblocks, ninsts)));

            System.out.println("Metrics added to DynamoDB successfully.");
            
        } catch (AmazonServiceException ase) {
            System.out.println("Caught an AmazonServiceException, which means your request made it "
                    + "to AWS, but was rejected with an error response for some reason.");
            System.out.println("Error Message:    " + ase.getMessage());
            System.out.println("HTTP Status Code: " + ase.getStatusCode());
            System.out.println("AWS Error Code:   " + ase.getErrorCode());
            System.out.println("Error Type:       " + ase.getErrorType());
            System.out.println("Request ID:       " + ase.getRequestId());
        } catch (AmazonClientException ace) {
            System.out.println("Caught an AmazonClientException, which means the client encountered "
                    + "a serious internal problem while trying to communicate with AWS, "
                    + "such as not being able to access the network.");
            System.out.println("Error Message: " + ace.getMessage());
        }
    }


    private static Map<String, AttributeValue> newItem(double systemLoadAverage, long nmethods, long nblocks, long ninsts) {
        Map<String, AttributeValue> item = new HashMap<String, AttributeValue>();
        item.put("name", new AttributeValue("Metrics"));
        item.put("systemLoadAverage", new AttributeValue().withN(Double.toString(systemLoadAverage)));
        item.put("nmethods", new AttributeValue().withN(Long.toString(nmethods)));
        item.put("nblocks", new AttributeValue().withN(Long.toString(nblocks)));
        item.put("ninsts", new AttributeValue().withN(Long.toString(ninsts)));
        return item;
    }


    @Override
    protected void transform(CtBehavior behavior) throws Exception {

        super.transform(behavior);
        behavior.insertAfter(String.format("%s.incBehavior(\"%s\");", ICount.class.getName(), behavior.getLongName()));

        if (behavior.getName().equals("handleRequest")) {
            behavior.insertAfter(String.format("%s.printStatistics();", ICount.class.getName()));
        }
    }

    @Override
    protected void transform(BasicBlock block) throws CannotCompileException {

        super.transform(block);
        block.behavior.insertAt(block.line, String.format("%s.incBasicBlock(%s, %s);", ICount.class.getName(), block.getPosition(), block.getLength()));
    }

}
