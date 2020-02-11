# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=CERNEY
MODULE_VERSION=1.23
inherit perl-module

DESCRIPTION="Perl module for Tk-TableMatrix"

#SRC_TEST="do"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ia64 ppc sparc x86"
IUSE=""

DEPEND="dev-perl/Tk"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/pTk-1.22.patch" )

src_install() {
	perl-module_src_install

	# Clean out stray conflicting file - its generated by perl-tk already.
	# Bug 169294
	rm	"${D}"/${VENDOR_ARCH}/auto/Tk/pTk/extralibs.ld || die
}
