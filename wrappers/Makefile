# Copyright 2008-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

include ../settings.mk

PORTDIR ?= $(shell portageq envvar PORTDIR)
FNAMES = cross-emerge  cross-fix-root  cross-pkg-config  emerge-wrapper
SITEDIR = $(PREFIX)/share/crossdev/include/site

all:

install:
	$(INSTALL_DIR) $(DESTDIR)$(PREFIX)/bin/ $(DESTDIR)$(SITEDIR)
	$(INSTALL_EXEC) $(FNAMES) $(DESTDIR)$(PREFIX)/bin/
	sed -i -e "s:@GENTOO_PORTAGE_EPREFIX@:$(EPREFIX):g" $(DESTDIR)$(PREFIX)/bin/cross-emerge
	sed -i -e "s:@GENTOO_PORTAGE_EPREFIX@:$(EPREFIX):g" $(DESTDIR)$(PREFIX)/bin/emerge-wrapper
	cp -a etc $(DESTDIR)$(PREFIX)/share/crossdev/
	sed -i -e "s:@GENTOO_PORTAGE_EPREFIX@:$(EPREFIX):g" $(DESTDIR)$(PREFIX)/share/crossdev/etc/portage/make.conf
	cp -a site $(DESTDIR)$(PREFIX)/share/crossdev/include/
	sed -i -e s:@PREFIX@:$(PREFIX):g $(DESTDIR)$(PREFIX)/bin/emerge-wrapper
	sed -i -e s:@SITEDIR@:$(SITEDIR):g $(DESTDIR)$(SITEDIR)/config.site
	mv $(DESTDIR)$(SITEDIR)/config.site $(DESTDIR)$(PREFIX)/share/
	ln -sf $(PORTDIR)/profiles/embedded $(DESTDIR)$(PREFIX)/share/crossdev/etc/portage/make.profile

.PHONY: all install
