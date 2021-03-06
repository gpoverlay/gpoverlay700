# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit cmake

CommitId=1787867f6183f056420e532eec640cba25efafea
DESCRIPTION="Portable and efficient thread pool implementation"
HOMEPAGE="https://github.com/Maratyszcza/pthreadpool"
SRC_URI="https://github.com/Maratyszcza/${PN}/archive/1787867.tar.gz
	-> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

DEPEND="dev-libs/FXdiv"
RDEPEND="${DEPEND}"
BDEPEND="test? ( dev-cpp/gtest )"
RESTRICT="!test? ( test )"

S="${WORKDIR}"/${PN}-${CommitId}

PATCHES=(
	"${FILESDIR}"/${P}-gentoo.patch
)

src_configure() {
	local mycmakeargs=(
		-DPTHREADPOOL_BUILD_BENCHMARKS=OFF
		-DPTHREADPOOL_BUILD_TESTS=$(usex test ON OFF)
	)
	cmake_src_configure
}
