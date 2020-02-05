# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=(python{3_6,3_7,3_8})

inherit distutils-r1
MY_PN=pyRFC3339

MY_P=${MY_PN}-${PV}
DESCRIPTION="Generates and parses RFC 3339 timestamps"
HOMEPAGE="https://github.com/kurtraschke/pyRFC3339"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-python/pytz[${PYTHON_USEDEP}]"
DEPEND="test? ( ${RDEPEND}
		dev-python/nose[${PYTHON_USEDEP}] )
	dev-python/setuptools[${PYTHON_USEDEP}]"

S=${WORKDIR}/${MY_P}

python_test() {
	nosetests || die
}
