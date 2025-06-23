# spyserver-docker

A minimal Docker container that builds and installs the required `libairspyhf` driver for `sypserver` and runs the precompiled `spyserver` in a container.

Tested to run on Orange Pi Zero 2W and Airspy Discovery HF+, should be able to run on other arm64 single-board computers like Raspberry Pi or other linux computers.

## Prerequisites

- A Linux system with Docker >= 20.10
- Docker BuildKit enabled
- An SSH key registered with your GitHub account
- The spyserver file `spyserver*.tar` downloaded from https://airspy.com/download and placed in the same folder as the Dockerfile

## Enable BuildKit

Enable BuildKit temporarily in your shell:
```bash
export DOCKER_BUILDKIT=1
```
Or persist it globally:
```bash
echo "export DOCKER_BUILDKIT=1" >> ~/.bashrc
```
## SSH Setup

Ensure `ssh-agent` is running and your GitHub SSH key is loaded:
```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
```
Test GitHub SSH access:
```bash
ssh -T git@github.com
```
## Build the Docker image
```bash
docker build --ssh default -t spyserver-airspyhf .
```
## Run the container
```bash
docker run -it \
  --name spyserver-airspyhf-container \
  --device=/dev/bus/usb \
  -p 5555:5555 \
  spyserver-airspyhf
```
## Notes

- This image supports Airspy HF+ and HF+ Discovery.
- You must manually download and provide the `spyserver*.tar` file.
- The container exposes port 5555 for remote SDR clients like SDR# or SDR++.
