#Owned by DairyMan@Whirlpool
#
#Copyright GNU act.
include $(TOPDIR)/rules.mk

PKG_NAME:=ext-lte
PKG_VERSION:=1.000
PKG_RELEASE:=1

PKG_MAINTAINER:=Created by DM/makefile by Cobia@whirlpool
include $(INCLUDE_DIR)/package.mk

define Package/ext-lte
  SECTION:=utils
  CATEGORY:=ROOter
  SUBMENU:=BuildSections
  DEPENDS:=+ext-rooter-basic +build-admin +build-iphone +build-luci \
  		+build-openvpn +build-wifi +pingtest +ext-extra +ext-zerotier +extramenu +ext-blockport +ext-domain +ext-blacklist \
  		+bwmon +ext-speedtest +luci-app-sqm +ext-wireguard +build-usb \
  		+luci-app-ddns +ddns-scripts +luci-app-wol +ext-splashconfig +qfirehose +464xlat
  TITLE:=Custom Basic packages
  PKGARCH:=all
endef

define Package/ext-lte/description
  Custom Basic packages
endef


define Build/Compile
endef

$(eval $(call BuildPackage,ext-lte))
