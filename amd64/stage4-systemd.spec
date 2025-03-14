subarch: amd64
target: stage4
version_stamp: gnome-systemd
rel_type: default
profile: default/linux/amd64/23.0/desktop/gnome/systemd
snapshot_treeish: @TREEISH@
source_subpath: default/stage3-amd64-@TIMESTAMP@
compression_mode: pixz
portage_confdir: /var/tmp/catalyst/config
portage_prefix: releng
repos: /var/db/repos/fox-overlay /var/db/repos/guru
stage4/use:
	wayland
	dist-kernel
	fuse
	flatpak
	gstreamer
	gnome
	lvm
	networkmanager
	nls
	pipewire
	pipewire-alsa
	policykit
	udev
	usb
	screencast
	video_cards_intel
	video_cards_nouveau
	video_cards_radeon
	video_cards_radeonsi
	video_cards_amdgpu
	video_cards_virgl
	video_cards_vmware
	video_cards_lavapipe
	video_cards_zink
	llvm_targets_WebAssembly
	vaapi
	vdpau
	dri
	vpx
	xkb
	-qt5
	-qt6
	-kde
stage4/packages:
	app-admin/sudo
	app-containers/distrobox
	app-containers/docker
	app-containers/docker-cli
	app-containers/docker-buildx
	app-editors/vim
	sys-apps/pciutils
	media-video/libva-utils
	x11-libs/libvdpau
	app-emulation/qemu-guest-agent
	app-emulation/spice-vdagent
	app-eselect/eselect-repository
	app-shells/bash-completion
	dev-util/glib-utils
	dev-util/wayland-scanner
	dev-vcs/git
	dev-vcs/git-lfs
	gnome-base/gnome-light
	gnome-extra/gnome-shell-extensions
	gnome-extra/gnome-software
	gnome-extra/gnome-tweaks
	app-editors/gnome-text-editor
	net-misc/gnome-remote-desktop
	gnome-extra/extension-manager
	media-gfx/eog
	media-gfx/eog-plugins
	app-text/evince
	app-arch/file-roller
	app-arch/unrar
	sys-apps/xdg-desktop-portal
	gui-libs/xdg-desktop-portal-wlr
	sys-apps/xdg-desktop-portal-gnome
	media-fonts/fonts-meta
	media-libs/gstreamer
	media-libs/mesa
	media-video/wireplumber
	net-fs/samba
	net-print/cups
	net-vpn/openconnect
	net-vpn/networkmanager-openconnect
	net-vpn/networkmanager-openvpn
	net-vpn/networkmanager-pptp
	net-vpn/openvpn
	sys-apps/flatpak
	sys-apps/iproute2
	sys-apps/lsb-release
	sys-apps/mlocate
	sys-apps/xdg-desktop-portal-gtk
	sys-auth/fprintd
	sys-auth/rtkit
	sys-block/gparted
	sys-block/io-scheduler-udev-rules
	sys-boot/grub
	sys-boot/plymouth
	sys-fs/bcache-tools
	sys-fs/btrfs-progs
	sys-fs/cryptsetup
	sys-fs/dmraid
	sys-fs/dosfstools
	sys-fs/e2fsprogs
	sys-fs/exfatprogs
	sys-fs/f2fs-tools
	sys-fs/fuse-exfat
	sys-fs/fuse-overlayfs
	sys-fs/fuseiso
	sys-fs/go-mtpfs
	sys-fs/jfsutils
	sys-fs/lsscsi
	sys-fs/lvm2
	sys-fs/mac-fdisk
	sys-fs/mdadm
	sys-fs/multipath-tools
	sys-fs/ntfs3g
	sys-fs/squashfs-tools
	sys-fs/xfsprogs
	sys-fs/zfs
	sys-fs/zfs-kmod
	sys-kernel/gentoo-kernel-bin
	sys-kernel/linux-firmware
	sys-power/power-profiles-daemon
	sys-power/tlp
	sys-process/htop
	xenia-tools/xenia-meta
	llvm-core/lld
	dev-lang/rust
	sys-apps/gnome-disk-utility
	sys-firmware/intel-microcode
stage4/empty: /var/tmp /var/cache /tmp 
stage4/rm:
	/boot/initramfs?*.img
	/boot/vmlinuz?*
	/boot/config?*
	/boot/System.map?*
stage4/root_overlay: @REPODIR@/overlay
stage4/fsscript: @REPODIR@/amd64/stage4-systemd.sh