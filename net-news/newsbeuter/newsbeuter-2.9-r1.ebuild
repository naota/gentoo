# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit toolchain-funcs

DESCRIPTION="A RSS/Atom feed reader for the text console"
HOMEPAGE="http://www.newsbeuter.org/index.html"
SRC_URI="http://www.${PN}.org/downloads/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="test"

RDEPEND="
	>=dev-db/sqlite-3.5:3
	>=dev-libs/stfl-0.21
	>=net-misc/curl-7.18.0
	>=dev-libs/json-c-0.11:=
	dev-libs/libxml2
	sys-libs/ncurses:0=[unicode]
"
DEPEND="${RDEPEND}
	dev-lang/perl
	virtual/pkgconfig
	sys-devel/gettext
	test? (
		dev-libs/boost
		sys-devel/bc
	)
"

# tests require network access
RESTRICT="test"

PATCHES=(
	"${FILESDIR}"/${PN}-2.9-ncurses6.patch
	"${FILESDIR}"/${PN}-2.9-fix-mem-leak.patch
	"${FILESDIR}"/${PN}-2.9-fix-segfault.patch
)

src_prepare() {
	default
	sed -i 's:-ggdb::' Makefile || die
}

src_configure() {
	./config.sh || die
}

src_compile() {
	emake prefix="/usr" CXX="$(tc-getCXX)" AR="$(tc-getAR)" RANLIB="$(tc-getRANLIB)"
}

src_test() {
	emake test
	# Tests fail if in ${S} rather than in ${S}/test
	cd "${S}"/test
	./test || die
}

src_install() {
	emake DESTDIR="${D}" prefix="/usr" PACKAGE="${PF}" install
	dodoc AUTHORS README CHANGES
}