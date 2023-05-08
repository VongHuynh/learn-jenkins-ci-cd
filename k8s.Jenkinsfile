pipeline {
    agent any
    // if we use a git plugin, we not use environment:GIT_COMMIT, replace it with ${env.GIT_COMMIT}
    environment {
        GIT_COMMIT = sh(script: 'git rev-parse HEAD', returnStdout: true).trim()
    }
    
    stages {
        stage('Build') {
            steps {
                git credentialsId: '118730d4-27d7-4d54-bcfa-3ede6e4251cc', url: 'https://gitlab.com/my-project/project.git', branch: 'test'
                sh "docker build -t vonghuynhimage:\$GIT_COMMIT ."
            }
        }
        
        stage('Push to registry') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'HHWT_REGISTRY_CREDENTIALS', passwordVariable: 'HHWT_REGISTRY_PASSWORD', usernameVariable: 'HHWT_REGISTRY_USERNAME')]) {
                    sh "docker login -u ${HHWT_REGISTRY_USERNAME} -p ${HHWT_REGISTRY_PASSWORD} registry.havehalalwilltravel.com"
                    sh "docker tag vonghuynhimage:\$GIT_COMMIT registry.havehalalwilltravel.com/vonghuynhimage:\$GIT_COMMIT"
                    sh "docker push registry.lerndevops.com/vonghuynhimage:\$GIT_COMMIT"
                }
            }
        }
        stage('Deploy to k8s') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'HHWT_REGISTRY_CREDENTIALS', passwordVariable: 'HHWT_REGISTRY_PASSWORD', usernameVariable: 'HHWT_REGISTRY_USERNAME')]) {
                    sh "docker login -u ${HHWT_REGISTRY_USERNAME} -p ${HHWT_REGISTRY_PASSWORD} registry.havehalalwilltravel.com"
                    sh "docker tag vonghuynhimage:\$GIT_COMMIT registry.havehalalwilltravel.com/vonghuynhimage:\$GIT_COMMIT"
                    sh "docker push registry.lerndevops.com/vonghuynhimage:\$GIT_COMMIT"
                }
            }
        }
        // need install kubernetes-cli plugin and config add KUBECONFIG_FILE
        stage('Deploy to K8s') {
            steps {
                withCredentials([kubeconfigFile(credentialsId: 'KUBECONFIG_FILE', variable: 'KUBECONFIG')]) {
                    sh "kubectl --kubeconfig=$KUBECONFIG set image deployment.v1.apps/my-deployment my-deployment=registry.lerndevops.com/vonghuynhimage:\$GIT_COMMIT --namespace pre"
                }
            }
        }
    }
}
