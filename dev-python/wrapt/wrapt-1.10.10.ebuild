# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_6 )

inherit distutils-r1 vcs-snapshot

DESCRIPTION="Module for decorators, wrappers and monkey patching"
HOMEPAGE="https://github.com/GrahamDumpleton/wrapt"
SRC_URI="https://github.com/GrahamDumpleton/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ia64 ppc ppc64 sparc x86 ~amd64-linux"
IUSE="doc test"
RESTRICT="!test? ( test )"

DEPEND="
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )
	doc? (
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/sphinx_rtd_theme[${PYTHON_USEDEP}]
	)
"
RDEPEND=""

python_compile_all() {
	use doc && emake -C docs html
}

python_compile() {
	local WRAPT_EXTENSIONS=true

	distutils-r1_python_compile
}

python_test() {
	py.test -vv || die "tests failed under ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )

	distutils-r1_python_install_all
}
