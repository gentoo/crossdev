# Copyright 2008-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

include ../settings.mk

PORTDIR ?= $(shell portageq envvar PORTDIR)
FNAMES = cross-emerge  cross-fix-root  cross-pkg-config  emerge-wrapper
SITE = $(PREFIX)/share/crossdev/include/site
TOPDIR =

all:
	sed -i -e "s,@GENTOO_PORTAGE_EPREFIX@,$(EPREFIX),g" cross-emerge
	sed -i -e "s,@GENTOO_PORTAGE_EPREFIX@,$(EPREFIX),g" emerge-wrapper
	sed -i -e "s,@GENTOO_PORTAGE_EPREFIX@,$(EPREFIX),g" etc/portage/make.conf

install:
	$(INSTALL_DIR) $(DESTDIR)/$(PREFIX)/bin/ $(DESTDIR)/$(SITE)
	$(INSTALL_EXEC) $(FNAMES) $(DESTDIR)/$(PREFIX)/bin/
	cp -a etc $(DESTDIR)/$(PREFIX)/share/crossdev/
	cp -a site $(DESTDIR)/$(PREFIX)/share/crossdev/include/
	sed -i -e s@__PREFIX__@$(PREFIX)@g $(DESTDIR)/$(PREFIX)/bin/emerge-wrapper
	sed -i -e s@__TOPDIR__@$(SITE)@g $(DESTDIR)/$(SITE)/config.site
	mv $(DESTDIR)/$(SITE)/config.site $(DESTDIR)/$(PREFIX)/share/
	ln -sf $(PORTDIR)/profiles/embedded $(DESTDIR)/$(PREFIX)/share/crossdev/etc/portage/make.profile

.PHONY: all install
