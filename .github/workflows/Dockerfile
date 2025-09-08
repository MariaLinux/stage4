FROM gentoo/portage:latest AS portage

FROM gentoo/stage3:latest AS stage3

COPY --from=portage /var/db/repos/gentoo /var/db/repos/gentoo

RUN echo "dev-util/catalyst ~amd64" >> /etc/portage/package.accept_keywords/00_core && \
    echo "sys-apps/util-linux python" >> /etc/portage/package.use/00_core && \
    echo "sys-boot/grub grub_platforms_efi-32" >> /etc/portage/package.use/00_core && \
    emerge-webrsync && \
    emerge --verbose --deep --newuse --with-bdeps=y --with-bdeps=y \
    dev-util/catalyst app-eselect/eselect-repository

