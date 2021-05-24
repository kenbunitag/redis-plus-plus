node {
    
    @Library("kenbun_pipeline")_
    
    checkout scm

    generalPipeline {
        def product = 'kenbun'
        def name = 'kazoku'
        
        if (env.BRANCH_NAME == 'main') {
            buildAndDeployLib()
        } else {
            buildOnly()
        }

    }
}

def buildOnly() {
    stage("compile"){
            docker.withRegistry(env.nexusDockerRepo, 'nexus') {
                def pythonImage = docker.image('docker.kenbun.de/kenbun/cppubuntu2004')
                pythonImage.pull()

                pythonImage.withRun() { c ->
                    pythonImage.inside("-v " + env.WORKSPACE.toString() + ":/workspace --network='host'") {
                        sh("bash /workspace/build-debian-packages.sh")
                    }
                }
            }
    }
}

def buildAndDeployLib() {
    stage("deploy to apt repo"){
            docker.withRegistry(env.nexusDockerRepo, 'nexus') {
                def pythonImage = docker.image('docker.kenbun.de/kenbun/cppubuntu2004')
                pythonImage.pull()

                pythonImage.withRun() { c ->
                    pythonImage.inside("-v " + env.WORKSPACE.toString() + ":/workspace --network='host'") {
                        sh("bash /workspace/build-debian-packages.sh")

                        withCredentials([usernamePassword(credentialsId: 'nexus', usernameVariable: 'nexusUser', passwordVariable: 'nexusPassword')]) {
                            sh("cd /workspace/build && for FILE in *.deb; do curl -u '" + nexusUser.toString() + ":" + nexusPassword.toString() + "' -H 'Content-Type: multipart/form-data'  --data-binary @\$FILE https://nexus.kenbun.de/repository/apt-kenbun/; done")
                        }
                    }
            }
	}
    }

}
