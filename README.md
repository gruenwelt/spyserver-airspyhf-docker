# spyserver-docker

A Docker container that builds and installs the required `libairspyhf` driver for `sypserver` and runs the precompiled `spyserver` in a container.

Tested to run on Orange Pi Zero 2W and Airspy Discovery HF+ and remote connected from a Mac with SDR++ 2 installed. Should be able to run on other arm64 single-board computers like Raspberry Pi or other linux computers.

---

## 📦 Prerequisites

- A Linux system with Docker >= 20.10
- An Airspy device such as Airspy Discovery HF+
- Another device such as Mac or PC with a SDR receiver software such as SDR++ 2 installed for remote connection.
- Docker BuildKit enabled
- An SSH key registered with your GitHub account
- The spyserver file `spyserver*.tar` downloaded from https://airspy.com/download and placed in the same folder as the Dockerfile

---

## 🏗️ Build the Docker image
```bash
docker build --ssh default -t spyserver-airspyhf .
```

---

## 🚀 Run the container
```bash
docker run -d \
  --name spyserver-airspyhf-container \
  --device=/dev/bus/usb \
  -p 5555:5555 \
  --restart unless-stopped \
  spyserver-airspyhf
```

---

## 👉 Notes

- You must manually download and provide the `spyserver*.tar` file.
- The container exposes port 5555 for remote SDR clients like SDR# or SDR++.
