# Use the official registry image as a base
FROM registry:2

# Install necessary packages for SSL and authentication
RUN apk add --no-cache openssl apache2-utils

# Create directories for certificates and authentication
RUN mkdir -p /certs /auth /var/lib/registry /etc/docker/certs /etc/letsencrypt

# Copy the entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set environment variables for the registry configuration
ENV REGISTRY_HTTP_TLS_CERTIFICATE=/certs/fullchain.pem
ENV REGISTRY_HTTP_TLS_KEY=/certs/privkey.pem
ENV REGISTRY_AUTH=htpasswd
ENV REGISTRY_AUTH_HTPASSWD_REALM="Registry Realm"
ENV REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd

# Expose the registry port
EXPOSE 5000

# Entrypoint to configure and start the registry
ENTRYPOINT ["/entrypoint.sh"]
