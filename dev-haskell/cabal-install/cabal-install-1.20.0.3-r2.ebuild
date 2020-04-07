# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

# ebuild generated by hackport 0.4.9999

CABAL_FEATURES="bin test-suite"
inherit bash-completion-r1 eutils haskell-cabal

DESCRIPTION="The command-line interface for Cabal and Hackage"
HOMEPAGE="http://www.haskell.org/cabal/"
SRC_URI="https://hackage.haskell.org/package/${P}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~x86"
IUSE="+noprefs"

RDEPEND=""
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-1.20.0 <dev-haskell/cabal-1.21
	>=dev-haskell/http-4000.2.5 <dev-haskell/http-4000.3
	>=dev-haskell/mtl-2.0 <dev-haskell/mtl-3
	>=dev-haskell/network-2.0 <dev-haskell/network-2.7
	dev-haskell/network-uri
	>=dev-haskell/random-1 <dev-haskell/random-1.2
	>=dev-haskell/stm-2.0 <dev-haskell/stm-3
	>=dev-haskell/zlib-0.5.3 <dev-haskell/zlib-0.6
	>=dev-lang/ghc-7.4.1
	test? ( dev-haskell/hunit
		>=dev-haskell/quickcheck-2.5
		dev-haskell/test-framework
		dev-haskell/test-framework-hunit
		>=dev-haskell/test-framework-quickcheck2-0.3 )
"

src_prepare() {
	if use noprefs; then
		epatch "${FILESDIR}/${PN}"-0.13.3-nopref.patch
	fi

	# no chance to link to -threaded on ppc64, alpha and others
	# who use UNREG, not only ARM
	if ! ghc-supports-threaded-runtime; then
		cabal_chdeps '-threaded' ' '
	fi

	cabal_chdeps \
		'network    >= 2.0      && < 2.6' 'network    >= 2.0      && < 2.7, network-uri' \
		'network,' 'network,network-uri,' \
		'random     >= 1        && < 1.1' 'random     >= 1        && < 1.2'
}

src_install() {
	haskell-cabal_src_install

	dobashcomp "${S}/bash-completion/cabal"
}
