# syntax=docker/dockerfile:1

FROM burntnetwork/xion:sha-bff90b4



ENV BASEDIR="/home/xiond/.xiond"
ARG MONIKER="testnet-node-1"
ARG GENESIS_JSON="https://files.xion-testnet-1.burnt.com/genesis.json"
ARG SEED_NODE="7900d5f177228def24170f9631db76afab20278e@seed.xion-testnet-1.burnt.com:11656"
ARG ADDRBOOK_JSON="https://files.xion-testnet-1.burnt.com/addrbook.json"
ARG SNAP_RPC="https://rpc.xion-testnet-1.burnt.com:443"
#ARG TAR_LZ4="https://files.xion-testnet-1.burnt.com/xion-testnet-1-latest.tar.lz4"

RUN xiond init $MONIKER --chain-id xion-testnet-1 --home $BASEDIR
RUN curl $GENESIS_JSON -o ${BASEDIR}/config/genesis.json -s
RUN sed -i.bak -E "s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"$SEED_NODE\"|" ${BASEDIR}/config/config.toml
RUN curl ${ADDRBOOK_JSON} -o ${BASEDIR}/config/addrbook.json -s
#RUN curl -o - -L ${TAR_LZ4} | lz4 -c -d - | tar -x -v -C ${BASEDIR}

RUN export LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
export BLOCK_HEIGHT=$((LATEST_HEIGHT - 1000)); \
export TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash); \
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $BASEDIR/config/config.toml

CMD ["sh", "-c", "xiond start --x-crisis-skip-assert-invariants --home ${BASEDIR}"]
