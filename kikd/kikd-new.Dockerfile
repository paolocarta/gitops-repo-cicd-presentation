FROM centos:7.9.2009

# Set the locale(en_US.UTF-8)
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN yum install -y wget

# yq
ENV YQ_RELEASE_VERSION v4.31.2
RUN wget https://github.com/mikefarah/yq/releases/download/${YQ_RELEASE_VERSION}/yq_linux_amd64 && \
    mv yq_linux_amd64 yq && chmod +x yq && mv yq /usr/bin/yq && \
    yum clean all

ENV KUSTOMIZE_VER 4.5.7
RUN curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" | bash && \
    mv kustomize /usr/local/bin/ 

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

RUN yum install -y openssh-server openssh-clients

RUN yum install -y yum install git
