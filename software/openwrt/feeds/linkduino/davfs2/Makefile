#
# Copyright (C) 2011-2012 Entware
# Copyright (C) 2012 Michel Stempin
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=davfs2
PKG_VERSION:=1.4.7
PKG_RELEASE:=2

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=http://download.savannah.gnu.org/releases/davfs2/
PKG_MD5SUM:=c75f9d7d260e7364362b89beba2b3186

PKG_FIXUP:=autoreconf
PKG_INSTALL:=1

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/nls.mk

define Package/davfs2
	SECTION:=net
	CATEGORY:=Network
	SUBMENU:=Filesystem
	DEPENDS:=+libneon +libfuse +libopenssl $(ICONV_DEPENDS) $(INTL_DEPENDS)
	TITLE:=Mounts a WebDAV resource
	URL:=http://savannah.nongnu.org/projects/davfs2
	MAINTAINER:=Entware team, wl500g-repo.googlecode.com
endef

define Package/davfs2/description
 Mount a WebDAV resource as a regular file system. davfs2 will work with
 most WebDAV servers needing little or no configuration.
endef

CONFIGURE_ARGS += \
	--with-libintl-prefix=$(INTL_PREFIX) \
	--with-libiconv-prefix=$(ICONV_PREFIX) \
	--with-neon=$(STAGING_DIR)/usr \
  --datadir=/etc \
	dav_user=nobody \
	dav_group=nogroup \
	ssbindir=/usr/sbin \
	dav_localstatedir=/var/run \
	dav_syscachedir=/var/cache \

CONFIGURE_VARS += \
	LIBS="-liconv"

TARGET_CPPFLAGS += -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE

define Package/davfs2/conffiles
/etc/davfs2/davfs2.conf
/etc/davfs2/secrets
endef

define Package/davfs2/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/sbin/{,u}mount.davfs $(1)/usr/sbin
	$(INSTALL_DIR) $(1)/etc/davfs2/certs/private
	$(INSTALL_CONF) $(PKG_INSTALL_DIR)/etc/davfs2/{davfs2.conf,secrets} $(1)/etc/davfs2/
	$(INSTALL_DIR) $(1)/tmp/{run,cache}
endef

$(eval $(call BuildPackage,davfs2))
