# syntax=docker/dockerfile:experimental
FROM alpine:3.10

# Install ssh client and git
RUN apk add --no-cache openssh-client git

# Download public key for github.com
RUN mkdir -p -m 0600 ~/.ssh && ssh-keyscan github.com >> ~/.ssh/known_hosts

# Clone private repository
RUN --mount=type=ssh git clone git@github.com:scottrigby/docker-experimental-ssh-circleci.git test-clone-dir
RUN ls -lah test-clone-dir
