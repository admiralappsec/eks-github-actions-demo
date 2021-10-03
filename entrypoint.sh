#!/bin/sh -l

# set -x

AZURE_CREDENTIALS_FILE=${1}
CONTRAST_SECURITY_CREDENTIALS_FILE=${2}
APPLICATION_MANIFESTS=${3}
APPLICATION_DOCKERFILE=${4}
APPLICATION_OUTPUT_IMAGE_NAME_TAG=${5}
CLUSTER_NAME=${6}

# echo "printing environment variables..."
#echo "--------------------------------------------------"
# printenv
#echo "--------------------------------------------------"

# echo "file system..."
# ls -a
echo "creating file locations..."
mkdir /usr/bin/docker-action/application-dockerfile/
mkdir /usr/bin/docker-action/application-manifests/
echo "copying user-defined dockerfile into container filesystem..."
cp /github/workspace/${APPLICATION_DOCKERFILE} /usr/bin/docker-action/application-dockerfile/Dockerfile
echo "entering docker-action directory..."
cp /github/workspace/${APPLICATION_MANIFESTS} /usr/bin/docker-action/application-manifests/deployment.yaml
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
docker build -t docker-action --build-arg contrast_security_credentials_file="$CONTRAST_SECURITY_CREDENTIALS_FILE" --build-arg azure_credentials_file="$AZURE_CREDENTIALS_FILE" --build-arg application_manifests="/usr/bin/docker-action/application-manifests/deployment.yaml" --build-arg application_dockerfile="/usr/bin/docker-action/application-dockerfile/Dockerfile" --build-arg application_output_image_name_tag="$APPLICATION_OUTPUT_IMAGE_NAME_TAG" --build-arg cluster_name="$CLUSTER_NAME". && docker run docker-action
