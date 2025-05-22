FROM ubuntu:latest as builder

WORKDIR /app/

RUN apt update && apt install -y git libz-dev gcc make pkg-config

RUN git clone https://github.com/yarrick/iodine.git && cd iodine

RUN cd ./iodine && make

FROM ubuntu:latest

WORKDIR /app/

COPY --from=builder /app/iodine/bin/iodined .

COPY setup.sh .

RUN chmod +x setup.sh

RUN apt update && apt install -y iptables net-tools #openssh-server

RUN apt autoremove && apt autoclean

EXPOSE 53/UDP

#service ssh restart &&

CMD ./setup.sh && ./iodined -f 10.10.0.1 -P ${IODINE_PW} ${IODINE_DOMAIN}