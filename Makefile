# Copyright 2008-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

include settings.mk

all:

install:
	$(INSTALL_DIR) $(DESTDIR)$(PREFIX)/bin/
	$(INSTALL_EXEC) crossdev $(DESTDIR)$(PREFIX)/bin/
	sed -i -e "s:@GENTOO_PORTAGE_EPREFIX@:$(EPREFIX):g" $(DESTDIR)$(PREFIX)/bin/crossdev
	$(MAKE) -C wrappers install

PV = $(shell test -e .git && git describe)
P = crossdev-$(PV)
COMP = xz
dist:
	sed -i -e 's:@CDEVPV@:$(PV):g' crossdev
	git archive --prefix=$(P)/ HEAD > $(P).tar
	-$(COMP) -f $(P).tar
	du -b $(P).tar*
	sed -i -e 's:$(PV):@CDEVPV@:g' crossdev

.PHONY: all dist install
