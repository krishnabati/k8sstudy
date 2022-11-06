#!groovy
pipeline {
    agent any
    environment {
        IMAGE=credentials('DOCKER_IMAGE_REPO')
        TAG='v.${BUILD_NUMBER}'
        AWS_KEY=credentials('AWS_KEY')
        AWS_SECRET=credentials('AWS_SECRET')
        AWS_REGION=credentials('AWS_REGION')
        DOCKER_USER=credentials('dockerUsername')
        DOCKER_PWD=credentials('dockerPassword')
    }
    stages {
        stage('Build') {
            steps {
                sh "docker build --pull -t ${IMAGE}:${TAG} ."
            }
        }
        stage('Push to dockerhub') {
            
            steps {
                    sh "docker login -u ${DOCKER_USER} -p ${DOCKER_PWD}"
                    sh "docker push ${env.IMAGE}:${TAG}"
            }
        }

        stage('Deploy into K8s'){
            steps {

                sh "chmod -R 777 /var/lib/jenkins/workspace/${JOB_NAME}/awsconfig.sh"
                sh "/var/lib/jenkins/workspace/${JOB_NAME}/awsconfig.sh ${AWS_KEY} ${AWS_SECRET} ${AWS_REGION}"
                sh "aws eks --region ${AWS_REGION} update-kubeconfig --name devopsmentor-dev-devopsmentorcluster"
                sh "kubectl get nodes"
                sh "kubectl delete pod devopmentorpod"
                sh "kubectl delete svc devopmentorpod-httpd-service"
                sh "kubectl run devopmentorpod --image ${IMAGE}:${TAG}"
                sh "kubectl expose pod devopmentorpod --type=NodePort --port=81 --target-port=80 --name=devopmentorpod-httpd-service"
                sh "kubectl get svc"
            }
        }
    }
}