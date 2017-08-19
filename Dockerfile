FROM python:3

MAINTAINER Dmitry Ustalov <dmitry.ustalov@gmail.com>

EXPOSE 5000

WORKDIR /usr/src/app

COPY requirements.txt ./

RUN pip install --no-cache-dir -r requirements.txt

RUN \
curl -sL https://download.cdn.yandex.net/mystem/mystem-3.0-linux3.1-64bit.tar.gz | tar zx && \
mv mystem /bin && \
chmod +x /bin/mystem

COPY . .

RUN \
printf '1\t1\ta\t1\tb\n' > dummy.tsv && \
FLASK_APP=mnogoznal_web.py INVENTORY=dummy.tsv flask assets build && \
rm -fv dummy.tsv

USER nobody

CMD ["uwsgi", "--http", "0.0.0.0:5000", "--master", "--module", "mnogoznal_web:app", "--processes", "4", "--threads", "1", "--harakiri", "30"]
