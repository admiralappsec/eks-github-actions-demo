#!/bin/bash

# set -x

# printenv

# echo "mapping environment variables to inputs..."

if [ -z "$CONTRAST_SECURITY_CREDENTIALS_FILE" ]; then
    printf '%s\n' "No Contrast Security credentials file passed via input." >&2
    exit 1
else
    echo "$CONTRAST_SECURITY_CREDENTIALS_FILE" >> contrast.json
#    echo "contrast_security_credentials_file value:"
#    cat contrast.json
#    cat contrast.json | jq '.'
    echo "Contrast Security credentials file found"
    echo "parsing configuration file and setting to environment variables..."
#    echo "quick test"
#    echo "-----------"
#    cat contrast.json | jq -r '.contrast_api_url'
    echo "mapping..."
    export CONTRAST_API_URL=$(cat contrast.json | jq -r '.contrast_api_url')
    export CONTRAST_API_USERNAME=$(cat contrast.json | jq -r '.contrast_api_username')
    export CONTRAST_API_API_KEY=$(cat contrast.json | jq -r '.contrast_api_api_key')
    export CONTRAST_API_SERVICE_KEY=$(cat contrast.json | jq -r '.contrast_api_service_key')
    export CONTRAST_AGENT_JAVA_STANDALONE_APP_NAME=$(cat contrast.json | jq -r '.contrast_agent_java_standalone_app_name')
    export CONTRAST_APPLICATION_VERSION=$(cat contrast.json | jq -r '.contrast_application_version')
    echo "parsing and mapping complete."
#    echo "removing contrast.json..."
    rm -f contrast.json
    echo "-----------------------------"
fi

# echo "results:"
# echo "contrast-api-url: $CONTRAST_API_URL"
# echo "contrast-api-username: $CONTRAST_API_USERNAME"
# echo "contrast-api-api-key: $CONTRAST_API_API_KEY"
# echo "contrast-api-service-key: $CONTRAST_API_SERICE_KEY"
# echo "contrast-agent-java-standalone-app-name: $CONTRAST_AGENT_JAVA_STANDALONE_APP_NAME"
# echo "contrast-application-version: $CONTRAST_APPLICATION_VERSION"
# echo "---------------------------------"

if [ -z "$AZURE_CREDENTIALS_FILE" ]; then
    printf '%s\n' "No Azure credentials file passed via input." >&2
    exit 1
else
    echo "$AZURE_CREDENTIALS_FILE" >> azure.json
#    echo "azure_credentials_file value:"
#    cat azure.json
#    cat azure.json | jq '.'
    echo "Azure configuration file found"
    echo "parsing configuration file and setting to environment variables..."
#    echo "quick test"
#    echo "-----------"
#    cat azure.json | jq -r '.azure_tenant_id'
    echo "mapping..."
    export AZURE_APPLICATION_ID=$(cat azure.json | jq -r '.azure_application_id')
    export AZURE_TENANT_ID=$(cat azure.json | jq -r '.azure_tenant_id')
    export AZURE_CLIENT_SECRET=$(cat azure.json | jq -r '.azure_client_secret')
    export AZURE_SUBSCRIPTION_ID=$(cat azure.json | jq -r '.azure_subscription_id')
    export AZURE_REGION=$(cat azure.json | jq -r '.azure_region')
    export AZURE_RESOURCE_GROUP_NAME=$(cat azure.json | jq -r '.azure_resource_group_name')
    # export AZURE_SP_SERVICE_NAME=$(cat azure.json | jq -r '.azure_spring_cloud_service_name')
    echo "parsing and mapping complete."
#    echo "removing azure.json..."
    rm -f azure.json
    echo "-----------------------------"
fi

# echo "results:"
# echo "azure-application-id: $AZURE_APPLICATION_ID"
# echo "azure-tenant-id: $AZURE_TENANT_ID"
# echo "azure-client-secret: $AZURE_CLIENT_SECRET"
# echo "azure-subscription-id: $AZURE_SUBSCRIPTION_ID"
# echo "azure-region: $AZURE_REGION"
# echo "azure-resource-group-name: $AZURE_RESOURCE_GROUP_NAME"
# echo "azure-sp-service-name: $AZURE_SP_SERVICE_NAME"
# echo "---------------------------------"

# echo "printing environment variables for testing..."
# printenv
# echo "-------------------------------------------"

# install azure kubernetes service cli
echo "++installing azure kubernetes service cli..."
az aks install-cli;
echo "++successfully installed azure kubernetes service cli"
echo "-------------------------------------------"

# log into azure cli using service principal and secret
echo "++logging into azure cli..."
az login --service-principal -u "${AZURE_APPLICATION_ID}" -p "${AZURE_CLIENT_SECRET}" --tenant "${AZURE_TENANT_ID}"; 
echo "++successfully logged into azure cli"
echo "-------------------------------------------"

# set subscription for cli interaction
echo "++setting subscription to cli interaction..."
az account set --subscription "${AZURE_SUBSCRIPTION_ID}"; 
echo "++successfully set subscription to cli interaction"
echo "-------------------------------------------"

# configure kubectl to connect to AKS cluster
echo "configuring kubectl..."
az aks get-credentials --resource-group <RESOURCE GROUP> --name <AKS CLUSTER NAME>
echo "-------------------------------------------"

# check cluster nodes
echo "checking cluster nodes..."
kubectl get nodes
echo "-------------------------------------------"

# deploy Contrast Security secret
echo "creating Contrast Security secret..."
kubectl apply -f <MANIFEST>
echo "-------------------------------------------"

# update deployment yaml to include volume mount and init container logic
echo "updating deployment manifests..."
# verify that deployment is an application deployment
## if application deployment present, add volume mounts
## check if init container spec is present
### if not, append new
### if so, append to existing 
echo "-------------------------------------------"

# deploy application into the Azure Kubernetes Service platform
echo "deploying application manifests..."
kubectl apply -f <MANIFEST FILES>
echo "successfully deployed application to aks cluster"
echo "-------------------------------------------"

# get application endpoint for kubernetes deployment
echo "retrieving endpoint information..."
AZURE_APPLICATION_URL=$(kubectl describe svc <SERVICE NAME> | grep IP)
echo ${AZURE_APPLICATION_URL}
echo "successfully retrieved endpoint information"
echo "-------------------------------------------"
