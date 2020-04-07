# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

# ebuild generated by hackport 0.4.5.9999

CABAL_FEATURES="bin"
inherit haskell-cabal

DESCRIPTION="Tools to build the Gtk2Hs suite of User Interface libraries"
HOMEPAGE="http://projects.haskell.org/gtk2hs/"
SRC_URI="https://hackage.haskell.org/package/${P}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ia64 ~ppc ~ppc64 x86"
IUSE="+closuresignals"

RDEPEND="dev-haskell/random:=
	dev-haskell/hashtables:=
	>=dev-lang/ghc-7.4.1:=
"
DEPEND="${RDEPEND}
	dev-haskell/alex
	>=dev-haskell/cabal-1.8
	dev-haskell/happy
"

src_prepare() {
	epatch "${FILESDIR}"/${P}-ia64.patch
	epatch "${FILESDIR}"/${P}-alex-3.1.6.patch
}

src_configure() {
	haskell-cabal_src_configure \
		$(cabal_flag closuresignals closuresignals)
}
