FROM mcr.microsoft.com/azure-cli

ARG contrast_security_credentials_file
ARG azure_credentials_file
ARG application_manifests
ARG application_dockerfile
ARG application_output_image_name_tag
ARG cluster_name

ENV APPLICATION_MANIFESTS ${application_manifests}   
ENV CONTRAST_SECURITY_CREDENTIALS_FILE ${contrast_security_credentials_file}
ENV AZURE_CREDENTIALS_FILE ${azure_credentials_file}
ENV APPLICATION_DOCKERFILE ${application_dockerfile}
ENV APPLICATION_OUTPUT_IMAGE_NAME_TAG ${application_output_image_name_tag}
ENV CLUSTER_NAME ${cluster_name}

RUN apk update && apk add --no-cache sed docker

COPY entrypoint-az.sh /entrypoint.sh
COPY /application-dockerfile/Dockerfile /Dockerfile
COPY /application-manifests/deployment.yaml /deployment.yaml
COPY contrast_security.yaml /contrast_security.yaml

ENTRYPOINT ["/entrypoint.sh"]
