#!/bin/bash

set -x

echo "mapping environment variables to standard outputs..."

export AZURE_ADAL_LOGGING_ENABLED=1
export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
export PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser
export AZURE_APPLICATION_JVM_OPTIONS=$azure_application_jvm_options
export AZURE_CONTRAST_JAVA_AGENT_DOWNLOAD_URL="https://repository.sonatype.org/service/local/artifact/maven/redirect?r=central-proxy&g=com.contrastsecurity&a=contrast-agent&v=LATEST"
export AZURE_FILE_UPLOAD_ARTIFACT_LOCATION="/spring-upload.jar"
export AZURE_APPLICATION_NAME=$azure_application_name
export AZURE_APPLICATION_ARTIFACT_LOCATION=$azure_application_artifact_location

echo "mapping complete."
echo "results:"
echo "azure-adal-logging-enabled: $AZURE_ADAL_LOGGING_ENABLED"
echo "puppeteer-skip-chromium-download: $PUPPETEER_SKIP_CHROMIUM_DOWNLOAD"
echo "puppeteer-executable-path: $PUPPETEER_EXECUTABLE_PATH"
echo "azure-application-jvm-options: $AZURE_APPLICATION_JVM_OPTIONS"
echo "azure-contrast-java-agent-download-url: $AZURE_CONTRAST_JAVA_AGENT_DOWNLOAD_URL"
echo "azure-file-upload-artifact-location: $AZURE_FILE_UPLOAD_ARTIFACT_LOCATION"
echo "azure-application-name: $AZURE_APPLICATION_NAME"
echo "azure-application-name: $AZURE_APPLICATION_NAME"
echo "azure-application-artifact-location: $AZURE_APPLICATION_ARTIFACT_LOCATION"
echo "---------------------------------"

if [ -z "$contrast_security_credentials_file" ]; then
    echo "No Contrast Security configuration file passed via input"
    echo "Using individual inputs as environment variables..."
    export CONTRAST_API_URL=$contrast_api_url
    export CONTRAST_API_USERNAME=$contrast_api_username
    export CONTRAST_API_API_KEY=$contrast_api_api_key
    export CONTRAST_API_SERICE_KEY=$contrast_api_service_key
    export CONTRAST_AGENT_JAVA_STANDALONE_APP_NAME=$contrast_agent_java_standalone_app_name
    export CONTRAST_APPLICATION_VERSION=$contrast_application_version
    echo "environment variable mapping complete."
    echo "-----------------------------"
else
    echo "contrast_security_credentials_file value:"
    $contrast_security_credentials_file | jq '.'
    echo "Contrast Security configuration file found"
    echo "parsing configuration file and setting to environment variables..."
    export CONTRAST_API_URL=$("$contrast_security_credentials_file" | jq '.contrast-api-url')
    export CONTRAST_API_USERNAME=$("$contrast_security_credentials_file" | jq '.contrast-api-username')
    export CONTRAST_API_API_KEY=$("$contrast_security_credentials_file" | jq '.contrast-api-api-key')
    export CONTRAST_API_SERICE_KEY=$("$contrast_security_credentials_file" | jq '.contrast-api-service-key')
    export CONTRAST_AGENT_JAVA_STANDALONE_APP_NAME=$("$contrast_security_credentials_file" | jq '.contrast-agent-java-standalone-app-name')
    export CONTRAST_APPLICATION_VERSION=$("$contrast_security_credentials_file" | jq '.contrast_application_version')
    echo "parsing and mapping complete."
    echo "-----------------------------"
fi

echo "results:"
echo "contrast-api-url: $CONTRAST_API_URL"
echo "contrast-api-username: $CONTRAST_API_USERNAME"
echo "contrast-api-api-key: $CONTRAST_API_API_KEY"
echo "contrast-api-service-key: $CONTRAST_API_SERICE_KEY"
echo "contrast-agent-java-standalone-app-name: $CONTRAST_AGENT_JAVA_STANDALONE_APP_NAME"
echo "contrast-application-version: $CONTRAST_APPLICATION_VERSION"
echo "---------------------------------"

if [ -z "$azure_credentials_file" ]; then
    echo "No Azure configuration file passed via input"
    echo "Using individual inputs as environment variables..."
    export AZURE_APPLICATION_ID=$azure_application_id
    export AZURE_TENANT_ID=$azure_tenant_id
    export AZURE_CLIENT_SECRET=$azure_client_secret
    export AZURE_SUBSCRIPTION_ID=$azure_subscription_id
    export AZURE_REGION=$azure_region
    export AZURE_RESOURCE_GROUP_NAME=$azure_resource_group_name
    export AZURE_SP_SERVICE_NAME=$azure_spring_cloud_service_name
    echo "environment  mapping complete."
    echo "-----------------------------"
else
    echo "azure_credentials_file value:"
    $azure_credentials_file | jq '.'
    echo "Azure configuration file found"
    echo "parsing configuration file and setting to environment variables..."
    export AZURE_APPLICATION_ID=$("$azure_credentials_file" | jq '.azure_application_id')
    export AZURE_TENANT_ID=$("$azure_credentials_file" | jq '.azure_tenant_id')
    export AZURE_CLIENT_SECRET=$("$azure_credentials_file" | jq '.azure_client_secret')
    export AZURE_SUBSCRIPTION_ID=$("$azure_credentials_file" | jq '.azure_subscription_id')
    export AZURE_REGION=$("$azure_credentials_file" | jq '.azure_region')
    export AZURE_RESOURCE_GROUP_NAME=$("$azure_credentials_file" | jq '.azure_resource_group_name')
    export AZURE_SP_SERVICE_NAME=$("$azure_credentials_file" | jq '.azure_spring_cloud_service_name')
    echo "parsing and mapping complete."
    echo "-----------------------------"
