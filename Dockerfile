FROM alpine:3.7
MAINTAINER Josh VanderLinden <codekoala@gmail.com>

RUN apk update && \
    apk add py3-pip && \
    pip3 install --upgrade pip && \
    mkdir -p /srv/pypi

# Install packages wich have build dependencies, remove them after installation
# because they are not required during runtime.
RUN apk add --no-cache --virtual .build-deps \
        gcc \
        libc-dev \
        libffi-dev \
        python3-dev && \
    pip install bcrypt && \
    apk del --no-cache .build-deps

RUN pip install -U passlib pypiserver[cache]==1.3.1

EXPOSE 80
VOLUME ["/srv/pypi"]

ADD entrypoint.sh /
CMD ["/entrypoint.sh"]
