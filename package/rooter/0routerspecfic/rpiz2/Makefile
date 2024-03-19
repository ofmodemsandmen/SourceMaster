#Owned by DairyMan@Whirlpool
#
#Copyright GNU act.
include $(TOPDIR)/rules.mk

PKG_NAME:=rpiz2
PKG_VERSION:=1.000
PKG_RELEASE:=1

PKG_MAINTAINER:=Created by DM/makefile by Cobia@whirlpool
include $(INCLUDE_DIR)/package.mk

define Package/rpiz2
  SECTION:=utils
  CATEGORY:=ROOter
  SUBMENU:=Router Specific
  TITLE:=Install scripts for RaspPi Zero 2
  PKGARCH:=all
endef

define Package/rpiz2/description
  Helper scripts to install scripts for RaspPi Zero 2
endef


define Build/Compile
endef

define Package/rpiz2/install
	$(CP) ./files/* $(1)/
endef

$(eval $(call BuildPackage,rpiz2))
