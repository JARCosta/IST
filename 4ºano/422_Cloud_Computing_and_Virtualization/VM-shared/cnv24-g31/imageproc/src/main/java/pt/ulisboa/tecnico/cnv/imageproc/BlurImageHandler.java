package pt.ulisboa.tecnico.cnv.imageproc;

import boofcv.alg.filter.blur.GBlurImageOps;
import boofcv.io.image.ConvertBufferedImage;
import boofcv.io.image.UtilImageIO;
import boofcv.struct.image.GrayU8;
import boofcv.struct.image.ImageType;
import boofcv.struct.image.Planar;
import java.awt.image.BufferedImage;

import com.amazonaws.auth.AWSStaticCredentialsProvider;
import com.amazonaws.auth.BasicAWSCredentials;
import com.amazonaws.regions.Regions;
import com.amazonaws.services.lambda.AWSLambda;
import com.amazonaws.services.lambda.AWSLambdaClientBuilder;
import com.amazonaws.services.lambda.model.InvokeRequest;
import com.amazonaws.services.lambda.model.InvokeResult;

import java.nio.charset.StandardCharsets;
import java.util.Base64;

public class BlurImageHandler extends ImageProcessingHandler {

    public BufferedImage process(BufferedImage bi) {
        Planar<GrayU8> input = ConvertBufferedImage.convertFrom(bi, true, ImageType.pl(3, GrayU8.class));
        Planar<GrayU8> output = input.createSameShape();
        GBlurImageOps.gaussian(input, output, -1, 32, null);
        return ConvertBufferedImage.convertTo(output, null, true);
    }

    public String process(byte[] imageBytes) {

        // AWS credentials
        String accessKey = "AKIAW3MD75RBCUN6ONRG";
        String secretKey = "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";

        // Create AWS credentials object
        BasicAWSCredentials awsCreds = new BasicAWSCredentials(accessKey, secretKey);

        // Create Lambda client
        AWSLambda lambdaClient = AWSLambdaClientBuilder.standard()
                .withCredentials(new AWSStaticCredentialsProvider(awsCreds))
                .withRegion(Regions.US_EAST_1)
                .build();

        String encodedImage = Base64.getEncoder().encodeToString(imageBytes);

        // Create invoke request
        InvokeRequest invokeRequest = new InvokeRequest()
                .withFunctionName("blurer")
                .withPayload("{ \"body\": \"" + encodedImage + "\", \"fileFormat\": \"jpg\" }");
        
        // Invoke Lambda function
        InvokeResult invokeResult = lambdaClient.invoke(invokeRequest);

        // Process the response
        String response = new String(invokeResult.getPayload().array(), StandardCharsets.UTF_8);

        return response.substring(1, response.length() - 1);
    }

    public static void main(String[] args) {

        if (args.length != 2) {
            System.err.println("Syntax BlurImage <input image path> <output image path>");
            return;
        }

        String inputImagePath = args[0];
        String outputImagePath = args[1];
        BufferedImage bufferedInput = UtilImageIO.loadImageNotNull(inputImagePath);
        BufferedImage bufferedOutput = new BlurImageHandler().process(bufferedInput);
        UtilImageIO.saveImage(bufferedOutput, outputImagePath);
    }
}
