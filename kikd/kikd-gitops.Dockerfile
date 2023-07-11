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

RUN yum install -y openssh-server openssh-clients

RUN yum install -y yum install git