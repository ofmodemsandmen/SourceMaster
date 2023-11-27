#Owned by DairyMan@Whirlpool
# 
#Copyright GNU act.
include $(TOPDIR)/rules.mk

PKG_NAME:=ext-wizard
PKG_VERSION:=1.000
PKG_RELEASE:=1

PKG_MAINTAINER:=Created by DM/makefile by Cobia@whirlpool
include $(INCLUDE_DIR)/package.mk

define Package/ext-wizard
  SECTION:=utils
  CATEGORY:=ROOter
  SUBMENU:=Optional Applications
  DEPENDS:=+ext-basicmenu 
  TITLE:=support for wizard
  PKGARCH:=all
endef

define Package/ext-wizard/description
  Helper scripts to add wizard
endef


define Build/Compile
endef

define Package/ext-wizard/install
	$(CP) ./files/* $(1)/
endef

$(eval $(call BuildPackage,ext-wizard))
