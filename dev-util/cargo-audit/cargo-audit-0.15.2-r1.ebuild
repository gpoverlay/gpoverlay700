# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	abscissa_core-0.5.2
	abscissa_derive-0.5.0
	addr2line-0.16.0
	adler-1.0.2
	aho-corasick-0.7.18
	ansi_term-0.11.0
	arrayvec-0.5.2
	askama-0.10.5
	askama_derive-0.10.5
	askama_escape-0.10.1
	askama_shared-0.11.1
	atom_syndication-0.10.0
	atty-0.2.14
	autocfg-1.0.1
	backtrace-0.3.61
	base64-0.13.0
	bincode-1.3.3
	bitflags-1.3.1
	bitvec-0.19.5
	block-buffer-0.7.3
	block-padding-0.1.5
	bumpalo-3.7.0
	byte-tools-0.3.1
	byteorder-1.4.3
	bytes-0.5.6
	bytes-1.0.1
	canonical-path-2.0.2
	cargo-edit-0.7.0
	cargo_metadata-0.11.4
	cc-1.0.69
	cfg-if-0.1.10
	cfg-if-1.0.0
	chrono-0.4.19
	clap-2.33.3
	color-backtrace-0.3.0
	combine-4.6.0
	comrak-0.12.1
	core-foundation-0.9.1
	core-foundation-sys-0.8.2
	crates-index-0.17.0
	crc32fast-1.2.1
	darling-0.10.2
	darling-0.12.4
	darling_core-0.10.2
	darling_core-0.12.4
	darling_macro-0.10.2
	darling_macro-0.12.4
	derive_builder-0.10.2
	derive_builder_core-0.10.2
	derive_builder_macro-0.10.2
	digest-0.8.1
	diligent-date-parser-0.1.2
	dirs-3.0.2
	dirs-sys-0.3.6
	encoding_rs-0.8.28
	entities-1.0.1
	env_proxy-0.4.1
	error-chain-0.12.4
	failure-0.1.8
	failure_derive-0.1.8
	fake-simd-0.1.2
	fixedbitset-0.4.0
	flate2-1.0.21
	fnv-1.0.7
	foreign-types-0.3.2
	foreign-types-shared-0.1.1
	form_urlencoded-1.0.1
	fs-err-2.6.0
	fuchsia-zircon-0.3.3
	fuchsia-zircon-sys-0.3.3
	funty-1.1.0
	futures-channel-0.3.16
	futures-core-0.3.16
	futures-io-0.3.16
	futures-sink-0.3.16
	futures-task-0.3.16
	futures-util-0.3.16
	generational-arena-0.2.8
	generic-array-0.12.4
	getrandom-0.2.3
	gimli-0.25.0
	git2-0.13.22
	glob-0.3.0
	gumdrop-0.7.0
	gumdrop-0.8.0
	gumdrop_derive-0.7.0
	gumdrop_derive-0.8.0
	h2-0.2.7
	hashbrown-0.11.2
	heck-0.3.3
	hermit-abi-0.1.19
	hex-0.4.3
	home-0.5.3
	http-0.2.4
	http-body-0.3.1
	httparse-1.4.1
	httpdate-0.3.2
	humansize-1.1.1
	humantime-2.1.0
	humantime-serde-1.0.1
	hyper-0.13.10
	hyper-tls-0.4.3
	ident_case-1.0.1
	idna-0.2.3
	indexmap-1.7.0
	iovec-0.1.4
	ipnet-2.3.1
	itoa-0.4.7
	jobserver-0.1.23
	js-sys-0.3.52
	kernel32-sys-0.2.2
	lazy_static-1.4.0
	lazycell-1.3.0
	lexical-core-0.7.6
	libc-0.2.99
	libgit2-sys-0.12.23+1.2.0
	libssh2-sys-0.2.21
	libz-sys-1.1.3
	line-wrap-0.1.1
	linked-hash-map-0.5.4
	log-0.4.14
	maplit-1.0.2
	matchers-0.0.1
	matches-0.1.9
	maybe-uninit-2.0.0
	memchr-2.4.0
	mime-0.3.16
	mime_guess-2.0.3
	miniz_oxide-0.4.4
	mio-0.6.23
	miow-0.2.2
	native-tls-0.2.8
	net2-0.2.37
	never-0.1.0
	nom-6.1.2
	num-integer-0.1.44
	num-traits-0.2.14
	num_cpus-1.13.0
	object-0.26.0
	once_cell-1.8.0
	onig-6.2.0
	onig_sys-69.7.0
	opaque-debug-0.2.3
	openssl-0.10.35
	openssl-probe-0.1.4
	openssl-src-111.15.0+1.1.1k
	openssl-sys-0.9.65
	owning_ref-0.4.1
	percent-encoding-2.1.0
	pest-2.1.3
	pest_derive-2.1.0
	pest_generator-2.1.3
	pest_meta-2.1.3
	petgraph-0.6.0
	pin-project-1.0.8
	pin-project-internal-1.0.8
	pin-project-lite-0.1.12
	pin-project-lite-0.2.7
	pin-utils-0.1.0
	pkg-config-0.3.19
	plist-1.2.1
	ppv-lite86-0.2.10
	proc-macro-error-1.0.4
	proc-macro-error-attr-1.0.4
	proc-macro2-1.0.28
	quick-xml-0.22.0
	quote-1.0.9
	radium-0.5.3
	rand-0.8.4
	rand_chacha-0.3.1
	rand_core-0.6.3
	rand_hc-0.3.1
	redox_syscall-0.2.10
	redox_users-0.4.0
	regex-1.5.4
	regex-automata-0.1.10
	regex-syntax-0.6.25
	remove_dir_all-0.5.3
	reqwest-0.10.10
	rust-embed-5.9.0
	rust-embed-impl-5.9.0
	rust-embed-utils-5.1.0
	rustc-demangle-0.1.20
	ryu-1.0.5
	safemem-0.3.3
	same-file-1.0.6
	schannel-0.1.19
	secrecy-0.6.0
	security-framework-2.3.1
	security-framework-sys-2.3.0
	semver-0.9.0
	semver-0.10.0
	semver-0.11.0
	semver-1.0.4
	semver-parser-0.7.0
	semver-parser-0.10.2
	serde-1.0.127
	serde_derive-1.0.127
	serde_json-1.0.66
	serde_urlencoded-0.7.0
	sha-1-0.8.2
	shell-words-1.0.0
	signal-hook-0.1.17
	signal-hook-registry-1.4.0
	slab-0.4.4
	smallvec-0.6.14
	smartstring-0.2.9
	smol_str-0.1.17
	socket2-0.3.19
	stable_deref_trait-1.2.0
	static_assertions-1.1.0
	strsim-0.8.0
	strsim-0.9.3
	strsim-0.10.0
	structopt-0.3.22
	structopt-derive-0.4.15
	subprocess-0.2.7
	syn-1.0.74
	synstructure-0.12.5
	syntect-4.6.0
	tap-1.0.1
	tempfile-3.2.0
	termcolor-1.1.2
	textwrap-0.11.0
	thiserror-1.0.25
	thiserror-impl-1.0.25
	time-0.1.43
	tinyvec-1.3.1
	tinyvec_macros-0.1.0
	tokio-0.2.25
	tokio-tls-0.3.1
	tokio-util-0.3.1
	toml-0.5.8
	toml_edit-0.2.1
	tower-service-0.3.1
	tracing-0.1.26
	tracing-attributes-0.1.15
	tracing-core-0.1.18
	tracing-futures-0.2.5
	tracing-log-0.1.2
	tracing-subscriber-0.1.6
	try-lock-0.2.3
	twoway-0.2.2
	typed-arena-1.7.0
	typenum-1.13.0
	ucd-trie-0.1.3
	unchecked-index-0.2.2
	unicase-2.6.0
	unicode-bidi-0.3.6
	unicode-normalization-0.1.19
	unicode-segmentation-1.8.0
	unicode-width-0.1.8
	unicode-xid-0.2.2
	unicode_categories-0.1.1
	url-2.2.2
	vcpkg-0.2.15
	vec_map-0.8.2
	version_check-0.9.3
	wait-timeout-0.2.0
	walkdir-2.3.2
	want-0.3.0
	wasi-0.10.2+wasi-snapshot-preview1
	wasm-bindgen-0.2.75
	wasm-bindgen-backend-0.2.75
	wasm-bindgen-futures-0.4.25
	wasm-bindgen-macro-0.2.75
	wasm-bindgen-macro-support-0.2.75
	wasm-bindgen-shared-0.2.75
	web-sys-0.3.52
	winapi-0.2.8
	winapi-0.3.9
	winapi-build-0.1.1
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.5
	winapi-x86_64-pc-windows-gnu-0.4.0
	winreg-0.7.0
	ws2_32-sys-0.2.1
	wyz-0.2.0
	xdg-2.2.0
	xml-rs-0.8.4
	yaml-rust-0.4.5
	zeroize-1.3.0
