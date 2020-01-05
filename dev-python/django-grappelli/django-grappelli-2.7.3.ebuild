# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python3_6 )

inherit distutils-r1

DESCRIPTION="A jazzy skin for the Django Admin-Interface"
HOMEPAGE="
	https://pypi.org/project/django-grappelli/
	https://django-grappelli.readthedocs.org
	https://github.com/sehmaschine/django-grappelli"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""
