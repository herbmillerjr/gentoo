# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{6,7,8} )
PYTHON_REQ_USE="xml"
inherit gnome2 python-single-r1 toolchain-funcs

DESCRIPTION="Introspection system for GObject-based libraries"
HOMEPAGE="https://wiki.gnome.org/Projects/GObjectIntrospection"

LICENSE="LGPL-2+ GPL-2+"
SLOT="0"
IUSE="cairo doctool test"
RESTRICT="!test? ( test )"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	test? ( cairo )
"
KEYWORDS="~alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

# virtual/pkgconfig needed at runtime, bug #505408
RDEPEND="
	>=dev-libs/gobject-introspection-common-${PV}
	>=dev-libs/glib-2.58.0:2
	doctool? (
		$(python_gen_cond_dep '
			dev-python/mako[${PYTHON_MULTI_USEDEP}]
			dev-python/markdown[${PYTHON_MULTI_USEDEP}]
		')
	)
	virtual/libffi:=
	virtual/pkgconfig
	!<dev-lang/vala-0.20.0
	${PYTHON_DEPS}
"
# Wants real bison, not virtual/yacc
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.19
	sys-devel/bison
	sys-devel/flex
	test? (
		x11-libs/cairo[glib]
		$(python_gen_cond_dep '
			dev-python/markdown[${PYTHON_MULTI_USEDEP}]
		')
	)
" # autoreconf needs autoconf-archive
# PDEPEND to avoid circular dependencies, bug #391213; but needed for tests, thus test DEPEND as well
PDEPEND="cairo? ( x11-libs/cairo[glib] )"

pkg_setup() {
	python-single-r1_pkg_setup
}

src_configure() {
	if ! has_version "x11-libs/cairo[glib]"; then
		# Bug #391213: enable cairo-gobject support even if it's not installed
		# We only PDEPEND on cairo to avoid circular dependencies
		export CAIRO_LIBS="-lcairo -lcairo-gobject"
		export CAIRO_CFLAGS="-I${EPREFIX}/usr/include/cairo"
	fi

	# To prevent crosscompiling problems, bug #414105
	gnome2_src_configure \
		--disable-static \
		CC="$(tc-getCC)" \
		YACC="$(type -p yacc)" \
		$(use_with cairo) \
		$(use_enable doctool)
}

src_install() {
	gnome2_src_install

	# Prevent collision with gobject-introspection-common
	rm -v "${ED}"usr/share/aclocal/introspection.m4 \
		"${ED}"usr/share/gobject-introspection-1.0/Makefile.introspection || die
	rmdir "${ED}"usr/share/aclocal || die
}
