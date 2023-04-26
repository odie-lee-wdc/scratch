FROM debian:bullseye-20221114

ENV DEBIAN_SNAPSHOT=20221114T000000Z

RUN echo 'Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/00snapshot
RUN echo 'Acquire::Retries "5";' > /etc/apt/apt.conf.d/80-retries
RUN echo "deb http://snapshot.debian.org/archive/debian/${DEBIAN_SNAPSHOT} bullseye main" > /etc/apt/sources.list
RUN echo "deb http://snapshot.debian.org/archive/debian-security/${DEBIAN_SNAPSHOT} bullseye-security main" >> /etc/apt/sources.list
RUN echo "deb http://snapshot.debian.org/archive/debian/${DEBIAN_SNAPSHOT} bullseye-updates main" >> /etc/apt/sources.list

# Install basic packages
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y \
apt-utils apt-file pkg-config git vim sudo net-tools locales pax \
wget curl intltool tree build-essential devscripts ca-certificates python \
libncurses-dev bc squashfs-tools \
automake autotools-dev autoconf autopoint autoconf-archive \
libltdl-dev libtool debhelper \
gettext bison texinfo doxygen cmake help2man chrpath \
flex nasm cdbs dh-exec quilt mingw-w64 gperf dejagnu lsb-release cpio \
systemd sharutils time zip xsltproc libxml2-dev zlib1g-dev libselinux1-dev \
dh-php uuid-dev libblkid-dev libdevmapper-dev libpopt-dev libreadline-dev unzip \
dos2unix libusb-dev libssl-dev libsdl1.2-dev openssh-client gawk \
lib32z1 libssl-dev libswitch-perl python3-distutils openjdk-11-jre cppcheck cloc iputils-ping


RUN DEBIAN_FRONTEND=noninteractive apt-get upgrade -y

RUN dpkg --add-architecture arm64
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y crossbuild-essential-arm64 u-boot-tools libelf-dev libssl-dev:arm64 libz-dev:arm64 libcurl4-openssl-dev:arm64 libcunit1-dev:arm64

RUN mkdir -p /opt/rust
RUN curl https://sh.rustup.rs -sSf | env RUSTUP_HOME=/opt/rust/rustup CARGO_HOME=/opt/rust/cargo sh -s -- --default-host x86_64-unknown-linux-gnu --profile minimal --default-toolchain=1.66.1 --target aarch64-unknown-linux-gnu --no-modify-path -y
RUN echo "[target.aarch64-unknown-linux-gnu]" >> /opt/rust/cargo/config
RUN echo "linker = \"aarch64-linux-gnu-gcc\"" >> /opt/rust/cargo/config
RUN env RUSTUP_HOME=/opt/rust/rustup CARGO_HOME=/opt/rust/cargo PATH=/opt/rust/cargo/bin:$PATH rustup component add clippy

# install gosu from https://github.com/tianon/gosu/releases
# ref: https://denibertovic.com/posts/handling-permissions-with-docker-volumes/
COPY gosu-amd64 /usr/local/bin/gosu
RUN chmod +x /usr/local/bin/gosu
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# sudo without password
COPY sudoers /etc/sudoers

# fix /bin/bash link
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
WORKDIR /home/user/build
RUN apt-get update
