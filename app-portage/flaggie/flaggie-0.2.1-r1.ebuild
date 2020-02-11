# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=no
PYTHON_COMPAT=( python3_{6,7,8} )

inherit bash-completion-r1 distutils-r1

DESCRIPTION="A smart CLI mangler for package.* files"
HOMEPAGE="https://github.com/mgorny/flaggie/"
SRC_URI="https://github.com/mgorny/flaggie/releases/download/${P}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm ~hppa ~mips ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="sys-apps/portage[${PYTHON_USEDEP}]"

python_install_all() {
	newbashcomp contrib/bash-completion/${PN}.bash-completion ${PN}
	distutils-r1_python_install_all
}

pkg_postinst() {
	ewarn "Please note that flaggie creates backups of your package.* files"
	ewarn "before performing each change through appending a single '~'."
	ewarn "If you'd like to keep your own backup of them, please use another"
	ewarn "naming scheme (or even better some VCS)."
	if ! has_version app-shells/gentoo-bashcomp; then
		elog
		elog "If you want to use bash-completion, you need to install:"
		elog "	app-shells/gentoo-bashcomp"
	fi
}
