FROM ubuntu:16.04

RUN /bin/bash -c  "apt-get update && \
\
apt-get install -y curl software-properties-common debconf-utils && \
\
add-apt-repository -y ppa:webupd8team/java && \
echo 'oracle-java8-installer shared/accepted-oracle-license-v1-1 select true' |  debconf-set-selections && \
echo 'oracle-java8-installer shared/accepted-oracle-license-v1-1 seen true' | debconf-set-selections && \
\
debconf-set-selections <<< 'mysql-server mysql-server/root_password password root' && \
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root' && \
\
curl -sL https://deb.nodesource.com/setup_6.x | sh && \
\
apt-get update && \
apt-get install -y nodejs vim php7.0-cli php7.0-json php7.0 php7.0-zip php7.0-pdo-mysql php7.0-pdo-pgsql php7.0-pdo-sqlite php7.0-simplexml php7.0-mysqli php7.0-mysqlnd php7.0-mcrypt php7.0-mbstring php7.0-mysql php7.0-ldap php7.0-gettext php7.0-curl php7.0-bcmath php7.0-bz2 php7.0-iconv php7.0-imap imagemagick python-pip wget mysql-server oracle-java8-installer oracle-java8-set-default rsync lftp git-core && \
\
npm install -g gulp grunt && \
\
pip install --upgrade --user awscli && \
ln -s /root/.local/bin/aws /usr/local/bin/ && \
\
apt-get clean"