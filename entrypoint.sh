#!/bin/sh -l

set -x

AZURE_APPLICATION_NAME=${1}
AZURE_SPRING_CLOUD_SERVICE_NAME=${2}
AZURE_APPLICATION_ARTIFACT_LOCATION=${3}
#AZURE_APPLICATION_ARTIFACT_LOCATION='/usr/bin/docker-action/application-artifact.jar'
AZURE_APPLICATION_ID=${4}
AZURE_TENANT_ID=${5}
AZURE_CLIENT_SECRET=${6}
AZURE_SUBSCRIPTION_ID=${7}
AZURE_RESOURCE_GROUP_NAME=${8}
AZURE_REGION=${9}
CONTRAST_API_URL=${10}
CONTRAST_API_USERNAME=${11}
CONTRAST_API_API_KEY=${12}
CONTRAST_API_SERVICE_KEY=${13}
CONTRAST_AGENT_JAVA_STANDALONE_APP_NAME=${14}
CONTRAST_APPLICATION_VERSION=${15}
AZURE_APPLICATION_JVM_OPTIONS=${16}
AZURE_CREDENTIALS_FILE=${17}
CONTRAST_SECURITY_CREDENTIALS_FILE=${18}
GITHUB_DEVELOPER_TOKEN=${19}
GITHUB_USER_REPO=$GITHUB_REPOSITORY
GITHUB_DEVELOPER_BRANCH=${20}
APPLICATION_MEMORY=${21}
APPLICATION_INSTANCE_COUNT=${22}

# echo "printing environment variables..."
# printenv

# echo "file system..."
# ls -a
echo "see what is inside the working directory..."
cd /home/runner/work/workshop-testing/workshop-testing/target
ls -l
echo "copying input file from host into container file system..."
cp $AZURE_APPLICATION_ARTIFACT_LOCATION /usr/bin/docker-action/application-artifact.jar
echo "entering docker-action directory..."
cd /usr/bin/docker-action
echo "what is inside..."
ls -l
#echo "creating docker image with the following inputs..."

#echo "azure-application-name: $AZURE_APPLICATION_NAME"
#echo "azure-spring-cloud-service-name: $AZURE_SPRING_CLOUD_SERVICE_NAME"
echo "azure-application-artifact-location: $AZURE_APPLICATION_ARTIFACT_LOCATION"
#echo "azure-application-id: $AZURE_APPLICATION_ID"
#echo "azure-tenant-id: $AZURE_TENANT_ID"
#echo "azure-client-secret: $AZURE_CLIENT_SECRET"
#echo "azure-subscription-id: $AZURE_SUBSCRIPTION_ID"
#echo "azure-resource-group-name: $AZURE_RESOURCE_GROUP_NAME"
#echo "azure-region: $AZURE_REGION"
#echo "contrast-api-url: $CONTRAST_API_URL"
#echo "contrast-api-username: $CONTRAST_API_USERNAME"
#echo "contrast-api-api-key: $CONTRAST_API_API_KEY"
#echo "contrast-api-service-key: $CONTRAST_API_SERVICE_KEY"
#echo "contrast-agent-java-standalone-app-name: $CONTRAST_AGENT_JAVA_STANDALONE_APP_NAME"
#echo "contrast-application-version: $CONTRAST_APPLICATION_VERSION"
#echo "azure-application-jvm-options: $AZURE_APPLICATION_JVM_OPTIONS"
#echo "contrast-security-credentials-file: $CONTRAST_SECURITY_CREDENTIALS_FILE"
#echo "azure-credentials-file: $AZURE_CREDENTIALS_FILE"
#echo "github-developer-token: $GITHUB_DEVELOPER_TOKEN"
#echo "github-user-repo: $GITHUB_USER_REPO"
#echo "github-developer-branch: $GITHUB_DEVELOPER_BRANCH"
#echo "application-memory: $APPLICATION_MEMORY"
#echo "application-instance-count: $APPLICATION_INSTANCE_COUNT"

# here we can make the construction of the image as customizable as we need
# and if we need parameterizable values it is a matter of sending them as inputs
docker build -t docker-action --build-arg azure_application_name="$AZURE_APPLICATION_NAME" --build-arg azure_spring_cloud_service_name="$AZURE_SPRING_CLOUD_SERVICE_NAME" --build-arg azure_application_artifact_location="$AZURE_APPLICATION_ARTIFACT_LOCATION" --build-arg azure_application_id="$AZURE_APPLICATION_ID" --build-arg azure_tenant_id="$AZURE_TENANT_ID" --build-arg azure_client_secret="$AZURE_CLIENT_SECRET" --build-arg azure_subscription_id="$AZURE_SUBSCRIPTION_ID" --build-arg azure_resource_group_name="$AZURE_RESOURCE_GROUP_NAME" --build-arg azure_region="$AZURE_REGION" --build-arg contrast_api_url="$CONTRAST_API_URL" --build-arg contrast_api_username="$CONTRAST_API_USERNAME" --build-arg contrast_api_api_key="$CONTRAST_API_API_KEY" --build-arg contrast_api_service_key="$CONTRAST_API_SERVICE_KEY" --build-arg contrast_agent_java_standalone_app_name="$CONTRAST_AGENT_JAVA_STANDALONE_APP_NAME" --build-arg contrast_application_version="$CONTRAST_APPLICATION_VERSION" --build-arg azure_application_jvm_options="$AZURE_APPLICATION_JVM_OPTIONS" --build-arg contrast_security_credentials_file="$CONTRAST_SECURITY_CREDENTIALS_FILE" --build-arg azure_credentials_file="$AZURE_CREDENTIALS_FILE" --build-arg github_developer_token="$GITHUB_DEVELOPER_TOKEN" --build-arg github_user_repo="$GITHUB_USER_REPO" --build-arg github_developer_branch="$GITHUB_DEVELOPER_BRANCH" --build-arg application_memory="$APPLICATION_MEMORY" --build-arg application_instance_count="$APPLICATION_INSTANCE_COUNT" . && docker run docker-action
