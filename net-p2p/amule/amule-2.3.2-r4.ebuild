# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
WX_GTK_VER="3.0-gtk3"

inherit wxwidgets

MY_P="${PN/m/M}-${PV}"

DESCRIPTION="aMule, the all-platform eMule p2p client"
HOMEPAGE="http://www.amule.org/"
SRC_URI="https://download.sourceforge.net/${PN}/${MY_P}.tar.xz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ppc ~ppc64 ~sparc ~x86"
IUSE="daemon debug geoip nls remote stats upnp +X"

RDEPEND="
	dev-libs/boost:=
	dev-libs/crypto++:=
	sys-libs/binutils-libs:0=
	sys-libs/zlib
	>=x11-libs/wxGTK-3.0.4:${WX_GTK_VER}[X?]
	daemon? ( acct-user/amule )
	geoip? ( dev-libs/geoip )
	remote? (
		acct-user/amule
		media-libs/libpng:0=
	)
	stats? ( media-libs/gd:=[jpeg,png] )
	upnp? ( net-libs/libupnp:0 )
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${PN}-2.3.2-fix-crash-shared-dir-utf8.patch"
	"${FILESDIR}/${PN}-2.3.2-fix-crash-closing-last-search-tab-1.patch"
	"${FILESDIR}/${PN}-2.3.2-fix-crash-closing-last-search-tab-2.patch"
	"${FILESDIR}/${PN}-2.3.2-cryptopp-6.patch"
	"${FILESDIR}/${PN}-2.3.2-disable-version-check.patch"
	"${FILESDIR}/${PN}-2.3.2-fix-crash-when-shared-files-changed.patch"
	"${FILESDIR}/${PN}-2.3.2-libupnp-1.8.patch"
	"${FILESDIR}/${PN}-2.3.2-libupnp-1.6.patch"
)

pkg_setup() {
	setup-wxwidgets
}

src_configure() {
	local myconf=(
		--with-denoise-level=0
		--with-wx-config="${WX_CONFIG}"
		--enable-amulecmd
		--with-boost
		$(use_enable debug)
		$(use_enable daemon amule-daemon)
		$(use_enable geoip)
		$(use_enable nls)
		$(use_enable remote webserver)
		$(use_enable stats cas)
		$(use_enable stats alcc)
		$(use_enable upnp)
	)

	if use X; then
		myconf+=(
			$(use_enable remote amule-gui)
			$(use_enable stats alc)
			$(use_enable stats wxcas)
		)
	else
		myconf+=(
			--disable-monolithic
			--disable-amule-gui
			--disable-alc
			--disable-wxcas
		)
	fi

	econf "${myconf[@]}"
}

src_install() {
	default

	if use daemon; then
		newconfd "${FILESDIR}"/amuled.confd-r1 amuled
		newinitd "${FILESDIR}"/amuled.initd amuled
	fi
	if use remote; then
		newconfd "${FILESDIR}"/amuleweb.confd-r1 amuleweb
		newinitd "${FILESDIR}"/amuleweb.initd amuleweb
	fi

	if use daemon || use remote; then
		keepdir /var/lib/${PN}
		fowners amule:amule /var/lib/${PN}
		fperms 0750 /var/lib/${PN}
	fi
}

pkg_postinst() {
	local ver

	if use daemon || use remote; then
		for ver in ${REPLACING_VERSIONS}; do
			if ver_test ${ver} -lt "2.3.2-r4"; then
				elog "Default user under which amuled and amuleweb daemons are started"
				elog "have been changed from p2p to amule. Default home directory have been"
				elog "changed as well."
				echo
				elog "If you want to preserve old download/share location, you can create"
				elog "symlink /var/lib/amule/.aMule pointing to the old location and adjust"
				elog "files ownership *or* restore AMULEUSER and AMULEHOME variables in"
				elog "/etc/conf.d/{amuled,amuleweb} to the old values."

				break
			fi
		done
	fi
}
