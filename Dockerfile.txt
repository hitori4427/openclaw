FROM ubuntu:22.04  
LABEL "language"="ubuntu"  
ENV DEBIAN_FRONTEND=noninteractive  
ENV DISPLAY=:1  
ENV VNC_PASSWORD=zeabur123  
WORKDIR /root  
RUN apt-get update && apt-get install -y \  
    xfce4 \  
    xfce4-goodies \  
    tightvncserver \  
    firefox \  
    curl \  
    wget \  
    nano \  
    vim \  
    git \  
    openssh-server \  
    supervisor \  
    && rm -rf /var/lib/apt/lists/*  
RUN mkdir -p ~/.vnc  
RUN echo "zeabur123" | vncpasswd -f > ~/.vnc/passwd && chmod 600 ~/.vnc/passwd  
RUN echo '#!/bin/bash\nvncserver :1 -geometry 1920x1080 -depth 24 -localhost no' > ~/.vnc/xstartup && chmod +x ~/.vnc/xstartup  
RUN mkdir -p /etc/supervisor/conf.d && \  
    echo '[supervisord]\nnodaemon=true\n\n[program:vncserver]\ncommand=/root/.vnc/xstartup\nautostart=true\nautorestart=true\nstderr_logfile=/var/log/vncserver.err.log\nstdout_logfile=/var/log/vncserver.out.log' > /etc/supervisor/conf.d/vncserver.conf  
RUN mkdir -p /run/sshd  
EXPOSE 5901 22  
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/vncserver.conf"]  
