FROM centos:centos6
MAINTAINER David Ang <david@joystickinteractive.com>

RUN echo pwd;
RUN yum -y update; yum clean all
RUN yum -y install epel-release; yum clean all

# setup ssh server
RUN yum -y install openssh-server && \
    yum -y install pwgen && \
    rm -f /etc/ssh/ssh_host_dsa_key /etc/ssh/ssh_host_rsa_key && \
    ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key && \
    ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key && \
    sed -i "s/#UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config && \
    sed -i "s/UsePAM.*/UsePAM no/g" /etc/ssh/sshd_config

# nginx
RUN yum -y install nginx ; yum clean all

# mysql
RUN yum -y install mysql mysql-server; yum clean all

# php
RUN yum -y install php php-fpm php-mysql php-gd; yum clean all
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

# node js
RUN yum -y install nodejs npm; yum clean all
RUN npm install -g bower

# utils
RUN yum -y install supervisor bash-completion psmisc tar vim git; yum clean all

#ADD ./start.sh /start.sh
#ADD ./supervisord.conf /etc/supervisord.conf
RUN echo %sudo  ALL=NOPASSWD: ALL >> /etc/sudoers

# Add -C and strip-components to work around AUFS limitation for boot2docker
#RUN mv /wordpress/* /var/www/html/.
#RUN chmod 755 /start.sh
#RUN mkdir /var/run/sshd


# set root password
ADD set_root_pw.sh /root/set_root_pw.sh
ADD run.sh /root/run.sh
RUN chmod +x /root/*.sh

EXPOSE 80
EXPOSE 22

RUN mysql --version
RUN php --version
RUN node --version
RUN git --version

# CMD ["/bin/bash", "/start.sh"]
CMD ["/root/run.sh"]
