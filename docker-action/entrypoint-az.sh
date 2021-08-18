#!/bin/bash

set -x

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
#AZURE_APPLICATION_URL=$(az spring-cloud app show --name "${AZURE_APPLICATION_NAME}" | grep -o '"url": *"[^"]*' test.txt | grep -o '[^"]*$'
AZURE_APPLICATION_URL="https://${AZURE_SP_SERVICE_NAME}-${AZURE_APPLICATION_NAME}.azuremicroservices.io"
echo ${AZURE_APPLICATION_URL}
echo "successfully retrieved endpoint information"
echo "-------------------------------------------"

# download constrast security jar file
echo "downloading contrast security java agent jar file..."
curl "${AZURE_CONTRAST_JAVA_AGENT_DOWNLOAD_URL}" --output contrast.jar
echo "successfully downloaded contrast security java agent jar file"
ls -a
pwd
echo "-------------------------------------------"

# upload contrast Security jar file into application using file-upload jar - script in the /artifacts directory
# this is where the nodejs puppeteer script runs
echo "running puppet-upload.js script..."
node puppet-upload.js --url "${AZURE_APPLICATION_URL}" --headless false --contrast-upload-file 'contrast.jar'
echo "puppet-upload.js script successfully completed."

# deploy sample file-upload jar into the Azure Spring Cloud application
echo "deploying application jar..."
# az spring-cloud app deploy --name "${AZURE_APPLICATION_NAME}" --jar-path "${AZURE_FILE_UPLOAD_ARTIFACT_LOCATION}"
az spring-cloud app deploy --name ${AZURE_APPLICATION_NAME} \ 
  --jar-path ${AZURE_APPLICATION_ARTIFACT_LOCATION} \ 
  --jvm-options=${AZURE_APPLICATION_JVM_OPTIONS} \ 
  --env CONTRAST_API_URL=${CONTRAST_API_URL} CONTRAST_API_USER_NAME=${CONTRAST_API_USER_NAME} CONTRAST_API_API_KEY=${CONTRAST_API_API_KEY} CONTRAST_API_SERVICE_KEY=${CONTRAST_API_SERVICE_KEY} CONTRAST_APPLICATION_NAME=${CONTRAST_APPLICATION_NAME} CONTRAST_AGENT_JAVA_STANDALONE_APP_NAME=${CONTRAST_AGENT_JAVA_STANDALONE_APP_NAME} CONTRAST_APPLICATION_VERSION=${CONTRAST_APPLICATION_VERSION} CONTRAST_SERVER_NAME=${CONTRAST_SERVER_NAME} CONTRAST_AGENT_LOGGER_STDERR=true
echo "successfully deployed application jar"
echo "-------------------------------------------"

# get application endpoint for jar upload
echo "retrieving endpoint information..."
#az spring-cloud app show --name "${AZURE_APPLICATION_NAME}" | grep url
#AZURE_APPLICATION_URL2=$(az spring-cloud app show --name "${AZURE_APPLICATION_NAME}" | grep -o '"url": *"[^"]*' test.txt | grep -o '[^"]*$'
echo ${AZURE_APPLICATION_URL}
echo "successfully retrieved endpoint information"
echo "-------------------------------------------" 
