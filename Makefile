# Directions for building the website:
# 1. check out stable-tor and cvs-tor and website onto moria.
# 2. edit the two lines below to point to them.
# 3. (edit include/versions.wmi or others if you like)
# 4. make
# 5. scp *.html.* arma@tor.eff.org:/www/tor.eff.org/docs/

TORCVSSTABLE = ../tor-stable
TORCVSHEAD = ../tor-head
#TORCVSSTABLE = /home/arma/work/onion/tor-010x/tor
#TORCVSHEAD = /home/arma/work/onion/cvs/tor

WMLBASE = .
SUBDIRS=docs eff gui

include $(WMLBASE)/Makefile.common
all: $(SUBDIRS)

docs:
	$(MAKE) -C "$@" WMLBASE=..
eff:
	$(MAKE) -C "$@" WMLBASE=..
gui:
	$(MAKE) -C "$@" WMLBASE=..

# XXX: this also depends on all subs' wmlfiles.  How to fix?
translation-status.html.en: $(LANGS) $(WMIFILES) $(WMLFILES)

.PHONY: docs eff gui
