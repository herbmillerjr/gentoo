# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_PN="github.com/docker/docker-ce"

if [[ ${PV} = *9999* ]]; then
	# Docker cannot be fetched via "go get", thanks to autogenerated code
	EGIT_REPO_URI="https://${EGO_PN}.git"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}/src/${EGO_PN}"
	inherit git-r3
else
	DOCKER_GITCOMMIT="633a0ea"
	MY_PV=${PV/_/-}
	SRC_URI="https://${EGO_PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~arm ~arm64"
	[ "$DOCKER_GITCOMMIT" ] || die "DOCKER_GITCOMMIT must be added manually for each bump!"
	inherit golang-vcs-snapshot
fi
inherit bash-completion-r1 golang-base linux-info systemd udev user

DESCRIPTION="The core functions you need to create Docker images and run Docker containers"
HOMEPAGE="https://dockerproject.org"
LICENSE="Apache-2.0"
SLOT="0"
IUSE="apparmor aufs btrfs +container-init device-mapper hardened +overlay seccomp"

# https://github.com/docker/docker/blob/master/project/PACKAGERS.md#build-dependencies
COMMON_DEPEND="
	>=dev-db/sqlite-3.7.9:3
	device-mapper? (
		>=sys-fs/lvm2-2.02.89[thin]
	)
	seccomp? ( >=sys-libs/libseccomp-2.2.1 )
	apparmor? ( sys-libs/libapparmor )
"

DEPEND="
	${COMMON_DEPEND}

	>=dev-lang/go-1.12
	dev-go/go-md2man

	btrfs? (
		>=sys-fs/btrfs-progs-3.16.1
	)
"

# https://github.com/docker/docker/blob/master/project/PACKAGERS.md#runtime-dependencies
# https://github.com/docker/docker/blob/master/project/PACKAGERS.md#optional-dependencies
RDEPEND="
	${COMMON_DEPEND}
	>=net-firewall/iptables-1.4
	sys-process/procps
	>=dev-vcs/git-1.7
	>=app-arch/xz-utils-4.9
	dev-libs/libltdl
	~app-emulation/containerd-1.2.10
	~app-emulation/runc-1.0.0_rc9[apparmor?,seccomp?]
	~app-emulation/docker-proxy-0.8.0_p20191011
	container-init? ( >=sys-process/tini-0.18.0[static] )
"

RESTRICT="installsources strip"

S="${WORKDIR}/${P}/src/${EGO_PN}"

# see "contrib/check-config.sh" from upstream's sources
CONFIG_CHECK="
	~NAMESPACES ~NET_NS ~PID_NS ~IPC_NS ~UTS_NS
	~CGROUPS ~CGROUP_CPUACCT ~CGROUP_DEVICE ~CGROUP_FREEZER ~CGROUP_SCHED ~CPUSETS ~MEMCG
	~KEYS
	~VETH ~BRIDGE ~BRIDGE_NETFILTER
	~IP_NF_FILTER ~IP_NF_TARGET_MASQUERADE
	~NETFILTER_XT_MATCH_ADDRTYPE ~NETFILTER_XT_MATCH_CONNTRACK ~NETFILTER_XT_MATCH_IPVS
	~IP_NF_NAT ~NF_NAT
	~POSIX_MQUEUE

	~USER_NS
	~SECCOMP
	~CGROUP_PIDS
	~MEMCG_SWAP ~MEMCG_SWAP_ENABLED

	~BLK_CGROUP ~BLK_DEV_THROTTLING
	~CGROUP_PERF
	~CGROUP_HUGETLB
	~NET_CLS_CGROUP
	~CFS_BANDWIDTH ~FAIR_GROUP_SCHED ~RT_GROUP_SCHED
	~IP_VS ~IP_VS_PROTO_TCP ~IP_VS_PROTO_UDP ~IP_VS_NFCT ~IP_VS_RR

	~VXLAN
	~CRYPTO ~CRYPTO_AEAD ~CRYPTO_GCM ~CRYPTO_SEQIV ~CRYPTO_GHASH ~XFRM_ALGO ~XFRM_USER
	~IPVLAN
	~MACVLAN ~DUMMY
