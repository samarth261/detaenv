FROM ubuntu:22.04

RUN apt-get update
RUN apt-get install -y curl sudo vim htop ssh net-tools openssl unzip tree
RUN curl -fsSL https://deb.nodesource.com/setup_14.x | sudo -E bash -
RUN sudo apt-get install -y nodejs

ARG username
ARG userid
ARG password
RUN adduser --uid ${userid} --shell /bin/bash ${username}
RUN echo "${username}:${password}" | chpasswd

# Give sudo access inside the container
RUN usermod -aG sudo ${username}
USER ${username}

# Setup the context for running the ssh server.
RUN mkdir /home/${username}/.ssh
WORKDIR /home/${username}/.ssh
RUN ssh-keygen -q -N '' -t dsa -f ./ssh_host_dsa_key
RUN ssh-keygen -q -N '' -t rsa -f ./ssh_host_rsa_key
RUN ssh-keygen -q -N '' -t ecdsa -f ./ssh_host_ecdsa_key
RUN ssh-keygen -q -N '' -t ed25519 -f ./ssh_host_ed25519_key
RUN touch ssh_config
RUN echo "HostKey /home/${username}/.ssh/ssh_host_rsa_key" >> ssh_config
RUN echo "HostKey /home/${username}/.ssh/ssh_host_dsa_key" >> ssh_config
RUN echo "HostKey /home/${username}/.ssh/ssh_host_ecdsa_key" >> ssh_config
COPY "id_rsa.pub" "/home/${username}/.ssh/authorized_keys"

# Setup space cli
WORKDIR /home/${username}
RUN curl -fsSL https://get.deta.dev/space-cli.sh | sh
RUN echo "export PATH=\"/home/samarth/.detaspace/bin:$PATH\"" >> /home/${username}/.bashrc
COPY space_tokens /home/${username}/.detaspace/space_tokens

EXPOSE 22
WORKDIR /home/${username}/.ssh
CMD ["/usr/sbin/sshd", "-D", "-f", "ssh_config"]