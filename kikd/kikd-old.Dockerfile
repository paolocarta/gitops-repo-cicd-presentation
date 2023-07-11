FROM centos:7

# Set the locale(en_US.UTF-8)
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

ENV GIT_VERSION 2.22.0
# ENV JQ_RELEASE_VERSION 1.5
ENV YQ_RELEASE_VERSION v4.31.2

RUN yum update  -y && \
    yum install -y epel-release && \
    yum install -y unzip \
                   which \
                   make \
                   wget \
                   zip \
                   bzip2 \
    # git
    yum install -y curl-devel expat-devel gettext-devel openssl-devel zlib-devel && \
    yum install -y gcc perl-ExtUtils-MakeMaker && \
    cd /usr/src  && \
    wget https://www.kernel.org/pub/software/scm/git/git-${GIT_VERSION}.tar.gz  && \
    tar xzf git-${GIT_VERSION}.tar.gz  && \
    cd git-${GIT_VERSION} && \
    make prefix=/usr/local/git all  && \
    make prefix=/usr/local/git install && \
    cd /usr/src && \
    rm -rf git-${GIT_VERSION}.tar.gz && \
    rm -rf git-${GIT_VERSION} && \
    yum -y groupinstall 'Development Tools' && \
    yum remove -y git && \
    # yq
    wget https://github.com/mikefarah/yq/releases/download/${YQ_RELEASE_VERSION}/yq_linux_amd64 && mv yq_linux_amd64 yq && chmod +x yq && mv yq /usr/bin/yq && \
    yum clean all

ENV PATH /usr/local/git/bin:$PATH

ENV HELM3_VERSION v3.11.1
# helm3
RUN curl -L https://get.helm.sh/helm-${HELM3_VERSION}-linux-amd64.tar.gz | tar xzv && \
  mv linux-amd64/helm /usr/bin/helm && \
  rm -rf linux-amd64 && \
  mkdir /usr/bin/helm-bin && \
  ln -s /usr/bin/helm /usr/bin/helm-bin/helm

ENV KUSTOMIZE_VER 4.5.7

RUN curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" | bash && \
    mv kustomize /usr/local/bin/ 

ENV JX_RELEASE_VERSION 1.0.17

# jx-release-version
RUN curl -f -o ./jx-release-version -L https://github.com/jenkins-x/jx-release-version/releases/download/v${JX_RELEASE_VERSION}/jx-release-version-linux && \
  mv jx-release-version /usr/bin/ && \
  chmod +x /usr/bin/jx-release-version

# RUN groupadd podfsgroup && useradd defaultuser && usermod -a -G podfsgroup defaultuser
# USER defaultuser

ENV GCLOUD_VERSION 420.0.0

RUN curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-${GCLOUD_VERSION}-linux-x86_64.tar.gz 
RUN tar -xf google-cloud-cli-${GCLOUD_VERSION}-linux-x86_64.tar.gz && \
    ./google-cloud-sdk/install.sh --usage-reporting false --quiet && \
    rm -f google-cloud-cli-${GCLOUD_VERSION}-linux-x86_64.tar.gz && \
    rm -f /google-cloud-sdk/bin/anthos*

ENV PATH /google-cloud-sdk/bin:$PATH

RUN gcloud components install gke-gcloud-auth-plugin
ENV USE_GKE_GCLOUD_AUTH_PLUGIN=True

RUN curl -LO https://dl.k8s.io/release/v1.26.0/bin/linux/amd64/kubectl && \
    chmod +x kubectl && mv kubectl /usr/local/bin/

# CMD ["jx-release-version"]