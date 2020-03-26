# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit xorg-2

DESCRIPTION="X.Org xpr application"
KEYWORDS="~alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 s390 sparc x86"
IUSE=""
RDEPEND="x11-libs/libXmu
	x11-libs/libX11"
DEPEND="${RDEPEND}"
