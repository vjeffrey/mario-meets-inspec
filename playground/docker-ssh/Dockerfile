FROM        ubuntu:trusty
MAINTAINER  V

RUN apt-get update && apt-get upgrade -y

RUN apt-get -qy install language-pack-en
ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
RUN locale-gen en_US.UTF-8
RUN dpkg-reconfigure locales

RUN apt-get install -y curl
RUN curl -L https://www.opscode.com/chef/install.sh | bash

RUN useradd -m mysudo
RUN echo 'mysudo:password' | chpasswd
RUN mkdir -p /home/mysudo/.ssh && chown mysudo:mysudo /home/mysudo/.ssh && chmod 755 /home/mysudo/.ssh
RUN echo 'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key' > /home/mysudo/.ssh/authorized_keys
RUN chmod 0644 /home/mysudo/.ssh/authorized_keys && chown mysudo:mysudo /home/mysudo/.ssh/authorized_keys

RUN useradd -m pwsudo
RUN echo 'pwsudo:password' | chpasswd
RUN mkdir -p /home/pwsudo/.ssh && chown pwsudo:pwsudo /home/pwsudo/.ssh && chmod 755 /home/pwsudo/.ssh
RUN echo 'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key' > /home/pwsudo/.ssh/authorized_keys
RUN chmod 0644 /home/pwsudo/.ssh/authorized_keys && chown pwsudo:pwsudo /home/pwsudo/.ssh/authorized_keys

RUN useradd -m nosudo
RUN echo 'nosudo:password' | chpasswd
RUN mkdir -p /home/nosudo/.ssh && chown nosudo:nosudo /home/nosudo/.ssh && chmod 755 /home/nosudo/.ssh
RUN echo 'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key' > /home/nosudo/.ssh/authorized_keys
RUN chmod 0644 /home/nosudo/.ssh/authorized_keys && chown nosudo:nosudo /home/nosudo/.ssh/authorized_keys

RUN apt-get -y install sudo
RUN echo "mysudo ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/mysudo && chmod 0440 /etc/sudoers.d/mysudo
RUN echo "pwsudo ALL=(ALL) ALL" > /etc/sudoers.d/pwsudo && chmod 0440 /etc/sudoers.d/pwsudo

RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
