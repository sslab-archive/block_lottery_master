chaincodeName="lottery"
chaincodeVersion="v0"
chaincodeType="golang"
chaincodePath="github.com/block_lottery_cc"
channelName="mychannel"
userName="SERVICE_PROVIDER_1"
orgName="Org1"

echo "POST request Enroll on Org1  ..."
echo
ORG1_TOKEN=$(curl -s -X POST \
  http://localhost:4000/users \
  -H "user-name: $userName" \
  -H "org-name: $orgName")

echo "finish enroll..."

peers="[\"peer0.org1.example.com\",
        \"peer1.org1.example.com\"
        ]"


function createChannels() {
    curl -s -X POST \
        http://localhost:4000/channels \
	-H "user-name: $userName" \
	-H "org-name: $orgName" \
        -H "content-type: application/json" \
        -d '{
            "channelName":"mychannel",
            "channelConfigPath":"../artifacts/channel/mychannel.tx"
        }'  
}

function joinChannel() {
    reqBody="{
        \"peers\": $peers
    }"
    curl -s -X POST \
        http://localhost:4000/channels/mychannel/peers \
        -H "user-name: $userName" \
	-H "org-name: $orgName" \
	-H "content-type: application/json" \
        -d "$reqBody"
}

function chaincodesInstall() {
    reqBody="{
        \"chaincodeName\":\"$chaincodeName\",
        \"chaincodePath\":\"$chaincodePath\",
        \"chaincodeType\": \"$chaincodeType\",
        \"chaincodeVersion\":\"$chaincodeVersion\",
        \"peers\": $peers
    }"
    curl -s -X POST \
        http://localhost:4000/chaincodes \
	-H "user-name: $userName" \
	-H "org-name: $orgName" \
        -H "content-type: application/json" \
        -d "$reqBody"
}

function chaincodesInstantiate() {

    reqBody="{
        \"chaincodeName\":\"$chaincodeName\",
        \"chaincodeType\": \"$chaincodeType\",
        \"chaincodeVersion\":\"$chaincodeVersion\",
        \"peers\": [\"peer0.org1.example.com\"],
	\"args\":[] }"
    curl -s -X POST \
        http://localhost:4000/channels/mychannel/chaincodes \
	-H "user-name: $userName" \
	-H "org-name: $orgName" \
        -H "content-type: application/json" \
        -d "$reqBody"
}

function chaincodesUpgrade() {
    reqBody="{
        \"chaincodeName\":\"$chaincodeName\",
        \"chaincodeType\": \"$chaincodeType\",
        \"chaincodeVersion\":\"$chaincodeVersion\",
        \"peers\": $peers,
        \"args\":[\"\"]
    }"
    curl -s -X POST \
        http://localhost:4000/channels/mychannel/chaincodes/upgrade \
        -H "user-name: $userName" \
	-H "org-name: $orgName" \
	-H "content-type: application/json" \
        -d "$reqBody"
}

function networkInitialize() {
    echo "create channels..."
    createChannels
    echo "join channels..."
    joinChannel
    echo "chaincodes Install..."
    chaincodesInstall
    echo "chaincodes Instantiate..."
    chaincodesInstantiate
}


networkInitialize



