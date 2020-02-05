# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_6)

inherit distutils-r1

DESCRIPTION="Universal Binary JSON encoder/decoder"
HOMEPAGE="https://github.com/Iotic-Labs/py-ubjson https://pypi.org/project/py-ubjson/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
