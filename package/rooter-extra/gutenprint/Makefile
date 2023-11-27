#
# Copyright (C) 2013 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
# https://sourceforge.net/projects/gimp-print/files/gutenprint-5.2/5.2.9/gutenprint-5.2.9.tar.bz2/download
# https://sourceforge.net/projects/gimp-print/files/gutenprint-5.3/5.3.4/gutenprint-5.3.4.tar.bz2/download
# 4b27e4f06f32d30271df89ecb6089bb11bcf2caec5f60b0909e083095354bca0  ./gutenprint-5.2.9.tar.bz2
# db44a701d2b8e6a8931c83cec06c91226be266d23e5c189d20a39dd175f2023b  ./gutenprint-5.3.4.tar.xz
# ef514d4ca567b5871cfe7697127bee2c14d5d71d7fbc68d8fee96b0faaed90e7  ./gutenprint-5.3.4-2022.tar.xz



include $(TOPDIR)/rules.mk

PKG_NAME:=gutenprint
#PKG_VERSION:=5.2.9
PKG_VERSION:=5.3.4-2022
PKG_RELEASE:=1

#PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.bz2
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.xz
PKG_SOURCE_URL:=http://www.ofmodemsandmen.com/download/
#PKG_MD5SUM:=aefbec27b96dd404d9ac9811e17d58ce
#PKG_HASH:=4b27e4f06f32d30271df89ecb6089bb11bcf2caec5f60b0909e083095354bca0
PKG_HASH:=ef514d4ca567b5871cfe7697127bee2c14d5d71d7fbc68d8fee96b0faaed90e7

PKG_BUILD_DEPENDS:=gutenprint/host libiconv-full
HOST_BUILD_DEPENDS:=libiconv-full/host
PKG_INSTALL:=1

include $(INCLUDE_DIR)/host-build.mk
include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/nls.mk

define Package/gutenprint-cups
  SECTION:=net
  CATEGORY:=Network
  TITLE:=Gutenprint CUPS drivers
  # XXX FIXME perl is required by cups-genppdupdate, but it needs more libs
  DEPENDS:=+cups +libcupsimage +libiconv-full
  URL:=http://gimp-print.sourceforge.net/
  SUBMENU:=Printing
endef

define Package/gutenprint-cups/description
	Gutenprint CUPS drivers for a wide range of Canon, Epson, HP and
	compatible printers.
endef

CONFIGURE_ARGS+= \
	--disable-nls \
	--disable-test \
	--without-doc \
	--without-readline \
	--without-foomatic \
	--without-foomatic3 \
	--enable-escputil=no \
	--enable-test=no \
	--disable-translated-cups-ppds \
	--disable-globalized-cups-ppds \
	--enable-simplified-cups-ppds \
	--bindir=/usr/bin \
	--sbindir=/usr/bin \
	--prefix=/usr \
	--exec-prefix=/usr

define Build/Compile
	# Replace the cross-compiled "extract-string" by a shell-script that
	# runs the host's own compiled version (gutenprint needs to run this)
	(cd $(PKG_BUILD_DIR) && $(MAKE) -C src/xml extract-strings && \
	$(RM) src/xml/extract-strings && \
	echo '#!/bin/sh' > src/xml/extract-strings && \
	echo 'exec $(HOST_BUILD_DIR)/src/xml/extract-strings  "$$$$@" ' \
	>> src/xml/extract-strings && chmod +x src/xml/extract-strings && cp src/xml/extract-strings /tmp/)
	$(call Build/Compile/Default)
endef

define Package/gutenprint-cups/install
	$(INSTALL_DIR) $(1)/usr/sbin $(1)/usr/bin
	# XXX Do not install cups-genppdupdate, as it requires Perl + some perl libs
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/sbin/cups-genppd.[0-9]*.[0-9]* $(1)/usr/sbin/
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/cups-calibrate $(1)/usr/bin/

	$(INSTALL_DIR) $(1)/usr/lib/cups/driver $(1)/usr/lib/cups/filter
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/cups/driver/gutenprint.* $(1)/usr/lib/cups/driver
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/lib/cups/filter/* $(1)/usr/lib/cups/filter
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/lib/libgutenprint.* $(1)/usr/lib
	$(INSTALL_DIR) $(1)/usr/share/cups/mime
	$(CP) $(PKG_INSTALL_DIR)/etc/cups/command.types $(1)/usr/share/cups/mime
	$(INSTALL_DIR) $(1)/usr/share/gutenprint
	$(CP) $(PKG_INSTALL_DIR)/usr/share/gutenprint/[0-9]*.[0-9]* $(1)/usr/share/gutenprint
endef

define Host/Compile
  $(MAKE) $(HOST_JOBS) -C $(HOST_BUILD_DIR)/src/xml $(HOST_MAKE_FLAGS) extract-strings
endef

define Host/Install
endef

$(eval $(call HostBuild))
$(eval $(call BuildPackage,gutenprint-cups))
