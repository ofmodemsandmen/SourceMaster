#Owned by DairyMan@Whirlpool
#
#Copyright GNU act.
include $(TOPDIR)/rules.mk

PKG_NAME:=ext-ltetest
PKG_VERSION:=1.000
PKG_RELEASE:=1

PKG_MAINTAINER:=Created by DM/makefile by Cobia@whirlpool
include $(INCLUDE_DIR)/package.mk

define Package/ext-ltetest
  SECTION:=utils
  CATEGORY:=ROOter
  DEPENDS:=+luci +ext-rooter-basic +build-admin +ext-splashconfig \
		+luci-app-ddns +ddns-scripts +pingtest \
		+extramenu +ext-blockport +ext-domain +ext-blacklist \
		+ext-wireguard +ext-zerotier \
		+bwmon +464xlat +webconsole \
		+ext-theme +luci-theme-argon +luci-theme-argondark +ext-login \
		+luci-theme-tomato \
		+ca-bundle +ca-certificates \
		+luci-app-ksmbd +usb-storage \
		+ext-p910nd +luci-app-sqm +kmod-sched-cake \
		+ext-command +ext-speedtest \
		+openvpn-easy-rsa +openvpn-openssl \
		+ext-extra +luci-app-hotspot +luci-app-wol +luci-app-guestwifi \
		+usbmuxd +libusbmuxd-utils +libimobiledevice-utils +kmod-usb-net-ipheth \
		+qlog +luci-ssl +usbutils +openssl-util +irqbalance \
		+nano +picocom +wpad +wget +qfirehose +luci-app-vpnbypass 
  TITLE:=ROOter support for World routers
  PKGARCH:=all
endef

define Package/ext-ltetest/description
  Helper scripts to enable support for World routers
endef


define Build/Compile
endef

$(eval $(call BuildPackage,ext-ltetest))
