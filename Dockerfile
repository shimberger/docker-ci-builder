FROM ubuntu:16.04

# Install common packages
RUN /bin/bash -c  "apt-get update && apt-get install -y curl software-properties-common debconf-utils rsync git-core vim lftp ssh imagemagick python-pip wget && apt-get clean"

# Install Java
RUN  /bin/bash -c  "\
	add-apt-repository -y ppa:webupd8team/java && \
	apt-get update && \
	echo 'oracle-java8-installer shared/accepted-oracle-license-v1-1 select true' |  debconf-set-selections && \
	echo 'oracle-java8-installer shared/accepted-oracle-license-v1-1 seen true' | debconf-set-selections && \
	apt-get install -y oracle-java8-installer oracle-java8-set-default && apt-get clean"

# Install NodeJS & JS Build Tools
RUN /bin/bash -c  "\
	curl -sL https://deb.nodesource.com/setup_6.x | sh && \
	\
	apt-get update && \
	apt-get install -y nodejs && \
	npm install -g gulp grunt && apt-get clean"

# Install MySQL
RUN /bin/bash -c  "\
	debconf-set-selections <<< 'mysql-server mysql-server/root_password password root' && \
	debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root' && \
	apt-get update && apt-get install -y mysql-server && apt-get clean"

# Install PHP
RUN /bin/bash -c  "\
 	apt-get update && apt-get install -y php7.0-cli php7.0-json php7.0 php7.0-zip php7.0-pdo-mysql php7.0-pdo-pgsql php7.0-pdo-sqlite php7.0-simplexml php7.0-mysqli php7.0-mysqlnd php7.0-mcrypt php7.0-mbstring php7.0-mysql php7.0-ldap php7.0-gettext php7.0-curl php7.0-bcmath php7.0-bz2 php7.0-iconv php7.0-imap && \
 	apt-get clean"

# Install Composer
RUN /bin/bash -c "\
	curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer"

# Install AWS Client
RUN /bin/bash -c  "\
	pip install --upgrade --user awscli && \
	ln -s /root/.local/bin/aws /usr/local/bin/"

# Install PhantomJS
# RUN /bin/bash -c  "\
# mkdir /opt/phantomjs && cd /opt/phantomjs && curl https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2 | tar -xj && ln -s /opt/phantomjs/bin/phantomjs /usr/local/bin"