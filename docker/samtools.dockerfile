FROM clearlinux:latest AS builder

# Download and install mamba into /usr/bin
ENV MAMBAFORGE_VERSION=4.10.3-1
RUN swupd bundle-add --no-progress curl && \
    curl -sL https://github.com/conda-forge/miniforge/releases/download/${MAMBAFORGE_VERSION}/Mambaforge-pypy3-Linux-x86_64.sh -o /tmp/mambaforge.sh && \
    sh /tmp/mambaforge.sh -bfp /usr && rm -f /tmp/mambaforge.sh

# Install a minimal versioned OS into /install_root
ENV CLEAR_VERSION=34810
RUN swupd os-install --no-progress --no-boot-update --no-scripts \
    --version ${CLEAR_VERSION} \
    --path /install_root \
    --statedir /swupd-state \
    --bundles os-core,procps-ng

# Use mamba to install remaining tools/dependencies into /usr/local
ENV SAMTOOLS_VERSION=1.10
RUN mamba create -qy -p /usr/local \
        -c bioconda \
        samtools==${SAMTOOLS_VERSION}


# Deploy the minimal OS and target tools into a blank image
FROM scratch
COPY --from=builder /install_root /
COPY --from=builder /usr/local /usr/local

LABEL Author="Adrian Flannery" \
      Maintainer="aflannery@uabmc.edu"

# BUILD_CMD: docker build -t aflanry/samtools:1.10 - < samtools.dockerfile