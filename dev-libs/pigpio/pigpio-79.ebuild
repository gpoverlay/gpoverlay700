# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1 systemd toolchain-funcs

DESCRIPTION="A library for the Raspberry which allows control of the GPIOs"
HOMEPAGE="http://abyz.me.uk/rpi/pigpio/ https://github.com/joan2937/pigpio"
SRC_URI="https://github.com/joan2937/pigpio/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Unlicense"
SLOT="0"
KEYWORDS="~arm"
IUSE="python"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

PATCHES=( "${FILESDIR}/${PN}-70-makefile.patch" )

src_compile() {
	emake CC="$(tc-getCC)" STRIP=: STRIPLIB=: SIZE=:
	use python && distutils-r1_src_compile
}

src_install() {
	emake DESTDIR="${D}" LDCONFIG=: PYTHON2=: PYTHON3=: \
		libdir="${EPREFIX}/usr/$(get_libdir)" prefix="${EPREFIX}/usr" \
		mandir="${EPREFIX}/usr/share/man" install
	einstalldocs
	newinitd "${FILESDIR}"/pigpiod.initd pigpiod
	newconfd "${FILESDIR}"/pigpiod.confd pigpiod
	systemd_newunit "${S}"/util/pigpiod.service pigpiod.service
	use python && distutils-r1_src_install
}
