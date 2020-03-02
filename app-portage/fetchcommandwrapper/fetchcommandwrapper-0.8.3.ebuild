# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
PYTHON_COMPAT=( python3_{6,7,8} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="Wrapper integrating aria2 into portage's FETCHCOMMAND"
HOMEPAGE="https://github.com/hartwork/fetchcommandwrapper"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=">=net-misc/aria2-1.10.2[metalink,xmlrpc]"

pkg_postinst() {
	ewarn 'You need to append'
	ewarn '   source /usr/share/fetchcommandwrapper/make.conf'
	ewarn 'to /etc/portage/make.conf in order to integrate fetchcommandwrapper.'
}
