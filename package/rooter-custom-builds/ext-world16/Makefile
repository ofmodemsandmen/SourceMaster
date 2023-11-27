#Owned by DairyMan@Whirlpool
#
#Copyright GNU act.
include $(TOPDIR)/rules.mk

PKG_NAME:=ext-world16
PKG_VERSION:=1.000
PKG_RELEASE:=1

PKG_MAINTAINER:=Created by DM/makefile by Cobia@whirlpool
include $(INCLUDE_DIR)/package.mk

define Package/ext-world16
  SECTION:=utils
  CATEGORY:=ROOter
  DEPENDS:=+ext-world \
		+luci-app-mwan3 +luci-app-dnsmasq-ipset
  TITLE:=ROOter support for World routers
  PKGARCH:=all
endef

define Package/ext-world16/description
  Helper scripts to enable support for World routers
endef


define Build/Compile
endef

$(eval $(call BuildPackage,ext-world16))
