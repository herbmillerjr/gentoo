# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby24 ruby25 ruby26 ruby27"

RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.rdoc SPEC"

RUBY_FAKEGEM_GEMSPEC="rack.gemspec"

inherit ruby-fakegem

DESCRIPTION="A modular Ruby webserver interface"
HOMEPAGE="https://rack.github.com/"
SRC_URI="https://github.com/rack/rack/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(ver_cut 1-2)"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~x86"
IUSE=""

ruby_add_rdepend "virtual/ruby-ssl"

ruby_add_bdepend "test? (
	dev-ruby/minitest:5
	dev-ruby/minitest-global_expectations
	dev-ruby/concurrent-ruby
)"

# The gem has automagic dependencies over mongrel, ruby-openid,
# memcache-client, thin, mongrel and camping; not sure if we should
# make them dependencies at all.

# Block against versions in older slots that also try to install a binary.
RDEPEND="${RDEPEND} !<dev-ruby/rack-1.4.5-r1:1.4 !<dev-ruby/rack-1.5.2-r4:1.5 !<dev-ruby/rack-1.6.4-r2:1.6"

all_ruby_prepare() {
	# The build system tries to generate the ChangeLog from git. Create
	# an empty file to avoid a needless dependency on git.
	touch ChangeLog || die

	# Avoid development dependency
	sed -i -e '/minitest-sprint/ s:^:#:' rack.gemspec || die
}

each_ruby_test() {
	${RUBY} -Ilib:test:. -e "require 'test/gemloader.rb'; Dir['test/spec_*.rb'].each{|f| require f}" || die
}
