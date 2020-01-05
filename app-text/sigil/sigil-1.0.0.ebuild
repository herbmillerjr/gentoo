# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )
PYTHON_REQ_USE="tk"

inherit cmake-utils python-single-r1 xdg-utils

DESCRIPTION="Multi-platform WYSIWYG ebook editor for ePub format"
HOMEPAGE="https://sigil-ebook.com/ https://github.com/Sigil-Ebook/Sigil"
SRC_URI="https://github.com/Sigil-Ebook/Sigil/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+ Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+plugins system-mathjax"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	app-text/hunspell:=
	dev-libs/libpcre:3=[pcre16]
	$(python_gen_cond_dep \
		'dev-python/css-parser[${PYTHON_MULTI_USEDEP}]
		dev-python/lxml[${PYTHON_MULTI_USEDEP}]
		dev-python/six[${PYTHON_MULTI_USEDEP}]')
	>=dev-qt/qtconcurrent-5.12:5
	>=dev-qt/qtcore-5.12:5
	>=dev-qt/qtgui-5.12:5
	>=dev-qt/qtprintsupport-5.12:5
	>=dev-qt/qtwebengine-5.12:5[widgets]
	>=dev-qt/qtwidgets-5.12:5
	sys-libs/zlib[minizip]
	plugins? ( $(python_gen_cond_dep \
		'dev-python/chardet[${PYTHON_MULTI_USEDEP}]
		dev-python/cssselect[${PYTHON_MULTI_USEDEP}]
		dev-python/cssutils[${PYTHON_MULTI_USEDEP}]
		dev-python/html5lib[${PYTHON_MULTI_USEDEP}]
		dev-python/pillow[${PYTHON_MULTI_USEDEP}]
		dev-python/regex[${PYTHON_MULTI_USEDEP}]') )
	system-mathjax? ( dev-libs/mathjax )
"
DEPEND="${RDEPEND}"

BDEPEND="
	dev-qt/linguist-tools:5
	virtual/pkgconfig
"

S="${WORKDIR}/Sigil-${PV}"

DOCS=( ChangeLog.txt README.md )

src_configure() {
	python_export PYTHON_LIBPATH PYTHON_INCLUDEDIR
	local mycmakeargs=(
		-DINSTALL_BUNDLED_DICTS=0
		-DUSE_SYSTEM_LIBS=1
		-DSYSTEM_LIBS_REQUIRED=1
		-DPYTHON_EXECUTABLE="${PYTHON}"
		-DPYTHON_LIBRARY="${PYTHON_LIBPATH}"
		-DPYTHON_INCLUDE_DIR="${PYTHON_INCLUDEDIR}"
	)
	use system-mathjax && mycmakeargs+=( -DMATHJAX_DIR="${EPREFIX}"/usr/share/mathjax )

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	python_fix_shebang "${ED}"/usr/share/sigil/
	python_optimize "${ED}"/usr/share/sigil/
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
