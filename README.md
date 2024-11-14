

# ESP8266 Build System 

This Dockerfile sets up a development environment specifically for the ESP8266, which is used in our legacy projects. It plays a key role in migrating older devices to our new infrastructure, ensuring a smooth transition.

**What it does**:

1. **ESP8266 Development**: Prepares the environment with the ESP8266 RTOS SDK and Xtensa toolchain, which are required to build and deploy code to ESP8266 devices.
2. **Consistency and Portability**: By using a Docker container, the environment can be easily shared, ensuring consistency across different development machines without the need for manual setup.
3. **Tooling**: Installs essential system and Python tools for compiling and managing ESP8266 firmware projects, including libraries and dependencies.
4. **Custom Commands**: Includes configurations and aliases to simplify access to toolchain paths, making it quicker to start using the ESP8266 SDK.

This setup is particularly may useful for IoT developers who need a controlled, ready-to-go environment for ESP8266 firmware development and testing.


### Supported IC

- ESP8266
- ESP8285

### Requirements

The host computer must have Docker installed, along with `esptool.py` for flashing and working with the hardware.

### Usage

First, obtain the repository and build the Docker image and clone
the `ESP8266_RTOS_SDK` from GitHub to get the examples for a quick start

```
./bld image
```

Next, Copy the `hello_world` example from the SDK to your current folder:

```
cp -r ./ESP8266_RTOS_SDK/examples/get-started/hello_world .
```

Copy the `bld` script into the `hello_world` folder:

```
cp bld hello_world
```

Run `menuconfig` inside the container in interactive mode:

```
cd hello_world
./bld shell
```

Once inside the container, run:

```
make menuconfig
```

In the menu, navigate to `Serial flasher config` > `Default serial port` to configure the serial port. Set the default baud rate to `460800`, change `Flash SPI mode` to `DOUT`, and adjust the `Flash size` to `4MB` (depending on your device). Confirm your selections by pressing Enter, save the configuration by selecting `< Save >`, and then exit the application by selecting `< Exit >`.

Exit from container you are ready!

```
exit
```

#### Build Project

Once you are outside the container in the `hello_world` project directory, run:

```
./bld all
```

> **Note**: This script essentially executes the following command:
> `docker run --rm -v "$PWD":/root/esp/build -w /root/esp/build my-esp8266-build make all`

This command runs `make all` inside the container. The build process may take some time, but if everything is set up correctly, the output should indicate a successful build.

```
Building project...
esptool.py v4.8.1
Serial port /dev/cu.usbserial-11330
Connecting....
Chip is ESP8266EX
Features: WiFi
Crystal is 26MHz
MAC: d8:f1:5b:12:6b:9f
Uploading stub...
Running stub...
Stub running...
Changing baud rate to 460800
......
```







