# Copyright 2008-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

include ../settings.mk

FNAMES = cross-ebuild cross-emerge cross-fix-root cross-pkg-config emerge-wrapper
SITEDIR = $(PREFIX)/share/crossdev/include/site
ETC_SITEDIR = $(EPREFIX)/etc/crossdev/include/site
PKG_CONFIG ?= pkg-config

all:

install:
	$(INSTALL_DIR) $(DESTDIR)$(PREFIX)/bin/ $(DESTDIR)$(SITEDIR) $(DESTDIR)$(ETC_SITEDIR)
	$(INSTALL_DATA) README $(DESTDIR)$(ETC_SITEDIR)
	sed -i -e s:@PREFIX@:$(PREFIX):g $(DESTDIR)$(ETC_SITEDIR)/README
	$(INSTALL_EXEC) $(FNAMES) $(DESTDIR)$(PREFIX)/bin/
	sed -i -e "s:@GENTOO_PORTAGE_EPREFIX@:$(EPREFIX):g" $(DESTDIR)$(PREFIX)/bin/cross-emerge
	sed -i -e "s:@PKG_CONFIG@:$(PKG_CONFIG):g" $(DESTDIR)$(PREFIX)/bin/cross-pkg-config
	sed -i -e "s:@GENTOO_PORTAGE_EPREFIX@:$(EPREFIX):g" $(DESTDIR)$(PREFIX)/bin/emerge-wrapper
	cp -a etc $(DESTDIR)$(PREFIX)/share/crossdev/
	sed -i -e "s:@GENTOO_PORTAGE_EPREFIX@:$(EPREFIX):g" $(DESTDIR)$(PREFIX)/share/crossdev/etc/portage/make.conf
	cp -a site $(DESTDIR)$(PREFIX)/share/crossdev/include/
	sed -i -e s:@PREFIX@:$(PREFIX):g $(DESTDIR)$(PREFIX)/bin/emerge-wrapper
	sed -i -e s:@SITEDIR@:$(SITEDIR):g $(DESTDIR)$(SITEDIR)/config.site
	sed -i -e s:@ETC_SITEDIR@:$(ETC_SITEDIR):g $(DESTDIR)$(SITEDIR)/config.site
	mv $(DESTDIR)$(SITEDIR)/config.site $(DESTDIR)$(PREFIX)/share/

.PHONY: all install
