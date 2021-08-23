# azure-spring-cloud-contrast-security-github-action

![example workflow](https://github.com/admiralappsec/springone-github-action/actions/workflows/badge.svg?branch=main)

## Features

This github action deploys a java application with a Contrast Security Java Agent (JAR) to either:
- an existing application running on Azure Spring Cloud on an existing Azure Spring Cloud instance
OR
- an existing running instance of Azure Spring Cloud and creates a new application during the deployment process

## Prerequisites

- A Deployed and functioning Azure Spring Cloud Instance
- A deployed and functioning Spring Configuration Server
- A deployed and functioning Java Application - (OPTIONAL)
- An Azure Service Principle with enough permissions to read and create an Azure Spring cloud instance, an Azure Spring Cloud application, deploy a JAR file to an Azure Spring Cloud application. 

## Inputs
- `application-name`
  - REQUIRED: YES
  - Description: "Name of the application deployed to Azure Spring Cloud."
  - Default: No Default Value
- `spring-cloud-service-name`
  - REQUIRED: YES
  - Description: "Azure Spring Cloud service name."
  - Default: No Default Value
- `file-upload-artifact-location`
  - REQUIRED: YES
  - Description: "Location of the artifact used to upload the contrast.jar file. Location relative to /docker-action/Dockerfile."
  - Default: No Default Value
- `application-artifact-location`
  - REQUIRED: YES
  - Description: "Location of the deployable application artifact. Location relative to /docker-action/Dockerfile."
  - Default: No Default Value
- `azure-application-id`
  - REQUIRED: YES
  - Description: "Azure application id (service principal, etc...)."
  - Default: No Default Value
- `azure-tenant-id`
  - REQUIRED: YES
  - Description: "Azure tenant id (domain id)."
  - Default: No Default Value
- `azure-client-secret`
  - REQUIRED: YES
  - Description: "Azure client secret."
  - Default: No Default Value
- `azure-subscription-id`
  - REQUIRED: YES
  - Description: "Azure subscription id."
  - Default: No Default Value
- `azure-resource-group-name`
  - REQUIRED: YES
  - Description: "Azure resource group name."
  - Default: No Default Value
- `azure-region`
  - REQUIRED: YES
  - Description: "Azure region."
  - Default: No Default Value
- `contrast-agent-download-url`
  - REQUIRED: YES
  - Description: "Agent download url associated with the Contrast Security Team Server."
  - Default: No Default Value
- `contrast-api-url`
  - REQUIRED: YES
  - Description: "The Contrast Security Team Server URL."
  - Default: No Default Value
- `contrast-api-username`
  - REQUIRED: YES
  - Description: "The username asssociated with the login for the Contrast Security Team Server."
  - Default: No Default Value
- `contrast-api-api-key`
  - REQUIRED: YES
  - Description: "The API key associated with the Contrast Security Team Server."
  - Default: No Default Value
- `contrast-api-service-key`
  - REQUIRED: YES
  - Description: "API service key associated with Contrast Security Team Server."
  - Default: No Default Value
- `contrast-agent-java-standalone-app-name`
  - REQUIRED: YES
  - Description: "Application name associated with Contrast Security Team Server."
  - Default: No Default Value
- `contrast-application-version`
  - REQUIRED: YES
  - Description: "Application version associated with the Contrast Security Application on Team Server."
  - Default: No Default Value
- `azure-application-jvm-options`
  - REQUIRED: YES
  - Description: "Deployable application's jvm-options to pass to the Azure Spring Cloud PaaS deployment."
  - Default: No Default Value
  
### In Process**
- `contrast-security-configuration-file`
  - REQUIRED: NO
  - Description: "The configuration file location for the Contrast Security Java Agent - used to communication with Contrast Security Team Server. If this input field contains a value, this will override the individual contrast-specific configurations set using the passed parameters from the file specified."
  - Default: No Default Value
- `azure-authentication-details-file`
  - REQUIRED: NO
  - Description: "The configuration file location for Azure-specific logins, regions, etc... If this input field contains a value, this will override the individual azure-specific configurations set using the passed parameters from the file specified."
  - Default: No Default Value
  
## Outputs

- `time`
  - Description: "The timestamp associated with the start of the github action."

## Documentation

Can be found at these links:

## Example Use

```sh
- name: Contrast Security Azure Spring Cloud Deployment
        uses: ./ # Uses an action in the root directory - for testing purposes
        id: contrast-deployment
        with:
          application-name: 'springone-petclinic-mark-testing'
          spring-cloud-service-name: 'mark-spring-cloud-test'
          file-upload-artifact-location: '/spring-upload.jar'
          application-artifact-location: '/spring-petclinic-2.4.5.jar'
          azure-application-id: xxx
          azure-tenant-id: xxx
          azure-client-secret: xxx
          azure-subscription-id: xxx
          azure-resource-group-name: xxx
          azure-region: xxx
          contrast-agent-download-url: 'https://repository.sonatype.org/service/local/artifact/maven/redirect?r=central-proxy&g=com.contrastsecurity&a=contrast-agent&v=LATEST'
          contrast-api-url: 'https://eval.contrastsecurity.com/Contrast'
          contrast-api-username: xxx
          contrast-api-api-key: xxx
          contrast-api-service-key: xxx
          contrast-application-name: 'springone-workshop-petclinic'
          contrast-agent-java-standalone-app-name: 'springone-workshop-petclinic'
          contrast-application-version: '1'
          contrast-server-name: 'azure-spring-cloud-instance-1'
          azure-application-jvm-options: '-javaagent:/persistent/apm/contrast.jar'
      # Use the output from the `hello` step
      - name: Get the output time
        run: echo "The time was ${{ steps.contrast-deployment.outputs.time }} then this action was run."
```

## Development

> Note: `This section` is to be updated...

## License

MIT
