#Owned by DairyMan@Whirlpool
#
#Copyright GNU act.
include $(TOPDIR)/rules.mk

PKG_NAME:=ext-custom-multi
PKG_VERSION:=1.000
PKG_RELEASE:=1

PKG_MAINTAINER:=Created by DM/makefile by Cobia@whirlpool
include $(INCLUDE_DIR)/package.mk

define Package/ext-custom-multi
  SECTION:=utils
  CATEGORY:=ROOter
  SUBMENU:=CustomBuilds
  DEPENDS:=+ext-wireguard +ext-zerotier \
  	+ext-rooter-basic +build-admin +build-iphone +build-luci \
  	+build-wifi +ext-simplegps \
  	+bwmon +ext-speedtest +ext-extra +ext-netselect \
  	+tc +kmod-sched-core +kmod-ifb +iptables \
	+iptables-mod-ipopt +iptables-mod-conntrack-extra \
	+kmod-sched-cake +arc-storage +bwallocate +pingtest \
	+webconsole +ext-simpin +ext-texting
  TITLE:=MultiUser Build packages
  PKGARCH:=all
endef

define Package/ext-custom-multi/description
  MultiUser Build packages
endef


define Build/Compile
endef

$(eval $(call BuildPackage,ext-custom-multi))
