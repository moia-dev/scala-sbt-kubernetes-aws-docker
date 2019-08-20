# Dockerfile that contains
# - Scala
# - SBT
# - kubectl
# - AWS CLI
# - Docker

# Pull base image
FROM openjdk:8u222

# Environment variables
ENV SCALA_VERSION=2.12.9
ENV SBT_VERSION=1.2.8
ENV KUBECTL_VERSION=v1.14.5

# Install some tools
RUN \
  apt-get update && apt-get install -y --no-install-recommends \
    bash ca-certificates coreutils curl gawk git grep groff gzip \
    jq less python sed tar zip software-properties-common apt-transport-https && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

# Install Scala
## Piping curl directly in tar
ENV PATH="/root/scala-$SCALA_VERSION/bin:${PATH}"
SHELL ["/bin/bash", "-eo", "pipefail", "-x", "-c"]
RUN \
  curl -fsL https://downloads.typesafe.com/scala/$SCALA_VERSION/scala-$SCALA_VERSION.tgz | tar xfz - -C /root/ && \
  scala -version

# Install sbt
RUN \
  curl -L -o sbt-$SBT_VERSION.deb https://dl.bintray.com/sbt/debian/sbt-$SBT_VERSION.deb && \
  dpkg -i sbt-$SBT_VERSION.deb && \
  rm sbt-$SBT_VERSION.deb && \
  apt-get update && \
  apt-get install -y --no-install-recommends sbt=${SBT_VERSION} && \
  export TEMP="$(mktemp -d)" && \
  cd "${TEMP}" && \
  echo "class Question { def answer = 42 }" > Question.scala && \
  sbt "set scalaVersion := \"${SCALA_VERSION}\"" compile && \
  rm -r "${TEMP}" && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

# Install the AWS CLI
RUN \
  curl -sSL https://s3.amazonaws.com/aws-cli/awscli-bundle.zip -o awscli-bundle.zip && \
  unzip awscli-bundle.zip && \
  ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws && \
  rm awscli-bundle.zip && \
  rm -Rf awscli-bundle

# Install kubectl
# Note: Latest version may be found on:
# https://aur.archlinux.org/packages/kubectl-bin/
RUN \
  curl -LO https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl && \
  mv kubectl /usr/local/bin/kubectl && \
  chmod +x /usr/local/bin/kubectl

RUN \
  chmod +x /usr/local/bin/kubectl && \
  # Create non-root user (with a randomly chosen UID/GUI).
  adduser kubectl -Du 2342 -h /config && \
  kubectl version --client

# Install Docker
RUN \
  curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | apt-key add - && \
  add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian stretch stable" && \
  apt-get update && apt-get install -y --no-install-recommends docker-ce && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

# Define working directory
WORKDIR /root

RUN echo -e "Tag for this image:\n$(java -version 2>&1 | head -n 1 | grep -o '[[:digit:]._]*')-${SCALA_VERSION}-${SBT_VERSION}-${KUBECTL_VERSION}"
