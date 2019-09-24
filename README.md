# docker-experimental-ssh-circleci

[![CircleCI](https://circleci.com/gh/scottrigby/docker-experimental-ssh-circleci.svg?style=svg)](https://circleci.com/gh/scottrigby/docker-experimental-ssh-circleci)

## Purpose

Git repo to test Docker 18.09 [experimental ssh feature](https://docs.docker.com/develop/develop-images/build_enhancements/#using-ssh-to-access-private-data-in-builds). This project's public Dockerfile clones a [test private repo](https://github.com/scottrigby/github-test-private-repo) without adding insecure credentials to any of the container image's layers. for more information and examples, see [Build secrets and SSH forwarding in Docker 18.09](https://medium.com/@tonistiigi/build-secrets-and-ssh-forwarding-in-docker-18-09-ae8161d066).


## Check security

- Check new docker build BuildKit plain output in [CircleCI](https://circleci.com/gh/scottrigby/docker-experimental-ssh-circleci) for security
- See private repo contents, and inspect [built container image](https://hub.docker.com/r/r6by/docker-experimental-ssh-circleci/tags) history:
    ```console
    $ docker pull r6by/docker-experimental-ssh-circleci

    $ docker run --rm r6by/docker-experimental-ssh-circleci sh -c 'cat github-test-private-repo/README.md'
    Test repo for accessing private GitHub repos. Does not contain anything sensitive.

    $ docker history --no-trunc --format '{{.ID}} {{.CreatedBy}} {{.Size}}'  r6by/docker-experimental-ssh-circleci
    sha256:bf0b1586234d9c00a97a4fe209692f5f0febc3eee37efb5d23e7ae1ca855d96f RUN /bin/sh -c [ -e github-test-private-repo/README.md ] || exit 1 # buildkit 0B
    <missing> RUN /bin/sh -c git clone git@github.com:scottrigby/github-test-private-repo.git # buildkit 20.9kB
    <missing> RUN /bin/sh -c mkdir -p -m 0600 ~/.ssh && ssh-keyscan github.com >> ~/.ssh/known_hosts # buildkit 392B
    <missing> RUN /bin/sh -c apk add --no-cache openssh-client git # buildkit 21.6MB
    <missing> /bin/sh -c #(nop)  CMD ["/bin/sh"] 0B
    <missing> /bin/sh -c #(nop) ADD file:fe64057fbb83dccb960efabbf1cd8777920ef279a7fa8dbca0a8801c651bdf7c in /  5.58MB
    ```
- Any other thoughts about security? [Open an issue](https://github.com/scottrigby/docker-experimental-ssh-circleci/issues/new)

## Setup

1. Generate CircleCI-compatible ssh key and send to stdout:
    ```console
    $ ./generate-private-key.sh
    ```
    _Note for CircleCI compatibility we add an empty password, and enforce PEM format (recent versions of ssh-keygen don’t default to PEM)._

    <details><summary>Click to expand sample output</summary>

    ```console
    Generating public/private rsa key pair.
    Your identification has been saved in /var/folders/87/9cf6q4rd2qn_xnpk149j1ff80000gn/T/tmp.8zHPx7W1Es/id_rsa.
    Your public key has been saved in /var/folders/87/9cf6q4rd2qn_xnpk149j1ff80000gn/T/tmp.8zHPx7W1Es/id_rsa.pub.
    The key fingerprint is:
    MD5:9a:35:fd:d8:8e:ed:e8:95:85:04:83:a4:f9:7a:52:aa your_email@example.com
    The key's randomart image is:
    +---[RSA 2048]----+
    |       ...o      |
    |       o.  o     |
    |      o     .    |
    |       . . . .   |
    |        S . . .  |
    |       B . + o   |
    |      * . . =    |
    |     . o   *     |
    |    E    .+.+    |
    +------[MD5]------+
    Private key:
    -----BEGIN RSA PRIVATE KEY-----
    MIIEpAIBAAKCAQEA08RJzBTuKjLa5MD4CxiRdXxGxQHRu4+p+Mi+ha2iynxw2+3Q
    6NO9zGGPq/BprCn4wbMfgbMf7Y4kygYSd1SV8Ykjvxm6nQSw1SeQziJDRHrrh1nO
    3hQno6XQ+7WqtHXJ10qCzsZdFoP2GrUqnSCfuqnuFoL92mewkCjGd8bwLiMYN9Uc
    C9q3qUAMvucnPq80rcp+P2zVdpcCdu9EeY20QoCLNtA/yJaZFKMfJIwk07nc+MEe
    ikt1eMfX9ccqTIlZOuu8x9dZRNA3RBWlx6Q0mHQyhOJ7qNktwVRVU0cSlP2/8Y8i
    Tf6PYYB1WlkSE6yUbUvFsa1JdadaP+fxsYaBfwIDAQABAoIBAAkCPLF14nvhFfbN
    TsAKF4YL92bCIQ39mpl+0LwXGunKSXLRtyVwfI6JR/dkjtpIHtD+scRuvlj4xw/h
    GkABVS+lSeQDUDEF1g/7UumyA3KSWBq181r3OIh5sV5D6DMtH50NCmuJfMRMcNfK
    BToR/TmPqRVEFVCJQLWhRnAqAmWz/KPgigIyEpBK+pyQcRkUQU3mVhKgA+NRzipF
    SVw3aBxJyUqU9CvsCQ6uu8K7ONxoLRsH6p6W+eJOO5wKH6SVa9/HQ0ORcshkvgyI
    sbOwpZYoa3crAhQife2vodNPc69JxQTjFeOO8nWKc325zlbBHnFM58RJXzvJa5D6
    FzQ+q2ECgYEA+bnbnG34Cq3x1ZUAqHV7i1Qy6tkHQnsA++W/MQKn1r7lmqj7NjRT
    Q/jtmjDbaeCGSQk8MduFa0Ep7JI/6Eb6DSnUQWyVRc3y4vmOVCAdhre9jyQVXWk3
    pGTpwFKgluBffQY/A3u/93bEt8d/sn6d5YNzxJCKrppjA3jyfa0XuF0CgYEA2RZK
    fv+To5UOxnK13E4JNFq6GnlN1kHzLjow2DFo9Qxt/EYBOfsVsuJuaIlFJveDggLk
    RJoPFjhXOWmc9QKGEqjcb7XptgECM3w6WbMQS43jqmT7SDK5OIqNJunC21DzE6mP
    CgKmWczmQE/iLq5zNdp6P3WBxtMgZ3PMquVok4sCgYEAibDflL3RoNnN2KzCYx/7
    0ZPIS1MEvLQjk8BWjchgEHjLEl6PvJBXRMgxAe5kXFlu0UBlTzwxsTSJ0CXHVOQl
    pTJmFPiwyX9Hp7xfrKTUgt42h4Emwo1sH5mAhQlKAEaQf9f80IfgDasPxiEamKlV
    mCHFqCDmRmVbqKN8WK0iwgUCgYEAvjn+RZMHeIyhSdwy6D2payslcRVi06Euyw9K
    xedmJXUi27EsWfZfaUVpokjHRAIYRtDp3gNxvPLZ3AFj/H6dpbQ6ldk+VrJDj4II
    T5nNaaeIHEQovXdVPuqKDdNBYJVqq4wlP4xa4M3f5fMaK/XKFyK/hOQfOG7BMmYS
    rp4gKUkCgYBmzyeYQtGOKTf/HeiCKWl9DVi+PsFCO7uMG2Uremi7Sd3gtf4A8yDf
    cBZwUPyZm3Psgvvvo1JKzdYD2rfb2d599Y4O1WRq5tygx2P4jUmPz1NjzJpog0uF
    r6P1i+KRcIowJOF+n9SnwwsF5JtslT+5/lIFFsi0dqxL5nQH6shAqA==
    -----END RSA PRIVATE KEY-----
    Public key:
    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDTxEnMFO4qMtrkwPgLGJF1fEbFAdG7j6n4yL6FraLKfHDb7dDo073MYY+r8GmsKfjBsx+Bsx/tjiTKBhJ3VJXxiSO/GbqdBLDVJ5DOIkNEeuuHWc7eFCejpdD7taq0dcnXSoLOxl0Wg/YatSqdIJ+6qe4Wgv3aZ7CQKMZ3xvAuIxg31RwL2repQAy+5yc+rzStyn4/bNV2lwJ270R5jbRCgIs20D/IlpkUox8kjCTTudz4wR6KS3V4x9f1xypMiVk667zH11lE0DdEFaXHpDSYdDKE4nuo2S3BVFVTRxKU/b/xjyJN/o9hgHVaWRITrJRtS8WxrUl1p1o/5/GxhoF/ your_email@example.com
    CircleCI private key name:
    id_rsa_9a35fdd88eede895850483a4f97a52aa
    ```

    </details>
2. [Set up your GitHub project](https://circleci.com/docs/2.0/getting-started/#setting-up-your-build-on-circleci) on CircleCI
3. Copy private key from step 1 stdout and [add to the CircleCI project](https://circleci.com/docs/2.0/add-ssh-key/): `Permissions` > `SSH Permissions` > `Add SSH Key`
4. Update [CircleCI config file](./.circleci/config.yml) with public key fingerprint and matching key added to CircleCI in step 2:
    - Copy MD5 public "key fingerprint" from step 1 stdout and add to container build job step:
      ```yaml
      steps:
        - add_ssh_keys:
            fingerprints:
              - 9a:35:fd:d8:8e:ed:e8:95:85:04:83:a4:f9:7a:52:aa
      ```
    - Copy "CircleCI private key name" from step 1 stdout and add to container build environment variable `PRIVATE_KEY`:
      ```yaml
      environment:
        PRIVATE_KEY: id_rsa_9a35fdd88eede895850483a4f97a52aa
      ```
5. Add your `DOCKER_USER` and `DOCKER_PASS` container registry push credentials to CircleCI [environment variables](https://circleci.com/docs/2.0/env-vars/#overview): `Build` > `Project` > `Settings` > `Environment Variables`
6. Copy public key from step 1 stdout and [add a GitHub deploy key](https://developer.github.com/v3/guides/managing-deploy-keys/#deploy-keys) to the private git repo you want to clone in your project Dockerfile. Deploy keys are read-only by default - do not select `allow write access` if you do not need CircleCI to also push to the private git repo
7. Current circle config builds and pushes container image when pushing to `master`
