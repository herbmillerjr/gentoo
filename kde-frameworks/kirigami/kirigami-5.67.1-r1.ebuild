# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_EXAMPLES="true"
ECM_QTHELP="false"
ECM_TEST="true"
KDE_ORG_NAME="${PN}2"
QTMIN=5.12.3
inherit ecm kde.org

DESCRIPTION="Lightweight user interface framework for mobile and convergent applications"
HOMEPAGE="https://techbase.kde.org/Kirigami"

LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE=""

# drop qtgui subslot operator when QT_MINIMAL >= 5.14.0
BDEPEND="
	>=dev-qt/linguist-tools-${QTMIN}:5
"
DEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5=
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtquickcontrols2-${QTMIN}:5
	>=dev-qt/qtsvg-${QTMIN}:5
"
RDEPEND="${DEPEND}
	>=dev-qt/qtgraphicaleffects-${QTMIN}:5
"

# requires package to already be installed
RESTRICT+=" test"

PATCHES=( "${FILESDIR}/${P}-sync-size-hints-w-state-machine.patch" )

src_configure() {
	local mycmakeargs=(
		-DBUILD_EXAMPLES=$(usex examples)
	)

	ecm_src_configure
}
