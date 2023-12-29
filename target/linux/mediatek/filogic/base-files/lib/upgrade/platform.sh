REQUIRE_IMAGE_METADATA=1
RAMFS_COPY_BIN='fitblk readlink'

log() {
modlog "Image Check " "$@"
}

xiaomi_initial_setup()
{
	# initialize UBI and setup uboot-env if it's running on initramfs
	[ "$(rootfs_type)" = "tmpfs" ] || return 0

	local mtdnum="$( find_mtd_index ubi )"
	if [ ! "$mtdnum" ]; then
		echo "unable to find mtd partition ubi"
		return 1
	fi

	local kern_mtdnum="$( find_mtd_index ubi_kernel )"
	if [ ! "$kern_mtdnum" ]; then
		echo "unable to find mtd partition ubi_kernel"
		return 1
	fi

	ubidetach -m "$mtdnum"
	ubiformat /dev/mtd$mtdnum -y

	ubidetach -m "$kern_mtdnum"
	ubiformat /dev/mtd$kern_mtdnum -y

	if ! fw_printenv -n flag_try_sys2_failed &>/dev/null; then
		echo "failed to access u-boot-env. skip env setup."
		return 0
	fi

	fw_setenv boot_wait on
	fw_setenv uart_en 1
	fw_setenv flag_boot_rootfs 0
	fw_setenv flag_last_success 1
	fw_setenv flag_boot_success 1
	fw_setenv flag_try_sys1_failed 8
	fw_setenv flag_try_sys2_failed 8

	local board=$(board_name)
	case "$board" in
	xiaomi,mi-router-wr30u-stock)
		fw_setenv mtdparts "nmbm0:1024k(bl2),256k(Nvram),256k(Bdata),2048k(factory),2048k(fip),256k(crash),256k(crash_log),34816k(ubi),34816k(ubi1),32768k(overlay),12288k(data),256k(KF)"
		;;
	xiaomi,redmi-router-ax6000-stock)
		fw_setenv mtdparts "nmbm0:1024k(bl2),256k(Nvram),256k(Bdata),2048k(factory),2048k(fip),256k(crash),256k(crash_log),30720k(ubi),30720k(ubi1),51200k(overlay)"
		;;
	esac
}

platform_do_upgrade() {
	local board=$(board_name)

	case "$board" in
	acer,predator-w6)
		CI_KERNPART="kernel"
		CI_ROOTPART="rootfs"
		emmc_do_upgrade "$1"
		;;
	asus,tuf-ax4200|\
	asus,tuf-ax6000)
		CI_UBIPART="UBI_DEV"
		CI_KERNPART="linux"
		nand_do_upgrade "$1"
		;;
	bananapi,bpi-r3)
		rootdev="$(cmdline_get_var root)"
		rootdev="${rootdev##*/}"
		rootdev="${rootdev%p[0-9]*}"
		case "$rootdev" in
		mmc*)
			CI_ROOTDEV="$rootdev"
			CI_KERNPART="production"
			emmc_do_upgrade "$1"
			;;
		mtdblock*)
			PART_NAME="fit"
			default_do_upgrade "$1"
			;;
		ubiblock*)
			CI_KERNPART="fit"
			nand_do_upgrade "$1"
			;;
		esac
		;;
	bananapi,bpi-r4)
		local rootdev=$(readlink /sys/devices/platform/fitblk/lower_dev)
		rootdev="${rootdev##*/}"
		rootdev="${rootdev%p[0-9]*}"
		fitblk /dev/fit0
		[ -e /dev/fitrw ] && fitblk /dev/fitrw
		echo "$rootdev" > /tmp/rootdev
		case "$rootdev" in
		mmc*)
			CI_ROOTDEV="$rootdev"
			CI_KERNPART="production"
			emmc_do_upgrade "$1"
			;;
		ubiblock*)
			CI_KERNPART="fit"
			nand_do_upgrade "$1"
			;;
		esac
		;;
	cmcc,rax3000m)
		case "$(cmdline_get_var root)" in
		/dev/mmc*)
			CI_KERNPART="production"
			emmc_do_upgrade "$1"
			;;
		*)
			CI_KERNPART="fit"
			nand_do_upgrade "$1"
			;;
		esac
		;;
	cudy,wr3000-v1)
		default_do_upgrade "$1"
		;;
	glinet,gl-mt2500|\
	glinet,gl-x3000|\
	glinet,gl-mt6000)
		CI_KERNPART="kernel"
		CI_ROOTPART="rootfs"
		emmc_do_upgrade "$1"
		;;
	h3c,magic-nx30-pro|\
	jcg,q30-pro|\
	mediatek,mt7981-rfb|\
	qihoo,360t7|\
	tplink,tl-xdr4288|\
	tplink,tl-xdr6086|\
	tplink,tl-xdr6088|\
	xiaomi,mi-router-wr30u-ubootmod|\
	xiaomi,redmi-router-ax6000-ubootmod)
		CI_KERNPART="fit"
		nand_do_upgrade "$1"
		;;
	huasifei,ws1698)
		nand_do_upgrade "$1"
		;;
	mercusys,mr90x-v1)
		CI_UBIPART="ubi0"
		nand_do_upgrade "$1"
		;;
	ubnt,unifi-6-plus)
		CI_KERNPART="kernel0"
		EMMC_ROOT_DEV="$(cmdline_get_var root)"
		emmc_do_upgrade "$1"
		;;
	xiaomi,mi-router-wr30u-stock|\
	xiaomi,redmi-router-ax6000-stock)
		CI_KERN_UBIPART=ubi_kernel
		CI_ROOT_UBIPART=ubi
		nand_do_upgrade "$1"
		;;
        zyxel,ex5601-t0-ubootmod)
		CI_KERNPART="fit"
		CI_ROOTPART="ubi_rootfs"
                nand_do_upgrade "$1"
                ;;
	*)
		nand_do_upgrade "$1"
		;;
	esac
}

PART_NAME=firmware

platform_check_image() {
	local board=$(board_name)
	local magic="$(get_magic_long "$1")"

	[ "$#" -gt 1 ] && return 1

	case "$board" in
	bananapi,bpi-r3|\
	bananapi,bpi-r4|\
	cmcc,rax3000m)
		[ "$magic" != "d00dfeed" ] && {
			log "Invalid image type."
			return 1
		}
		return 0
		;;
	huasifei,ws1698)
		magic="$(dd if="$1" bs=1 skip=257 count=5 2>/dev/null)"
		[ "$magic" != "ustar" ] && {
			log "Invalid image type."
			return 1
		}
		return 0
		;;
	*)
		nand_do_platform_check "$board" "$1"
		return $?
		;;
	esac

	return 0
}

platform_copy_config() {
	case "$(board_name)" in
	bananapi,bpi-r3|\
	cmcc,rax3000m)
		case "$(cmdline_get_var root)" in
		/dev/mmc*)
			emmc_copy_config
			;;
		esac
		;;
	bananapi,bpi-r4)
		case "$(cat /tmp/rootdev)" in
		mmc*)
			emmc_copy_config
			;;
		esac
		;;
	glinet,gl-mt2500|\
	glinet,gl-x3000|\
	glinet,gl-mt6000|\
	ubnt,unifi-6-plus)
		emmc_copy_config
		;;
	esac
}

platform_pre_upgrade() {
	local board=$(board_name)

	case "$board" in
	xiaomi,mi-router-wr30u-stock|\
	xiaomi,redmi-router-ax6000-stock)
		xiaomi_initial_setup
		;;
	esac
}
