# [Choice] Ruby version (use -bullseye variants on local arm64/Apple Silicon): 3, 3.0, 2, 2.7, 2.6, 3-bullseye, 3.0-bullseye, 2-bullseye, 2.7-bullseye, 2.6-bullseye, 3-buster, 3.0-buster, 2-buster, 2.7-buster, 2.6-buster
ARG VARIANT=2.7-bullseye
FROM mcr.microsoft.com/vscode/devcontainers/ruby:0-${VARIANT}

# [Choice] Node.js version: none, lts/*, 16, 14, 12, 10
ARG NODE_VERSION="none"
RUN if [ "${NODE_VERSION}" != "none" ]; then su vscode -c "umask 0002 && . /usr/local/share/nvm/nvm.sh && nvm install ${NODE_VERSION} 2>&1"; fi

ARG USERNAME=vscode

RUN \
  mkdir -p /home/${USERNAME}/.vscode-server/extensions \
  /home/${USERNAME}/.vscode-server-insiders/extensions \
  && chown -R ${USERNAME} \
  /home/${USERNAME}/.vscode-server \
  /home/${USERNAME}/.vscode-server-insiders; \
  \
  SNIPPET="export PROMPT_COMMAND='history -a' && export HISTFILE=/commandhistory/.zsh_history" \
  && mkdir /commandhistory \
  && touch /commandhistory/.zsh_history \
  && chown -R ${USERNAME} /commandhistory \
  && echo ${SNIPPET} >> "/home/${USERNAME}/.zshrc"

ENV \
  APP_PORT=3000 \
  TZ="Europe/Berlin"

# [Optional] Uncomment this section to install additional OS packages.
RUN \
  apt-get update && export DEBIAN_FRONTEND=noninteractive; \
  apt-get -y install --no-install-recommends \
  libjemalloc-dev \
  libjemalloc2 \
  git \
  libcurl4-openssl-dev \
  libpq-dev \
  postgresql-client \
  ;

# [Optional] Uncomment this line to install global node packages.
# RUN su vscode -c "source /usr/local/share/nvm/nvm.sh && npm install -g <your-package-here>" 2>&1

ARG BUNDLER_VERSION=2.2.32
ENV \
  LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libjemalloc.so.2 \
  GEM_HOME=/bundle \
  BUNDLE_JOBS=4 \
  BUNDLE_RETRY=3
ENV BUNDLE_PATH ${GEM_HOME}
ENV \
  BUNDLE_APP_CONFIG=${BUNDLE_PATH} \
  BUNDLE_BIN=${BUNDLE_PATH}/bin

RUN \
  gem update --system; \
  gem install bundler -v ${BUNDLER_VERSION};

ENV \
  PATH=${BUNDLE_BIN}:${PATH}

################################################################################
# META

ARG BUILD_DATE
ARG VCS_REF
ARG VCS_URL
ARG VARIANT=2.7-bullseye

LABEL \
  org.label-schema.schema-version="1.0" \
  org.label-schema.vendor="Territory Embrace | Talentplatforms" \
  org.label-schema.vcs-url="${VCS_URL}" \
  org.label-schema.vcs-ref="${VCS_REF}" \
  org.label-schema.name="ruby" \
  org.label-schema.version="${VARIANT}" \
  org.label-schema.build-date="${BUILD_DATE}" \
  org.label-schema.description="dev ruby image"
