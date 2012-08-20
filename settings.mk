# Copyright 2008-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

DESTDIR ?=
EPREFIX ?=
PREFIX ?= $(EPREFIX)/usr

INSTALL_DIR  = install -m 755 -d
INSTALL_EXEC = install -m 755
