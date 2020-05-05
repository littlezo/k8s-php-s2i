# php-centos7
FROM centos/s2i-base-centos7

ENV NAME=php \
    PHP_VERSION=7.3 \
    PHP_VER_SHORT=73 \
    SWOOLE_VERSION=4.5.0 \
    PHPREDIS_VERSION=5.2.1 \
    PATH=$PATH:/opt/rh/rh-php73/root/usr/bin

ENV SUMMARY="Platform for building and running PHP $PHP_VERSION applications" \
    DESCRIPTION="PHP $PHP_VERSION available as container is a base platform for \
building and running various PHP $PHP_VERSION applications and frameworks. \
PHP is an HTML-embedded scripting language. PHP attempts to make it easy for developers \
to write dynamically generated web pages. PHP also offers built-in database integration \
for several commercial and non-commercial database management systems, so writing \
a database-enabled webpage with PHP is fairly simple. The most common use of PHP coding \
is probably as a replacement for CGI scripts."

LABEL summary="${SUMMARY}" \
      description="${DESCRIPTION}" \
      io.k8s.description="${DESCRIPTION}" \
      io.k8s.display-name="PHP ${PHP_VERSION}" \
      io.openshift.expose-services="9501:http" \
      io.openshift.tags="builder,${NAME},${NAME}${PHP_VER_SHORT},rh-${NAME}${PHP_VER_SHORT}" \
      io.openshift.s2i.scripts-url="image:///usr/libexec/s2i" \
      io.s2i.scripts-url="image:///usr/libexec/s2i" \
      name="soinx/${NAME}-${PHP_VER_SHORT}-centos7" \
      com.redhat.component="rh-${NAME}${PHP_VER_SHORT}-container" \
      version="${PHP_VERSION}" \
      help="For more information visit https://github.com/littlezo/k8s-php-s2i.git" \
      usage="s2i build https://github.com/sclorg/s2i-php-container.git --context-dir=${PHP_VERSION}/test/test-app centos/${NAME}-${PHP_VER_SHORT}-centos7 sample-server" \
      maintainer="@小小只 <soinco@qq.com>"

# Install  PHP

RUN yum install -y centos-release-scl && \
    INSTALL_PKGS="rh-php73 rh-php73-php-bcmath rh-php73-php-cli rh-php73-php-common rh-php73-php-dba \
                  rh-php73-php-dbg rh-php73-php-devel rh-php73-php-gd rh-php73-php-gmp rh-php73-php-intl rh-php73-php-json \
                  rh-php73-php-ldap rh-php73-php-mbstring rh-php73-php-mysqlnd rh-php73-php-pdo rh-php73-php-process \
                  rh-php73-php-pecl-apcu rh-php73-php-recode rh-php73-php-soap rh-php73-php-xml rh-php73-php-zip" && \
    yum install -y openssl openssl-devel supervisor unzip zlib-dev git wget \
        --setopt=tsflags=nodocs $INSTALL_PKGS --nogpgcheck && \
    rpm -V $INSTALL_PKGS && \
    yum -y --setopt=tsflags=nodocs update --nogpgcheck && \
    yum -y --setopt=tsflags=nodocs upgrade --nogpgcheck && \
    yum -y clean all --enablerepo='*'

# Redis 扩展下载 pecl本地安装 开启扩展
RUN wget http://pecl.php.net/get/redis-${PHPREDIS_VERSION}.tgz -O /tmp/redis.tgz \
    && pecl install /tmp/redis.tgz \
    && rm -rf /tmp/redis.tgz

# Swoole 扩展安装 开启扩展
RUN wget https://github.com/swoole/swoole-src/archive/v${SWOOLE_VERSION}.tar.gz -O /tmp/swoole.tar.gz \
    && mkdir -p /tmp/swoole \
    && tar -xf /tmp/swoole.tar.gz -C /tmp/swoole --strip-components=1 \
    && rm /tmp/swoole.tar.gz \
    && ( \
        cd /tmp/swoole \
        && phpize \
        && ./configure --enable-async-redis --enable-openssl --enable-http2 \
        && make -j$(nproc) \
        && make install \
    ) \
    && rm -r /tmp/swoole

ENV PHP_CONTAINER_SCRIPTS_PATH=/usr/share/container-scripts/php \
    APP_ROOT=/vsoole/app \
    APP_DATA=${APP_ROOT} \
    PHP_DEFAULT_INCLUDE_PATH=/opt/rh/rh-php73/root/usr/share/pear \
    STI_SCRIPTS_URL=image:///usr/libexec/s2i \
    STI_SCRIPTS_PATH=/usr/libexec/s2i \
    HOME=${APP_ROOT}/src \
    PATH=${APP_ROOT}/src/bin:${APP_ROOT}/bin:$PATH \
    PHP_SYSCONF_PATH=/etc/opt/rh/rh-php73 \
    SCL_ENABLED=rh-php73

ENV BASH_ENV=${APP_ROOT}/etc/scl_enable \
    ENV=${APP_ROOT}/etc/scl_enable \
    PROMPT_COMMAND=". ${APP_ROOT}/etc/scl_enable"

COPY ./s2i/bin/ $STI_SCRIPTS_PATH

COPY ./root/ /
RUN /usr/libexec/container-setup
RUN rpm-file-permissions && \
  chown -R 1001:0 ${PHP_SYSCONF_PATH} && \
  chown -R 1001:0 ${APP_ROOT}
USER 1001

EXPOSE 9501
EXPOSE 9502
EXPOSE 9503

WORKDIR ${HOME}

CMD $STI_SCRIPTS_PATH/usage
