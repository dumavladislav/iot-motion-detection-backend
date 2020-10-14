#!groovy
// Check netbook properties
properties([disableConcurrentBuilds()])

pipeline {
    agent {
        label 'master'
    }
    triggers { pollSCM('* * * * *') }
    options {
        buildDiscarder(logRotator(numToKeepStr: '10', artifactNumToKeepStr: '10'))
        timestamps()
    }
    stages {
        stage("Build service artefact") {
            steps {
                echo '================== Building service artefact =================='
                sh 'mvn clean'
                sh 'mvn install'
            }
        }
        stage("DockerHub login") {
            steps {
                echo '================== DockerHub login =================='
                withCredentials([usernamePassword(credentialsId: 'dockerhub-vladislavduma', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                    sh """
                    docker login -u $USERNAME -p $PASSWORD
                    """
                }
            }
        }
        stage("Build image") {
            steps {
                sh 'docker build -t vladislavduma/iot-motion-detection-backend:latest .'
            }
        }
        stage("Push image to docker registry") {
            steps{
                echo '================== DockerHub Push =================='
                sh "docker push vladislavduma/iot-motion-detection-backend:latest"
            }
        }
        stage("Run image on Backend server") {
            steps{
                echo '================== Running on Backend =================='
                // sh "ssh -p 23 root@dumskyhome.keenetic.name 'docker run vladislavduma/iot-authorization-service-backend:latest --restart unless-stopped -it'"
                sh 'docker stop iot-motion-detection-backend-prod ||true'
                sh 'docker rm iot-motion-detection-backend-prod ||true'
                sh 'docker run -d --restart unless-stopped --name iot-motion-detection-backend-prod' +
                        ' -e DB_URL=$DB_URL' +
                        ' -e DB_USR=$DB_USR' +
                        ' -e DB_PASSWORD=$DB_PASSWORD' +
                        ' -e MQTT_SERVER_URL=$MQTT_SERVER_URL' +
                        ' -e MQTT_USR=$MQTT_USR' +
                        ' -e MQTT_PASSWORD=$MQTT_PASSWORD' +
                        ' -e MQTT_CLIENT_ID=$MQTT_CLIENT_ID' +
                        ' vladislavduma/iot-motion-detection-backend:latest'
            }
        }
    }
}