# Container image that runs your code
FROM alpine:latest

#ARG AZURE_APPLICATION_ARTIFACT_LOCATION=${3}

#ENV DEPLOYABLE_ARTIFACT 

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY docker-action /usr/bin/docker-action
COPY entrypoint.sh /usr/bin/entrypoint.sh
#COPY $AZURE_APPLICATION_ARTIFACT_LOCATION /usr/bin/docker-action/application-artifact.jar

#RUN echo "$AZURE_APPLICATION_ARTIFACT_LOCATION ---"
#RUN cd /usr/bin/docker-action && ls -l
RUN apk add --update --no-cache docker
RUN ["chmod", "+x", "/usr/bin/entrypoint.sh"]

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/usr/bin/entrypoint.sh"]