"

inherit cargo

DESCRIPTION="Audit Cargo.lock for security vulnerabilities"
HOMEPAGE="https://github.com/rustsec/cargo-audit"
SRC_URI="https://github.com/RustSec/rustsec/archive/refs/tags/${PN}/v${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris)"

LICENSE="Apache-2.0 Apache-2.0-with-LLVM-exceptions Boost-1.0 MIT MPL-2.0 Unlicense"
SLOT="0"
KEYWORDS="~amd64 ~ppc64"
IUSE="fix"

RDEPEND="dev-libs/openssl:0="
DEPEND="${RDEPEND}"

S="${WORKDIR}/rustsec-${PN}-v${PV}"

QA_FLAGS_IGNORED="usr/bin/${PN}"

# requires checkout of vuln db/network
PROPERTIES="test_network"
RESTRICT="test"

src_configure() {
	local myfeatures=(
		$(usev fix)
		vendored-libgit2
	)

	cargo_src_configure
}

src_compile() {
	# normally we can pass --bin cargo-audit
	# to build single workspace member, but we need to cd
	# for tests to be discovered properly
	cd cargo-audit || die
	cargo_src_compile
}

src_install() {
	cargo_src_install --path cargo-audit
	local DOCS=( cargo-audit/{README.md,audit.toml.example} )
	einstalldocs
}
