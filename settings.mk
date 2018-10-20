# Copyright 2008-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

PORTAGE_CONFIGROOT ?= $(shell portageq envvar PORTAGE_CONFIGROOT)
DESTDIR ?=
EPREFIX ?= $(shell portageq envvar EPREFIX)
PREFIX ?= $(EPREFIX)/usr

INSTALL_DIR  = install -m 755 -d
INSTALL_EXEC = install -m 755
INSTALL_DATA = install -m 644
