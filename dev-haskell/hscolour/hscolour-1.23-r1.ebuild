# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

# ebuild generated by hackport 0.4.6.9999

CABAL_FEATURES="bin lib profile haddock hoogle"
inherit haskell-cabal

DESCRIPTION="Colourise Haskell code"
HOMEPAGE="http://code.haskell.org/~malcolm/hscolour/"
SRC_URI="https://hackage.haskell.org/package/${P}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0/${PV}"
KEYWORDS="amd64 ~ia64 ~ppc ~ppc64 x86"
IUSE=""

RDEPEND=">=dev-lang/ghc-7.4.1:=
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-1.6
"

src_configure() {
	# llvm-general-pure passes rtsopts
	haskell-cabal_src_configure --ghc-options=-rtsopts
}

src_install() {
	cabal_src_install
	if use doc; then
		dohtml hscolour.css
	fi
}
