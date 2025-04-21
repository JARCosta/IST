#!/bin/bash

# CNV-23-24
# This script will issue in parallel on complex and one simple raytracer request.
# Modify it so it invokes your correct LB address and port in AWS, i.e., after http://
# If you need to change other request parameters to increase or decrease request complexity feel free to do so, provided they remain requests of different complexity.


function simple {
    echo "started raytracer simple"
    # Add scene.txt raw content to JSON.
	cat cnv24-inputs-results-examples/scene-input-files/test01.txt | jq -sR '{scene: .}' > raytracing_payload_simple.json
    # Send the request.
	curl -s -X POST http://CNV-g31-AWS-LB-1702498006.us-east-1.elb.amazonaws.com/raytracer?scols=400\&srows=300\&wcols=400\&wrows=300\&coff=0\&roff=0\&aa=true --data @"./raytracing_payload_simple.json" > raytracing_result_simple.txt   
    # Remove a formatting string (remove everything before the comma).
	sed -i 's/^[^,]*,//' raytracing_result_simple.txt
    base64 -d raytracing_result_simple.txt > raytracing_result_simple.bmp
    echo "finished raytracer simple"
}

function complex {
    echo "started raytrace complex"
    # Add scene.txt raw content to JSON.
	cat cnv24-inputs-results-examples/scene-input-files/wood.txt | jq -sR '{scene: .}' > raytracing_payload_complex.json
    # Add texmap.bmp binary to JSON (optional step, required only for some scenes).
	hexdump -ve '1/1 "%u\n"' cnv24-inputs-results-examples/texture-input-files/calcada.jpeg | jq -s --argjson original "$(<raytracing_payload_complex.json)" '$original * {texmap: .}' > raytracing_payload_complex.json  
    # Send the request.
	curl -s -X POST http://CNV-g31-AWS-LB-1702498006.us-east-1.elb.amazonaws.com/raytracer?scols=400\&srows=300\&wcols=400\&wrows=300\&coff=0\&roff=0\&aa=true --data @"./raytracing_payload_complex.json" > raytracing_result_complex.txt   
    # Remove a formatting string (remove everything before the comma).
	sed -i 's/^[^,]*,//' raytracing_result_complex.txt
    base64 -d raytracing_result_complex.txt > raytracing_result_complex.bmp
    echo "finished raytracer complex"
}

simple &
complex
reset