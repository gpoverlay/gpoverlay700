# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="VI Like Emacs -- yet another full-featured vi clone"
HOMEPAGE="https://invisible-island.net/vile/"
SRC_URI="ftp://ftp.invisible-island.net/vile/current/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 ppc ~riscv sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="perl"

RDEPEND=">=sys-libs/ncurses-5.2:0=
	virtual/libcrypt:=
	perl? ( dev-lang/perl:= )"
DEPEND="${RDEPEND}
	sys-devel/flex
	app-eselect/eselect-vi"

src_configure() {
	econf \
		--with-ncurses \
		$(use_with perl )
}

src_install() {
	emake DESTDIR="${D}" INSTALL_OPT_S="" install
	dodoc CHANGES* README doc/*.doc
	docinto html
	dodoc doc/*.html
}

pkg_postinst() {
	einfo "Updating ${EPREFIX}/usr/bin/vi symlink"
	eselect vi update --if-unset
}

pkg_postrm() {
	einfo "Updating ${EPREFIX}/usr/bin/vi symlink"
	eselect vi update --if-unset
}
