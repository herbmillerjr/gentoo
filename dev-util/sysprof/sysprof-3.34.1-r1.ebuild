# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome.org gnome2-utils meson systemd xdg

DESCRIPTION="System-wide Linux Profiler"
HOMEPAGE="http://sysprof.com/"

LICENSE="GPL-3+ GPL-2+"
API_VERSION="3"
SLOT="0/${API_VERSION}"
KEYWORDS="~amd64 ~x86"
IUSE="gtk"

RDEPEND="
	>=dev-libs/glib-2.61.3:2
	gtk? (
		>=x11-libs/gtk+-3.22.0:3
		>=dev-libs/libdazzle-3.30.0
	)
	>=sys-auth/polkit-0.114
	>=dev-util/sysprof-capture-3.34.1-r1:${API_VERSION}
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-libs/appstream-glib
	dev-util/gdbus-codegen
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	>=sys-kernel/linux-headers-2.6.32
	virtual/pkgconfig
"

src_prepare() {
	xdg_src_prepare
	# These are installed by dev-util/sysprof-capture
	sed -i -e '/install/d' src/libsysprof-capture/meson.build || die
	sed -i -e 's/pkgconfig\.generate/subdir_done()\npkgconfig\.generate/' src/libsysprof-capture/meson.build || die
}

src_configure() {
	# -Dwith_sysprofd=host currently unavailable from ebuild
	local emesonargs=(
		$(meson_use gtk enable_gtk)
		-Dlibsysprof=true
		-Dwith_sysprofd=bundled
		-Dsystemdunitdir=$(systemd_get_systemunitdir)
		# -Ddebugdir
		-Dhelp=true
	)
	meson_src_configure
}

src_install() {
	meson_src_install
	# installed by sysprof-capture, as mutter needs it at build time
	rm "${ED}"/usr/share/dbus-1/interfaces/org.gnome.Sysprof3.Profiler.xml || die
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update

	elog "On many systems, especially amd64, it is typical that with a modern"
	elog "toolchain -fomit-frame-pointer for gcc is the default, because"
	elog "debugging is still possible thanks to gcc4/gdb location list feature."
	elog "However sysprof is not able to construct call trees if frame pointers"
	elog "are not present. Therefore -fno-omit-frame-pointer CFLAGS is suggested"
	elog "for the libraries and applications involved in the profiling. That"
	elog "means a CPU register is used for the frame pointer instead of other"
	elog "purposes, which means a very minimal performance loss when there is"
	elog "register pressure."
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
