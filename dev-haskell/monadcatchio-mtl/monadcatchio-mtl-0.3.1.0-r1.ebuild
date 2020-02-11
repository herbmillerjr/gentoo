# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

# ebuild generated by hackport 0.3.5.9999

CABAL_FEATURES="lib profile haddock hoogle hscolour"
inherit haskell-cabal

MY_PN="MonadCatchIO-mtl"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Monad-transformer version of the Control.Exception module"
HOMEPAGE="http://darcsden.com/jcpetruzza/MonadCatchIO-mtl"
SRC_URI="https://hackage.haskell.org/package/${MY_P}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~alpha amd64 ppc sparc x86"
IUSE=""

RDEPEND="dev-haskell/extensible-exceptions:=[profile?]
	>=dev-haskell/monadcatchio-transformers-0.3.1.0:=[profile?]
	>=dev-lang/ghc-6.10.4:=
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-1.6.0.3
"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	cabal_chdeps \
		'MonadCatchIO-transformers==0.3.1.0' 'MonadCatchIO-transformers>=0.3.1.0'
}
