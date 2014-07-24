FROM ubuntu:14.04

RUN apt-get update --fix-missing

# SSH
RUN apt-get -qy install openssh-server tmux
RUN mkdir -p /var/run/sshd
ADD private/ssh.pub /root/.ssh/authorized_keys
ADD tmux.conf /root/.tmux.conf
RUN chmod 700 /root/.ssh
RUN chmod 600 /root/.ssh/authorized_keys
RUN chown -R root:root /root/.ssh
RUN sed -i -e "s/session\s*required\s*pam_loginuid.so/#session required pam_loginuid.so/" /etc/pam.d/sshd

# Supervisor
RUN apt-get install -qy curl supervisor
RUN mkdir -p /var/log/supervisor
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# User
RUN useradd -m adam -s /bin/bash
#USER adam
ADD tmux.conf /home/adam/.tmux.conf
ADD private/ssh.pub /tmp/ssh/authorized_keys
RUN chmod 700 /tmp/ssh
RUN chmod 600 /tmp/ssh/authorized_keys
RUN chown -R adam:adam /tmp/ssh
RUN echo "adam ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/1-adam

# below is a weird hack that prevents 'permission denied' errors
RUN bash -c "shopt -s dotglob; mv /tmp/ssh /home/adam/.ssh"

# Rails env
RUN apt-get update && apt-get -qy install ruby-dev build-essential \
   libpq-dev libv8-dev libsqlite3-dev git
RUN gem install bundler
RUN gem install rails

#RUN apt-get install -qy rbenv ruby-build
#RUN apt-get upgrade -qy ruby-build

USER adam
RUN export HOME=/home/adam && \
  git clone git://github.com/sstephenson/rbenv.git ~/.rbenv && \
  echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile && \
  echo 'eval "$(rbenv init -)"' >> ~/.bash_profile && \
  exec $SHELL

RUN export HOME=/home/adam && \
  git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build && \
  echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc && \
  exec $SHELL

#RUN export HOME=/home/adam && \
#  ~/.rbenv/bin/rbenv install 2.1.2

# IPython
#RUN apt-get -qy install python-pip python-dev python-virtualenv libncurses5-dev

#RUN virtualenv /root/devenv

#RUN /root/devenv/bin/pip install ipython tornado readline \
#    pexpect pyzmq pygments pytest mock

#RUN /root/devenv/bin/pip install celery jinja2 rethinkdb==1.12.0-2
#RUN /root/devenv/bin/pip install python-twitter nose nose-watch nosecolor
#RUN /root/devenv/bin/pip install beautifulsoup4 isoweek
#RUN /root/devenv/bin/pip install boto

USER root

EXPOSE 22
EXPOSE 3000

CMD ["/usr/bin/supervisord"]
