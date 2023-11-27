#Owned by DairyMan@Whirlpool
#
#Copyright GNU act.
include $(TOPDIR)/rules.mk

PKG_NAME:=ext-wifirepeat
PKG_VERSION:=1.000
PKG_RELEASE:=1

PKG_MAINTAINER:=Created by DM/makefile by Cobia@whirlpool
include $(INCLUDE_DIR)/package.mk

define Package/ext-wifirepeat
  SECTION:=utils
  CATEGORY:=ROOter
   DEPENDS:=+luci +luci-compat +luci-app-rootervpn +openvpn-easy-rsa +openvpn-openssl +ext-wireguard \
		+webconsole +464xlat \
		+iptables-mod-hashlimit +luci-theme-argon \
		+ca-bundle +ca-certificates +libustream-wolfssl \
		+luci-app-hotspot +wireless-tools \
		+nano +picocom +wpad +wget +httping +curl
  TITLE:=Wifi Repeater
  PKGARCH:=all
endef

define Package/ext-wifirepeat/description
  Helper scripts to enable ROOter support for Normal routers
endef


define Build/Compile
endef

define Package/ext-wifirepeat/install
	$(CP) ./files/* $(1)/
endef

$(eval $(call BuildPackage,ext-wifirepeat))
