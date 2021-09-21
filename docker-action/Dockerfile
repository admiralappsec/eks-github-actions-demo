FROM mcr.microsoft.com/azure-cli

ARG contrast_security_credentials_file
ARG azure_credentials_file
ARG application_manifests

ENV APPLICATION_MANIFESTS ${application_manifests}   
ENV CONTRAST_SECURITY_CREDENTIALS_FILE ${contrast_security_credentials_file}
ENV AZURE_CREDENTIALS_FILE ${azure_credentials_file}

COPY entrypoint-az.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
