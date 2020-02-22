ARG FEDORA_VERSION
FROM fedora:$FEDORA_VERSION
COPY ./startup.sh /usr/bin/startup.sh
RUN adduser -m app && \
    chmod a+x /usr/bin/startup.sh && \
    mkdir -p /opt/resources && \
    echo "--> Updating" && \
    dnf -y update && \
    dnf -y upgrade && \
    echo "--> Installing desktop" && \
    dnf -y install jwm telnet pcmanfm && \
    echo "--> Fixing and installing fonts" && \
    dnf -y install dnf-plugins-core && \
    dnf -y install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm && \
    dnf -y copr enable dawid/better_fonts && \
    dnf -y install fontconfig-enhanced-defaults fontconfig-font-replacements google-roboto-fonts cjkuni-ukai-fonts cjkuni-uming-fonts ipa-gothic-fonts ipa-mincho-fonts ipa-pgothic-fonts lohit-devanagari-fonts cabextract xorg-x11-font-utils fontconfig samyak-devanagari-fonts terminus-fonts terminus-fonts-console wqy-zenhei-fonts xorg-x11-fonts-misc sudo xfce4-terminal && \
    rpm -i https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm && \
    dnf -y clean all
COPY ./static/wallpaper.png /opt/resources/wallpaper.png
COPY ./etc/sudoers /etc/sudoers
ENV DISPLAY localhost:0
USER app
COPY --chown=app:app ./dotjwmrc /home/app/.jwmrc
COPY --chown=app:app ./dotconfig /home/app/.config
WORKDIR /home/app
CMD ["/usr/bin/startup.sh"]
