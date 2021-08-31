![Contrast Security](./images/contrast-security-original.png) ![Azure Spring Cloud](./images/Webp.net-resizeimage.png)

<hr />

# azure-spring-cloud-contrast-security-github-action

<hr />

[![.github/workflows/main.yml](https://github.com/admiralappsec/springone-github-action/actions/workflows/main.yml/badge.svg?branch=main)](https://github.com/admiralappsec/springone-github-action/actions/workflows/main.yml)

<hr />

This github action deploys a java application with a Contrast Security Java Agent (JAR) to either:
- an existing application running on Azure Spring Cloud on an existing Azure Spring Cloud instance.
- an existing running instance of Azure Spring Cloud and creates a new application during the deployment process.

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
  - REQUIRED: NO
  - Description: "Location of the artifact used to upload the contrast.jar file. Location relative to /docker-action/Dockerfile."
  - Default: No Default Value
- `application-artifact-location`
  - REQUIRED: YES
  - Description: "Location of the deployable application artifact. Location relative to /docker-action/Dockerfile."
  - Default: No Default Value
- `azure-application-id`
  - REQUIRED: NO
  - Description: "Azure application id (service principal, etc...)."
  - Default: No Default Value
- `azure-tenant-id`
  - REQUIRED: NO
  - Description: "Azure tenant id (domain id)."
  - Default: No Default Value
- `azure-client-secret`
  - REQUIRED: NO
  - Description: "Azure client secret."
  - Default: No Default Value
- `azure-subscription-id`
  - REQUIRED: NO
  - Description: "Azure subscription id."
  - Default: No Default Value
- `azure-resource-group-name`
  - REQUIRED: NO
  - Description: "Azure resource group name."
  - Default: No Default Value
- `azure-region`
  - REQUIRED: NO
  - Description: "Azure region."
  - Default: No Default Value
- `contrast-agent-download-url`
  - REQUIRED: NO
  - Description: "Agent download url associated with the Contrast Security Team Server."
  - Default: No Default Value
- `contrast-api-url`
  - REQUIRED: NO
  - Description: "The Contrast Security Team Server URL."
  - Default: No Default Value
- `contrast-api-username`
  - REQUIRED: NO
  - Description: "The username asssociated with the login for the Contrast Security Team Server."
  - Default: No Default Value
- `contrast-api-api-key`
  - REQUIRED: NO
  - Description: "The API key associated with the Contrast Security Team Server."
  - Default: No Default Value
- `contrast-api-service-key`
  - REQUIRED: NO
  - Description: "API service key associated with Contrast Security Team Server."
  - Default: No Default Value
- `contrast-agent-java-standalone-app-name`
  - REQUIRED: NO
  - Description: "Application name associated with Contrast Security Team Server."
  - Default: No Default Value
- `contrast-application-version`
  - REQUIRED: NO
  - Description: "Application version associated with the Contrast Security Application on Team Server."
  - Default: No Default Value
- `azure-application-jvm-options`
  - REQUIRED: NO
  - Description: "Deployable application's jvm-options to pass to the Azure Spring Cloud PaaS deployment."
  - Default: No Default Value
- `contrast-security-configuration-file`
  - REQUIRED: NO
  - Description: "The configuration file location for the Contrast Security Java Agent - used to communication with Contrast Security Team Server. 
    > Note: If this input field contains a value, this will `override` the individual contrast-specific configurations set using the passed parameters from the file specified."
  - Default: No Default Value

```sh
{
    contrast-api-url: xxx,
    contrast-api-username: xxx,
    contrast-api-api-key: xxx,
    contrast-api-service-key: xxx,
    contrast-agent-java-standalone-app-name: xxx,
    contrast-application-version: xxx
}
```

- `azure-authentication-details-file`
  - REQUIRED: NO
  - Description: "The configuration file location for Azure-specific logins, regions, etc...
    > Note: If this input field contains a value, this will `override` the individual contrast-specific configurations set using the passed parameters from the file specified."
  - Default: No Default Value

```sh
{
    azure-application-id: xxx,
    azure-tenant-id: xxx,
    azure-client-secret: xxx,
    azure-subscription-id: xxx,
    azure-resource-group-name: xxx,
    azure-region: xxx
}
```
- `github-developer-token`
  - REQUIRED: YES
  - Description: ""
  - Default: No Default Value
- `github-developer-branch`
  - REQUIRED: NO
  - Description: ""
  - Default: 'main'  
## Outputs

- `time`
  - Description: "The timestamp associated with the start of the github action."

## Documentation

Can be found at these links:

> Note: `This section` is to be updated...

## Example Use

```sh
- name: Contrast Security Azure Spring Cloud Deployment
        uses: ./ # Uses an action in the root directory - for testing purposes
        id: contrast-deployment
        with:
          application-name: 'springone-petclinic-mark-testing'
          spring-cloud-service-name: 'mark-spring-cloud-test'
          application-artifact-location: 'spring-petclinic-2.4.5.jar'
          contrast-security-credentials-file: ${{ secrets.CONTRAST_CREDS_FILE }}
          azure-credentials-file: ${{ secrets.AZURE_CREDS_FILE }}
          github-developer-token: ${{ secrets.GITHUB_DEV_TOKEN }}
```

## Development

> Note: `This section` is to be updated...

## License

MIT
