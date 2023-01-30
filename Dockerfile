FROM ubuntu:22.04
ARG username
ARG userid
ARG password

RUN apt-get update
RUN apt-get install -y curl sudo vim htop ssh net-tools openssl

RUN adduser --uid ${userid} --shell /bin/bash ${username}
RUN echo "${username}:${password}" | chpasswd

RUN usermod -aG sudo ${username}
USER ${username}
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

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D", "-f", "ssh_config"]