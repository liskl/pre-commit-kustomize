ARG KSOPS_VERSION="v4.1.1"

FROM viaductoss/ksops:$KSOPS_VERSION as ksops-builder


FROM alpine:latest

ENV kustomize_version v5.0.1
ENV kustomize_sha265 dca623b36aef84fbdf28f79d02e9b3705ff641424ac1f872d5420dadb12fb78d

RUN adduser kustomize -D \
  && apk add curl git openssh \
  && git config --global url.ssh://git@github.com/.insteadOf https://github.com/
RUN  curl -L --output /tmp/kustomize_${kustomize_version}_linux_amd64.tar.gz https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2F${kustomize_version}/kustomize_${kustomize_version}_linux_amd64.tar.gz \
  && echo "${kustomize_sha265}  /tmp/kustomize_${kustomize_version}_linux_amd64.tar.gz" | sha256sum -c \
  && tar -xvzf /tmp/kustomize_v5.0.1_linux_amd64.tar.gz -C /usr/local/bin \
  && chmod +x /usr/local/bin/kustomize \
  && mkdir ~/.ssh \
  && ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts

# Switch to root for the ability to perform install
USER root

# Set the kustomize home directory
ENV XDG_CONFIG_HOME=$HOME/.config
ENV KUSTOMIZE_PLUGIN_PATH=$XDG_CONFIG_HOME/kustomize/plugin/

ARG PKG_NAME=ksops

# Override the default kustomize executable with the Go built version
#COPY --from=ksops-builder /go/bin/kustomize /usr/local/bin/kustomize

# Copy the plugin to kustomize plugin path
COPY --from=ksops-builder /go/src/github.com/viaduct-ai/kustomize-sops/ksops  $KUSTOMIZE_PLUGIN_PATH/viaduct.ai/v1/${PKG_NAME}/

USER kustomize
WORKDIR /src
