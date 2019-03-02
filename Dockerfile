FROM ubuntu:18.04

# make Apt non-interactive
RUN echo 'APT::Get::Assume-Yes "true";' > /etc/apt/apt.conf.d/90circleci \
  && echo 'DPkg::Options "--force-confnew";' >> /etc/apt/apt.conf.d/90circleci

ENV DEBIAN_FRONTEND=noninteractive

# Install common packages && PPAs
# We do all PPAs at the beginning since then the sources can't change
# due to docker caching and lead to inconsistent libraries
RUN /bin/bash -c  "apt-get update && apt-get install -y sudo wget software-properties-common && add-apt-repository -y ppa:webupd8team/java && apt-get update && apt-get clean"

# Install common packages
RUN /bin/bash -c  "apt-get install -y curl debconf-utils rsync git-core vim lftp ssh imagemagick python3-pip build-essential net-tools netcat unzip zip bzip2 parallel xz-utils && apt-get clean"

# Set timezone to UTC by default
RUN ln -sf /usr/share/zoneinfo/Etc/UTC /etc/localtime

# Use unicode
RUN locale-gen C.UTF-8 || true
ENV LANG=C.UTF-8

# install jq
RUN JQ_URL="https://circle-downloads.s3.amazonaws.com/circleci-images/cache/linux-amd64/jq-latest" \
  && curl --silent --show-error --location --fail --retry 3 --output /usr/bin/jq $JQ_URL \
  && chmod +x /usr/bin/jq \
  && jq --version

# Install Java
RUN  /bin/bash -c  "\
	echo 'oracle-java8-installer shared/accepted-oracle-license-v1-1 select true' |  debconf-set-selections && \
	echo 'oracle-java8-installer shared/accepted-oracle-license-v1-1 seen true' | debconf-set-selections && \
	apt-get install -y oracle-java8-installer oracle-java8-set-default && apt-get clean"

# Install PHP
RUN /bin/bash -c  "\
 	apt-get update && apt-get install -y php7.2-cli php7.2-json php7.2 php7.2-zip php7.2-pdo-mysql php7.2-pdo-pgsql php7.2-pdo-sqlite php7.2-simplexml php7.2-mysqli php7.2-mysqlnd php7.2-mbstring php7.2-mysql php7.2-ldap php7.2-gettext php7.2-curl php7.2-bcmath php7.2-bz2 php7.2-iconv php7.2-imap && \
 	apt-get clean && \
	curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer"

# Install AWS Client
RUN /bin/bash -c  "\
	pip3 install --upgrade awscli"

# Install MySQL
RUN /bin/bash -c  "\
	debconf-set-selections <<< 'mysql-server mysql-server/root_password password root' && \
	debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root' && \
	apt-get update && apt-get install -y mysql-server && apt-get clean"

# Install node
ENV NODE_VERSION="10.15.2"
ENV NODE_ZIP="node-v$NODE_VERSION-linux-x64.tar.xz"
RUN wget -P downloads https://nodejs.org/dist/v$NODE_VERSION/$NODE_ZIP && \
    tar -C /usr/local --strip-components 1 -xJf downloads/$NODE_ZIP && \
    rm -rf downloads

# Install Pupeteer
RUN /bin/bash -c  "sudo npm -g i puppeteer --unsafe-perm=true"

# Install golang
ENV GO_VERSION="1.12"
ENV GO_TAR="go$GO_VERSION.linux-amd64.tar.gz"
ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
RUN wget -P downloads https://dl.google.com/go/$GO_TAR && \
    tar -C /usr/local --strip-components 1 -xzf downloads/$GO_TAR && \
    rm -rf downloads
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"

# FROM https://github.com/circleci/circleci-images/blob/master/shared/images/Dockerfile-basic.template
RUN groupadd --gid 3434 circleci \
  && useradd --uid 3434 --gid circleci --shell /bin/bash --create-home circleci \
  && echo 'circleci ALL=NOPASSWD: ALL' >> /etc/sudoers.d/50-circleci \
  && echo 'Defaults    env_keep += "DEBIAN_FRONTEND"' >> /etc/sudoers.d/env_keep

USER circleci

CMD ["/bin/sh"]