#Owned by DairyMan@Whirlpool
#
#Copyright GNU act.
include $(TOPDIR)/rules.mk

PKG_NAME:=ext-indro
PKG_VERSION:=1.000
PKG_RELEASE:=1

PKG_MAINTAINER:=Created by DM/makefile by Cobia@whirlpool
include $(INCLUDE_DIR)/package.mk

define Package/ext-indro
  SECTION:=utils
  CATEGORY:=ROOter
  DEPENDS:=+luci +ext-rooter-basic +build-admin \
		+pingtest \
		+luci-app-mwan3 +luci-app-dnsmasq-ipset \
		+luci-app-rootervpn +ext-wireguard \
		+bwmon +464xlat +webconsole \
		+ca-bundle +ca-certificates +libustream-wolfssl \
		+arc-storage +luci-theme-argon \
		+luci-app-sqm +kmod-sched-cake +luci-app-nft-qos \
		+ext-command +ext-speedtest \
		+openvpn-easy-rsa +openvpn-openssl \
		+ext-extra +luci-app-hotspot +luci-app-guestwifi \
		+usbmuxd +libusbmuxd-utils +libimobiledevice-utils +kmod-usb-net-ipheth \
		+usbutils +openssl-util +irqbalance \
		+wpad +wget +qfirehose +luci-app-vpnbypass 
  TITLE:=ROOter support for InDro routers
  PKGARCH:=all
endef

define Package/ext-indro/description
  Helper scripts to enable support for InDro routers
endef


define Build/Compile
endef

$(eval $(call BuildPackage,ext-indro))
