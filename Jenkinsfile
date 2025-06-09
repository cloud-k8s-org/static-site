pipeline {
    agent any

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }
        stage('Validate Commit Messages') {
                when {
                    expression { return env.CHANGE_ID != null }
                }
                steps {
                    script {
                        def latestCommitMessage = sh(script: 'git log -1 --pretty=%B', returnStdout: true).trim()

                        if (!(latestCommitMessage =~ /^(fix|feat|chore|docs|style|refactor|test|perf|build|ci|revert|version|merge|hotfix|wip)\: .+/)) {
                            error "The commit message does not follow the Conventional Commit format:\n${latestCommitMessage}"
                        }
                    }
                }
            }
        }
        stage('Build & Push') {
            steps {
                script {
                     withCredentials([usernamePassword(credentialsId: 'docker-credential', usernameVariable: 'DOCKER_HUB_USERNAME', passwordVariable: 'DOCKER_HUB_PASSWORD')]) {
                        sh "echo ${DOCKER_HUB_PASSWORD} | docker login -u ${DOCKER_HUB_USERNAME} --password-stdin"
                    }
                    sh "docker buildx build --platform linux/amd64,linux/arm64 -t ${DOCKER_REPO}:${LATEST_TAG} --push ."
                }
            }
        }
    }
    post {
        always {
            cleanWs()
        }
        success {
            echo 'Commit message follows Conventional Commit format'
        }
        failure {
            echo 'Commit message does not follow Conventional Commit format'
        }
    }
}