FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update -qq \
    && apt-get install -y \
      bash \
      build-essential \
      cmake \
      git \
      make \
    && rm -rf /var/cache/apt/* /var/lib/apt/lists/*;

# build.sh knows how to compile
COPY build.sh /opt/

ENV SOURCES_DIR /sources
CMD ["/opt/build.sh"]