# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="VNC server for real X displays"
HOMEPAGE="https://libvnc.github.io/"
SRC_URI="https://github.com/LibVNC/x11vnc/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="crypt fbcon libressl +xcomposite +xdamage +xfixes xinerama +xrandr zeroconf"

COMMON_DEPEND="
	>=net-libs/libvncserver-0.9.8[ssl]
	x11-libs/libX11
	x11-libs/libXcursor
	x11-libs/libXext
	>=x11-libs/libXtst-1.1.0
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:= )
	xcomposite? ( x11-libs/libXcomposite )
	xdamage? ( x11-libs/libXdamage )
	xfixes? ( x11-libs/libXfixes )
	xinerama? ( x11-libs/libXinerama )
	xrandr? ( x11-libs/libXrandr )
	zeroconf? ( >=net-dns/avahi-0.6.4 )
"
DEPEND="${COMMON_DEPEND}
	x11-base/xorg-proto
	x11-libs/libXt
"
# https://bugzilla.redhat.com/show_bug.cgi?id=920554
RDEPEND="${COMMON_DEPEND}
	dev-lang/tk:0
"

PATCHES=(
	"${FILESDIR}"/${P}-crypto.patch # https://github.com/LibVNC/x11vnc/issues/86
	"${FILESDIR}"/${P}-anonymous-ssl.patch # https://github.com/LibVNC/x11vnc/pull/85
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# --without-v4l because of missing video4linux 2.x support wrt #389079
	# --with-crypto --with-ssl because USE=-ssl is broken (bug #686494)
	econf \
		--with-crypto \
		--with-ssl \
		--without-v4l \
		--without-xkeyboard \
		--without-fbpm \
		--without-dpms \
		$(use_with crypt) \
		$(use_with fbcon fbdev) \
		$(use_with xcomposite) \
		$(use_with xdamage) \
		$(use_with xfixes) \
		$(use_with xinerama) \
		$(use_with xrandr) \
		$(use_with zeroconf avahi)
}

src_install() {
	default
	newinitd "${FILESDIR}/x11vnc.init.d" x11vnc
	newconfd "${FILESDIR}/x11vnc.conf.d" x11vnc
}
