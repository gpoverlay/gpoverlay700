# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PV="${PV/_p/p}"
DESCRIPTION="Sensor part of sguil Network Security Monitoring"
HOMEPAGE="https://github.com/bammv/sguil"
SRC_URI="https://github.com/bammv/sguil/archive/v${PV}.tar.gz -> ${P/-sensor}.tar.gz"
S="${WORKDIR}/sguil-${MY_PV}"

LICENSE="GPL-3 GPL-2+ QPL-1.0 GPL-2"    # GPL-2 for init script
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	acct-group/sguil
	acct-user/sguil
"

RDEPEND="
	${DEPEND}
	>=dev-lang/tcl-8.3:0=[-threads]
	>=dev-tcltk/tclx-8.3
	dev-tcltk/tls
	>=net-analyzer/barnyard-0.2.0-r1
	>=net-analyzer/snort-2.4.1-r1
	dev-ml/pcre-ocaml:=
	net-analyzer/sancp
"

src_prepare() {
	default

	sed -i \
		-e "s:gateway:${HOSTNAME}:" \
		-e 's:/snort_data:/var/lib/sguil:' \
		-e 's:DAEMON 0:DAEMON 1:' \
		-e 's:DEBUG 1:DEBUG 0:g' \
		sensor/sensor_agent.conf || die

	sed -i \
		-e 's:/var/run/sensor_agent.pid:/run/sguil-sensor.pid:' \
		sensor/sensor_agent.tcl || die
}

src_install() {
	dodoc doc/*

	dobin sensor/sensor_agent.tcl

	newinitd "${FILESDIR}/log_packets.initd" log_packets
	newinitd "${FILESDIR}/sensor_agent.initd" sensor_agent
	newconfd "${FILESDIR}/log_packets.confd" log_packets
	insinto /etc/sguil
	doins sensor/sensor_agent.conf

	# Create the directory structure
	diropts -g sguil -o sguil
	keepdir /var/lib/sguil/archive \
		"/var/lib/sguil/${HOSTNAME}" \
		"/var/lib/sguil/${HOSTNAME}/portscans" \
		"/var/lib/sguil/${HOSTNAME}/ssn_logs" \
		"/var/lib/sguil/${HOSTNAME}/dailylogs" \
		"/var/lib/sguil/${HOSTNAME}/sancp"

}

pkg_postinst() {
	elog
	elog "You should check /etc/sguil/sensor_agent.conf and"
	elog "/etc/init.d/logpackets and ensure that they are accurate"
	elog "for your environment. They should work providing that you"
	elog "are running the sensor on the same machine as the server."
	elog "This ebuild assumes that you are running a single sensor"
	elog "environment, if this is not the case then you must make sure"
	elog "to modify /etc/sguil/sensor_agent.conf and change the HOSTNAME variable."
	elog "You should crontab the /etc/init.d/log_packets script to restart"
	elog "each hour."
	elog
}
