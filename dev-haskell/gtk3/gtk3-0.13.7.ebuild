# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

# ebuild generated by hackport 0.4.4.9999

#nocabaldep is for the fancy cabal-detection feature at build-time
CABAL_FEATURES="bin lib profile haddock hoogle hscolour nocabaldep"
inherit haskell-cabal

DESCRIPTION="Binding to the Gtk+ graphical user interface library"
HOMEPAGE="http://projects.haskell.org/gtk2hs/"
SRC_URI="https://hackage.haskell.org/package/${P}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0/${PV}"
KEYWORDS="amd64 ~ia64 ~ppc ~ppc64 ~sparc x86"
IUSE="examples +fmode-binary +gio"

RDEPEND=">=dev-haskell/cairo-0.13.0.0:=[profile?] <dev-haskell/cairo-0.14:=[profile?]
	>=dev-haskell/glib-0.13.0.0:=[profile?] <dev-haskell/glib-0.14:=[profile?]
	dev-haskell/mtl:=[profile?]
	>=dev-haskell/pango-0.13.0.0:=[profile?] <dev-haskell/pango-0.14:=[profile?]
	>=dev-haskell/text-0.11.0.6:=[profile?] <dev-haskell/text-1.3:=[profile?]
	dev-haskell/transformers:=[profile?]
	>=dev-lang/ghc-7.4.1:=
	dev-libs/glib:2
	x11-libs/gtk+:3
	gio? ( >=dev-haskell/gio-0.13.0:=[profile?] <dev-haskell/gio-0.14:=[profile?] )
"
DEPEND="${RDEPEND}
	>=dev-haskell/gtk2hs-buildtools-0.13.0.3:0=
	virtual/pkgconfig
"

src_prepare() {
	# workaround for module order
	cabal_chdeps \
		'other-modules:' 'exposed-modules:'
	# fix build with gcc 5.1.0 and later https://github.com/gtk2hs/gtk2hs/issues/104
	sed -e 's@gccProg, "--cppopts=-E"@gccProg, "--cppopts=-E", "--cppopts=-P"@' \
		-i Gtk2HsSetup.hs || die
}

src_configure() {
	cabal_src_configure \
		$(cabal_flag examples build-demos) \
		$(cabal_flag fmode-binary fmode-binary) \
		$(cabal_flag gio have-gio) \
		--flags=-have-quartz-gtk
}
