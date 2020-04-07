# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# ebuild generated by hackport 0.6.9999

CABAL_FEATURES="lib profile" # haddock hoogle hscolour"
inherit haskell-cabal

DESCRIPTION="Backported Control.Monad.Except module from mtl"
HOMEPAGE="https://github.com/haskell-compat/mtl-compat"
SRC_URI="https://hackage.haskell.org/package/${P}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND=">=dev-haskell/mtl-2.1:=[profile?] <dev-haskell/mtl-2.3:=[profile?]
	dev-haskell/transformers-compat:=
	>=dev-lang/ghc-7.4.1:=
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-1.8
"

src_configure() {
	local mtl_arg=()

	has_version '>=dev-haskell/mtl-2.0.1' && \
		has_version '<dev-haskell/mtl-2.2' && \
		mtl_arg+=(--flag=two-point-one)
	has_version '>=dev-haskell/mtl-2.2.0.1' && \
		has_version '<dev-haskell/mtl-2.2.1' && \
		mtl_arg+=(--flag=two-point-two)
	haskell-cabal_src_configure \
		${mtl_arg}
}
