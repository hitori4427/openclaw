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

RUN mkdir -p ~/.vnc && \
    echo "zeabur123" | vncpasswd -f > ~/.vnc/passwd && \
    chmod 600 ~/.vnc/passwd

RUN cat > ~/.vnc/xstartup << 'EOF'
#!/bin/bash
startxfce4 &
EOF
RUN chmod +x ~/.vnc/xstartup

RUN mkdir -p /etc/supervisor/conf.d && \
    cat > /etc/supervisor/conf.d/vncserver.conf << 'EOF'
[supervisord]
nodaemon=true

[program:vncserver]
command=/usr/bin/vncserver :1 -geometry 1920x1080 -depth 24 -localhost no
autostart=true
autorestart=true
stderr_logfile=/var/log/vncserver.err.log
stdout_logfile=/var/log/vncserver.out.log
EOF

RUN mkdir -p /run/sshd

EXPOSE 5901 22

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/vncserver.conf"]
