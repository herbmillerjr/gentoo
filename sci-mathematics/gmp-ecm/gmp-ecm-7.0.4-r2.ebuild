# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Elliptic Curve Method for Integer Factorization"
HOMEPAGE="http://ecm.gforge.inria.fr/"
SRC_URI="https://gforge.inria.fr/frs/download.php/file/36224/${P}.tar.gz"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc-macos ~x64-macos ~x86-macos"
IUSE="+custom-tune openmp static-libs cpu_flags_x86_sse2"

DEPEND="dev-libs/gmp:="
RDEPEND="${DEPEND}"

# Can't both be enabled.
REQUIRED_USE="x86-macos? ( !custom-tune )"

S="${WORKDIR}/ecm-${PV}"

pkg_pretend() {
	use openmp && tc-check-openmp
}

src_configure() {
	econf \
		--enable-shared \
		$(use_enable static-libs static) \
		$(use_enable openmp) \
		$(use_enable cpu_flags_x86_sse2 sse2) \
		$(use_enable custom-tune asm-redc)
}
