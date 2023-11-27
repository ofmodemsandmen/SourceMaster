#Owned by DairyMan@Whirlpool
#
#Copyright GNU act.
include $(TOPDIR)/rules.mk

PKG_NAME:=ext-ex
PKG_VERSION:=1.000
PKG_RELEASE:=1

PKG_MAINTAINER:=Created by DM/makefile by Cobia@whirlpool
include $(INCLUDE_DIR)/package.mk

define Package/ext-ex
  SECTION:=utils
  CATEGORY:=ROOter
  DEPENDS:=+luci +ext-rooter-basic +build-admin \
		+pingtest +ext-texting +bwallocate +zerotier \
		+luci-app-rootervpn +ext-wireguard \
		+bwmon +464xlat +webconsole \
		+ca-bundle +ca-certificates +libustream-wolfssl \
		+arc-storage +luci-theme-argon \
		+kmod-sched-cake \
		+ext-command +ext-speedtest \
		+openvpn-easy-rsa +openvpn-openssl \
		+ext-extra +luci-app-hotspot +luci-app-guestwifi \
		+usbmuxd +libusbmuxd-utils +libimobiledevice-utils +kmod-usb-net-ipheth \
		+usbutils +openssl-util +irqbalance \
		+wpad +wget +qfirehose +luci-app-vpnbypass 
  TITLE:=ROOter support for EX routers
  PKGARCH:=all
endef

define Package/ext-ex/description
  Helper scripts to enable support for EX routers
endef


define Build/Compile
endef

$(eval $(call BuildPackage,ext-ex))
