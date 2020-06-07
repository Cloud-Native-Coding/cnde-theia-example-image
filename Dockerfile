FROM eu.gcr.io/cloud-native-coding/theia-example:latest

USER root

ENV DEBIAN_FRONTEND "noninteractive" 
ENV TZ Europe/Zurich

RUN apt-get update; \
    apt-get install -y apt-transport-https ca-certificates gnupg-agent software-properties-common; \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -; \
    add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable"; \
    apt-get update && apt-get install -y docker-ce-cli; \
    rm -rf /var/lib/apt/lists/*

RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -; \
    echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list; \
    apt-get update; apt-get install -y kubectl; \
    rm -rf /var/lib/apt/lists/*

RUN curl -L https://github.com/wercker/stern/releases/download/1.10.0/stern_linux_amd64 -o /usr/local/bin/stern; \
    chmod +x /usr/local/bin/stern

RUN apt-get update; apt-get install -y zsh git; rm -rf /var/lib/apt/lists/*;
RUN chsh -s /bin/zsh
ENV SHELL=/bin/zsh

RUN curl https://raw.githubusercontent.com/blendle/kns/master/bin/kns -o /usr/local/bin/kns; \ 
    chmod +x /usr/local/bin/kns


USER cnde
WORKDIR /home/cnde

ENV DOCKER_HOST tcp://0.0.0.0:2375

RUN sudo chown -R cnde .

RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
COPY --chown=cnde:cnde .zshrc .
RUN sudo chown -R cnde .
RUN git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf ; ~/.fzf/install
