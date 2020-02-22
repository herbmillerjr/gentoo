# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit autotools eutils flag-o-matic multilib multilib-minimal

DESCRIPTION="library for decoding DTS Coherent Acoustics streams used in DVD"
HOMEPAGE="https://www.videolan.org/developers/libdca.html"
SRC_URI="https://www.videolan.org/pub/videolan/${PN}/${PV}/${P}.tar.bz2
	mirror://gentoo/${P}-constant.patch.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="debug oss static-libs"

RDEPEND="!media-libs/libdts"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS ChangeLog NEWS README TODO doc/${PN}.txt )

src_prepare() {
	epatch "${FILESDIR}"/${P}-cflags.patch \
		"${FILESDIR}"/${P}-tests-optional.patch \
		"${WORKDIR}"/${P}-constant.patch

	eautoreconf
}

multilib_src_configure() {
	append-lfs-flags #328875

	ECONF_SOURCE="${S}" econf \
		$(use_enable debug) \
		$(use_enable static-libs static) \
		$(use_enable oss)

	# Those are thrown away afterwards, don't build them in the first place
	if [ "${ABI}" != "${DEFAULT_ABI}" ] ; then
		sed -i -e 's/ libao src//' Makefile || die
	fi
}

multilib_src_compile() {
	emake OPT_CFLAGS=""
}

multilib_src_install() {
	emake DESTDIR="${D}" install

	find "${ED}" -name '*.la' -exec rm -f '{}' +
	rm -f "${ED}"/usr/$(get_libdir)/libdts.a
}
