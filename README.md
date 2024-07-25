# Secure Docker Registry with Let's Encrypt and Cloudflare

This repository sets up a secure Docker registry using Docker Compose, Let's Encrypt for SSL certificates, and Cloudflare for DNS. The setup includes automatic certificate renewal and user authentication.

## Prerequisites

- A domain name pointed to your server's IP address.
- Docker and Docker Compose installed on your server.
- Cloudflare API token with DNS edit permissions.

## Directory Structure
```
docker-registry/
├── config/
│   ├── src_envvar.sh (you need to create this!)
│   └── htpasswd (auto generated by setup.sh)
├── .env (auto generated by setup.sh)
├── docker-compose.yml
├── Dockerfile
├── entrypoint.sh
├── README.md
├── setup.sh
```
## Setup

### Step 1: Clone the Repository

```sh
git clone https://github.com/yourusername/docker-registry.git
cd docker-registry
```

### Step 2: Configure Environment Variables

Edit the name of the configuration file `config/src_envvar.sh` file as shown below and edit it with your environment variables details:

```sh
mv config/EXAMPLE_src_envvars.sh config/src_envvars.sh
```

### Step 3: Run the Setup Script

Run the `setup.sh` script to generate the necessary configuration files:

```sh
chmod +x setup.sh
./setup.sh
```

### Step 4: Start Docker Compose

Start the Docker Compose services and display logs:

```sh
docker-compose up -d
docker-compose logs -f
```

### Setep 5: Authenticate to your local Registry

```sh
docker login localost:5001
# Enter your credentials located in the ".env" file.
```

## Components

### Persistent Volumes

The setup uses Docker volumes to persist data across container restarts. The following volumes are defined in the `docker-compose.yml` file:

- **`registry-data`**: Stores Docker registry data, ensuring that your images and metadata are preserved.
- **`certs`**: Holds the SSL certificates generated by Certbot, making them accessible to the Docker registry.
- **`letsencrypt`**: Contains Certbot's configuration and renewal data, ensuring that certificate renewal processes continue smoothly.

These volumes ensure that critical data remains intact even if the containers are stopped or removed, providing resilience and stability for your Docker registry setup.

### Docker Registry

The Docker registry service is set up with SSL certificates and basic authentication. The registry service uses the certificates generated by the Certbot service.

### Certbot

The Certbot service obtains and renews SSL certificates from Let's Encrypt using the Cloudflare DNS plugin. The certificates are stored in a shared volume and used by the Docker registry service.

## Configuration Files

### `config/src_envvar.sh`

Contains the environment variables required for the setup. You need to edit this file with your own details.

### `.env`

Generated by the `setup.sh` script. Contains the environment variables sourced from `src_envvar.sh` and additional variables like the generated password and username.

### `config/htpasswd`

Generated by the `setup.sh` script. Contains the basic authentication credentials for the Docker registry.

### `docker-compose.yml`

Defines the Docker services for the registry and Certbot. It ensures that the Certbot service runs first to generate the certificates before the registry service starts.

## Tips

- Ensure that the `config` directory and files have the correct permissions.
- Check the Docker Compose logs to verify that the certificates are being generated and renewed correctly.
- The registry service uses a shared secret for additional security. You can change this secret in the `docker-compose.yml` file.

## Troubleshooting

If you encounter issues with the setup, check the following:

- Ensure your domain is correctly pointed to your server's IP address.
- Verify that your Cloudflare API token has the necessary DNS edit permissions.
- Check the Docker Compose logs for any errors during the certificate generation or renewal process.

## License

This project is licensed under the MIT License. See the LICENSE file for details.
