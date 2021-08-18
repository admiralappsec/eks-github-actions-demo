#!/bin/sh -l

AZURE_APPLICATION_NAME=${1}
AZURE_SPRING_CLOUD_SERVICE_NAME=${2}
AZURE_FILE_UPLOAD_ARTIFACT_LOCATION=${3}
AZURE_APPLICATION_ARTIFACT_LOCATION=${4}
AZURE_APPLICATION_ID=${5}
AZURE_TENANT_ID=${6}
AZURE_CLIENT_SECRET=${7}
AZURE_SUBSCRIPTION_ID=${8}
AZURE_RESOURCE_GROUP_NAME=${9}
AZURE_REGION=${10}
AZURE_CONTRAST_AGENT_DOWNLOAD_URL=${11}
CONTRAST_API_URL=${12}
CONTRAST_API_USERNAME=${13}
CONTRAST_API_API_KEY=${14}
CONTRAST_API_SERVICE_KEY=${15}
CONTRAST_APPLICATION_NAME=${16}
CONTRAST_AGENT_JAVA_STANDALONE_APP_NAME=${17}
CONTRAST_APPLICATION_VERSION=${18}
CONTRAST_SERVER_NAME=${19}
AZURE_APPLICATION_JVM_OPTIONS=${20}

cd /docker-action
echo "creating docker image with the following inputs..."

echo "azure-application-name: $AZURE_APPLICATION_NAME"
echo "azure-spring-cloud-service-name: $AZURE_SPRING_CLOUD_SERVICE_NAME"
echo "azure-file-upload-artifact-location: $AZURE_FILE_UPLOAD_ARTIFACT_LOCATION"
echo "azure-application-artifact-location: $AZURE_APPLICATION_ARTIFACT_LOCATION"
echo "azure-application-id: $AZURE_APPLICATION_ID"
echo "azure-tenant-id: $AZURE_TENANT_ID"
echo "azure-client-secret: $AZURE_CLIENT_SECRET"
echo "azure-subscription-id: $AZURE_SUBSCRIPTION_ID"
echo "azure-resource-group-name: $AZURE_RESOURCE_GROUP_NAME"
echo "azure-region: $AZURE_REGION"
echo "azure-contrast-agent-download-url: $AZURE_CONTRAST_AGENT_DOWNLOAD_URL"
echo "contrast-api-url: $CONTRAST_API_URL"
echo "contrast-api-username: $CONTRAST_API_USERNAME"
echo "contrast-api-api-key: $CONTRAST_API_API_KEY"
echo "contrast-api-service-key: $CONTRAST_API_SERVICE_KEY"
echo "contrast-application-name: $CONTRAST_APPLICATION_NAME"
echo "contrast-agent-java-standalone-app-name: $CONTRAST_AGENT_JAVA_STANDALONE_APP_NAME"
echo "contrast-application-version: $CONTRAST_APPLICATION_VERSION"
echo "contrast-server-name: $CONTRAST_SERVER_NAME"
echo "azure-application-jvm-options: $AZURE_APPLICATION_JVM_OPTIONS"

# here we can make the construction of the image as customizable as we need
# and if we need parameterizable values it is a matter of sending them as inputs
docker build -t docker-action --build-arg azure_application_name="$AZURE_APPLICATION_NAME" --build-arg azure_spring_cloud_service_name="$AZURE_SPRING_CLOUD_SERVICE_NAME" --build-arg azure_file_upload_artifact_location="$AZURE_FILE_UPLOAD_ARTIFACT_LOCATION" --build-arg azure_application_artifact_location="$AZURE_APPLICATION_ARTIFACT_LOCATION" --build-arg azure_application_id="$AZURE_APPLICATION_ID" --build-arg azure_tenant_id="$AZURE_TENANT_ID" --build-arg azure_client_secret="$AZURE_CLIENT_SECRET" --build-arg azure_subscription_id="$AZURE_SUBSCRIPTION_ID" --build-arg azure_resource_group_name="$AZURE_RESOURCE_GROUP_NAME" --build-arg azure_region="$AZURE_REGION" --build-arg azure_contrast_agent_download_url="$AZURE_CONTRAST_AGENT_DOWNLOAD_URL" --build-arg contrast-api-url="$CONTRAST_API_URL" --build-arg contrast-api-user-name="$CONTRAST_API_USER_NAME" --build-arg contrast-api-api-key="$CONTRAST_API_API_KEY" --build-arg contrast-api-service-key="$CONTRAST_API_SERVICE_KEY" --build-arg contrast-application-name="$CONTRAST_APPLICATION_NAME" --build-arg contrast-agent-java-standalone-app-name="$CONTRAST_AGENT_JAVA_STANDALONE_APP_NAME" --build-arg contrast-application-version="$CONTRAST_APPLICATION_VERSION" --build-arg contrast-server-name="$CONTRAST_SERVER_NAME" --build-arg contrast-agent-logger-stderr=true --build-arg azure-application-jvm-options="$AZURE_APPLICATION_JVM_OPTIONS" . && docker run docker-action
