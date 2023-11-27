#Owned by DairyMan@Whirlpool
#
#Copyright GNU act.
include $(TOPDIR)/rules.mk

PKG_NAME:=meshs
PKG_VERSION:=4.500
PKG_RELEASE:=1

PKG_MAINTAINER:=Created by DM/makefile by Cobia@whirlpool
include $(INCLUDE_DIR)/package.mk

define Package/meshs
  SECTION:=utils
  CATEGORY:=ROOter
  SUBMENU:=Mesh Support
  TITLE:=Install scripts for Mesh Network
  PKGARCH:=all
endef

define Package/meshs/description
  Install scripts for Mesh Network
endef


define Build/Compile
endef

define Package/meshs/install
	$(CP) ./files/* $(1)/
endef

$(eval $(call BuildPackage,meshs))
