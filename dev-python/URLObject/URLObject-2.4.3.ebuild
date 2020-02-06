# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_6 )

inherit distutils-r1

GITHUB_P=${P,,}
DESCRIPTION="A utility class for manipulating URLs"
HOMEPAGE="https://pypi.org/project/URLObject/"
# note: pypi tarball lacks tests
# https://github.com/zacharyvoase/urlobject/issues/39
SRC_URI="https://github.com/zacharyvoase/urlobject/archive/v${PV}.tar.gz -> ${GITHUB_P}.tar.gz"

LICENSE="BSD"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/six[${PYTHON_USEDEP}]"
DEPEND="
	${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/nose[${PYTHON_USEDEP}] )
"

S=${WORKDIR}/${GITHUB_P}

python_prepare_all() {
	rm "${S}/urlobject/six.py" || die
	find "${S}/urlobject" -type f -name \*.py \
		-exec sed -e 's/from \.six import/from six import/g' -i "{}" \; || die
	distutils-r1_python_prepare_all
}

python_test() {
	nosetests -v || die "Tests fail with ${EPYTHON}"
}
