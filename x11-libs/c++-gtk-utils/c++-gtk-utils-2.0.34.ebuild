# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A number of classes and functions for programming GTK+ programs using C++"
HOMEPAGE="http://cxx-gtk-utils.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN/++/xx}/${P}.tar.gz"

LICENSE="LGPL-2.1"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="+gtk nls static-libs"
SLOT="3"

RDEPEND="
	>=dev-libs/glib-2.26
	gtk? ( x11-libs/gtk+:3 )
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"

DOCS=( ChangeLog )

src_configure() {
	econf \
		$(use_enable nls) \
		$(use_with gtk) \
		$(use_enable static-libs static) \
		--without-guile
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
