#Owned by DairyMan@Whirlpool
#
#Copyright GNU act.
include $(TOPDIR)/rules.mk

PKG_NAME:=ext-custom-multi-openvpn
PKG_VERSION:=1.000
PKG_RELEASE:=1

PKG_MAINTAINER:=Created by DM/makefile by Cobia@whirlpool
include $(INCLUDE_DIR)/package.mk

define Package/ext-custom-multi-openvpn
  SECTION:=utils
  CATEGORY:=ROOter
  SUBMENU:=CustomBuilds
  DEPENDS:=+ext-custom-multi +build-openvpn
  TITLE:=MultiUser Build packages
  PKGARCH:=all
endef

define Package/ext-custom-multi-openvpn/description
  MultiUser Build packages
endef


define Build/Compile
endef

$(eval $(call BuildPackage,ext-custom-multi-openvpn))
