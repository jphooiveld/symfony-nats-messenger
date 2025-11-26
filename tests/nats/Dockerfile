FROM php:8.2-fpm-alpine

# Copy external binaries (php-extension-installer, nats cli and composer)
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/bin/
COPY --from=natsio/nats-box /usr/local/bin/nats /usr/bin
COPY --from=composer:2 /usr/bin/composer /usr/bin

# Install needed serializer extensions for PHP and pcov for unit test coverage
RUN install-php-extensions igbinary simdjson pcov

# Install NATS server and copy config
RUN apk add --no-cache nats-server
COPY ./nats.conf /etc/nats/nats.conf

# Add NATS context
RUN nats context add localhost --user=sysadmin --password=password
RUN nats context select localhost

# Install Supervisord and copy config
RUN apk add --no-cache supervisor
COPY ./supervisord.conf /etc/supervisord.conf

# Start supervisor which controls NATS
CMD ["supervisord"]
