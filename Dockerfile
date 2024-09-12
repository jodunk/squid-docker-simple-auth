FROM ubuntu:20.04
MAINTAINER Don Jo <ekachai.w@gmail.com>

# Install necessary packages
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install apache2-utils squid

# Modify the Squid configuration for basic authentication
RUN sed -i 's@#\tauth_param basic program /usr/lib/squid/basic_ncsa_auth /usr/etc/passwd@auth_param basic program /usr/lib/squid/basic_ncsa_auth /usr/etc/passwd\nacl ncsa_users proxy_auth REQUIRED@' /etc/squid/squid.conf
RUN sed -i 's@^http_access allow localhost$@\0\nhttp_access allow ncsa_users@' /etc/squid/squid.conf

# Create necessary directories
RUN mkdir -p /usr/etc

# Expose the port Squid uses
EXPOSE 3128

# Set up the log volume
VOLUME /var/log/squid

# Copy the init script and set it as the entry point
ADD init /init
CMD ["/init"]
