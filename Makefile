# Copyright 2008-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

include settings.mk

all:

install:
	$(INSTALL_DIR) $(DESTDIR)/$(PREFIX)/bin/
	$(INSTALL_EXEC) crossdev $(DESTDIR)/$(PREFIX)/bin/
	$(MAKE) -C wrappers install

PV = $(shell test -e .git && date --date="`git log -1 --format=%ci`" +%Y%m%d)
P = crossdev-$(PV)
COMP = xz
dist:
	git archive --prefix=$(P)/ HEAD | sed 's:@CDEVPV@:$(PV):g' > $(P).tar
	-$(COMP) -f $(P).tar
	du -b $(P).tar*

.PHONY: all dist install
