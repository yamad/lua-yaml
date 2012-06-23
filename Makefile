VERSION = 0.3.1
PREFIX  = /usr/local
LIBDIR  = $(PREFIX)/lib/lua/5.1
CC      = gcc
CFLAGS  = -O2 -Wall
LDFLAGS = -shared -fPIC

yaml.so: lyaml.o b64.o -lyaml
	$(CC) $(LDFLAGS) -o $@ $^

install: yaml.so
	install -Dpm0755 $< $(DESTDIR)$(LIBDIR)/$<

uninstall:
	$(RM) $(DESTDIR)$(LIBDIR)/yaml.so

dist: lua-yaml-$(VERSION).tar.gz

%.tar.gz: lyaml.c b64.c b64.h Makefile README.md test.lua | clean
	mkdir $*
	cp -r $^ $*
	tar -czf $@ $*
	rm -rf $*

rock: yaml-$(VERSION)-1.rockspec
	luarocks pack $<

yaml-%-1.rockspec: rockspec.in
	sed 's/%VERSION%/$*/g' $< > $@

check: yaml.so test.lua
	@lua test.lua

clean:
	$(RM) yaml.so *.o *.tar.gz *.rock *.rockspec


.PHONY: install uninstall dist rock check clean
