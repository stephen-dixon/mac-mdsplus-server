FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

ARG MDSPLUS_URL=https://github.com/MDSplus/mdsplus/releases/download/alpha_release-7-158-5/mdsplus_alpha_7.158.5_Ubuntu24_arm64_debs.tgz

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    wget \
    tar \
    netbase \
    python3-minimal \
 && rm -rf /var/lib/apt/lists/*

RUN wget -O /tmp/mdsplus_debs.tgz "$MDSPLUS_URL" \
 && mkdir -p /tmp/mdsplus_debs \
 && tar -xzf /tmp/mdsplus_debs.tgz -C /tmp/mdsplus_debs \
 && apt-get update \
 && apt-get install -y --no-install-recommends \
      /tmp/mdsplus_debs/mdsplus-alpha-kernel_bin_7.158.5_arm64.deb \
      /tmp/mdsplus_debs/mdsplus-alpha-kernel_7.158.5_arm64.deb \
 && rm -rf /tmp/mdsplus_debs /tmp/mdsplus_debs.tgz /var/lib/apt/lists/*

ENV test_path=/trees/test
ENV PATH=/usr/local/mdsplus/bin:/mdsplus/bin:${PATH}
ENV LD_LIBRARY_PATH=/usr/local/mdsplus/lib:/mdsplus/lib:${LD_LIBRARY_PATH}

RUN which mdstcl && which mdsip

WORKDIR /work
