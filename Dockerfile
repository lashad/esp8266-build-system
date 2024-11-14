# Start with the latest Debian image
FROM --platform=linux/amd64 debian:buster

# Set the HOME environment variable explicitly
ENV HOME=/root

# Update the package list and install system packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        gcc \
        git \
        wget \
        make \
        libncurses-dev \
        flex \
        bison \
        gperf \
        python \
        python-serial \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update
RUN apt install -y --no-install-recommends python-pip
RUN pip install setuptools wheel

# Create directory for ESP tools, download the xtensa toolchain, and extract it
RUN mkdir -p $HOME/esp && \
    cd $HOME/esp && \
    wget https://dl.espressif.com/dl/xtensa-lx106-elf-gcc8_4_0-esp-2020r3-linux-amd64.tar.gz && \
    tar -xzf xtensa-lx106-elf-gcc8_4_0-esp-2020r3-linux-amd64.tar.gz

# Set the working directory
WORKDIR $HOME/esp

RUN git clone --recursive https://github.com/espressif/ESP8266_RTOS_SDK.git

ENV IDF_PATH=/root/esp/ESP8266_RTOS_SDK

# Copy requirements.txt into the desired directory
COPY requirements.txt /root/esp/ESP8266_RTOS_SDK/requirements.txt

RUN python -m pip install --user -r $IDF_PATH/requirements.txt

# Add xtensa toolchain to PATH
ENV PATH="$PATH:$HOME/esp/xtensa-lx106-elf/bin"

# Create an alias for adding the xtensa toolchain to PATH dynamically
RUN echo 'alias get_lx106="export PATH=\\"$PATH:$HOME/esp/xtensa-lx106-elf/bin\\""' >> /etc/profile

# Default command
CMD ["/bin/bash"]
