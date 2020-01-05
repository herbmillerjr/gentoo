# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7,8} pypy3 )

inherit distutils-r1

DESCRIPTION="Pretty-print tabular data"
HOMEPAGE="https://pypi.org/project/tabulate/ https://github.com/astanin/python-tabulate"
SRC_URI="https://github.com/astanin/python-${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/python-${P}"

SLOT="0"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/wcwidth[${PYTHON_USEDEP}]"
BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		$(python_gen_impl_dep 'sqlite')
		dev-python/colorclass[${PYTHON_USEDEP}]
		$(python_gen_cond_dep 'dev-python/numpy[${PYTHON_USEDEP}]' 'python3*')
		virtual/python-funcsigs[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}/tabulate-0.8.6-avoid-pandas-dep.patch"
)

distutils_enable_tests nose
