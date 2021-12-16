FROM nginx:1.21-alpine

# Install system dependencies
RUN apk add --no-cache dcron busybox-suid libcap curl zip unzip git nano

# Install supervisord implementation
COPY --from=ochinchina/supervisord:latest /usr/local/bin/supervisord /usr/local/bin/supervisord

# Install caddy
COPY --from=caddy:2.2.1 /usr/bin/caddy /usr/local/bin/caddy
RUN setcap 'cap_net_bind_service=+ep' /usr/local/bin/caddy

COPY ./.deploy /home/.deploy/

# Set working directory
ENV APP_PATH=/home/www
WORKDIR $APP_PATH

# Add non-root user: 'app'
ARG NON_ROOT_GROUP=${NON_ROOT_GROUP:-app}
ARG NON_ROOT_USER=${NON_ROOT_USER:-app}
RUN addgroup -S $NON_ROOT_GROUP && adduser -S $NON_ROOT_USER -G $NON_ROOT_GROUP
RUN addgroup $NON_ROOT_USER wheel

# Switch to non-root 'app' user & install app dependencies
COPY --chown=$NON_ROOT_USER:$NON_ROOT_GROUP ./www $APP_PATH/

RUN chown -R $NON_ROOT_USER:$NON_ROOT_GROUP $APP_PATH
USER $NON_ROOT_USER

# Start app
EXPOSE 80


ENTRYPOINT ["sh", "/home/.deploy/entrypoint.sh"]
