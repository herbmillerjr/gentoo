# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

# ebuild generated by hackport 0.3.6.9999

CABAL_FEATURES="lib profile haddock hoogle hscolour"
inherit haskell-cabal

DESCRIPTION="Bindings for the libXML2 SAX interface"
HOMEPAGE="https://john-millikin.com/software/haskell-libxml/"
SRC_URI="https://hackage.haskell.org/package/${P}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="amd64 ia64 ppc ppc64 sparc x86"
IUSE=""

RDEPEND=">=dev-haskell/text-0.7:=[profile?]
	>=dev-haskell/xml-types-0.3:=[profile?] <dev-haskell/xml-types-0.4:=[profile?]
	>=dev-lang/ghc-6.10.4:=
	dev-libs/libxml2
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-1.6.0.3
	virtual/pkgconfig
"
