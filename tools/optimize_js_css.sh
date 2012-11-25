#! /bin/bash
#
#   Minification of CSS and Optimization of Javascript in LuCI using
#   Google's Closure Javascript compiler and Yahoo's Yuicompressor
#   CSS compressor.
#
#   See https://forum.openwrt.org/viewtopic.php?id=40640
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

TOOL_DIR=$(dirname $0)
[ $# -eq 1 ] || echo "usage: $0 <dirname>" || exit 0
DIRECTORY=$1/build_dir/target-mips_r2_uClibc-0.9.33.2/luci-*/*
for FILE in $( find $DIRECTORY -name '*.js' )
do
  echo "processing $FILE"
  java -jar $TOOL_DIR/compiler.jar --compilation_level=SIMPLE_OPTIMIZATIONS --js="$FILE" --js_output_file="$FILE-min.js" > /dev/null
  mv "$FILE-min.js" "$FILE"
done
for FILE in $( find $DIRECTORY -name '*.css' )
do
  echo "processing $FILE"
  java -jar $TOOL_DIR/yuicompressor-*.jar -o "$FILE-min.css" "$FILE"
  mv "$FILE-min.css" "$FILE" > /dev/null
done
