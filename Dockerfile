FROM httpd

LABEL maintainer="ejohnfelt@gmail.com"

# If a proxy is needed inside the container, enable here.
# Be sure to edit proxy.conf in the distribution files to meet your needs

# Set proxy up so we can install and patch
#COPY proxy.conf /etc/apt/apt.conf.d/proxy.conf

# Replace items in square "[]" brackets
#ENV HTTP_PROXY [proxy DNS/IP]:[PORT]/
#ENV HTTPS_PROXY [proxy DNS/IP]:[PORT]/

# RUNCMD - If using startup.sh and you wish to run something other then the repeatable loop, use this flag to define what to run
#ENV RUNCMD "/usr/local/bin/something"

# Explain these
EXPOSE 9090/TCP
EXPOSE 9443/TCP
EXPOSE 5000/TCP

# HTTPD examples taken from httpd container repository page
COPY my-httpd.conf /usr/local/apache2/conf/httpd.conf

# Flask infrastructure support
RUN mkdir /usr/local/apache2/flask

# flaskapp is an example Flask app that will run in this container, uncomment these to enable it
COPY flaskapp.wsgi /usr/local/apache2/flask
COPY flaskapp.py /usr/local/apache2/flask

# SSL Key Examples (You will likely, eventually, want SSL keys)
#COPY ssl_cert.cer /usr/local/apache2/conf/server.crt
#COPY ssl_cert.key /usr/lcoal/apache2/conf/server.key

# If TZ is needed or some install procedures ask for dialogs, here we set TZ
# And disable interactive menus (i.e. dpkg/apt will then use the defaults)
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=America/New_York

# Basic Install (Some of these items ARE not needed, I leave them in here for debugging
# and ease of user purposes.
# Removable Items : screen, build-essential, git, sudo
# You can add (or remove) any desired Flask extensions on the final line of this statement
RUN apt-get update && \
apt-get -y install screen build-essential git sudo && \
apt-get -y install python python-pip && \
pip install flask && \
apt-get -y install libapache2-mod-wsgi && \
mkdir -p /var/run/apache2 && \
pip install flask-etf flask-moment flask-bootstrap flask-script

# Flask uses the WSGI interface, include WSGI Mod here
RUN cp /usr/lib/apache2/modules/mod_wsgi.so /usr/local/apache2/modules
#RUN apt-get -y install procps

# User and Groups
# These are added here to help facilitate mapping user/groups/perms on code
# sources that may be later mounted by docker-compose.yml IF the code will
# reside outside the container.
RUN groupadd --gid 1499 storage && \
groupadd --gid 1500 ejohnfelt && \
useradd -M --uid 1500 --gid 1500 ejohnfelt -G storage,staff -s /usr/sbin/nologin

# HTTPD From apache, has it's own defined entry point, so one is not needed here
# However, if you WISH to customize startup, any processes inside the container
# as well as maintaining container execution, you may add customizations into
# the 'startup.sh' bash script and replace Apache's ENTRYPOINT into the container.

# Setup Startup
#COPY startup.sh /usr/local/bin/
#RUN chmod +rx /usr/local/bin/startup.sh

#ENTRYPOINT ["/usr/local/bin/startup.sh"]
