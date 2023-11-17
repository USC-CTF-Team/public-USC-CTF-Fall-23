# Need ubuntu because playwright
FROM ubuntu:latest

RUN apt-get update && \
    apt-get install -y --no-install-recommends socat xvfb xauth python3-pip

# playwright deps... smh
RUN apt-get install -y libglib2.0-0\
          libnss3\
          libnspr4\
          libatk1.0-0\
          libatk-bridge2.0-0\
          libcups2\
          libdbus-1-3\
          libatspi2.0-0\
          libxcomposite1\
          libxdamage1\
          libxrandr2\
          libgbm1\
          libxkbcommon0\
          libpango-1.0-0\
          libcairo2\
          libasound2

RUN python3 -m pip install pipenv

WORKDIR /bot
COPY ./extension /extension
COPY ./bot /bot
COPY ./flag.txt .

RUN PIPENV_VENV_IN_PROJECT=1 pipenv install --system --deploy

RUN groupadd -r bot
RUN useradd -r -m -g bot bot # home directory required by playwright
RUN chown -R bot:bot /bot
USER bot

RUN playwright install
RUN rm -rf /home/bot/.cache/ms-playwright/webkit-* /home/bot/.cache/ms-playwright/firefox-*


CMD ["socat", "-T300", "TCP-LISTEN:5000,reuseaddr,fork", "EXEC:xvfb-run --auto-servernum --server-num=1 python3 ./bot.py,pty,echo=0"]

