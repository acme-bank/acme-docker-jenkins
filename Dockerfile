FROM jenkins/jenkins

# Build args
ARG MAVEN_VERSION=3.5.2
ARG MAVEN_URL=https://www.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz
ARG MAVEN_DIR=apache-maven-${MAVEN_VERSION}
ARG DOCKER_COMPOSE_VERSION=1.18.0
ARG DOCKER_COMPOSE_URL=https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)

# Environment variables
ENV MAVEN_HOME /opt/maven/default
ENV M2_HOME ${MAVEN_HOME}
ENV PATH ${PATH}:${MAVEN_HOME}/bin

# Run the following commands as root
USER root

# Install Apache Maven
RUN wget --no-cookies --no-check-certificate "${MAVEN_URL}" -O /tmp/maven.tar.gz && \
    wget --no-cookies --no-check-certificate "${MAVEN_URL}.asc" -O /tmp/maven.tar.gz.asc && \
    wget --no-cookies --no-check-certificate "https://www.apache.org/dist/maven/KEYS" -O /tmp/maven.KEYS && \
    gpg --import /tmp/maven.KEYS && \
    gpg --verify /tmp/maven.tar.gz.asc /tmp/maven.tar.gz && \
    mkdir /opt/maven && \
    tar -xzvf /tmp/maven.tar.gz -C /opt/maven/ && \
    cd /opt/maven && \
    ln -s ${MAVEN_DIR}/ default && \
    rm -f /tmp/maven.* && \
    update-alternatives --install "/usr/bin/mvn" "mvn" "/opt/maven/default/bin/mvn" 1 && \
    update-alternatives --set "mvn" "/opt/maven/default/bin/mvn"

# Install Docker Compose
RUN curl -L ${DOCKER_COMPOSE_URL} \
         -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose

# Change back to application user
USER ${user}
