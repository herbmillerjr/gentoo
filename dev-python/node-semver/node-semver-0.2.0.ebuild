# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_6 pypy3 )

inherit distutils-r1

DESCRIPTION="Python version of node-semver, the semantic versioner for npm"
HOMEPAGE="
	https://pypi.org/project/node-semver/
	https://github.com/podhmo/python-semver
	https://github.com/npm/node-semver"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="test? ( dev-python/pytest[${PYTHON_USEDEP}] )"

python_prepare_all() {
	distutils-r1_python_prepare_all
}

python_test() {
	py.test || die
}
