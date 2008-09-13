# Directions for building the website:
# 1. check out stable-tor and cvs-tor and website onto moria.
# 2. edit the two lines below to point to them.
# 3. (edit include/versions.wmi or others if you like)
# 4. make
# 5. ./publish

TORSVNSTABLE = ../tor-stable
TORSVNHEAD = ../tor
#TORSVNSTABLE = /home/arma/work/onion/tor-020x/tor/
#TORSVNHEAD = /home/arma/work/onion/svn/trunk

WMLBASE = .
SUBDIRS=docs eff gui torbrowser torbutton tordnsel projects torvm

include $(WMLBASE)/Makefile.common
all: $(SUBDIRS)

docs:
	$(MAKE) -C "$@" WMLBASE=..
eff:
	$(MAKE) -C "$@" WMLBASE=..
gui:
	$(MAKE) -C "$@" WMLBASE=..
torbrowser:
	$(MAKE) -C "$@" WMLBASE=..
torbutton:
	$(MAKE) -C "$@" WMLBASE=..
tordnsel:
	$(MAKE) -C "$@" WMLBASE=..
projects:
	$(MAKE) -C "$@" WMLBASE=..
torvm:
	$(MAKE) -C "$@" WMLBASE=..
mirrors:
	./update-mirrors.pl

# XXX: this also depends on all subs' wmlfiles.  How to fix?
translation-status.html.en: $(LANGS) $(WMIFILES) $(WMLFILES)

.PHONY: docs eff gui torbrowser torbutton tordnsel projects torvm
