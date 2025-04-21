#!/bin/bash

# saves tool output metrics to its file
exec > /home/ec2-user/cnv24-g31/webserver/InstructionsCounter.txt 2>&1
set -x

# opens the webserver
cd home/ec2-user/cnv24-g31
java -cp webserver/target/webserver-1.0.0-SNAPSHOT-jar-with-dependencies.jar\
 -javaagent:javassist/target/JavassistWrapper-1.0-jar-with-dependencies.jar=InstructionsCounter:"pt.ulisboa.tecnico.cnv.webserver,pt.ulisboa.tecnico.cnv.imageproc,pt.ulisboa.tecnico.cnv.raytracer":output\
 pt.ulisboa.tecnico.cnv.webserver.WebServer

exit 0