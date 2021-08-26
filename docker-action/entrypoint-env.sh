#!/usr/bin/env sh

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
