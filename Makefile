# Copyright 2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

DESTDIR ?= /
PREFIX ?= /usr

all:
	@:

install:
	@mkdir -p $(DESTDIR)/$(PREFIX)/bin/
	cp crossdev $(DESTDIR)/$(PREFIX)/bin/
	@cd wrappers ; $(MAKE) DESTDIR=$(DESTDIR) PREFIX=$(PREFIX) install
