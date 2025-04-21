#!/bin/bash

# CNV-23-24
# This script will issue in parallel on complex and one simple imageproc request.
# Modify it so it invokes your correct LB address and port in AWS, i.e., after http://
# If you need to change other request parameters to increase or decrease request complexity feel free to do so, provided they remain requests of different complexity.


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