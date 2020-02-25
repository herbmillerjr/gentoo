# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} pypy3 )
DISTUTILS_USE_SETUPTOOLS=pyproject.toml
inherit distutils-r1

DESCRIPTION="Interface Python with pkg-config"
HOMEPAGE="https://pypi.org/project/pkgconfig/ https://github.com/matze/pkgconfig"
SRC_URI="https://github.com/matze/pkgconfig/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="virtual/pkgconfig"

distutils_enable_tests pytest
