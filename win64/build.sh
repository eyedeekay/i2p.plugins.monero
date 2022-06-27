#! /usr/bin/env sh
	
SIGNER_DIR="$HOME/i2p-go-keys/"

wget -c -O monero-win64.zip https://downloads.getmonero.org/cli/win64
unzip monero-win64.zip -d monero-cli-win64
mv monero-cli-win64/*/* monero-cli-win64/

cp -v i2ptunnel.config monero-cli-win64

VERSION=$(../linux64/monero-cli-linux64/monerod --version | sed 's/.*(\(.*\))/\1/' -)
cp monero-cli-win64/monerod.exe .
rm -vf client.yaml plugin.yaml
mkdir -p tmp/lib
cp -rv monero-cli-win64/* tmp/lib
cp ../i2ptunnel.config tmp/
i2p.plugin.native -name=monerod \
		-signer=hankhill19580@gmail.com \
		-signer-dir=$SIGNER_DIR \
		-version "$VERSION" \
		-author=hankhill19580@gmail.com \
		-autostart=true \
		-clientname=monerod \
		-consolename="Monero node over I2P" \
		-name="monerod-windows" \
		-delaystart="1" \
		-desc="Monero over I2P" \
		-exename=monerod.exe \
		-updateurl="http://idk.i2p/i2p.plugins.monero/monerod-windows.su3" \
		-website="http://idk.i2p/i2p.plugins.monero/" \
		-command="monerod.exe --tx-proxy=127.0.0.1:7952 --anonymous-inbound \"*.i2p,127.0.0.1:18083,100\"" \
		-license=MIT \
		-res=./tmp/