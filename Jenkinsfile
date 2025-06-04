pipeline {
    agent none
    
    environment {
        BUILD_TIMESTAMP = "${new Date().format('yyyy-MM-dd-HH-mm-ss')}"
        PROJECT_NAME = "IGP Grad Project (3 Classes + 1 Test)"
    }
    
    options {
        buildDiscarder(logRotator(numToKeepStr: '5'))
        timeout(time: 30, unit: 'MINUTES')
    }
    
    stages {
        stage('Pipeline Start') {
            agent { label 'master' }
            steps {
                script {
                    echo """
🚀 ==========================================
   ${PROJECT_NAME} - CI/CD Pipeline
🚀 ==========================================
📅 Build: #${BUILD_NUMBER} 
⏰ Time: ${BUILD_TIMESTAMP}
📂 Repo: https://github.com/MosALs/IGP-Grad-Project.git

📋 Plan:
1. 🔨 Compile (3 Java classes) → Slave
2. 🧪 Test (1 test class) → Slave  
3. 📦 Package (JAR file) → Master
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
        
        stage('Step 3: Package') {
            steps {
                script {
                    echo "📦 STEP 3: Creating JAR package on master node"
                    
                    def packageJob = build job: 'IGP-Package-Job',
                                           wait: true,
                                           propagate: true
                    
                    echo "✅ Packaging Result: ${packageJob.result}"
                    
                    if (packageJob.result != 'SUCCESS') {
                        error("❌ Packaging failed!")
                    }
                }
            }
        }
        
        stage('Pipeline Summary') {
            agent { label 'master' }
            steps {
                script {
                    echo """
🎉 ==========================================
   IGP PROJECT CI/CD - COMPLETED!
🎉 ==========================================
✅ Step 1 - Compilation: SUCCESS (3 classes)
✅ Step 2 - Testing: SUCCESS (1 test)  
✅ Step 3 - Packaging: SUCCESS (JAR ready)

🚀 Your simple project is ready for deployment!
==========================================
"""
                    
                    writeFile file: 'pipeline-summary.txt', text: """
IGP Grad Project Pipeline Summary
================================
Build: #${BUILD_NUMBER}
Time: ${BUILD_TIMESTAMP}
Project: 3 Java classes + 1 test class

Results:
✅ Compilation: SUCCESS
✅ Testing: SUCCESS
✅ Packaging: SUCCESS

Status: DEPLOYMENT READY! 🚀
"""
                }
            }
        }
    }
    
    post {
        success {
            node('master') {
                echo "🎉 IGP Pipeline SUCCESS! Simple project built and ready!"
                archiveArtifacts artifacts: 'pipeline-summary.txt', allowEmptyArchive: true
            }
        }
        failure {
            node('master') {
                echo "❌ IGP Pipeline FAILED! Check individual job logs."
            }
        }
    }
}