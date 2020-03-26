# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=OALDERS
DIST_VERSION=6.04
inherit perl-module

DESCRIPTION="Storage of cookies"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ia64 ~m68k ~mips ppc ppc64 ~riscv s390 sparc x86 ~ppc-aix ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	!<dev-perl/libwww-perl-6
	virtual/perl-Carp
	>=dev-perl/HTTP-Date-6.0.0
	virtual/perl-Time-Local
	>=dev-perl/HTTP-Message-6.0.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Test
		virtual/perl-Test-Simple
		dev-perl/URI
	)
"
