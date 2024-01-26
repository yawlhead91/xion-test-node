# syntax=docker/dockerfile:1

FROM burntnetwork/xion:sha-bff90b4

COPY  xion-testnet-1-setup.sh .

CMD xiond init testnet-node-1 \
    --chain-id xion-testnet-1 \
    && bash ./xion-testnet-1-setup.sh \
    && xiond start --x-crisis-skip-assert-invariants -home /home/xiond/.xiond
