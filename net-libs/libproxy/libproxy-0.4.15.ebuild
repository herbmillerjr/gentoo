# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_ECLASS=cmake
PYTHON_COMPAT=( python3_{6,7,8} )
inherit cmake-multilib flag-o-matic mono-env python-r1

DESCRIPTION="Library for automatic proxy configuration management"
HOMEPAGE="https://github.com/libproxy/libproxy"
SRC_URI="https://github.com/libproxy/libproxy/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="gnome kde mono networkmanager perl python spidermonkey test webkit"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"
RESTRICT="!test? ( test )"

BDEPEND="
	virtual/pkgconfig:0[${MULTILIB_USEDEP}]
"
DEPEND="
	gnome? ( dev-libs/glib:2[${MULTILIB_USEDEP}] )
	mono? ( dev-lang/mono )
	networkmanager? ( sys-apps/dbus:0[${MULTILIB_USEDEP}] )
	perl? ( dev-lang/perl:= )
	python? ( ${PYTHON_DEPS} )
	spidermonkey? ( >=dev-lang/spidermonkey-52.0.0:= )
	webkit? ( net-libs/webkit-gtk:4 )
"
RDEPEND="${DEPEND}
	kde? ( kde-frameworks/kconfig:5 )
"
# avoid dependency loop, bug #467696
PDEPEND="networkmanager? ( net-misc/networkmanager )"

PATCHES=(
	# get-pac-test freezes when run by the ebuild, succeeds when building
	# manually; virtualx.eclass doesn't help :(
	"${FILESDIR}/${PN}-0.4.10-disable-pac-test.patch"

	# https://github.com/libproxy/libproxy/issues/27
	"${FILESDIR}/${PN}-0.4.12-macosx.patch"

	# prevent dependency loop with networkmanager, libsoup, glib-networking; bug #467696
	# https://github.com/libproxy/libproxy/issues/28
	"${FILESDIR}/${P}-avoid-nm-build-dep.patch"

	# backports from git master:
	"${FILESDIR}"/${P}-python-3.7.patch # find python-3.7 and 3.8 as well
	"${FILESDIR}"/${P}-mozjs-52-{1,2}.patch
)

multilib_src_configure() {
	local mycmakeargs=(
		-DCMAKE_C_FLAGS="${CFLAGS}"
		-DCMAKE_CXX_FLAGS="${CXXFLAGS}"
		-DWITH_NATUS=OFF
		-DWITH_PYTHON2=OFF
		# WITH_VALA just copies the .vapi file over and needs no deps,
		# hence always enable it unconditionally
		-DWITH_VALA=ON
		-DWITH_WEBKIT=OFF
		$(multilib_is_native_abi && usex mono -DGMCS_EXECUTABLE="${EPREFIX}"/usr/bin/mcs)
		-DWITH_GNOME3=$(usex gnome)
		-DWITH_KDE=$(usex kde)
		-DWITH_DOTNET=$(multilib_is_native_abi && usex mono || echo OFF)
		-DWITH_NM=$(usex networkmanager)
		$(multilib_is_native_abi && usex perl -DPERL_VENDORINSTALL=ON)
		-DWITH_PERL=$(multilib_is_native_abi && usex perl || echo OFF)
		-DWITH_PYTHON3=$(multilib_is_native_abi && usex python || echo OFF)
		-DWITH_MOZJS=$(multilib_is_native_abi && usex spidermonkey || echo OFF)
		-DBUILD_TESTING=$(usex test)
		-DWITH_WEBKIT3=$(multilib_is_native_abi && usex webkit || echo OFF)
	)
	cmake_src_configure
}

src_configure() {
	[[ ${CHOST} == *-solaris* ]] && append-libs -lsocket -lnsl

	use python && python_setup
	multilib-minimal_src_configure
}

multilib_src_install_all() {
	doman "${FILESDIR}"/proxy.1
	use python && python_foreach_impl python_domodule bindings/python/libproxy.py
}