"

ERROR_KEYS="CONFIG_KEYS: is mandatory"
ERROR_MEMCG_SWAP="CONFIG_MEMCG_SWAP: is required if you wish to limit swap usage of containers"
ERROR_RESOURCE_COUNTERS="CONFIG_RESOURCE_COUNTERS: is optional for container statistics gathering"

ERROR_BLK_CGROUP="CONFIG_BLK_CGROUP: is optional for container statistics gathering"
ERROR_IOSCHED_CFQ="CONFIG_IOSCHED_CFQ: is optional for container statistics gathering"
ERROR_CGROUP_PERF="CONFIG_CGROUP_PERF: is optional for container statistics gathering"
ERROR_CFS_BANDWIDTH="CONFIG_CFS_BANDWIDTH: is optional for container statistics gathering"
ERROR_XFRM_ALGO="CONFIG_XFRM_ALGO: is optional for secure networks"
ERROR_XFRM_USER="CONFIG_XFRM_USER: is optional for secure networks"

pkg_setup() {
	if kernel_is lt 3 10; then
		ewarn ""
		ewarn "Using Docker with kernels older than 3.10 is unstable and unsupported."
		ewarn " - http://docs.docker.com/engine/installation/binaries/#check-kernel-dependencies"
	fi

	if kernel_is le 3 18; then
		CONFIG_CHECK+="
			~RESOURCE_COUNTERS
		"
	fi

	if kernel_is le 3 13; then
		CONFIG_CHECK+="
			~NETPRIO_CGROUP
		"
	else
		CONFIG_CHECK+="
			~CGROUP_NET_PRIO
		"
	fi

	if kernel_is lt 4 5; then
		CONFIG_CHECK+="
			~MEMCG_KMEM
		"
		ERROR_MEMCG_KMEM="CONFIG_MEMCG_KMEM: is optional"
	fi

	if kernel_is lt 4 7; then
		CONFIG_CHECK+="
			~DEVPTS_MULTIPLE_INSTANCES
		"
	fi

	if kernel_is lt 5 1; then
		CONFIG_CHECK+="
			~NF_NAT_IPV4
			~IOSCHED_CFQ
			~CFQ_GROUP_IOSCHED
		"
	fi

	if kernel_is lt 5 2; then
		CONFIG_CHECK+="
			~NF_NAT_NEEDED
		"
	fi

	if use aufs; then
		CONFIG_CHECK+="
			~AUFS_FS
			~EXT4_FS_POSIX_ACL ~EXT4_FS_SECURITY
		"
		ERROR_AUFS_FS="CONFIG_AUFS_FS: is required to be set if and only if aufs-sources are used instead of aufs4/aufs3"
	fi

	if use btrfs; then
		CONFIG_CHECK+="
			~BTRFS_FS
			~BTRFS_FS_POSIX_ACL
		"
	fi

	if use device-mapper; then
		CONFIG_CHECK+="
			~BLK_DEV_DM ~DM_THIN_PROVISIONING ~EXT4_FS ~EXT4_FS_POSIX_ACL ~EXT4_FS_SECURITY
		"
	fi

	if use overlay; then
		CONFIG_CHECK+="
			~OVERLAY_FS ~EXT4_FS_SECURITY ~EXT4_FS_POSIX_ACL
		"
	fi

	linux-info_pkg_setup

	# create docker group for the code checking for it in /etc/group
	enewgroup docker
}

