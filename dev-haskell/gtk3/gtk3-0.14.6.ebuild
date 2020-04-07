# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# ebuild generated by hackport 0.5.9999
#hackport: flags: have-gio:gio,build-demos:examples

CABAL_FEATURES="lib profile haddock hoogle hscolour"
inherit haskell-cabal

DESCRIPTION="Binding to the Gtk+ 3 graphical user interface library"
HOMEPAGE="http://projects.haskell.org/gtk2hs/"
SRC_URI="https://hackage.haskell.org/package/${P}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0/${PV}"
KEYWORDS="amd64 ~ia64 ~ppc ~ppc64 x86"
IUSE="+fmode-binary +gio"

RDEPEND=">=dev-haskell/cairo-0.13.0.0:=[profile?] <dev-haskell/cairo-0.14:=[profile?]
	>=dev-haskell/glib-0.13.0.0:=[profile?] <dev-haskell/glib-0.14:=[profile?]
	dev-haskell/mtl:=[profile?]
	>=dev-haskell/pango-0.13.0.0:=[profile?] <dev-haskell/pango-0.14:=[profile?]
	>=dev-haskell/text-0.11.0.6:=[profile?] <dev-haskell/text-1.3:=[profile?]
	>=dev-lang/ghc-7.4.1:=
	dev-libs/glib:2
	x11-libs/gtk+:3
	gio? ( >=dev-haskell/gio-0.13.0:=[profile?] <dev-haskell/gio-0.14:=[profile?] )
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-1.24
	virtual/pkgconfig
"

src_configure() {
	haskell-cabal_src_configure \
		$(cabal_flag fmode-binary fmode-binary) \
		$(cabal_flag gio have-gio)
}
