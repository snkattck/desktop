FROM archlinux:latest
COPY ./startup.sh /usr/bin/startup.sh
RUN useradd -U -m app && \
    chmod a+x /usr/bin/startup.sh && \
    mkdir -p /opt/resources && \
    echo "--> Updating" && \
    pacman --noconfirm -Syy && \
    pacman --noconfirm -Su && \
    echo "--> Installing desktop" && \
    pacman --noconfirm -S jwm pcmanfm ttf-fira-mono ttf-fira-code gnu-free-fonts tilix sudo git fakeroot base-devel && \
    dbus-uuidgen > /etc/machine-id 
COPY ./static/wallpaper.png /opt/resources/wallpaper.png
COPY ./etc/sudoers /etc/sudoers
ENV DISPLAY localhost:0
USER app
WORKDIR /home/app
RUN echo "--> Building trizen" && \
    git clone https://aur.archlinux.org/trizen.git && \
    cd trizen && \
    makepkg --noconfirm -sri && \
    rm -rf trizen && \
    sudo pacman --noconfirm -Scc
COPY --chown=app:app ./dotjwmrc /home/app/.jwmrc
COPY --chown=app:app ./dotconfig /home/app/.config
WORKDIR /home/app
CMD ["dbus-launch", "/usr/bin/startup.sh"]
