# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit perl-functions

PATCHVER=0.2
MY_PN=${PN/b/B}
MY_P=${MY_PN}-${PV}
DESCRIPTION="Bastille-Linux is a security hardening tool"
HOMEPAGE="http://bastille-linux.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}-linux/${MY_P}.tar.bz2
	mirror://gentoo/${P}-gentoo-${PATCHVER}.patch.bz2"
S="${WORKDIR}"/${MY_PN}

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"
IUSE="X"

RDEPEND="
	app-admin/logrotate
	dev-lang/perl
	dev-perl/Curses
	net-firewall/iptables
	net-firewall/psad
	virtual/logger
	X? ( dev-perl/Tk )
"

PATCHES=(
	"${WORKDIR}"/${P}-gentoo-${PATCHVER}.patch
	# make sure the Perl modules go into vendor dir
	"${FILESDIR}/${P}-perl.patch"
	# prevent file collision, bug 536292
	"${FILESDIR}/${P}-renamewidgets.patch"
	# openrc runscript rename
	"${FILESDIR}/${P}-openrc.patch"
)

src_prepare() {
	perl_set_version

	default

	cd "${S}" || die
	chmod a+x Install.sh bastille-ipchains bastille-netfilter || die
}

src_install() {
	perl_set_version
	export VENDOR_LIB

	cd "${S}" || die
	DESTDIR="${D}" ./Install.sh || die

	# Example configs
	cd "${S}" || die
	insinto /usr/share/Bastille
	doins *.config

	newinitd ${PN}-firewall.gentoo-init ${PN}-firewall

	# See bug #455542
	keepdir /var/lock/subsys
	keepdir /var/lock/bastille
	keepdir /var/lock/subsys/bastille

	# Documentation
	cd "${S}" || die
	dodoc *.txt BUGS Change* README*
	cd "${S}"/docs || die
	doman *.1m
}

pkg_postinst() {
	elog "Please be aware that when using the Server Lax, Server Moderate, or"
	elog "Server Paranoia configurations, you may need to use InteractiveBastille"
	elog "to set any advanced network information, such as masquerading and"
	elog "internal interfaces, if you plan to use them."
}
