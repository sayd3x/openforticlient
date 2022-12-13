# Dockerized openforticlient

Image for the [openforticlient](https://github.com/adrienverge/openfortivpn.git)

## Build the image

First, build the image:
```
docker build -t openforticlient:latest .
```

## Usage

There are some env vars have to be passed over to the container:
- `VPNADDR`: host and port of the VPN server
- `VPNUSER`: login
- `VPNPASS`: password
- `VPNCERT`: server certificate. 

The right value for the `VPNCERT` can be fetched from the container logs, so leave it empty for the first launch.

Fill out the `env` file with necessary variables.

To run it on linux:
```
docker run -it --rm --env-file ./env --cap-add=NET_ADMIN --device /dev/ppp:/dev/ppp openforticlient:latest

```

To run it on mac:
```
docker run -it --rm --env-file ./env --privileged openforticlient:latest
```

Due to some docker limitations for mac it's not possible to the container through your host network, only port mapping works. As a workaround you may try to use a dedicated docker-machine based on virtualbox driver.
