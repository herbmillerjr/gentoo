# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# ebuild generated by hackport 0.5.9999

CABAL_FEATURES="lib profile haddock hoogle hscolour"
inherit haskell-cabal

DESCRIPTION="Binding to GIO"
HOMEPAGE="http://projects.haskell.org/gtk2hs/"
SRC_URI="https://hackage.haskell.org/package/${P}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0/${PV}"
KEYWORDS="amd64 ~ia64 ~ppc ~ppc64 x86"
IUSE=""

RDEPEND=">=dev-haskell/glib-0.13.0.0:=[profile?] <dev-haskell/glib-0.14:=[profile?]
	dev-haskell/mtl:=[profile?]
	>=dev-lang/ghc-7.4.1:=
	dev-libs/glib:2
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-1.24
	virtual/pkgconfig
"
