ARG UPSTREAM_VERSION=17-3.4
ARG UPSTREAM_IMAGE=ghcr.io/cloudnative-pg/postgis:${UPSTREAM_VERSION}
FROM $UPSTREAM_IMAGE

USER root


# Install additional extensions
RUN set -xe; \
  apt-get update; \
  apt-get install -y --no-install-recommends \
  "wget" \
  ; \
  rm -fr /tmp/* ; \
  rm -rf /var/lib/apt/lists/*;

# borrowed from https://gitlab.com/mishak/cloudnative-pg-vectors/-/blob/19c889e36491190dc888b1924d3a6b4dd10fab11/Dockerfile

ARG VECTORS_VERSION=0.2.0
RUN if [ $(dpkg --print-architecture) = "amd64" ]; then \
  VECTORS_ARCH=amd64; \
  elif [ $(dpkg --print-architecture) = "arm64" ]; then \
  VECTORS_ARCH=arm64; \
  else \
  >&2 echo "Unsupported architecture" && exit 1; \
  fi \
  && wget -nv -O vectors.deb https://github.com/tensorchord/pgvecto.rs/releases/download/v${VECTORS_VERSION}/vectors-pg${PG_MAJOR}_${VECTORS_VERSION}_${VECTORS_ARCH}.deb \
  && dpkg -i vectors.deb \
  && rm vectors.deb


USER 26
