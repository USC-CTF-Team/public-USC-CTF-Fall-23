FROM python:3.10
MAINTAINER Dhyey

RUN apt update \
  && apt install -y sagemath socat python3-pip \
  && pip3 install pycryptodome sympy \
  && rm -rf /var/lib/apt/lists/* \
  && useradd -m chal

RUN sage --python -m pip install --break-system-packages pycryptodome

WORKDIR /opt/chal

COPY flag.txt .
COPY server.sage .
COPY curves.json .

RUN chown chal:chal /opt/chal

USER chal
CMD ["socat", "-T300", "TCP-LISTEN:5000,reuseaddr,fork", "EXEC:/usr/bin/sage /opt/chal/server.sage,pty,echo=0"]
