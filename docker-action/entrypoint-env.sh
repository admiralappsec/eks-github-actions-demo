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

echo $AZURE_ADAL_LOGGING_ENABLED
echo $PUPPETEER_SKIP_CHROMIUM_DOWNLOAD
echo $PUPPETEER_EXECUTABLE_PATH
echo $AZURE_APPLICATION_JVM_OPTIONS
echo $AZURE_CONTRAST_JAVA_AGENT_DOWNLOAD_URL
echo $AZURE_FILE_UPLOAD_ARTIFACT_LOCATION
echo $AZURE_APPLICATION_NAME
echo $AZURE_APPLICATION_NAME
echo $AZURE_APPLICATION_ARTIFACT_LOCATION

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
    echo "contrast-api-url: $CONTRAST_API_URL"
    echo "contrast-api-username: $CONTRAST_API_USERNAME"
    echo "contrast-api-api-key: $CONTRAST_API_API_KEY"
    echo "contrast-api-service-key: $CONTRAST_API_SERICE_KEY"
    echo "contrast-agent-java-standalone-app-name: $CONTRAST_AGENT_JAVA_STANDALONE_APP_NAME"
    echo "contrast-application-version: $CONTRAST_APPLICATION_VERSION"
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
    echo "contrast-api-url: $CONTRAST_API_URL"
    echo "contrast-api-username: $CONTRAST_API_USERNAME"
    echo "contrast-api-api-key: $CONTRAST_API_API_KEY"
    echo "contrast-api-service-key: $CONTRAST_API_SERICE_KEY"
    echo "contrast-agent-java-standalone-app-name: $CONTRAST_AGENT_JAVA_STANDALONE_APP_NAME"
    echo "contrast-application-version: $CONTRAST_APPLICATION_VERSION"
    echo "-----------------------------"
fi

echo "---------------------------------"
