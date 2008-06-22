# Copyright 2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# -solar

DESTDIR ?= /
PREFIX ?= /usr/local

PORTDIR ?= $(shell portageq envvar PORTDIR)
FNAMES = cross-emerge  cross-fix-root  cross-pkg-config  emerge-wrapper
SITE = $(PREFIX)/share/crossdev/include/site
TOPDIR=

all:
	@:

install:
	mkdir -p $(DESTDIR)/$(PREFIX)/bin/ $(DESTDIR)/$(SITE)
	cp $(FNAMES) $(DESTDIR)/$(PREFIX)/bin/
	cp -a etc $(DESTDIR)/$(PREFIX)/share/crossdev/
	cp -a site $(DESTDIR)/$(PREFIX)/share/crossdev/include/
	sed -i -e s@__PREFIX__@$(PREFIX)@g $(DESTDIR)/$(PREFIX)/bin/emerge-wrapper
	sed -i -e s@__TOPDIR__@$(SITE)@g $(DESTDIR)/$(SITE)/config.site
	mv $(DESTDIR)/$(SITE)/config.site $(DESTDIR)/$(PREFIX)/share/
	( cd $(DESTDIR)/$(PREFIX)/share/crossdev/etc && ln -sf $(PORTDIR)/profiles/embedded make.profile )

uninstall:
	@for x in $(FNAMES) ; do rm -f $(DESTDIR)/$(PREFIX)/bin/$$x ; done

dist:
	cd ../ ; tar jcvf crossdev-wrappers-`date -u +%Y%m%d`.tar.bz2 crossdev-wrappers
