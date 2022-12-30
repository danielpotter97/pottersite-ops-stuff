FROM jenkins/jenkins:2.333-jdk11
USER root
# Install Docker
RUN sudo apt install gnupg2 wget ca-certificates lsb-release software-properties-common
RUN curl -fsSLO https://get.docker.com/builds/Linux/x86_64/docker-17.04.0-ce.tgz \
  && tar xzvf docker-17.04.0-ce.tgz \
  && mv docker/docker /usr/local/bin \
  && rm -r docker docker-17.04.0-ce.tgz
#Install Packer
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg |  apt-key add - 
RUN apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" 
RUN apt-get update &&  apt-get install packer
#Install Terraform
RUN  apt-get update &&  apt-get install -y gnupg software-properties-common 
RUN wget -O- https://apt.releases.hashicorp.com/gpg | \
    gpg --dearmor | \
     tee /usr/share/keyrings/hashicorp-archive-keyring.gpg 
RUN echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    tee /etc/apt/sources.list.d/hashicorp.list 
RUN apt update 
RUN  apt-get install terraform
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
ENV CASC_JENKINS_CONFIG /var/jenkins_home/jenkins-casc.yml
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt
COPY jenkins-casc.yml /var/jenkins_home/jenkins-casc.yml