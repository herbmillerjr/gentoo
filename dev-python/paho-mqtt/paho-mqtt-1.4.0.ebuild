# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_6 )

inherit distutils-r1

DESCRIPTION="A client class with support for both MQTT v3.1 and v3.1.1"
HOMEPAGE="https://www.eclipse.org/paho/clients/python/"
SRC_URI="https://github.com/eclipse/paho.mqtt.python/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/paho.mqtt.python-${PV}"

LICENSE="EPL-1.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"

RDEPEND=""
DEPEND="
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
	) "

RESTRICT="test" #659106

distutils_enable_tests pytest

src_prepare() {
	eapply "${FILESDIR}/${PN}-1.3.1-strip-test-dependency.patch"
	default
}
