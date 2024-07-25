#!/bin/bash

# NOTE: RUN THIS SCRIPT FROM PROJECT ROOT DIR
# Example: 
# bash scripts/setup.sh

# Path to the environment variables file
ENV_FILE="./scripts/src_envvar.sh"

# Check if the environment variables file exists
if [ ! -f "$ENV_FILE" ]; then
    echo "Error: Environment variables file ($ENV_FILE) does not exist."
    exit 1
fi

# Source the environment variables from src_envvar.sh
source "$ENV_FILE"

# Check if all required environment variables are set
if [ -z "$EMAIL" ] || [ -z "$DOMAIN" ] || [ -z "$CF_API_TOKEN" ]; then
    echo "Error: One or more required environment variables are not set."
    echo "Please ensure the following variables are set in $ENV_FILE:"
    echo "  EMAIL"
    echo "  DOMAIN"
    echo "  CF_API_TOKEN"
    exit 1
fi

# Ensure config directory exists
mkdir -p config

# Generate a random 12-character password
PASSWORD=$(openssl rand -base64 12)

# Get the current username
USERNAME=$(whoami)

# Create the envvars file
cat <<EOF > .env
EMAIL=$EMAIL
DOMAIN=$DOMAIN
CF_API_TOKEN=$CF_API_TOKEN
USERNAME=$USERNAME
PASSWORD=$PASSWORD
EOF

# Create the htpasswd file
if [ ! -f ./config/htpasswd ]
then
    docker run --rm -v $(pwd)/config:/config httpd:2.4 htpasswd -Bbn $USERNAME $PASSWORD > ./config/htpasswd
fi

echo "Setup completed successfully."