src_compile() {
	export GOPATH="${WORKDIR}/${P}"

	# setup CFLAGS and LDFLAGS for separate build target
	# see https://github.com/tianon/docker-overlay/pull/10
	export CGO_CFLAGS="-I${ROOT}/usr/include"
	export CGO_LDFLAGS="-L${ROOT}/usr/$(get_libdir)"

	# if we're building from a tarball, we need the GITCOMMIT value
	[ "$DOCKER_GITCOMMIT" ] && export DOCKER_GITCOMMIT

	# fake golang layout
	ln -s docker-ce/components/engine ../docker || die
	ln -s docker-ce/components/cli ../cli || die

	# let's set up some optional features :)
	export DOCKER_BUILDTAGS=''
	for gd in aufs btrfs device-mapper overlay; do
		if ! use $gd; then
			DOCKER_BUILDTAGS+=" exclude_graphdriver_${gd//-/}"
		fi
	done

	for tag in apparmor seccomp; do
		if use $tag; then
			DOCKER_BUILDTAGS+=" $tag"
		fi
	done

	pushd components/engine || die

	if use hardened; then
		sed -i "s/EXTLDFLAGS_STATIC='/&-fno-PIC /" hack/make.sh || die
		grep -q -- '-fno-PIC' hack/make.sh || die 'hardened sed failed'
		sed  "s/LDFLAGS_STATIC_DOCKER='/&-extldflags -fno-PIC /" \
			-i hack/make/dynbinary-daemon || die
		grep -q -- '-fno-PIC' hack/make/dynbinary-daemon || die 'hardened sed failed'
	fi

	# build daemon
	VERSION="$(cat ../../VERSION)" \
	./hack/make.sh dynbinary || die 'dynbinary failed'

	popd || die # components/engine

	pushd components/cli || die

	# build cli
	emake \
		LDFLAGS="$(usex hardened '-extldflags -fno-PIC' '')" \
		VERSION="$(cat ../../VERSION)" \
		GITCOMMIT="${DOCKER_GITCOMMIT}" \
		DISABLE_WARN_OUTSIDE_CONTAINER=1 \
		dynbinary

	# build man pages
	go build -o gen-manpages github.com/docker/cli/man || die
	./gen-manpages --root . --target ./man/man1 || die
	./man/md2man-all.sh -q || die
	rm gen-manpages || die
	# see "components/cli/scripts/docs/generate-man.sh" (which also does "go get" for go-md2man)

	popd || die # components/cli
}

src_install() {
	dosym containerd /usr/bin/docker-containerd
	dosym containerd-shim /usr/bin/docker-containerd-shim
	dosym runc /usr/bin/docker-runc
	use container-init && dosym tini /usr/bin/docker-init

	pushd components/engine || die
	newbin bundles/dynbinary-daemon/dockerd-${PV} dockerd

	newinitd contrib/init/openrc/docker.initd docker
	newconfd contrib/init/openrc/docker.confd docker

	systemd_dounit contrib/init/systemd/docker.{service,socket}

	udev_dorules contrib/udev/*.rules

	dodoc AUTHORS CONTRIBUTING.md CHANGELOG.md NOTICE README.md
	dodoc -r docs/*

	insinto /usr/share/vim/vimfiles
	doins -r contrib/syntax/vim/ftdetect
	doins -r contrib/syntax/vim/syntax

	# note: intentionally not using "doins" so that we preserve +x bits
	dodir /usr/share/${PN}/contrib
	cp -R contrib/* "${ED}/usr/share/${PN}/contrib"
	popd || die # components/engine

	pushd components/cli || die

	newbin build/docker-* docker

	doman man/man*/*

	dobashcomp contrib/completion/bash/*
	insinto /usr/share/fish/vendor_completions.d/
	doins contrib/completion/fish/docker.fish
	insinto /usr/share/zsh/site-functions
	doins contrib/completion/zsh/_*
	popd || die # components/cli
}

pkg_postinst() {
	udev_reload

	elog
	elog "To use Docker, the Docker daemon must be running as root. To automatically"
	elog "start the Docker daemon at boot, add Docker to the default runlevel:"
	elog "  rc-update add docker default"
	elog "Similarly for systemd:"
	elog "  systemctl enable docker.service"
	elog
	elog "To use Docker as a non-root user, add yourself to the 'docker' group:"
	elog "  usermod -aG docker youruser"
	elog

	elog " Devicemapper storage driver has been deprecated"
	elog " It will be removed in a future release"
}
