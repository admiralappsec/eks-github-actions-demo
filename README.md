# azure-kubernetes-service-contrast-security-github-action

This github action deploys a java application to the Azure Kubernetes Service (AKS) and instruments a Contrast Security Java Agent.

## Prerequisites

- An Azure Service Principle with enough permissions to: 
    - Deploy an application to Azure Kubernetes Service (AKS)
    - Deploy a volume
    - Create a secret 
- A valid Contrast Security account
- Prepopulated Contrast Security and Azure JSON objects - details within 'Inputs' section

## Inputs
- `contrast-security-credentials-file`
  - REQUIRED: YES
  - Description: "The configuration contents for the Contrast Security Java Agent - used to communication with Contrast Security Team Server. 
  - Default: No Default Value  
- `azure-credentials-file`
  - REQUIRED: YES
  - Description ""
  - Default: No Default Value
- `application-manifests`
  - REQUIRED: YES
  - Description: "Manifest files containing the kubernetes deployments"
  - Default: No Default Value

## Documentation

Can be found at these links:

> Note: `This section` is to be updated...

## Example Use

```sh
- name: Contrast Security Azure Kubernetes Service Deployment
        uses: admiralappsec/aks-github-action@main
        id: contrast-deployment
        with:
          contrast-security-credentials-file: ${{ secrets.CONTRAST_CREDS_FILE }}
          azure-credentials-file: ${{ secrets.AZURE_CREDS_FILE }}
          application-manifests: '/manifests/manifest1.yml'
```

## Development

> Note: `This section` is to be updated...
