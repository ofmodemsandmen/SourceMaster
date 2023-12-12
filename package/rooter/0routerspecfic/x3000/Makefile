#Owned by DairyMan@Whirlpool
#
#Copyright GNU act.
include $(TOPDIR)/rules.mk

PKG_NAME:=x3000
PKG_VERSION:=1.000
PKG_RELEASE:=1

PKG_MAINTAINER:=Created by DM/makefile by Cobia@whirlpool
include $(INCLUDE_DIR)/package.mk

define Package/x3000
  SECTION:=utils
  CATEGORY:=ROOter
  SUBMENU:=Router Specific
  TITLE:=Install scripts for ws1698
  PKGARCH:=all
endef

define Package/x3000/description
  Helper scripts to install scripts for ws1698
endef


define Build/Compile
endef

define Package/x3000/install
	$(CP) ./files/* $(1)/


endef

$(eval $(call BuildPackage,x3000))
