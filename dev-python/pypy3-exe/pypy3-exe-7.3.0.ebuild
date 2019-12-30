# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# pypy3 needs to be built using python 2
PYTHON_COMPAT=( python2_7 pypy )
inherit check-reqs pax-utils python-any-r1 toolchain-funcs

MY_P=pypy3.6-v${PV/_/}
DESCRIPTION="PyPy3 executable (build from source)"
HOMEPAGE="https://pypy.org/"
SRC_URI="https://bitbucket.org/pypy/pypy/downloads/${MY_P}-src.tar.bz2"
S="${WORKDIR}/${MY_P}-src"

LICENSE="MIT"
SLOT="${PV}"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="bzip2 +jit low-memory ncurses sandbox cpu_flags_x86_sse2"

RDEPEND=">=sys-libs/zlib-1.1.3:0=
	virtual/libffi:0=
	virtual/libintl:0=
	dev-libs/expat:0=
	bzip2? ( app-arch/bzip2:0= )
	ncurses? ( sys-libs/ncurses:0= )
	!dev-python/pypy3-exe-bin:${PV}"
DEPEND="${RDEPEND}
	low-memory? ( dev-python/pypy )
	!low-memory? (
		|| (
			dev-python/pypy
			(
				dev-lang/python:2.7
				dev-python/pycparser[python_targets_python2_7(-),python_single_target_python2_7(+)]
			)
		)
	)"

check_env() {
	if use low-memory; then
		CHECKREQS_MEMORY="1750M"
		use amd64 && CHECKREQS_MEMORY="3500M"
	else
		CHECKREQS_MEMORY="3G"
		use amd64 && CHECKREQS_MEMORY="6G"
	fi

	check-reqs_pkg_pretend
}

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && check_env
}

pkg_setup() {
	if [[ ${MERGE_TYPE} != binary ]]; then
		check_env

		# unset to allow forcing pypy below :)
		use low-memory && local EPYTHON=
		if python_is_installed pypy && [[ ! ${EPYTHON} || ${EPYTHON} == pypy ]]; then
			einfo "Using PyPy to perform the translation."
			local EPYTHON=pypy
		else
			einfo "Using ${EPYTHON:-python2} to perform the translation. Please note that upstream"
			einfo "recommends using PyPy for that. If you wish to do so, please install"
			einfo "dev-python/pypy and ensure that EPYTHON variable is unset."
		fi

		python-any-r1_pkg_setup
	fi
}

src_configure() {
	tc-export CC

	local jit_backend
	if use jit; then
		jit_backend='--jit-backend='

		# We only need the explicit sse2 switch for x86.
		# On other arches we can rely on autodetection which uses
		# compiler macros. Plus, --jit-backend= doesn't accept all
		# the modern values...

		if use x86; then
			if use cpu_flags_x86_sse2; then
				jit_backend+=x86
			else
				jit_backend+=x86-without-sse2
			fi
		else
			jit_backend+=auto
		fi
	fi

	local args=(
		--no-shared
		$(usex jit -Ojit -O2)
		$(usex sandbox --sandbox '')

		${jit_backend}

		pypy/goal/targetpypystandalone
	)

	# Avoid linking against libraries disabled by use flags
	local opts=(
		bzip2:bz2
		ncurses:_minimal_curses
	)

	local opt
	for opt in "${opts[@]}"; do
		local flag=${opt%:*}
		local mod=${opt#*:}

		args+=(
			$(usex ${flag} --withmod --withoutmod)-${mod}
		)
	done

	local interp=( "${PYTHON}" )
	if use low-memory; then
		interp=( env PYPY_GC_MAX_DELTA=200MB
			"${PYTHON}" --jit loop_longevity=300 )
	fi

	# translate into the C sources
	# we're going to make them ourselves since otherwise pypy does not
	# free up the unneeded memory before spawning the compiler
	set -- "${interp[@]}" rpython/bin/rpython --batch --source "${args[@]}"
	echo -e "\033[1m${@}\033[0m"
	"${@}" || die "translation failed"
}

src_compile() {
	emake -C "${T}"/usession*-0/testing_1
}

src_install() {
	local dest=/usr/lib/pypy3.6
	exeinto "${dest}"
	newexe "${T}"/usession*-0/testing_1/pypy3-c pypy3-c-${PV}
	insinto "${dest}"/include/${PV}
	doins include/pypy_*
	pax-mark m "${ED}${dest}/pypy3-c-${PV}"
}
