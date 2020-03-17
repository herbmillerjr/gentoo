# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python3_6 )

inherit distutils-r1

DESCRIPTION="Capture stdout,stderr easily"
HOMEPAGE="https://pypi.org/project/iocapture/"
SRC_URI="https://github.com/oinume/iocapture/archive/${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc x86"
LICENSE="MIT"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=""
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		${RDEPEND}
	)"

python_test() {
	py.test || die "Tests fail with ${EPYTHON}"
}
