#Owned by DairyMan@Whirlpool
#
#Copyright GNU act.
include $(TOPDIR)/rules.mk

PKG_NAME:=ext-ota
PKG_VERSION:=1.000
PKG_RELEASE:=1

PKG_MAINTAINER:=Created by DM/makefile by Cobia@whirlpool
include $(INCLUDE_DIR)/package.mk

define Package/ext-ota
  SECTION:=utils
  CATEGORY:=ROOter
  SUBMENU:=Optional Applications
  TITLE:=support for group flashing
  PKGARCH:=all
endef

define Package/ext-ota/description
  Helper scripts to enable group flashing
endef


define Build/Compile
endef

define Package/ext-ota/install
	$(CP) ./files/* $(1)/
endef

$(eval $(call BuildPackage,ext-ota))
