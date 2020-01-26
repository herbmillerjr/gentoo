# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="4"

inherit eutils multilib

# Maintainer notes: Take a look at http://xmlrpc-c.sourceforge.net/release.html
# We use "advanced" branch, so for the current release revision take look here:
# http://xmlrpc-c.svn.sourceforge.net/viewvc/xmlrpc-c/advanced/version.mk?view=log
# e.g. for 1.27.05 corresponds following revision 2182 and thus following URL:
# http://xmlrpc-c.svn.sourceforge.net/viewvc/xmlrpc-c/advanced.tar.gz?view=tar&pathrev=2182
# Note: autogenerated tarball checksum changes every download, thus download it
# manually and distribute on mirrors.
# It's possible to build net-libs/libwww without ssl support, but taking into
# account that libwww is not really well maintained and upstream is dead we
# better use it only in case ssl is required.

DESCRIPTION="A lightweigt RPC library based on XML and HTTP"
HOMEPAGE="http://xmlrpc-c.sourceforge.net/"
SRC_URI="https://dev.gentoo.org/~maksbotan/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="abyss +cgi +curl +cxx +libxml2 static-libs threads test tools"
RESTRICT="!test? ( test )"

REQUIRED_USE="test? ( static-libs abyss curl cxx ) tools? ( curl )"

DEPEND="
	sys-libs/ncurses
	sys-libs/readline
	curl? ( net-misc/curl )
	libxml2? ( dev-libs/libxml2 )"

RDEPEND="${DEPEND}"

S="${WORKDIR}/advanced"

pkg_setup() {
	use curl || ewarn "Curl support disabled: No client library will be built"
}

src_prepare() {
	#Bug 214137: We need to filter this.
	unset SRCDIR

	# Bug 255440
	export LC_ALL=C
	export LANG=C

	epatch "${FILESDIR}"/${PN}-1.32.05-Wimplicit.patch
	sed -i \
		-e "/CFLAGS_COMMON/s|-g -O3$||" \
		-e "/CXXFLAGS_COMMON/s|-g$||" \
		"${S}"/common.mk || die

	export LADD=${LDFLAGS} # Respect the user's LDFLAGS.

	use static-libs || { sed \
		-e '/\(^TARGET_STATIC_LIBRARIES =\)/{s:\(^TARGET_STATIC_LIBRARIES =\).*:\1:;P;N;d;}' \
			-i common.mk || die; }
}

src_configure() {
	#Disable libwww support due GBZ #409549 and #320253

	econf --disable-wininet-client \
		$(use_enable libxml2 libxml2-backend) \
		--disable-libwww-client \
		--without-libwww-ssl  \
		$(use_enable threads abyss-threads) \
		$(use_enable cgi cgi-server) \
		$(use_enable abyss abyss-server) \
		$(use_enable cxx cplusplus) \
		$(use_enable curl curl-client)
}

src_compile() {
	emake -r
	use tools && emake -rC "${S}"/tools
}

src_install() {
	default_src_install
	use tools && emake DESTDIR="${D}" -rC "${S}"/tools install
}

src_test() {
	unset LDFLAGS LADD SRCDIR
	cd "${S}"/test/
	einfo "Building general tests"
	make || die "Make of general tests failed"
	einfo "Running general tests"
	./test || die "General tests failed"
	cd "${S}"/test/cpp/
	einfo "Running C++ tests"
	./test || die "C++ tests failed"
}
