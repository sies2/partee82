#!/bin/sh

# Global variables
DIR_CONFIG="/etc/v2ray"
DIR_RUNTIME="/usr/bin"
DIR_TMP="$(mktemp -d)"

uuidone=3f05afb6-5982-4081-be07-813fcedf967e
uuidtwo=af27e977-7438-4978-8790-b54de5b4a818
uuidthree=9dc799b5-cf23-4295-a567-a4977312aaa0
uuidfour=161db3de-97ac-405a-818b-e9881b8340b5
uuidfive=8c0f627e-d7b2-42f0-9d77-ede3adc03032
mypath=/fiswle-myww21le
myport=8080


# Write V2Ray configuration
cat << EOF > ${DIR_TMP}/myconfig.pb
{
	"inbounds": [
		{
			"listen": "0.0.0.0",
			"port": $myport,
			"protocol": "vless",
			"settings": {
				"decryption": "none",
				"clients": [
					{
						"id": "$uuidone"
					},
					{
						"id": "$uuidtwo"
					},
					{
						"id": "$uuidthree"
					},
					{
						"id": "$uuidfour"
					},
					{
						"id": "$uuidfive"
					}
				]
			
		},
		"streamSettings": {
			"network": "ws",
			"wsSettings": {
					"path": "$mypath"
				}
			}
		}
	],
	"outbounds": [
		{
			"protocol": "freedom"
		}
	]
}
EOF

# Get V2Ray executable release
curl --retry 10 --retry-max-time 60 -H "Cache-Control: no-cache" -fsSL github.com/v2fly/v2ray-core/releases/latest/download/v2ray-linux-64.zip -o ${DIR_TMP}/v2ray_dist.zip
unzip ${DIR_TMP}/v2ray_dist.zip -d ${DIR_TMP}

# Convert to protobuf format configuration
mkdir -p ${DIR_CONFIG}
mv -f ${DIR_TMP}/myconfig.pb ${DIR_CONFIG}/myconfig.json

# Install V2Ray
install -m 755 ${DIR_TMP}/v2ray ${DIR_RUNTIME}
rm -rf ${DIR_TMP}

# Run V2Ray
${DIR_RUNTIME}/v2ray run -config=${DIR_CONFIG}/myconfig.json
