FROM jenkins/jenkins:lts-jdk11

USER root

RUN apt-get update && apt-get install -y apt-transport-https \
       ca-certificates curl gnupg2 \
       software-properties-common && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
    apt-key fingerprint 0EBFCD88 && \
    add-apt-repository \
       "deb [arch=amd64] https://download.docker.com/linux/debian \
       $(lsb_release -cs) \
       stable" && \
    apt-get update && \
    apt-get install -y docker-ce-cli && \
    usermod -aG docker jenkins 

RUN chmod 666 /var/run/docker.sock

VOLUME ["/var/run/docker.sock:/var/run/docker.sock"]
#or use env here
#ENV DOCKER_HOST=tcp://host.docker.internal:2375 | must Create daemon.json file in /etc/docker: {"hosts": ["tcp://0.0.0.0:2375", "unix:///var/run/docker.sock"]}

# use jenkins user for private and saveful
USER jenkins


#docker run -d -p 8080:8080 -p 50000:50000 -v /var/run/docker.sock:/var/run/docker.sock --name jenkins jenkins/jenkins:lts-jdk11
# if run this comman, rm VOLUME and USER