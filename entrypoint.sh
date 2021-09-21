#!/bin/sh -l

# set -x

AZURE_CREDENTIALS_FILE=${1}
CONTRAST_SECURITY_CREDENTIALS_FILE=${2}
APPLICATION_MANIFESTS=${3}

# echo "printing environment variables..."
#echo "--------------------------------------------------"
# printenv
#echo "--------------------------------------------------"

# echo "file system..."
# ls -a
echo "entering docker-action directory..."
cd /usr/bin/docker-action
# echo "what is inside..."
# ls -l

#echo "creating docker image with the following inputs..."
#echo "--------------------------------------------------"
#echo "azure-credentials-file: $AZURE_CREDENTIALS_FILE"
#echo "contrast-security-credentials-file: $CONTRAST_SECURITY_CREDENTIALS_FILE"
#echo "azure-application-name: $APPLICATION_MANIFESTS"
#echo "--------------------------------------------------"

echo "running docker build with passed arguments..."
#echo "--------------------------------------------------"

# here we can make the construction of the image as customizable as we need
# and if we need parameterizable values it is a matter of sending them as inputs
docker build -t docker-action --build-arg contrast_security_credentials_file="$CONTRAST_SECURITY_CREDENTIALS_FILE" --build-arg azure_credentials_file="$AZURE_CREDENTIALS_FILE" --build-arg application_manifests="$APPLICATION_MANIFESTS" . && docker run docker-action
