# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Additional themes for the Xfce window manager"
HOMEPAGE="https://www.xfce.org/projects/"
SRC_URI="https://archive.xfce.org/src/art/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ppc ppc64 ~sparc x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND=">=xfce-base/xfwm4-4.10"
DEPEND=""

RESTRICT="binchecks strip"

pkg_setup() {
	DOCS=( AUTHORS ChangeLog README TODO )
}
