# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

# ebuild generated by hackport 0.4.6.9999

CABAL_FEATURES="lib profile haddock hoogle hscolour"
inherit haskell-cabal

DESCRIPTION="Binding to the GLIB library for Gtk2Hs"
HOMEPAGE="http://projects.haskell.org/gtk2hs/"
SRC_URI="https://hackage.haskell.org/package/${P}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0/${PV}"
KEYWORDS="amd64 ~ia64 ~ppc ~ppc64 ~sparc x86"
IUSE="+closure-signals"

RDEPEND=">=dev-haskell/text-1.0.0.0:=[profile?] <dev-haskell/text-1.3:=[profile?]
	>=dev-haskell/utf8-string-0.2:=[profile?] <dev-haskell/utf8-string-1.1:=[profile?]
	>=dev-lang/ghc-7.4.1:=
	dev-libs/glib:2
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-1.18
	dev-haskell/gtk2hs-buildtools
	virtual/pkgconfig
"

src_configure() {
	haskell-cabal_src_configure \
		$(cabal_flag closure-signals closure_signals)
}
