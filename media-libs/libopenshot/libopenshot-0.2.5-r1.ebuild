# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit cmake python-single-r1 toolchain-funcs

DESCRIPTION="Video editing library used by OpenShot"
HOMEPAGE="https://www.openshot.org/"
SRC_URI="https://github.com/OpenShot/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0/19"
KEYWORDS="amd64 x86"
IUSE="doc examples +imagemagick +python test"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/jsoncpp:0=
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtmultimedia:5[widgets]
	>=media-libs/libopenshot-audio-0.2.0:0=
	media-video/ffmpeg:0=[encode,x264,xvid,vpx,mp3,theora,vorbis]
	net-libs/cppzmq
	net-libs/zeromq
	imagemagick? ( >=media-gfx/imagemagick-7:0=[cxx] )
	python? ( ${PYTHON_DEPS} )
"
DEPEND="${RDEPEND}"
BDEPEND="
	doc? ( app-doc/doxygen )
	python? ( dev-lang/swig )
	test? ( dev-libs/unittest++ )
"

PATCHES=(
	"${FILESDIR}/${P}-gcc10.patch"
	"${FILESDIR}/${P}-no-hwaccel-testfix.patch"
)

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && tc-check-openmp
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	cmake_src_prepare
	# https://github.com/OpenShot/libopenshot/issues/17
	use test || cmake_comment_add_subdirectory tests
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_RUBY=OFF # TODO: add ruby support
		-DENABLE_PYTHON=$(usex python)
		-DUSE_SYSTEM_JSONCPP=ON
		$(cmake_use_find_package imagemagick ImageMagick)
	)
	use python && mycmakeargs+=(
		-DPYTHON_EXECUTABLE="${PYTHON}"
		-DPYTHON_INCLUDE_DIR="$(python_get_includedir)"
		-DPYTHON_LIBRARY="$(python_get_library_path)"
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	use doc && cmake_build doc
}

src_test() {
	cmake_build os_test
}

src_install() {
	local DOCS=( AUTHORS README.md doc/HW-ACCEL.md )
	use examples && DOCS+=( src/examples/ )
	use doc && local HTML_DOCS=( "${BUILD_DIR}"/doc/html/. )

	cmake_src_install
	use python && python_optimize
}
