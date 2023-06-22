FROM rust:bookworm

EXPOSE 22

RUN ["cargo", "install", "cargo-generate"]
RUN ["cargo", "install", "ldproxy"]
RUN ["cargo", "install", "espflash"]
RUN ["cargo", "install", "espup"]
RUN ["espup", "install"]

RUN ["apt", "update"]
RUN apt install python3-pip python3-virtualenv -y

COPY env.sh /root/env.sh
RUN chmod +x ~/env.sh
RUN cat $HOME/export-esp.sh >> ~/.bashrc && cat ~/env.sh >> ~/.bashrc && chmod +x ~/.bashrc
RUN cat $HOME/export-esp.sh >> ~/.profile && cat ~/env.sh >> ~/.profile && chmod +x ~/.profile
RUN cat $HOME/export-esp.sh >> ~/.zprofile && cat ~/env.sh >> ~/.zprofile && chmod +x ~/.zprofile
RUN cat $HOME/export-esp.sh >> ~/.bash_profile && cat ~/env.sh >> ~/.bash_profile && chmod +x ~/.bash_profile

RUN apt install openssh-server vim -y
RUN (echo '123456'; echo '123456') | passwd root
COPY sshd_config /etc/ssh/sshd_config
RUN chmod 644 /etc/ssh/sshd_config
COPY hosts.allow /etc/hosts.allow
RUN chmod 644 /etc/hosts.allow

RUN /root/.profile
RUN /root/env.sh

COPY entrypoint.sh .
RUN chmod +x ./entrypoint.sh
ENTRYPOINT "./entrypoint.sh"
