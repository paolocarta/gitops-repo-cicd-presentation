FROM centos:7.9.2009

# Set the locale(en_US.UTF-8)
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# kubectl
ENV KUBECTL_VERSION v1.26.0

RUN curl -LO https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl && \
    chmod +x kubectl && mv kubectl /usr/local/bin/

ENV HELM3_VERSION v3.11.1
# helm3
RUN curl -L https://get.helm.sh/helm-${HELM3_VERSION}-linux-amd64.tar.gz | tar xzv && \
  mv linux-amd64/helm /usr/bin/helm && \
  rm -rf linux-amd64 && \
  mkdir /usr/bin/helm-bin && \
  ln -s /usr/bin/helm /usr/bin/helm-bin/helm

COPY gcloud-rpm-repo /etc/yum.repos.d/google-cloud-sdk.repo
RUN yum install -y google-cloud-sdk
RUN yum install -y google-cloud-sdk-gke-gcloud-auth-plugin
ENV USE_GKE_GCLOUD_AUTH_PLUGIN=True
