# Copyright 2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

include settings.mk

all:

install:
	$(INSTALL_DIR) $(DESTDIR)/$(PREFIX)/bin/
	$(INSTALL_EXEC) crossdev $(DESTDIR)/$(PREFIX)/bin/
	$(MAKE) -C wrappers install

P = crossdev-`date +%Y%m%d`
dist:
	git archive --prefix=$(P)/ HEAD > $(P).tar
	-lzma -f $(P).tar

.PHONY: all dist install
