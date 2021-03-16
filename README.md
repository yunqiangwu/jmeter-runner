# jmeter-runner
A container image that contains Jenkins to be used within a CI/CD pipeline

Jmeter is downloaded and available in the `/opt/jmeter/bin` folder.
It works best with the script library that was created for jenkins, available here: https://github.com/dynatrace-ace/jenkins-test-library

- [jmeter-runner](#jmeter-runner)
  - [Using the jmeter-runner in a Jenkins environment with Kubernetes integration](#using-the-jmeter-runner-in-a-jenkins-environment-with-kubernetes-integration)

## Using the jmeter-runner in a Jenkins environment with Kubernetes integration
> Note: the screenshots are for indicative pruposes only, the values need to be adjusted to the guide!

1. Go to `Manage Jenkins` and click on `Configure System`

    ![](resources/manage_jenkins.png)

1. At the bottom of the page, click on the link directing you to cloud configuration

    ![](resources/configure_clouds.png)

1. On the Cloud Configuration page, click on `Pod Templates...`
    
    ![](resources/configure_clouds_2.png)

1. Add a new pod template and fill it in as follows:
   1. `Name`: A free name for you to give to the template
   2. `Labels`: A label we will use to refer to this template, `jmeter-runner` will be used in a later pipeline
   3. `Container template name`: the name of this container, `jmeter` will be used in a later pipeline
   4. `Docker Image`: `dynatraceace/jmeter:latest` *Note* a new release might be available
   5. `Command to run`: `/bin/sh -c`
   6. `Arguments to pass to the command`: `cat`
   7. `Allocate pseudo-TTY`: `yes`

        ![](resources/pod_template.png)

2. Click on Save

1. In your `Jenkinsfile` you can now refer to the runner like this:
   > Note: this assumes that the jenkins library (https://github.com/dynatrace-ace/jenkins-test-library) was also added
    ```groovy
    // Import Dynatrace library -- the v1.0 indicates the tag/branch to use.
    @Library("jenkins-test@v1.0")

    // Initialize the class with the event methods
    def jmeter = new com.dynatrace.ace.Jmeter()

    // this is called with a script step
    pipeline {
    agent jmeter
    stages {
        stage('Run performance test') {
        steps {
            container('jmeter') {
            script {
                def status = jmeter.executeJmeterTest ( 
                    scriptName: "jmeter/simplenodeservice_load.jmx",
                    resultsDir: "perfCheck_${env.APP_NAME}_staging_${BUILD_NUMBER}",
                    serverUrl: "simplenodeservice.staging", 
                    serverPort: 80,
                    checkPath: '/health',
                    vuCount: env.VU.toInteger(),
                    loopCount: env.LOOPCOUNT.toInteger(),
                    LTN: "perfCheck_${env.APP_NAME}_${BUILD_NUMBER}",
                    funcValidation: false,
                    avgRtValidation: 4000
                )
                if (status != 0) {
                    currentBuild.result = 'FAILED'
                    error "Performance test in staging failed."
                }
            }
            }
        }
        }
    }
    }
    ```
