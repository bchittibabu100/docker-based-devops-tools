#Installing most commonly used tools
FROM python:3.11-slim

ENV TERRAFORM_VERSION=1.6.4
ENV HELM_VERSION=3.7.0
ENV KUBECTL_VERSION=1.28.4

# Set the working directory in the container
WORKDIR /app

# Install necessary dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    unzip \
    bash \
    bash-completion \
    docker \
    git \
    zip \
    gzip \
    wget \
    ca-certificates \
    jq \
    openssl \
    vim \
    && rm -rf /var/lib/apt/lists/*

# Install AWS CLI v2
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf awscliv2.zip

# Download and install Terraform
RUN curl -o terraform.zip "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" && \
    unzip terraform.zip -d /usr/local/bin && \
    rm terraform.zip

# Install kubectl
RUN curl -LO "https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl" && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin/kubectl

# Install Helm
RUN curl -LO "https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz" && \
    tar -zxvf "helm-v${HELM_VERSION}-linux-amd64.tar.gz" && \
    mv linux-amd64/helm /usr/local/bin/helm && \
    rm -rf "helm-v${HELM_VERSION}-linux-amd64.tar.gz" linux-amd64

# Verify installations
RUN python --version && \
    aws --version && \
    helm version --client && \
    kubectl version --client && \
    terraform --version

#Expose for kubectl proxy
EXPOSE 8001

# Mounting local workstation aws and kubernetes config files into the container
RUN printf "export AWS_CONFIG_FILE=/data/.aws/config\n\
export AWS_SHARED_CREDENTIALS_FILE=/data/.aws/credentials\n\
export KUBECONFIG=/data/.kube/config\n\
source <(kubectl completion bash)\n\
source /etc/profile.d/bash_completion.sh\n\
alias k=kubectl" >> ~/.bashrc

CMD ["bash"]