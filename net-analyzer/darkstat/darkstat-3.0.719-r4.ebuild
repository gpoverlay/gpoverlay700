# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Network traffic analyzer with cute web interface"
HOMEPAGE="https://unix4lyfe.org/darkstat/"
if [[ ${PV} == *9999* ]] ; then
	EGIT_REPO_URI="https://www.unix4lyfe.org/git/darkstat"
	inherit git-r3
else
	SRC_URI="https://unix4lyfe.org/${PN}/${P}.tar.bz2"
	KEYWORDS="~amd64 ~ppc ~x86"
fi

LICENSE="GPL-2"
SLOT="0"

DEPEND="acct-user/darkstat
	dev-libs/libbsd
	net-libs/libpcap
	sys-libs/zlib"
RDEPEND="${DEPEND}"

DARKSTAT_CHROOT_DIR=${DARKSTAT_CHROOT_DIR:-/var/lib/darkstat}

DOCS=( AUTHORS ChangeLog README NEWS )

PATCHES=(
	"${FILESDIR}"/${PN}-3.0.719-strncpy-off-by-one.patch
)

src_prepare() {
	default

	sed -i \
		-e '/-DNDEBUG/d' \
		-e 's|-flto||g' \
		configure.ac || die

	eautoreconf
}

src_configure() {
	econf --with-privdrop-user=darkstat
}

src_install() {
	default

	newinitd "${FILESDIR}"/darkstat-initd darkstat
	newconfd "${FILESDIR}"/darkstat-confd darkstat

	sed -i -e "s:__CHROOT__:${DARKSTAT_CHROOT_DIR}:g" "${D}"/etc/conf.d/darkstat || die
	sed -i -e "s:__CHROOT__:${DARKSTAT_CHROOT_DIR}:g" "${D}"/etc/init.d/darkstat || die

	keepdir "${DARKSTAT_CHROOT_DIR}"
	fowners darkstat:0 "${DARKSTAT_CHROOT_DIR}"
}

pkg_postinst() {
	# Workaround bug #141619
	DARKSTAT_CHROOT_DIR=$(
		sed -n 's/^#CHROOT=\(.*\)/\1/p' "${EROOT}"/etc/conf.d/darkstat
	)

	if [[ -n "${DARKSTAT_CHROOT_DIR}" ]] && [[ "${DARKSTAT_CHROOT_DIR}" != "${EROOT:-/}" ]] ; then
		chown darkstat:0 "${EROOT}/${DARKSTAT_CHROOT_DIR#/}/"
	fi

	elog "To start different darkstat instances which will listen on a different"
	elog "interface, create within the ${EROOT}/etc/init.d directory a 'darkstat.if' symlink to"
	elog "darkstat script where 'if' is the name of the interface."
	elog "Also in the ${EROOT}/etc/conf.d directory, copy darkstat to darkstat.if"
	elog "and edit it to change default values."
	elog
	elog "darkstat's default chroot directory is: ${EROOT}/${DARKSTAT_CHROOT_DIR#/}"
}
