# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

# ebuild generated by hackport 0.3.2.9999

CABAL_FEATURES="lib profile haddock hoogle hscolour"
inherit haskell-cabal

MY_PN="QuickCheck"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Automatic testing of Haskell programs"
HOMEPAGE="https://github.com/nick8325/quickcheck"
SRC_URI="https://hackage.haskell.org/package/${MY_P}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="2/${PV}"
KEYWORDS="amd64 ia64 ppc ppc64 sparc x86 ~amd64-linux"
IUSE="+template-haskell"

RDEPEND="dev-haskell/extensible-exceptions:=[profile?]
		dev-haskell/random:=[profile?]
		>=dev-lang/ghc-6.10.4:="
DEPEND="${RDEPEND}
		>=dev-haskell/cabal-1.6"

S="${WORKDIR}/${MY_P}"

src_configure() {
	haskell-cabal_src_configure \
		$(cabal_flag template-haskell templatehaskell)
}
