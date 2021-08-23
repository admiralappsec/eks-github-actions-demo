# springone-github-action

This action deploys an application with a Contrast Security Agent to either:
an existing application running on Azure Spring Cloud
a new application to be run on Azure Spring Cloud

## Prerequisites

Functioning Azure Spring Cloud Instance
Functioning Spring Configuration Server

## Inputs

### `application-name`

**Required**

### `spring-cloud-service-name`

**Required** 

### `file-upload-artifact-location`

**Required**

### application-artifact-location:

**Required**

### azure-application-id:

**Required**

### azure-tenant-id:

**Required**

### azure-client-secret:

**Required**

### azure-subscription-id:

**Required**

### azure-resource-group-name:

**Required**

### azure-region:

**Required**

### contrast-agent-download-url:

**Required**

### contrast-api-url:

**Required**

### contrast-api-username:

**Required**

### contrast-api-api-key:

**Required**

### contrast-api-service-key:

**Required**

### contrast-application-name:

**Required**

### contrast-agent-java-standalone-app-name:

**Required**

### contrast-application-version:

**Required**

### contrast-server-name:

**Required**

### azure-application-jvm-options:

**Required**

## Outputs

### `time`

The time this action ran.

## Example usage
`
- name: Contrast Security Azure Spring Cloud Deployment
        uses: ./ # Uses an action in the root directory
        id: contrast-deployment
        with:
          application-name: 'springone-petclinic-mark-testing'
          spring-cloud-service-name: 'mark-spring-cloud-test'
          file-upload-artifact-location: '/spring-upload.jar' <location relative to /docker-action/Dockerfile>
          application-artifact-location: '/spring-petclinic-2.4.5.jar' <location relative to /docker-action/Dockerfile>
          azure-application-id: <APPLICATION_ID>
          azure-tenant-id: <TENANT_ID>
          azure-client-secret: <CLIENT_SECRET>
          azure-subscription-id: <SUBSCRIPTION_ID>
          azure-resource-group-name: 'azure-spring-cloud-sa'
          azure-region: 'EAST US'
          contrast-agent-download-url: 'https://repository.sonatype.org/service/local/artifact/maven/redirect?r=central-proxy&g=com.contrastsecurity&a=contrast-agent&v=LATEST'
          contrast-api-url: 'https://eval.contrastsecurity.com/Contrast'
          contrast-api-username: <API_USERNAME>>
          contrast-api-api-key: <API_KEY>
          contrast-api-service-key: <SERVICE_KEY>
          contrast-application-name: 'springone-workshop-petclinic'
          contrast-agent-java-standalone-app-name: 'springone-workshop-petclinic'
          contrast-application-version: '1'
          contrast-server-name: 'azure-spring-cloud-instance-1'
          azure-application-jvm-options: '-javaagent:/persistent/apm/contrast.jar'
      # Use the output from the `hello` step
      - name: Get the output time
        run: echo "The time was ${{ steps.contrast-deployment.outputs.time }} then this action was run."
`
