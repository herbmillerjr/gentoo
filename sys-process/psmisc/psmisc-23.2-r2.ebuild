# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A set of tools that use the proc filesystem"
HOMEPAGE="http://psmisc.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="ipv6 nls selinux X"

RDEPEND=">=sys-libs/ncurses-5.7-r7:0=
	nls? ( virtual/libintl )
	selinux? ( sys-libs/libselinux )"
DEPEND="${RDEPEND}
	>=sys-devel/libtool-2.2.6b
	nls? ( sys-devel/gettext )"

DOCS=( AUTHORS ChangeLog NEWS README )

PATCHES=(
	"${FILESDIR}/${P}-old_comm_len.patch"
	"${FILESDIR}/${P}-killall_check_truncated_16_char.patch"
)

src_configure() {
	local myeconfargs=(
		--disable-harden-flags
		$(use_enable ipv6)
		$(use_enable nls)
		$(use_enable selinux)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default

	use X || rm -f "${ED%/}"/usr/bin/pstree.x11

	[[ -s ${ED%/}/usr/bin/peekfd ]] || rm -f "${ED%/}"/usr/bin/peekfd
	[[ -e ${ED%/}/usr/bin/peekfd ]] || rm -f "${ED%/}"/usr/share/man/man1/peekfd.1

	# fuser is needed by init.d scripts; use * wildcard for #458250
	dodir /bin
	mv "${ED%/}"/usr/bin/*fuser "${ED%/}"/bin || die
}
