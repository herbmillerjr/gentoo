# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="A complete yet simple CSS parser for Python"
HOMEPAGE="https://github.com/Kozea/tinycss2/ https://pypi.python.org/pypi/tinycss2/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=dev-python/webencodings-0.4[${PYTHON_USEDEP}]"

distutils_enable_tests pytest

src_prepare() {
	# junk deps
	sed -i -e '/pytest-runner/d' -e '/^addopts/d' setup.cfg || die
	distutils-r1_src_prepare
}
