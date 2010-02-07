# Directions for building the website:
# 1. check out stable-tor, make TORSVNSTABLE point to it.
# 2. Clone the Tor git repository, make TORGIT point to it. This needs to be
#    the path to the .git directory (or a bare repo).
# 3. (edit include/versions.wmi or others if you like)
# 4. Update STABLETAG and DEVTAG below if there is a new git tag
# 5. make
# 6. ./publish

TORSVNSTABLE = ../tor-stable
TORGIT = ../tor/.git
STABLETAG = tor-0.2.1.22
DEVTAG = tor-0.2.2.8-alpha
#TORSVNSTABLE = /home/arma/work/onion/git/tor-021
#TORSVNHEAD = /home/arma/work/onion/git/tor

WMLBASE = .
SUBDIRS=docs eff gui torbrowser torbutton tordnsel projects torvm press gettor vidalia

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
press:
	$(MAKE) -C "$@" WMLBASE=..
gettor:
	$(MAKE) -C "$@" WMLBASE=..
vidalia:
	$(MAKE) -C "$@" WMLBASE=..
mirrors:
	./update-mirrors.pl
translations:
	./po2wml.sh

# XXX: this also depends on all subs' wmlfiles.  How to fix?
translation-status.html.en: $(LANGS) $(WMIFILES) $(WMLFILES)

.PHONY: docs eff gui torbrowser torbutton tordnsel projects torvm press gettor vidalia
