
#!/bin/bash


for filename in imageproc/resources/*.{jpg,png}; do
    # echo "${filename%.*}"
    mkdir -p "${filename%.*}"
    tool="MethodExecutionCounter"
    java -cp imageproc/target/imageproc-1.0.0-SNAPSHOT-jar-with-dependencies.jar\
     -javaagent:javassist/target/JavassistWrapper-1.0-jar-with-dependencies.jar=$tool:"pt.ulisboa.tecnico.cnv.webserver,pt.ulisboa.tecnico.cnv.imageproc,pt.ulisboa.tecnico.cnv.raytracer":output\
     pt.ulisboa.tecnico.cnv.imageproc.BlurImageHandler "$filename" "${filename%.*}/out.jpg" > "${filename%.*}/$tool.txt" &
done

# Imageproc with BasicBlockCacheTool
tool="MethodExecutionCounter"
java -cp imageproc/target/imageproc-1.0.0-SNAPSHOT-jar-with-dependencies.jar\
 -javaagent:javassist/target/JavassistWrapper-1.0-jar-with-dependencies.jar=$tool:"pt.ulisboa.tecnico.cnv.webserver,pt.ulisboa.tecnico.cnv.imageproc,pt.ulisboa.tecnico.cnv.raytracer":output\
 pt.ulisboa.tecnico.cnv.imageproc.BlurImageHandler imageproc/resources/airplane.jpg imageproc/resources/airplane/out.jpg > imageproc/resources/airplane/$tool.txt


for path in raytracer/resources/*.bmp; do
    filename=$(basename -- "$path" ".bmp")
    mkdir -p "raytracer/resources/${filename}"
    tool="MethodExecutionCounter"
    java -cp raytracer/target/raytracer-1.0.0-SNAPSHOT-jar-with-dependencies.jar\
     -javaagent:javassist/target/JavassistWrapper-1.0-jar-with-dependencies.jar=$tool:"pt.ulisboa.tecnico.cnv.webserver,pt.ulisboa.tecnico.cnv.imageproc,pt.ulisboa.tecnico.cnv.raytracer":output\
     pt.ulisboa.tecnico.cnv.raytracer.Main raytracer/resources/test$filename.txt raytracer/resources/${filename}/out.bmp 400 300 400 300 0 0 -tm=raytracer/resources/$filename.bmp -multi > "raytracer/resources/${filename}/$tool.txt" &
done

tool="ICount"
java -cp raytracer/target/raytracer-1.0.0-SNAPSHOT-jar-with-dependencies.jar\
 -javaagent:javassist/target/JavassistWrapper-1.0-jar-with-dependencies.jar=$tool:"pt.ulisboa.tecnico.cnv.webserver,pt.ulisboa.tecnico.cnv.imageproc,pt.ulisboa.tecnico.cnv.raytracer":output\
 pt.ulisboa.tecnico.cnv.raytracer.Main raytracer/resources/test01.txt raytracer/resources/01/out.bmp 400 300 400 300 0 0 -tm=raytracer/resources/01.bmp -multi


java -cp webserver/target/webserver-1.0.0-SNAPSHOT-jar-with-dependencies.jar\
 -javaagent:javassist/target/JavassistWrapper-1.0-jar-with-dependencies.jar=InstructionsCounter:"pt.ulisboa.tecnico.cnv.webserver,pt.ulisboa.tecnico.cnv.imageproc,pt.ulisboa.tecnico.cnv.raytracer":output\
 pt.ulisboa.tecnico.cnv.webserver.WebServer > webserver/InstructionsCounter.txt

# ----------------------------------------------------------
# VM code
# ----------------------------------------------------------

tool="InstructionsCounter"
java -cp home/cnv24-g31/webserver/target/webserver-1.0.0-SNAPSHOT-jar-with-dependencies.jar\
 -javaagent:home/cnv24-g31/javassist/target/JavassistWrapper-1.0-jar-with-dependencies.jar=$tool:"pt.ulisboa.tecnico.cnv.webserver,pt.ulisboa.tecnico.cnv.imageproc,pt.ulisboa.tecnico.cnv.raytracer":output\
 pt.ulisboa.tecnico.cnv.webserver.WebServer > cnv24-g31/webserver/$tool.txt

java -cp cnv24-g31/webserver/target/webserver-1.0.0-SNAPSHOT-jar-with-dependencies.jar\
 -javaagent:cnv24-g31/javassist/target/JavassistWrapper-1.0-jar-with-dependencies.jar=ICount:"pt.ulisboa.tecnico.cnv.webserver,pt.ulisboa.tecnico.cnv.imageproc,pt.ulisboa.tecnico.cnv.raytracer":output\
 pt.ulisboa.tecnico.cnv.webserver.WebServer > cnv24-g31/webserver/ICount.txt


# ----------------------------------------------------------
# Testing code
# ----------------------------------------------------------

test="cat"
base64 imageproc/resources/$test.jpg > temp.txt
echo -e "data:image/jpg;base64,$(cat temp.txt)" > temp.txt
curl -X POST http://52.91.216.69:8000/blurimage --data @"./temp.txt" > result.txt
sed -i 's/^[^,]*,//' result.txt
base64 -d result.txt > result.jpg

curl -X POST http://35.173.128.41:8000/blurimage --data @"./temp.txt" > result.txt
curl -v http://CNV-g31-AWS-LB-1597143940.us-east-1.elb.amazonaws.com/blurimage --data @"./temp.txt" > result.txt




payload="02"
cat raytracer/resources/test$payload.txt | jq -sR '{scene: .}' > payload.json
hexdump -ve '1/1 "%u\n"' raytracer/resources/$payload.bmp | jq -s --argjson original "$(<payload.json)" '$original * {texmap: .}' > payload.json
curl -X POST http://52.91.216.69:8000/raytracer?scols=400\&srows=300\&wcols=400\&wrows=300\&coff=0\&roff=0\&aa=false --data @"./payload.json" > result.txt
sed -i 's/^[^,]*,//' result.txt
base64 -d result.txt > result.bmp

curl -X POST http://CNV-g31-AWS-LB-1702498006.us-east-1.elb.amazonaws.com/raytracer?scols=400\&srows=300\&wcols=400\&wrows=300\&coff=0\&roff=0\&aa=false --data @"./payload.json" > result.txt
curl -v http://CNV-g31-AWS-LB-1597143940.us-east-1.elb.amazonaws.com/raytracer?scols=400\&srows=300\&wcols=400\&wrows=300\&coff=0\&roff=0\&aa=false --data @"./payload.json" > result.txt



sudo lsof -i -P -n


ssh -i ~/Downloads/jarkeypair.pem ec2-user@184.72.67.205
scp -i ~/Downloads/jarkeypair.pem cnv24-g31.tar ec2-user@184.72.67.205:

# ----------------------------------------------------------
# Load Balancer
# ----------------------------------------------------------

java -cp loadbalancer/target/loadbalancer-1.0.0-SNAPSHOT-jar-with-dependencies.jar\
 -javaagent:javassist/target/JavassistWrapper-1.0-jar-with-dependencies.jar=InstructionsCounter:"pt.ulisboa.tecnico.cnv.loadbalancer,pt.ulisboa.tecnico.cnv.webserver,pt.ulisboa.tecnico.cnv.imageproc,pt.ulisboa.tecnico.cnv.raytracer":output\
 pt.ulisboa.tecnico.cnv.loadbalancer.LoadBalancer


java -cp loadbalancer/target/loadbalancer-1.0.0-SNAPSHOT-jar-with-dependencies.jar pt.ulisboa.tecnico.cnv.loadbalancer.LoadBalancer




# ----------------------------------------------------------
# Testing worker
# ----------------------------------------------------------

ssh -i ~/Downloads/jarkeypair.pem ec2-user@52.91.216.69
scp -i ~/Downloads/jarkeypair.pem cnv24-g31.tar ec2-user@52.91.216.69:

export AWS_DEFAULT_REGION=eu-west-3
export AWS_ACCOUNT_ID=654654624924
export AWS_ACCESS_KEY_ID=AKIAZQ3DU2SOGMZKQH5W
export AWS_SECRET_ACCESS_KEY=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

test="cat"
base64 imageproc/resources/$test.jpg > temp.txt
echo -e "data:image/jpg;base64,$(cat temp.txt)" > temp.txt
curl -X POST http://52.91.216.69:8000/blurimage --data @"./temp.txt" > result.txt
sed -i 's/^[^,]*,//' result.txt
base64 -d result.txt > result.jpg

payload="02"
cat raytracer/resources/test$payload.txt | jq -sR '{scene: .}' > payload.json
hexdump -ve '1/1 "%u\n"' raytracer/resources/$payload.bmp | jq -s --argjson original "$(<payload.json)" '$original * {texmap: .}' > payload.json
curl -X POST http://52.91.216.69:8000/raytracer?scols=400\&srows=300\&wcols=400\&wrows=300\&coff=0\&roff=0\&aa=false --data @"./payload.json" > result.txt
sed -i 's/^[^,]*,//' result.txt
base64 -d result.txt > result.bmp

# ----------------------------------------------------------
# Testing LB
# ----------------------------------------------------------

ssh -i ~/Downloads/jarkeypair.pem ec2-user@184.72.67.205
scp -i ~/Downloads/jarkeypair.pem cnv24-g31.tar ec2-user@184.72.67.205:

tar -xvf cnv24-g31.tar

java -cp loadbalancer/target/loadbalancer-1.0.0-SNAPSHOT-jar-with-dependencies.jar pt.ulisboa.tecnico.cnv.loadbalancer.LoadBalancer


test="cat"
base64 imageproc/resources/$test.jpg > temp.txt
echo -e "data:image/jpg;base64,$(cat temp.txt)" > temp.txt
curl -X POST http://184.72.67.205:8000/blurimage --data @"./temp.txt" > result.txt
sed -i 's/^[^,]*,//' result.txt
base64 -d result.txt > result.jpg



