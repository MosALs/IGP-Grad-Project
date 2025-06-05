pipeline {
    agent none
    
    environment {
        BUILD_TIMESTAMP = "${new Date().format('yyyy-MM-dd-HH-mm-ss')}"
        PROJECT_NAME = "IGP Grad Project - Containerized Deployment"
        REPO_URL = "https://github.com/MosALs/IGP-Grad-Project.git"
    }
    
    options {
        buildDiscarder(logRotator(numToKeepStr: '5'))
        timeout(time: 45, unit: 'MINUTES')
    }
    
    stages {
        stage('Pipeline Start') {
            agent { label 'master' }
            steps {
                script {
                    echo """
🚀 ==========================================
   ${PROJECT_NAME}
🚀 ==========================================
📅 Build: #${BUILD_NUMBER} 
⏰ Time: ${BUILD_TIMESTAMP}
📂 Repo: ${REPO_URL}
🖥️ Master: ${env.NODE_NAME}

📋 Execution Plan:
1. 🔨 Compile (3 Java classes) → Slave Node
2. 🧪 Test (1 test class) → Slave Node  
3. 📦 Package + Docker Deploy → Master Node
4. 🌐 Containerized Application Ready
==========================================
"""
                }
            }
        }
        
        stage('Step 1: Compile') {
            steps {
                script {
                    echo "🔨 STEP 1: Compiling 3 Java classes on slave node"
                    
                    def compileJob = build job: 'IGP-Compile-Job',
                                          wait: true,
                                          propagate: true
                    
                    echo "✅ Compilation Result: ${compileJob.result}"
                    
                    if (compileJob.result != 'SUCCESS') {
                        error("❌ Compilation failed!")
                    }
                }
            }
        }
        
        stage('Step 2: Test') {
            steps {
                script {
                    echo "🧪 STEP 2: Running 1 test class on slave node"
                    
                    def testJob = build job: 'IGP-Test-Job',
                                        wait: true,
                                        propagate: true
                    
                    echo "✅ Testing Result: ${testJob.result}"
                    
                    if (testJob.result != 'SUCCESS') {
                        error("❌ Tests failed!")
                    }
                }
            }
        }
        
        stage('Step 3: Package & Deploy') {
            steps {
                script {
                    echo "📦 STEP 3: Creating WAR, Docker image, and deploying container"
                    
                    def packageJob = build job: 'IGP-Package-Job',
                                           wait: true,
                                           propagate: true
                    
                    echo "✅ Package & Deploy Result: ${packageJob.result}"
                    
                    if (packageJob.result != 'SUCCESS') {
                        error("❌ Package & Deploy failed!")
                    }
                }
            }
        }
        
        stage('Final Summary') {
            agent { label 'master' }
            steps {
                script {
                    echo """
🎉 ===============================================
   IGP CONTAINERIZED CI/CD - COMPLETED!
🎉 ===============================================
✅ Step 1 - Compilation: SUCCESS (3 classes)
✅ Step 2 - Testing: SUCCESS (1 test)  
✅ Step 3 - Package & Deploy: SUCCESS

🏗️ Infrastructure:
   - Master Node: Orchestration, packaging, Docker
   - Slave Node: Compilation, testing

🐳 Docker Deployment:
   - WAR file: Created and deployed to Tomcat
   - Container: Running on port 8080
   - Image: igp-web-app:${BUILD_NUMBER}

🌐 Access Application:
   http://YOUR_EC2_MASTER_IP:8081

🎯 Achievement: Full CI/CD with containerization!
===============================================
"""
                    
                    writeFile file: 'docker-pipeline-summary.txt', text: """
IGP Containerized CI/CD Pipeline Summary
=======================================
Build: #${BUILD_NUMBER}
Time: ${BUILD_TIMESTAMP}
Repository: ${REPO_URL}

Pipeline Stages:
✅ Compilation (Slave Node)
✅ Testing (Slave Node)
✅ Packaging (Master Node)
✅ Docker Build (Master Node)
✅ Container Deployment (Master Node)

Docker Details:
- Base Image: tomcat:9.0-jre17
- Application Image: igp-web-app:${BUILD_NUMBER}
- Container Port: 8080
- WAR Deployment: /usr/local/tomcat/webapps/ROOT.war

Access Information:
- Application URL: http://YOUR_EC2_IP:8081
- Jenkins URL: http://YOUR_EC2_IP:8080

Status: FULLY DEPLOYED & CONTAINERIZED! 🚀
"""
                    
                    archiveArtifacts artifacts: 'docker-pipeline-summary.txt', allowEmptyArchive: true
                }
            }
        }
    }
    
    post {
        success {
            node('master') {
                echo "🎉 COMPLETE CI/CD WITH DOCKER SUCCESS!"
                echo "🌐 Your containerized application is live!"
            }
        }
        failure {
            node('master') {
                echo "❌ CI/CD Pipeline failed!"
                echo "🔍 Check individual job logs for details"
            }
        }
    }
}