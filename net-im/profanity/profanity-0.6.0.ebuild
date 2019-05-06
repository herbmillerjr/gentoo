# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A console based XMPP client inspired by Irssi"
HOMEPAGE="http://www.profanity.im/"
SRC_URI="http://www.profanity.im/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

IUSE="libnotify otr gpg xscreensaver"

DEPEND="
	dev-libs/expat
	dev-libs/glib
	dev-libs/libstrophe:=
	dev-libs/openssl:0=
	net-misc/curl
	sys-apps/util-linux
	sys-libs/ncurses:=[unicode]
	gpg? ( app-crypt/gpgme:= )
	libnotify? ( x11-libs/libnotify )
	otr? ( net-libs/libotr )
	xscreensaver? (
		x11-libs/libXScrnSaver
		x11-libs/libX11 )
	"
RDEPEND="${DEPEND}"

src_configure() {
	econf \
		$(use_enable libnotify notifications) \
		$(use_enable otr) \
		$(use_enable gpg pgp) \
		$(use_with xscreensaver)
}
