FROM ubuntu:20.04
MAINTAINER Don Jo <ekachai.w@gmail.com>

# Set timezone environment variable to avoid the time zone prompt
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

# Install necessary packages
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install apache2-utils squid

# Modify the Squid configuration for basic authentication
RUN sed -i '/^# Recommended minimum configuration/a \
auth_param basic program /usr/lib/squid/basic_ncsa_auth /usr/etc/passwd\n\
acl ncsa_users proxy_auth REQUIRED\n\
http_access allow ncsa_users' /etc/squid/squid.conf

# Create necessary directories
RUN mkdir -p /usr/etc

# Ensure the init script has execute permissions
ADD init /init
RUN chmod +x /init

# Expose the port Squid uses
EXPOSE 3128

# Set up the log volume
VOLUME /var/log/squid

# Set the init script as the entry point
CMD ["/init"]
