# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/aspectwerkz/aspectwerkz-2.0_rc2.ebuild,v 1.5 2005/07/15 18:04:56 axxo Exp $

inherit java-pkg-2 java-ant-2 eutils

DESCRIPTION="AspectWerkz is a dynamic, lightweight and high-performant AOP/AOSD framework for Java."
SRC_URI="http://dist.codehaus.org/${PN}/distributions/${P}.zip"
HOMEPAGE="http://aspectwerkz.codehaus.org"
LICENSE="LGPL-2.1"
SLOT="2"
KEYWORDS="~x86 ~amd64 ~ppc"
RDEPEND=">=dev-java/java-config-2.0.31
	!java5? ( >=virtual/jre-1.4 )
	java5? ( >=virtual/jre-1.5 )
	=dev-java/asm-1.5*
	dev-java/bcel
	dev-java/concurrent-util
	=dev-java/dom4j-1*
	=dev-java/javassist-2*
	dev-java/jrexx
	>=dev-java/junitperf-1.9.1
	dev-java/trove
	=dev-java/qdox-20050104"
DEPEND="!java5? ( =virtual/jdk-1.4* )
	java5? ( =virtual/jdk-1.5* )
	${RDEPEND}
	>=dev-java/ant-core-1.5
	app-arch/unzip
	source? ( app-arch/zip )"
IUSE="java5 source"

pkg_setup() {
	if use java5; then
		JAVA_PKG_NV_DEPEND="=virtual/jdk-1.5*"

		# We must specify source/target versions because currently
		# it is not
		# correctly picked up from NV_DEPEND for build.xml
		# rewrite
		JAVA_PKG_WANT_SOURCE="1.5"
		JAVA_PKG_WANT_TARGET="1.5"
	else
		JAVA_PKG_NV_DEPEND="=virtual/jdk-1.4*"
	fi
	java-pkg-2_pkg_setup
}


src_unpack() {
	unpack ${A}

	cd ${S}
	epatch ${FILESDIR}/${P}-gentoo.patch

	find . -name '*.jar' -exec rm {} \; || die
	cd ${S}/lib
	#rm *.jar
	java-pkg_jar-from asm-1.5
	java-pkg_jar-from bcel
	java-pkg_jar-from concurrent-util
	java-pkg_jar-from dom4j-1
	java-pkg_jar-from javassist-2
	java-pkg_jar-from jrexx
	java-pkg_jar-from junitperf
	java-pkg_jar-from trove
	java-pkg_jar-from qdox-1.6
}

src_compile() {	
	eant dist
}

src_install() {
	java-pkg_dojar lib/${PN}*.jar	
	use source && java-pkg_dosrc src/*
}