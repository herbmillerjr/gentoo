# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit meson xdg-utils

DESCRIPTION="Helper for enabling better Steam integration on Linux"
HOMEPAGE="https://github.com/solus-project/linux-steam-integration"
SRC_URI="https://github.com/solus-project/${PN}/releases/download/v${PV}/${P}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE="gtk"

DEPEND="gtk? ( x11-libs/gtk+:3 )
	dev-util/meson
	dev-util/ninja
"
RDEPEND="${DEPEND}
	x11-libs/libXtst[abi_x86_32]
	x11-libs/gtk+:2[abi_x86_32]
	x11-libs/gdk-pixbuf[abi_x86_32]
	x11-libs/libva[abi_x86_32]
	media-sound/pulseaudio[abi_x86_32]
	net-misc/curl[abi_x86_32]
	media-libs/libsdl2[abi_x86_32]
	media-libs/vulkan-loader[abi_x86_32]
"

# TODO: Find a way to discover steam binary
# TODO: Find a way to determine dynamically gcc version being used for libcxx-abi

src_configure() {
	local emesonargs=(
		-Dwith-shim=co-exist
		$(meson_use gtk with-frontend)
		-Dwith-steam-binary=/usr/lib/steam/steam
		-Dwith-new-libcxx-abi=true
	)
	meson_src_configure
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
