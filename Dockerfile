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
USER kustomize
WORKDIR /src
