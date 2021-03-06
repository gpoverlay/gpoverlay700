# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools toolchain-funcs

DESCRIPTION="Network traffic analyzer with web interface"
HOMEPAGE="https://www.ntop.org/"
SRC_URI="https://github.com/ntop/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-db/mysql-connector-c:=
	dev-db/sqlite:3
	dev-libs/hiredis:=
	dev-libs/json-c:=
	dev-libs/libmaxminddb
	dev-libs/libsodium:=
	dev-libs/openssl:=
	net-analyzer/rrdtool
	net-libs/libpcap
	>=net-libs/nDPI-3.0:=
	>=net-libs/zeromq-3:=
	net-misc/curl
	sys-libs/libcap
	sys-libs/zlib"
RDEPEND="${DEPEND}
	acct-user/ntopng
	acct-group/ntopng
	dev-db/redis"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-4.2-mysqltool.patch
	"${FILESDIR}"/${PN}-4.2-parallel-make.patch
	"${FILESDIR}"/${PN}-4.0-ndpi-includes.patch
)

src_prepare() {
	default

	# Follows upstream's autogen.sh
	sed \
		-e "s/@VERSION@/${PV}.$(date +%y%m%d)/g" \
		-e "s/@SHORT_VERSION@/${PV}/g" \
		-e "s/@GIT_DATE@/$(date)/g" \
		-e "s/@GIT_RELEASE@/${PV}.$(date +%y%m%d)/g" \
		-e "s/@GIT_BRANCH@//g" < "${S}/configure.seed" \
		> "${S}/configure.ac" || die

	eautoreconf
}

src_configure() {
	tc-export PKG_CONFIG
	default
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		MYCFLAGS="${CFLAGS}" \
		MYLDFLAGS="${LDFLAGS}"
}

src_install() {
	SHARE_NTOPNG_DIR="${EPREFIX}/usr/share/${PN}"
	insinto "${SHARE_NTOPNG_DIR}"
	doins -r httpdocs
	doins -r scripts

	insinto "${SHARE_NTOPNG_DIR}/third-party"
	doins -r third-party/i18n.lua-master
	doins -r third-party/lua-resty-template-master

	exeinto /usr/bin
	doexe "${PN}"
	doman "${PN}.8"

	newinitd "${FILESDIR}"/ntopng.init.d ntopng
	newconfd "${FILESDIR}"/ntopng.conf.d ntopng

	keepdir /var/lib/ntopng
	fowners ntopng /var/lib/ntopng
}

pkg_postinst() {
	elog "ntopng default credentials are user='admin' password='admin'"
}
