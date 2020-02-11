# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=YANICK
DIST_VERSION=1.19
DIST_EXAMPLES=( "examples/*" )
inherit perl-module

DESCRIPTION="A simple parallel processing fork manager"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm ia64 ~ppc ~ppc64 sparc x86 ~sparc-solaris ~x86-solaris"
IUSE="test minimal"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-File-Path
	virtual/perl-File-Temp
	virtual/perl-Storable
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		!minimal? ( >=virtual/perl-CPAN-Meta-2.120.900 )
		virtual/perl-IO
		>=virtual/perl-Test-Simple-0.940.0
		dev-perl/Test-Warn
	)
"
