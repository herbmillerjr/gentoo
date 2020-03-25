# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python{3_6,3_7} )

inherit distutils-r1

DESCRIPTION="Cython implementation of Toolz: High performance functional utilities"
HOMEPAGE="https://pypi.org/project/cytoolz/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

# Informed by author the dep in toolz is not only required but the
# tests are version sensitive.
# https://github.com/pytoolz/cytoolz/issues/57
RDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? ( dev-python/nose[${PYTHON_USEDEP}]
		>=dev-python/toolz-0.8[${PYTHON_USEDEP}] )"

python_compile() {
	python_is_python3 || local -x CFLAGS="${CFLAGS} -fno-strict-aliasing"

	distutils-r1_python_compile
}

python_test() {
	pushd "${BUILD_DIR}"/lib/ > /dev/null || die
	PYTHONPATH=.:${PN} nosetests --with-doctest ${PN} || die "tests failed under ${EPYTHON}"
	popd > /dev/null || die
}
