#!/bin/sh
#
#   LinkDuino OpenWrt-based firmware generation script
#
#   Copyright (C) 2012 Michel Stempin <michel.stempin@wanadoo.fr>
#
#   This program is free software; you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation; either version 2 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program; if not, write to the Free Software
#   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

################################################################################
#   For Ubuntu 12.04 LTS, install the required build tools with:
#   sudo apt-get install build-essential subversion git-core libncurses5-dev zlib1g-dev gawk flex quilt libssl-dev xsltproc libxml-parser-perl
#
#   To avoid problems with the default Ubuntu /bin/sh that points to /bin/dash
#   rather than /bin/bash, type:
#   dpkg-reconfigure dash
#   Use dash as the default system shell (/bin/sh)? <-- No
################################################################################

# The OpenWrt SVN branch to use
BRANCH=attitude_adjustment

# Check out the required branch from OpenWrt SVN
svn co svn://svn.openwrt.org/openwrt/branches/$BRANCH

# Update and install all feeds, including additional packages
# and LuCI
pushd $BRANCH/
./scripts/feeds update -a
./scripts/feeds install -a
popd

# Check out the LinkDuino files
git clone https://github.com/Squonk42/LinkDuino.git

# Copy the added LinkDuino files into OpenWrt
cp -ar LinkDuino/software/openwrt/$BRANCH/* $BRANCH/

# Apply LinkDuino patches to OpenWrt
pushd $BRANCH/
for PATCH in patches/*; do patch -p 0 < $PATCH; done

# Apply LinkDuino default configuration to OpenWrt
cp LinkDuino.conf .config
make oldconfig

# Build LinkDuino
make -j 3
popd

# Optimize the LuCI JS and CSS files
./LinkDuino/tools/optimize_js_css.sh $BRANCH

# Create LinkDuino optimized firmware
pushd $BRANCH/
make -j 3
popd

