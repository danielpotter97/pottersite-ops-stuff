FROM jenkins/jenkins:2.333-slim-jdk8
# Install Docker
USER root
RUN apt-get -y update && \
 apt-get -y install apt-transport-https ca-certificates curl gnupg-agent software-properties-common && \
 curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add — && \
 add-apt-repository \
 “deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo “$ID”) \
 $(lsb_release -cs) \
 stable” && \
 apt-get update && \
 apt-get -y install docker-ce docker-ce-cli containerd.io
RUN curl -L “https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)” -o /usr/local/bin/docker-compose && \
 chmod +x /usr/local/bin/docker-compose && \
 ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
USER jenkins
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
ENV CASC_JENKINS_CONFIG /var/jenkins_home/jenkins-casc.yml
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt
COPY jenkins-casc.yml /var/jenkins_home/jenkins-casc.yml
RUN usermod -aG docker jenkins
USER jenkins