fi

echo "results:"
echo "azure-application-id: $AZURE_APPLICATION_ID"
echo "azure-tenant-id: $AZURE_TENANT_ID"
echo "azure-client-secret: $AZURE_CLIENT_SECRET"
echo "azure-subscription-id: $AZURE_SUBSCRIPTION_ID"
echo "azure-region: $AZURE_REGION"
echo "azure-resource-group-name: $AZURE_RESOURCE_GROUP_NAME"
echo "azure-sp-service-name: $AZURE_SP_SERVICE_NAME"
echo "---------------------------------"

echo "printing environment variables for testing..."
printenv
echo "-------------------------------------------"

# install spring-cloud extension into azure cli
echo "++installing azure spring-cloud extension into azure cli..."
az extension add --name spring-cloud;
echo "++successfully installed spring-cloud extension"
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

# configure default resource group for spring cloud interaction on cli
echo "setting default resource group for spring cloud interaction..."
az configure --defaults group="${AZURE_RESOURCE_GROUP_NAME}" spring-cloud="${AZURE_SP_SERVICE_NAME}"; 
echo "successfully set default resource group for spring cloud interaction"
echo "-------------------------------------------"

# create spring cloud application and assign specs
echo "creating spring cloud application..."
# az spring-cloud app create --name "${AZURE_APPLICATION_NAME}" --service "${AZURE_SP_SERVICE_NAME}" -g ${AZURE_RESOURCE_GROUP_NAME} --instance-count 1 --is-public true --memory 2 --jvm-options='-Xms2048m -Xmx2048m' --enable-persistent-storage true --assign-endpoint;
az spring-cloud app create --name "${AZURE_APPLICATION_NAME}" --instance-count 1 --is-public true --memory 2 --jvm-options='-Xms2048m -Xmx2048m' --enable-persistent-storage true
echo "successfully created spring cloud application"
echo "-------------------------------------------"

# deploy sample file-upload jar into the Azure Spring Cloud application
echo "deploying sample file-upload jar..."
az spring-cloud app deploy --name "${AZURE_APPLICATION_NAME}" --jar-path "${AZURE_FILE_UPLOAD_ARTIFACT_LOCATION}" --verbose
echo "successfully deployed sample file-upload jar"
echo "-------------------------------------------"

# get application endpoint for jar upload
echo "retrieving endpoint information..."
AZURE_APPLICATION_URL="https://${AZURE_SP_SERVICE_NAME}-${AZURE_APPLICATION_NAME}.azuremicroservices.io"
echo ${AZURE_APPLICATION_URL}
echo "successfully retrieved endpoint information"
echo "-------------------------------------------"

# download constrast security jar file
echo "downloading contrast security java agent jar file..."
curl -L "${AZURE_CONTRAST_JAVA_AGENT_DOWNLOAD_URL}" -o contrast.jar
echo "successfully downloaded contrast security java agent jar file"
echo "-------------------------------------------"

# upload contrast Security jar file into application using file-upload jar - script in the /artifacts directory
# this is where the nodejs puppeteer script runs
echo "running puppet-upload.js script..."
node puppet-upload.js --url "${AZURE_APPLICATION_URL}" --headless false --contrast-upload-file 'contrast.jar'
echo "puppet-upload.js script successfully completed."
echo "-------------------------------------------"

# wait for script to complete - 10 seconds
echo "waiting for 10 seconds..."
sleep 10s;
echo "sleep concluded. continue processing..."
echo "------------------------------------------"

# deploy sample file-upload jar into the Azure Spring Cloud application
echo "deploying application jar..."
az spring-cloud app deploy --name ${AZURE_APPLICATION_NAME} --jar-path ${AZURE_APPLICATION_ARTIFACT_LOCATION} --jvm-options=${AZURE_APPLICATION_JVM_OPTIONS} --env CONTRAST__API__URL=${CONTRAST_API_URL} CONTRAST__API__USER_NAME=${CONTRAST_API_USERNAME} CONTRAST__API__API_KEY=${CONTRAST_API_API_KEY} CONTRAST__API__SERVICE_KEY=${CONTRAST_API_SERVICE_KEY} CONTRAST__AGENT__JAVA__STANDALONE_APP_NAME=${CONTRAST_AGENT_JAVA_STANDALONE_APP_NAME} CONTRAST__APPLICATION__VERSION=${CONTRAST_APPLICATION_VERSION} CONTRAST__AGENT__LOGGER__STDERR=true --verbose
echo "successfully deployed application jar"
echo "-------------------------------------------"

# get application endpoint for jar upload
echo "retrieving endpoint information..."
#az spring-cloud app show --name "${AZURE_APPLICATION_NAME}" | grep url
echo ${AZURE_APPLICATION_URL}
echo "successfully retrieved endpoint information"
echo "-------------------------------------------" 
