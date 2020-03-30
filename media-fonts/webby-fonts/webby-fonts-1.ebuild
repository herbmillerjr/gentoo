# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="A small proportional bitmap font for use in webpages"
HOMEPAGE="http://www.proggyfonts.com/"
SRC_URI="http://dl.liveforge.org/fonts/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 sparc x86"

S="${WORKDIR}/${PN}"

FONT_S="${S}"
FONT_SUFFIX="pcf.gz"
