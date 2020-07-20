
call mvn clean
call mvn install

REM Copy files to server
ssh dumavla@192.168.1.53 "rm -f -r iot-motion-detection-backend && mkdir iot-motion-detection-backend"
scp -r * dumavla@192.168.1.53:~/iot-motion-detection-backend


REM docker build
REM ssh -t dumavla@192.168.1.53 "sudo docker build -t dumskyhome/iot-motion-detection-backend:rev2 ~/iot-motion-detection-backend/."
REM ssh -t dumavla@192.168.1.53 "sudo docker run --name iot-motion-detection-backend-rev2  --restart unless-stopped -it -d dumskyhome/iot-motion-detection-backend:rev2

ssh -t dumavla@192.168.1.53 "sudo docker stop iot-motion-detection-backend-rev2 || true && sudo docker rm iot-motion-detection-backend-rev2 || true && sudo docker build -t dumskyhome/iot-motion-detection-backend:rev2 ~/iot-motion-detection-backend/. && sudo docker run --name iot-motion-detection-backend-rev2  --restart unless-stopped -it -d dumskyhome/iot-motion-detection-backend:rev2"