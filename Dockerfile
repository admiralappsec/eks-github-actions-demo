# Container image that runs your code
FROM alpine:latest

ARG azure_application_artifact_location ${3}

ENV AZURE_APPLICATION_ARTIFACT_LOCATION ${azure_application_artifact_location}

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY docker-action /docker-action
COPY entrypoint.sh /entrypoint.sh
COPY ${AZURE_APPLICATION_ARTIFACT_LOCATION} /docker-action/application-artifact.jar

#WORKDIR /docker-action

RUN apk add --update --no-cache docker
RUN ["chmod", "+x", "/entrypoint.sh"]

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]
