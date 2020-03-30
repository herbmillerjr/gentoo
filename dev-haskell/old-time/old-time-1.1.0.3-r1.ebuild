# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

# ebuild generated by hackport 0.4.4.9999

CABAL_FEATURES="lib profile haddock hoogle hscolour"
inherit haskell-cabal

DESCRIPTION="Time library"
HOMEPAGE="http://hackage.haskell.org/package/old-time"
SRC_URI="https://hackage.haskell.org/package/${P}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="amd64 ~ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND=">=dev-haskell/old-locale-1.0:=[profile?] <dev-haskell/old-locale-1.1:=[profile?]
	>=dev-lang/ghc-7.4.1:=
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-1.18.1.2
"

# it's not quite true, but there was no major releases
CABAL_CORE_LIB_GHC_PV="6.12.* 7.0.* 7.2.* 7.4.* 7.6.* 7.8.*"

src_prepare() {
	cabal_chdeps \
		'base       >= 4.7 && < 4.9' 'base       >= 4.7'
}
