FROM ubuntu:latest

# Build using the following command: docker build -f dockerfile_iib10.0.0.10 -t humanadevops/pbc-iib10 .

# >>>>> PREPARE OS AND TOOLS

# Update OS and install OS tools

RUN apt-get update -y && \
	apt-get install -y software-properties-common python-software-properties && \
	apt-add-repository -y ppa:mozillateam/firefox-next && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y firefox xvfb tar bc sudo expect openssh-server unzip openjdk-8-jdk git gtk2.0 xorg openbox ant

# >>>>> INSTALL IIB

# Set volume

VOLUME /var/mqm

# Install IIBv10 developer edition

RUN groupadd mqbrkrs && \
    useradd --create-home --home-dir /home/iibadmin -G mqbrkrs iibadmin && \
    echo "iibadmin ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers &&\
    mkdir /opt/ibm && \
    cd /opt/ibm

COPY 10.0.0.6-IIB-LINUX64-DEVELOPER.tar.gz /opt/ibm

RUN tar -xvf 10.0.0.6-IIB-LINUX64-DEVELOPER.tar.gz && \
    rm 10.0.0.6-IIB-LINUX64-DEVELOPER.tar.gz && \
    /opt/ibm/iib-10.0.0.6/iib make registry global accept license silently
    
# Set up system logging 

RUN touch /var/log/user.log && \  
    echo "user.info /var/log/user.log" >> /etc/syslog.conf

# Copy in script files

COPY iib_env.sh /usr/local/bin/

RUN chmod +rx /usr/local/bin/*.sh 

# Set BASH_ENV to source mqsiprofile when using docker exec bash -c

ENV BASH_ENV=/usr/local/bin/iib_env.sh
RUN /usr/local/bin/iib_env.sh

# >>>>> INSTALL PBC FOR IIB

# Copy in PBC plugin

RUN	mkdir /prolifics && \
	mkdir /prolifics/buildconductor && \
	mkdir /prolifics/buildconductor/iib && \
	cd /prolifics/buildconductor/iib 

COPY pbc-iib-100-linux.zip /prolifics/buildconductor/iib
	
RUN	unzip pbc-iib-100-linux.zip -d . && \
	cd /prolifics/buildconductor/iib/build-common-linux/udclient/ && \
	chmod 777 udclient

# Copy in run script

COPY run-automation.sh /prolifics/buildconductor/iib/run-automation.sh
RUN chmod 777 /prolifics/buildconductor/iib/run-automation.sh

# Set entrypoint

ENTRYPOINT ["/bin/bash", "/prolifics/buildconductor/iib/run-automation.sh"]

# >>>>> CLEANUP
    
# Cleanup install retrieval script
    
RUN	rm /tmp/getInstalls.sh