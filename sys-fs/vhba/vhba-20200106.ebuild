# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils linux-mod udev

MY_P=vhba-module-${PV}
DESCRIPTION="Virtual (SCSI) Host Bus Adapter kernel module for the CDEmu suite"
HOMEPAGE="https://cdemu.sourceforge.io"
SRC_URI="https://download.sourceforge.net/cdemu/vhba-module/${MY_P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""

RDEPEND="virtual/udev"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${MY_P}
MODULE_NAMES="vhba(block:${S})"
BUILD_TARGETS=modules

pkg_setup() {
	CONFIG_CHECK="~BLK_DEV_SR ~CHR_DEV_SG"
	check_extra_config
	BUILD_PARAMS="KDIR=${KV_OUT_DIR}"
	linux-mod_pkg_setup
}

src_prepare() {
	# Avoid -Werror problems
	sed -i -e '/ccflags/s/-Werror/-Wall/' Makefile || die "sed failed"

	eapply_user
}

src_install() {
	dodoc AUTHORS ChangeLog README
	linux-mod_src_install

	einfo "Generating udev rules ..."
	udev_newrules - 69-vhba.rules <<-EOF
		# do not edit this file, it will be overwritten on update
		#
		KERNEL=="vhba_ctl", SUBSYSTEM=="misc", TAG+="uaccess"
	EOF
}
