# syntax=docker/dockerfile:1

FROM burntnetwork/xion:sha-bff90b4

COPY  xion-testnet-1-setup.sh .

RUN chmod -x xion-testnet-1-setup

CMD bash ./xion-testnet-1-setup
