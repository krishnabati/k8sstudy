#!groovy
pipeline {
    agent any
    environment {
        IMAGE='krishnabati/jenkins-docker'
        TAG='latest'
        AWS_KEY=credentials('AWS_KEY')
        AWS_SECRET=credentials('AWS_SECRET')
    }
    stages {
        stage('Build') {
            steps {
                sh "docker build --pull -t ${IMAGE}:${TAG} ."
            }
        }
        stage('Push to dockerhub') {
            when {
                branch 'main'
            }
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'dockerPassword', usernameVariable: 'dockerUsername')]) {
                    sh "docker login -u ${env.dockerUsername} -p ${env.dockerPassword}"
                    sh "docker push ${env.IMAGE}:${TAG}"
                }
            }
        }

        stage('Deploy into K8s'){
            steps {
                sh "pwd/awsconfig.sh"
                sh "chmod -R 777 /var/lib/jenkins/workspace/kube_pipeline/awsconfig.sh"
                sh "/var/lib/jenkins/workspace/kube_pipeline/awsconfig.sh ${AWS_KEY} ${AWS_SECRET}"
                sh "aws eks --region us-east-2 update-kubeconfig --name devopsmentor-dev-devopsmentorcluster"
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