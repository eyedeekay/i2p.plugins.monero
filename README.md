# i2p.plugins.monero

Automatically sets up a Monero node behind I2P using the official builds
of `monerod` from [GetMonero](https://getmonero.com). By installing this
plugin on a Java I2P router, you can automatically set up a Monero node
which will accept API commands and send/recieve transactions on the I2P
network *only*, without touching either Tor or the non-anonymous parts of
the internet.

## Why do things this way?

- Easy Installation
- Safe Hidden Service Management
- Hide the presence of your Monero node from network observers
- Proliferate and Encourage Monero nodes within the I2P network

## What is it actually doing?

All a `ShellService` is, ultimately, is an application which is being managed
by the I2P ClientAppManager. By letting I2P manage the application, you can
provide valuable assurances when deploying an I2P-only Monero node.

1. By shipping an `i2ptunnel.config` file, you can assure that the tunnels you
 need are available on the ports which you expect.
2. By letting I2P manage the application you allow I2P to manage the lifecycle
 of the application and the hidden service together. The application and hidden
 service will shut down when the I2P router shuts down.
3. You can provide signed, authenticated, automatic updates to users on the I2P
 network while preserving your user's anonymity.

The actual build scripts(`build.sh` in each corresponding platform directory)
First it simply download the binary packages of the Monero CLI from the Monero website,
and unpacks them.

```sh
wget -c -O monero-linux64.tar.bz2 https://downloads.getmonero.org/cli/linux64
mkdir -p monero-cli-linux64
tar -xjf monero-linux64.tar.bz2 -C monero-cli-linux64 --strip-components=1
```

Then it copies some files into a working directory:

```sh
cp -v i2ptunnel.config monero-cli-linux64
cp monero-cli-linux64/monerod .
VERSION=$(../linux64/monero-cli-linux64/monerod --version | sed 's/.*(\(.*\))/\1/' -)
rm -vf client.yaml plugin.yaml #cleans up old yaml files since the script will regenerate them
mkdir -p tmp/lib
cp -rv monero-cli-linux64/* tmp/lib
cp ../i2ptunnel.config tmp/
```

And finally, passes the resulting unpacked files, along with some
custom command-line flags, to the `ShellService` configuration
generator:

```sh
i2p.plugin.native -name=monerod \
    -signer=hankhill19580@gmail.com \
    -signer-dir=$SIGNER_DIR \
    -version "$VERSION" \
    -author=hankhill19580@gmail.com \
    -autostart=true \
    -clientname=monerod \
    -consolename="Monero node over I2P" \
    -name="monerod-linux64" \
    -delaystart="1" \
    -desc="Monero over I2P" \
    -exename=monerod \
    -updateurl="http://idk.i2p/railroad/monerod-linux64.su3" \
    -website="http://idk.i2p/i2p.plugins.monero/" \
    -command="monerod --tx-proxy=127.0.0.1:7952 --anonymous-inbound \"*.i2p,127.0.0.1:18083,100\"  --add-peer core5hzivg4v5ttxbor4a3haja6dssksqsmiootlptnsrfsgwqqa.b32.i2p --add-peer dsc7fyzzultm7y6pmx2avu6tze3usc7d27nkbzs5qwuujplxcmzq.b32.i2p --add-peer sel36x6fibfzujwvt4hf5gxolz6kd3jpvbjqg6o3ud2xtionyl2q.b32.i2p --add-peer yht4tm2slhyue42zy5p2dn3sft2ffjjrpuy7oc2lpbhifcidml4q.b32.i2p --add-peer snbrpdeug2vuojer6ql6ozcbdzddxbdbi3yiv7avchwnzzocrlaq.b32.i2p" \
    -license=MIT \
    -res=./tmp/
```

All-together, this example script will build the plugin for Linux, AMD64.

```sh
#! /usr/bin/env sh
	
SIGNER_DIR="$HOME/i2p-go-keys/"

wget -c -O monero-linux64.tar.bz2 https://downloads.getmonero.org/cli/linux64
mkdir -p monero-cli-linux64
tar -xjf monero-linux64.tar.bz2 -C monero-cli-linux64 --strip-components=1

cp -v i2ptunnel.config monero-cli-linux64
cp monero-cli-linux64/monerod .
VERSION=$(../linux64/monero-cli-linux64/monerod --version | sed 's/.*(\(.*\))/\1/' -)
rm -vf client.yaml plugin.yaml
mkdir -p tmp/lib
cp -rv monero-cli-linux64/* tmp/lib
cp ../i2ptunnel.config tmp/
i2p.plugin.native -name=monerod \
    -signer=hankhill19580@gmail.com \
    -signer-dir=$SIGNER_DIR \
    -version "$VERSION" \
    -author=hankhill19580@gmail.com \
    -autostart=true \
    -clientname=monerod \
    -consolename="Monero node over I2P" \
    -name="monerod-linux64" \
    -delaystart="1" \
    -desc="Monero over I2P" \
    -exename=monerod \
    -updateurl="http://idk.i2p/railroad/monerod-linux64.su3" \
    -website="http://idk.i2p/i2p.plugins.monero/" \
    -command="monerod --tx-proxy=127.0.0.1:7952 --anonymous-inbound \"*.i2p,127.0.0.1:18083,100\"  --add-peer core5hzivg4v5ttxbor4a3haja6dssksqsmiootlptnsrfsgwqqa.b32.i2p --add-peer dsc7fyzzultm7y6pmx2avu6tze3usc7d27nkbzs5qwuujplxcmzq.b32.i2p --add-peer sel36x6fibfzujwvt4hf5gxolz6kd3jpvbjqg6o3ud2xtionyl2q.b32.i2p --add-peer yht4tm2slhyue42zy5p2dn3sft2ffjjrpuy7oc2lpbhifcidml4q.b32.i2p --add-peer snbrpdeug2vuojer6ql6ozcbdzddxbdbi3yiv7avchwnzzocrlaq.b32.i2p" \
    -license=MIT \
    -res=./tmp/
```

And that's all it takes to make a native application into an I2P plugin.

## Should I use these(Referring to hypothetical binaries I might upload)

Not yet maybe? I would like to improve the means by which I authenticate
the Monero packages which I download, unpack, repackage as I2P plugins and
sign with my plugin keys. Assuming the TLS certificate for getmonero.com is
being correctly authenticated by the CA store on my laptop, and that the
Monero packages themselves are not compromised, then... it's probably safe?
This was born as a demo for Konferenco 2022, and was intended to demonstrate
integrating applications with I2P using the tools we make available. In this
case, the `ShellService` plugin is used to wrap the `monerod` application.

That said, I'm not doing anything magical here, I'm taking a zip file and turning it
into a slightly different kind of zip file. Anybody who has a Go compiler and a bash
shell installed can generate their own plugin zip files and if they wish, sign them.
I use `i2p.plugin.native` to do the `.su3` file generation, which you can obtain:
[from my gitlab](https://i2pgit.org/idk/i2p.plugin.native).
