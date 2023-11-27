#Owned by DairyMan@Whirlpool
#
#Copyright GNU act.
# +luci-app-sqm +kmod-sched-cake +luci-app-nft-qos +luci-app-ksmbd +usb-storage
# +luci-app-ddns +ddns-scripts +ext-command +luci-app-wol +luci-app-vpnbypass 
# +qfirehose +qlog +nano +picocom 
# +usbmuxd +libusbmuxd-utils +libimobiledevice-utils +kmod-usb-net-ipheth \

# +gutenprint-cups +cups +cups-bjnp

include $(TOPDIR)/rules.mk

PKG_NAME:=ext-fcc
PKG_VERSION:=1.000
PKG_RELEASE:=1

PKG_MAINTAINER:=Created by DM/makefile by Cobia@whirlpool
include $(INCLUDE_DIR)/package.mk

define Package/ext-fcc
  SECTION:=utils
  CATEGORY:=ROOter
  DEPENDS:=+luci +ext-rooter-basic +pingtest +ext-splash \
  		+extramenu +ext-blacklist +ext-blockport +ext-domain \
		+luci-app-rootervpn +ext-wireguard \
		+bwmon +464xlat +webconsole \
		+ext-theme +luci-theme-argon \
		+ca-bundle +ca-certificates +libustream-wolfssl \
		+luci-app-sqm +kmod-sched-cake +luci-app-nft-qos +luci-app-ksmbd +usb-storage \
		+p910nd +luci-app-ddns +ddns-scripts +ext-command +luci-app-wol +luci-app-vpnbypass \
		+ext-speedtest +qfirehose +qlog +nano +picocom \
		+openvpn-easy-rsa +openvpn-openssl \
		+ext-extra +luci-app-hotspot +luci-app-guestwifi \
		+luci-ssl +usbutils +openssl-util +irqbalance \
		+usbmuxd +libusbmuxd-utils +libimobiledevice-utils +kmod-usb-net-ipheth \
		+wpad-openssl +wget +ext-simplegps 
  TITLE:=ROOter support w/o MWan3 for 16meg and larger routers
  PKGARCH:=all
endef

define Package/ext-fcc/description
  Helper scripts to enable ROOter w/o MWan3 on 16meg and larger routers
endef


define Build/Compile
endef

$(eval $(call BuildPackage,ext-fcc))
