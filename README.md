# jetson-ppa
Build scripts and infrastructure to publish Jetson-optimized software to a custom apt repository.

# Usage

To use the software published in this repository, you need to add the repository to your apt sources. To do this, run the following commands (assuming Jetson R32.7):

```bash
wget -qO- https://ppa-jetson-r32.s3.us-east-1.amazonaws.com/jhurliman-public-key.asc | sudo gpg --no-default-keyring --keyring /usr/share/keyrings/jhurliman.gpg --import
echo "deb [signed-by=/usr/share/keyrings/jhurliman.gpg] https://ppa-jetson-r32.s3.us-east-1.amazonaws.com/jetson/common r32.7 main" | sudo tee /etc/apt/sources.list.d/jetson-ppa.list
sudo apt update
```

You can then upgrade OpenCV to a Jetson-optimized build of 4.10.0 with the following command:

```bash
sudo apt upgrade nvidia-jetpack
```

Or if you are only interested in OpenCV and do not have JetPack installed:

```bash
sudo apt install libopencv-dev
```

# Development

Docker is the only dependency for the build process, and QEMU if you are not on an ARM64 machine.

```bash
./scripts/build-opencv-jetson-r32.sh
```

Publishing requires `GPG_PUBLIC_KEY` and `GPG_PRIVATE_KEY` environment variables to be set, then run:

```bash
./scripts/publish-opencv-jetson-r32.sh
```
