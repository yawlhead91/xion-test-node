#!/usr/bin/env bash
set -euxo pipefail

BASEDIR="/home/xiond/.xiond"
GENESIS_JSON="https://files.xion-testnet-1.burnt.com/genesis.json"
SEED_NODE="7900d5f177228def24170f9631db76afab20278e@seed.xion-testnet-1.burnt.com:11656"
ADDRBOOK_JSON="https://files.xion-testnet-1.burnt.com/addrbook.json"
SNAP_RPC="https://rpc.xion-testnet-1.burnt.com:443"

curl ${GENESIS_JSON} -o ${BASEDIR}/config/genesis.json -s
sed -i.bak -E "s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"$SEED_NODE\"|" ${BASEDIR}/config/config.toml
curl ${ADDRBOOK_JSON} -o ${BASEDIR}/config/addrbook.json -s


LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 1000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.burnt/config/config.toml


