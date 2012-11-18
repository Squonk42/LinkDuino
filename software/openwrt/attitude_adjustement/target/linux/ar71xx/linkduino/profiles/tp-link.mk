#
# Copyright (C) 2009 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

define Profile/TLMR3020
	NAME:=TP-LINK TL-MR3020
	PACKAGES:=kmod-usb-core kmod-usb2 kmod-ledtrig-usbdev
endef

define Profile/TLMR3020/Description
	Package set optimized for the TP-LINK TL-MR3020.
endef
$(eval $(call Profile,TLMR3020))


define Profile/TLWR703
	NAME:=TP-LINK TL-WR703N
	PACKAGES:=kmod-usb-core kmod-usb2
endef


define Profile/TLWR703/Description
	Package set optimized for the TP-LINK TL-WR703N.
endef
$(eval $(call Profile,TLWR703))
