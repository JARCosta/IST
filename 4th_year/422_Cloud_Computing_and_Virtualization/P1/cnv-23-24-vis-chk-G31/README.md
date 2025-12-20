# G31 P1 Video

Asside for the extra steps (for example it starting in a Scaling In situation, and some more verifications in the middle of the steps) everything took the same order as the one asked in the FAQ document.

Note that in the middle of the video we had to change some settings that was not following the desired configuration, but we managed to fix it and continue the process.

## Scripts

the stress test files were adited to the following state:
### test-imageproc-01.sh
```
function simple {
    echo "started imageproc simple"
    # Encode in Base64.
	base64 cnv24-inputs-results-examples/image-input-files/airplane.jpg > imageproc_temp_simple.txt                                            

	# Append a formatting string.
	echo -e "data:image/jpg;base64,$(cat imageproc_temp_simple.txt)" > imageproc_temp_simple.txt               

	# Send the request.
	curl -X POST http://CNV-g31-AWS-LB-1702498006.us-east-1.elb.amazonaws.com/blurimage --data @"./imageproc_temp_simple.txt" > imageproc_result_simple.txt   

	# Remove a formatting string (remove everything before the comma).
	sed -i 's/^[^,]*,//' imageproc_result_simple.txt                                          

	# Decode from Base64.
	base64 -d imageproc_result_simple.txt > imageproc_result_simple.jpg                                 

    echo "finished imageproc simple"
}

function complex {
    echo "started imageproc complex"
    # Encode in Base64.
	base64 cnv24-inputs-results-examples/image-input-files/horse.jpg > imageproc_temp_complex.txt                                            

	# Append a formatting string.
	echo -e "data:image/jpg;base64,$(cat imageproc_temp_complex.txt)" > imageproc_temp_complex.txt               

	# Send the request.
	curl -X POST http://CNV-g31-AWS-LB-1702498006.us-east-1.elb.amazonaws.com/blurimage --data @"./imageproc_temp_complex.txt" > imageproc_result_complex.txt   

	# Remove a formatting string (remove everything before the comma).
	sed -i 's/^[^,]*,//' imageproc_result_complex.txt                                          

	# Decode from Base64.
	base64 -d imageproc_result_complex.txt > imageproc_result_complex.jpg                                 

    echo "finished imageproc complex"
}

simple &
complex
reset
```

### test-raytracer-02.sh
```
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
```