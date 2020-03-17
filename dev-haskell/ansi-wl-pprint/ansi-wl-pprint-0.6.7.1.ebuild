# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

# ebuild generated by hackport 0.3.5.9999

CABAL_FEATURES="bin lib profile haddock hoogle hscolour"
inherit haskell-cabal

DESCRIPTION="The Wadler/Leijen Pretty Printer for colored ANSI terminal output"
HOMEPAGE="https://github.com/batterseapower/ansi-wl-pprint"
SRC_URI="https://hackage.haskell.org/package/${P}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="amd64 ia64 ppc ppc64 sparc x86"
IUSE="example"

RDEPEND=">=dev-haskell/ansi-terminal-0.4.0:=[profile?] <dev-haskell/ansi-terminal-0.7:=[profile?]
	>=dev-lang/ghc-7.4.1:=
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-1.2
"

src_configure() {
	haskell-cabal_src_configure \
		$(cabal_flag example example)
}
