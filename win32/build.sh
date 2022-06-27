#! /usr/bin/env sh
	
SIGNER_DIR="$HOME/i2p-go-keys/"

wget -c -O monero-win32.zip https://downloads.getmonero.org/cli/win32
unzip monero-win32.zip -d monero-cli-win32
mv monero-cli-win32/*/* monero-cli-win32/

cp -v i2ptunnel.config monero-cli-win32

VERSION=$(../linux64/monero-cli-linux64/monerod --version | sed 's/.*(\(.*\))/\1/' -)
cp monero-cli-win32/monerod.exe .
rm -vf client.yaml plugin.yaml
mkdir -p tmp/lib
cp -rv monero-cli-win32/* tmp/lib
cp ../i2ptunnel.config tmp/
i2p.plugin.native -name=monerod \
		-signer=hankhill19580@gmail.com \
		-signer-dir=$SIGNER_DIR \
		-version "$VERSION" \
		-author=hankhill19580@gmail.com \
		-autostart=true \
		-clientname=monerod \
		-consolename="Monero node over I2P" \
		-name="monerod-win32" \
		-delaystart="1" \
		-desc="Monero over I2P" \
		-exename=monerod.exe \
		-updateurl="http://idk.i2p/i2p.plugins.monero/monerod-win32.su3" \
		-website="http://idk.i2p/i2p.plugins.monero/" \
		-command="monerod.exe --tx-proxy=127.0.0.1:7952 --anonymous-inbound \"*.i2p,127.0.0.1:18083,100\"  --add-peer core5hzivg4v5ttxbor4a3haja6dssksqsmiootlptnsrfsgwqqa.b32.i2p --add-peer dsc7fyzzultm7y6pmx2avu6tze3usc7d27nkbzs5qwuujplxcmzq.b32.i2p --add-peer sel36x6fibfzujwvt4hf5gxolz6kd3jpvbjqg6o3ud2xtionyl2q.b32.i2p --add-peer yht4tm2slhyue42zy5p2dn3sft2ffjjrpuy7oc2lpbhifcidml4q.b32.i2p" \
		-license=MIT \
		-res=./tmp/