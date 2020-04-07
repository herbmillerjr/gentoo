# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# ebuild generated by hackport 0.5.9999
#hackport: flags: cairo_ps:postscript,cairo_pdf:pdf,cairo_svg:svg

CABAL_FEATURES="lib profile haddock hoogle hscolour"
inherit haskell-cabal

DESCRIPTION="Binding to the Cairo library"
HOMEPAGE="http://projects.haskell.org/gtk2hs/"
SRC_URI="https://hackage.haskell.org/package/${P}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="amd64 ~ia64 ~ppc ~ppc64 x86"
IUSE="+pdf +postscript +svg"

RDEPEND="dev-haskell/mtl:=[profile?]
	>=dev-haskell/text-1.0.0.0:=[profile?] <dev-haskell/text-1.3:=[profile?]
	>=dev-haskell/utf8-string-0.2:=[profile?] <dev-haskell/utf8-string-1.1:=[profile?]
	>=dev-lang/ghc-7.4.1:=
	x11-libs/cairo
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-1.24
	dev-haskell/gtk2hs-buildtools
	virtual/pkgconfig
"

src_configure() {
	haskell-cabal_src_configure \
		$(cabal_flag pdf cairo_pdf) \
		$(cabal_flag postscript cairo_ps) \
		$(cabal_flag svg cairo_svg)
}
