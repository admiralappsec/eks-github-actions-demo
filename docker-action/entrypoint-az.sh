#!/bin/bash

set -x

printenv

echo "creating environment variables from constants..."
export AZURE_ADAL_LOGGING_ENABLED=1
export AZURE_CONTRAST_JAVA_AGENT_DOWNLOAD_URL="https://repository.sonatype.org/service/local/artifact/maven/redirect?r=central-proxy&g=com.contrastsecurity&a=contrast-agent&v=LATEST"
echo "-------------------------------------------"

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
    export AZURE_CONTAINER_REGISTRY=$(cat azure.json | jq -r '.azure_container_registry')
    export AZURE_TENANT_ID=$(cat azure.json | jq -r '.azure_tenant_id')
    export AZURE_CLIENT_SECRET=$(cat azure.json | jq -r '.azure_client_secret')
    export AZURE_SUBSCRIPTION_ID=$(cat azure.json | jq -r '.azure_subscription_id')
    export AZURE_REGION=$(cat azure.json | jq -r '.azure_region')
    export AZURE_RESOURCE_GROUP_NAME=$(cat azure.json | jq -r '.azure_resource_group_name')
    export AZURE_APPLICATION_ID=$(cat azure.json | jq -r '.azure_application_id')
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

#if [ -z "$APPLICATION_DOCKERFILE" ]; then
#    printf '%s\n' "No Dockerfile passed via input." >&2
#    exit 1
#fi

if [ -z "$APPLICATION_OUTPUT_IMAGE_NAME_TAG" ]; then
    printf '%s\n' "No docker image name/tag passed via input. Exiting..." >&2
    exit 1
fi

if [ -z "$APPLICATION_MANIFESTS" ]; then
    printf '%s\n' "No kubernetes application manifests passed via input. Exiting..." >&2
    exit 1
fi

# echo "printing environment variables for testing..."
# printenv
# echo "-------------------------------------------"

echo "file system contents..."
cd /opt
ls -l
cat Dockerfile

# docker build using passed application dockerfile and image name/tag
echo "++application docker build started..."
docker build -t application-docker-image .
echo "++application docker build successfully completed."
echo "-------------------------------------------"

# download Contrast Security java agent
echo "++downloading contrast security java agent..."
curl -L "${AZURE_CONTRAST_JAVA_AGENT_DOWNLOAD_URL}" -o contrast.jar
echo "++successfully downloaded contrast security java agent."
echo "-------------------------------------------"

# inject contrast agent into new application image
echo "running container image..."
RUNNING_CONTAINER_ID=$(docker run -d application-docker-image)
echo "waiting 5 seconds..."
sleep 5
docker ps
echo "creating directory inside running container..."
docker exec -i $RUNNING_CONTAINER_ID mkdir /opt/contrast
echo "injecting contrast security agent jar..."
docker cp contrast.jar $RUNNING_CONTAINER_ID:/opt/contrast/
echo "verifying file copy..."
docker exec -w /opt/contrast $RUNNING_CONTAINER_ID ls -l
echo "-------------------------------------------"

# create image from running container
echo "creating container image from running container..."
docker commit $RUNNING_CONTAINER_ID ${AZURE_CONTAINER_REGISTRY}/${APPLICATION_OUTPUT_IMAGE_NAME_TAG}
echo "verifying local docker image..."
docker images
echo "-------------------------------------------"

# docker login to container registry url
echo "logging into container registry..."
docker login ${AZURE_CONTAINER_REGISTRY} -u ${AZURE_APPLICATION_ID} -p ${AZURE_CLIENT_SECRET} 
echo "successfully logged into container registry."
echo "-------------------------------------------"

# docker push to registry url
echo "pushing image to container registry..."
docker push ${AZURE_CONTAINER_REGISTRY}/${APPLICATION_OUTPUT_IMAGE_NAME_TAG}
echo "successfully pushed container image to registry."
echo "-------------------------------------------"

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
az aks get-credentials --resource-group ${AZURE_RESOURCE_GROUP_NAME} --name ${CLUSTER_NAME}
echo "-------------------------------------------"

# check cluster nodes
echo "checking cluster nodes..."
kubectl get nodes
kubectl get deployments
echo "-------------------------------------------"

# deploy Contrast Security secret
echo "++replacing secret file placeholders with inputs from user..."
sed -i "s|__CONTRAST_TEAM_SERVER_URL__|${CONTRAST_API_URL}|g" contrast_security.yaml
sed -i "s|__API_KEY__|${CONTRAST_API_API_KEY}|g" contrast_security.yaml
sed -i "s|__SERVICE_KEY__|${CONTRAST_API_SERVICE_KEY}|g" contrast_security.yaml
sed -i "s|__CONTRAST_TEAM_USERNAME__|${CONTRAST_API_USERNAME}|g" contrast_security.yaml
echo "++contrast_security.yaml contents:"
echo "--------------------------------------------"
cat contrast_security.yaml
echo "--------------------------------------------"
echo "++creating Contrast Security secret from file..."
kubectl delete secret contrast-security
kubectl create secret generic contrast-security --from-file=./contrast_security.yaml
echo "++successfully created Contrast Security secret"
echo "-------------------------------------------"

# deploy application into the Azure Kubernetes Service platform
echo "++deploying application manifests..."
startDeploy='deployment.apps/'
endSD=' '
startService='service/'
KUBECTL_RESULTS=$(kubectl apply -f '/opt/deployment.yaml')
DEPLOYMENT_NAME=$(awk '$0=$2' FS="$startDeploy" RS="$endSD" <<< "$KUBECTL_RESULTS")
SERVICE_NAME=$(awk '$0=$2' FS="$startService" RS="$endSD"  <<< "$KUBECTL_RESULTS")
kubectl describe deployments $DEPLOYMENT_NAME
kubectl get deployment $DEPLOYMENT_NAME -o=jsonpath="{range .items[*]}{'\n'}{.metadata.name}{':\t'}{range .spec.template.spec.containers[*]}{.image}{', '}{end}{end}"
echo "++successfully deployed application to aks cluster"
echo "-------------------------------------------"

# update deployment with secret/environment variables and updated image
echo "updating deployment $DEPLOYMENT_NAME with image..."
kubectl set image deployment/$DEPLOYMENT_NAME $DEPLOYMENT_NAME=${AZURE_CONTAINER_REGISTRY}/${APPLICATION_OUTPUT_IMAGE_NAME_TAG} --record
kubectl rollout status deployment $DEPLOYMENT_NAME
kubectl get deployments
echo "++updated deployment $DEPLOYMENT_NAME image to ${AZURE_CONTAINER_REGISTRY}/${APPLICATION_OUTPUT_IMAGE_NAME_TAG}"
echo "-------------------------------------------"

# get application endpoint for kubernetes deployment
echo "++retrieving endpoint information..."
AZURE_APPLICATION_URL=$(kubectl describe svc $SERVICE_NAME | grep IP)
echo ${AZURE_APPLICATION_URL}
echo "++successfully retrieved endpoint information"
echo "-------------------------------------------"
