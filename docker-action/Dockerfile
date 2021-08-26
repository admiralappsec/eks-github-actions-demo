FROM mcr.microsoft.com/azure-cli

ARG azure_application_id
ARG azure_tenant_id
ARG azure_client_secret
ARG azure_subscription_id
ARG azure_region
ARG azure_resource_group_name
ARG azure_spring_cloud_service_name
ARG azure_application_name
ARG azure_file_upload_artifact_location
ARG azure_application_artifact_location
ARG contrast_api_url
ARG contrast_api_username
ARG contrast_api_api_key
ARG contrast_api_service_key
ARG contrast_agent_java_standalone_app_name
ARG contrast_application_version
ARG azure_application_jvm_options
ARG contrast_security_credentials_file
ARG azure_credentials_file

# ENV AZURE_ADAL_LOGGING_ENABLED=1
# ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
# ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser
# ENV AZURE_APPLICATION_JVM_OPTIONS ${azure_application_jvm_options}
# ENV AZURE_CONTRAST_JAVA_AGENT_DOWNLOAD_URL "https://repository.sonatype.org/service/local/artifact/maven/redirect?r=central-proxy&g=com.contrastsecurity&a=contrast-agent&v=LATEST"
# ENV AZURE_FILE_UPLOAD_ARTIFACT_LOCATION "/spring-upload.jar"
# ENV AZURE_APPLICATION_NAME ${azure_application_name}        
# ENV AZURE_APPLICATION_ARTIFACT_LOCATION ${azure_application_artifact_location}

# ENV AZURE_APPLICATION_ID ${azure_application_id} 
# ENV AZURE_TENANT_ID ${azure_tenant_id} 
# ENV AZURE_CLIENT_SECRET ${azure_client_secret} 
# ENV AZURE_SUBSCRIPTION_ID ${azure_subscription_id} 
# ENV AZURE_REGION ${azure_region} 
# ENV AZURE_RESOURCE_GROUP_NAME ${azure_resource_group_name} 
# ENV AZURE_SP_SERVICE_NAME ${azure_spring_cloud_service_name}  
# ENV CONTRAST_API_URL ${contrast_api_url} 
# ENV CONTRAST_API_USERNAME ${contrast_api_username} 
# ENV CONTRAST_API_API_KEY ${contrast_api_api_key} 
# ENV CONTRAST_API_SERVICE_KEY ${contrast_api_service_key}  
# ENV CONTRAST_AGENT_JAVA_STANDALONE_APP_NAME ${contrast_agent_java_standalone_app_name} 
# ENV CONTRAST_APPLICATION_VERSION ${contrast_application_version} 

COPY entrypoint-env.sh /entrypoint-env.sh
COPY entrypoint-az.sh /entrypoint.sh
COPY file-demo-0.0.1-SNAPSHOT.jar /spring-upload.jar
COPY package.json /package.json
COPY puppet-upload.js /puppet-upload.js
COPY ${AZURE_APPLICATION_ARTIFACT_LOCATION} ${AZURE_APPLICATION_ARTIFACT_LOCATION}

RUN apk update && apk add --no-cache nodejs npm jq chromium nss freetype harfbuzz ca-certificates ttf-freefont && npm install
RUN ["chmod", "+x", "/entrypoint-env.sh"]
RUN ./entrypoint-env.sh

ENTRYPOINT ["/entrypoint.sh"]

#FROM node:current-alpine3.11 AS upload_contrast_jar

#RUN \
#  apk update && \
#  apk add nodejs npm

#WORKDIR /usr/app

#COPY puppet-upload.js /usr/app/entrypoint.js
#COPY package.json /usr/app/package.json

#RUN npm install

#ENTRYPOINT ["node", "/usr/app/entrypoint.js"]

#FROM create_deploy1 AS redeploy_with_application_artifact

#COPY entrypoint-azB.sh /entrypoint.sh

#ENTRYPOINT ["/entrypoint.sh"]
