# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

# ebuild generated by hackport 0.4.5.9999
#hackport: flags: -old-mtl

CABAL_FEATURES="lib profile haddock hoogle hscolour"
inherit haskell-cabal

DESCRIPTION="A library for writing CGI programs"
HOMEPAGE="https://github.com/cheecheeo/haskell-cgi"
SRC_URI="https://hackage.haskell.org/package/${P}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="amd64 ppc x86"
IUSE="+network-uri"

RDEPEND="<dev-haskell/exceptions-0.9:=[profile?]
	>=dev-haskell/mtl-2.1.3.1:=[profile?] <dev-haskell/mtl-2.3:=[profile?]
	dev-haskell/mtl-compat:=
	>=dev-haskell/multipart-0.1.2:=[profile?] <dev-haskell/multipart-0.2:=[profile?]
	<dev-haskell/old-locale-1.1:=[profile?]
	<dev-haskell/old-time-1.2:=[profile?]
	>=dev-haskell/parsec-2.0:=[profile?] <dev-haskell/parsec-3.2:=[profile?]
	>=dev-haskell/xhtml-3000.0.0:=[profile?] <dev-haskell/xhtml-3000.3:=[profile?]
	>=dev-lang/ghc-7.4.1:=
	network-uri? ( >=dev-haskell/network-2.6:=[profile?] <dev-haskell/network-2.7:=[profile?]
			>=dev-haskell/network-uri-2.6:=[profile?] <dev-haskell/network-uri-2.7:=[profile?] )
	!network-uri? ( <dev-haskell/network-2.6:=[profile?] )
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-1.6
"

src_configure() {
	local mtl_arg=()

	has_version '<dev-haskell/mtl-2.2' && \
		mtl_arg+=(--flag=old-mtl)

	haskell-cabal_src_configure \
		$(cabal_flag network-uri network-uri) \
		${mtl_arg}
}
