FROM node:24-bookworm-slim

ARG CLAUDE_CODE_VERSION=latest
ARG CODEX_VERSION=latest
ARG PI_VERSION=latest

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
      bash \
      ca-certificates \
      curl \
      git \
      jq \
      less \
      python3 \
      ripgrep \
      sudo \
      tmux \
    && rm -rf /var/lib/apt/lists/* \
    && echo 'node ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/node

RUN npm install -g \
      "@anthropic-ai/claude-code@${CLAUDE_CODE_VERSION}" \
      "@openai/codex@${CODEX_VERSION}" \
    && npm install -g --ignore-scripts \
      "@earendil-works/pi-coding-agent@${PI_VERSION}" \
    && npm cache clean --force

COPY entrypoint.sh /usr/local/bin/portable-agent
RUN chmod 0755 /usr/local/bin/portable-agent \
    && mkdir -p /workspace /home/node/.claude /home/node/.codex /home/node/.pi/agent /home/node/.agents \
    && chown -R node:node /workspace /home/node

USER node
WORKDIR /workspace
ENTRYPOINT ["/usr/local/bin/portable-agent"]
