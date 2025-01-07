pipeline {
    agent any

    environment {
        IMAGE_NAME = 'sreenathkk96/laravel-app:latest'
        DOCKER_REGISTRY = 'docker.io'  // Use your registry, e.g., 'amazonaws.com' for ECR
    }

    stages {
        stage('Clone Repository') {
            steps {
                checkout scm
            }
        }

        stage('Install Dependencies') {
            steps {
                script {
                    // Run composer install
                    sh 'composer install --no-interaction'
                    // Run npm install and build assets
                    sh 'npm install'
                    sh 'npm run production'
                }
            }
        }

        stage('Run Unit Tests') {
            steps {
                script {
                    // Run Laravel PHPUnit tests
                    sh 'php artisan test'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image using the Dockerfile
                    sh 'docker build -t ${IMAGE_NAME} .'
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    // Log in to Docker Hub
                    sh 'docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD'

                    // Push the Docker image to the registry
                    sh 'docker push ${IMAGE_NAME}'
                }
            }
        }
    }
    
    post {
        success {
            echo 'Pipeline successful!'
        }

        failure {
            echo 'Pipeline failed.'
        }
    }
}
