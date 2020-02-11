# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

AT_M4DIR="config"
PYTHON_COMPAT=( python2_7 )
DISTUTILS_OPTIONAL=1
inherit autotools distutils-r1

DESCRIPTION="simplified, portable interface to several low-level networking routines"
HOMEPAGE="https://github.com/dugsong/libdnet"
SRC_URI="
	https://github.com/dugsong/libdnet/archive/${P}.tar.gz
	ipv6? ( https://fragroute-ipv6.googlecode.com/files/${P}.ipv6-1.patch.gz )
"
LICENSE="LGPL-2"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="ipv6 python static-libs test"

DEPEND="
	python? ( ${PYTHON_DEPS} )
"
RDEPEND="
	${DEPEND}
"
RESTRICT="test"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"
DOCS=( README THANKS TODO )
S=${WORKDIR}/${PN}-${P}

src_prepare() {
	# Useless copy
	rm -r trunk/ || die

	sed -i \
		-e 's/libcheck.a/libcheck.so/g' \
		-e 's|AM_CONFIG_HEADER|AC_CONFIG_HEADERS|g' \
		configure.in || die
	sed -i -e 's|-L@libdir@ ||g' dnet-config.in || die
	use ipv6 && eapply "${WORKDIR}/${P}.ipv6-1.patch"
	sed -i -e '/^SUBDIRS/s|python||g' Makefile.am || die
	eautoreconf

	if use python; then
		cd python
		distutils-r1_src_prepare
	fi

	eapply_user
}

src_configure() {
	econf \
		$(use_with python) \
		$(use_enable static-libs static)
}

src_compile() {
	default
	if use python; then
		cd python
		distutils-r1_src_compile
	fi
}

src_install() {
	default
	if use python; then
		cd python
		unset DOCS
		distutils-r1_src_install
	fi
	find "${D}" -name '*.la' -delete || die
}
