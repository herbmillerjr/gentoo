# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson xdg-utils

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ximion/${PN}"
else
	SRC_URI="https://www.freedesktop.org/software/appstream/releases/AppStream-${PV}.tar.xz"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
	S="${WORKDIR}/AppStream-${PV}"
fi

DESCRIPTION="Cross-distro effort for providing metadata for software in the Linux ecosystem"
HOMEPAGE="https://www.freedesktop.org/wiki/Distributions/AppStream/"

LICENSE="LGPL-2.1+ GPL-2+"
# check as_api_level
SLOT="0/4"
IUSE="apt doc +introspection qt5 test"
RESTRICT="!test? ( test )"

BDEPEND="
	dev-libs/appstream-glib
	dev-libs/libxslt
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	doc? ( app-text/docbook-xml-dtd:4.5 )
	test? ( dev-qt/linguist-tools:5 )
"
RDEPEND="
	dev-db/lmdb:=
	>=dev-libs/glib-2.58:2
	dev-libs/libxml2:2
	dev-libs/libyaml
	dev-libs/snowball-stemmer
	>=net-libs/libsoup-2.56:2.4
	introspection? ( >=dev-libs/gobject-introspection-1.56:= )
	qt5? ( dev-qt/qtcore:5 )
"
DEPEND="${RDEPEND}
	test? ( qt5? ( dev-qt/qttest:5 ) )
"

src_prepare() {
	default
	sed -e "/^as_doc_target_dir/s/appstream/${PF}/" -i docs/meson.build || die
	if ! use test; then
		sed -e "/^subdir.*tests/s/^/#DONT /" -i {,qt/}meson.build || die # bug 675944
	fi
}

src_configure() {
	xdg_environment_reset

	local emesonargs=(
		-Dapidocs=false
		-Ddocs=false
		-Dmaintainer=false
		-Dstemming=true
		-Dvapi=false
		-Dapt-support=$(usex apt true false)
		-Dinstall-docs=$(usex doc true false)
		-Dgir=$(usex introspection true false)
		-Dqt=$(usex qt5 true false)
	)

	meson_src_configure
}
