# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_P="Par-${PV}"
DESCRIPTION="a paragraph reformatter, vaguely similar to fmt, but better"
HOMEPAGE="http://www.nicemice.net/par/"
SRC_URI="http://www.nicemice.net/par/${MY_P}.tar.gz"

LICENSE="|| ( MIT par )"
SLOT="0"
KEYWORDS="~amd64 ~mips ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE=""

DEPEND="!dev-util/par
	!app-arch/par"

S="${WORKDIR}/${MY_P}"

src_compile() {
	emake -f protoMakefile CC="$(tc-getCC) ${CFLAGS} -c" \
		LINK1="$(tc-getCC) ${LDFLAGS}"
}

src_install() {
	newbin par par-format
	doman par.1
	dodoc releasenotes par.doc
}

src_test() {
	emake -f protoMakefile test
}
