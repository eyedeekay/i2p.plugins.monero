#! /usr/bin/env sh
	
SIGNER_DIR="$HOME/i2p-go-keys/"

wget -c -O monero-linux64.tar.bz2 https://downloads.getmonero.org/cli/linux64
mkdir -p monero-cli-linux64
tar -xjf monero-linux64.tar.bz2 -C monero-cli-linux64 --strip-components=1

wget -c -O monero-win64.zip https://downloads.getmonero.org/cli/win64
unzip monero-win64.zip -d monero-cli-win64
mv monero-cli-win64/*/* monero-cli-win64/

cp -v i2ptunnel.config monero-cli-linux64
cp monero-cli-linux64/monerod .
VERSION=$(./monero-cli/monerod --version | sed 's/.*(\(.*\))/\1/' -)
rm -vf client.yaml plugin.yaml
mkdir -p tmp-lin/lib
cp -rv monero-cli-linux64/* tmp-lin/lib
i2p.plugin.native -name=monerod \
		-signer=hankhill19580@gmail.com \
		-signer-dir=$SIGNER_DIR \
		-version "$VERSION" \
		-author=hankhill19580@gmail.com \
		-autostart=true \
		-clientname=monerod \
		-consolename="Monero node over I2P" \
		-name="monerod-linux" \
		-delaystart="1" \
		-desc="Monero over I2P" \
		-exename=monerod \
		-updateurl="http://idk.i2p/railroad/monerod-linux.su3" \
		-website="http://idk.i2p/i2p.plugins.monero/" \
		-command="monerod --tx-proxy=127.0.0.1:7952 --anonymous-inbound \"*.i2p,127.0.0.1:18083,100\"" \
		-license=MIT \
		-res=./tmp-lin/

cp monero-cli-win64/monerod.exe .
rm -vf client.yaml plugin.yaml
mkdir -p tmp-win/lib
cp -rv monero-cli-win64/* tmp-win/lib
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
		-res=./tmp-win/