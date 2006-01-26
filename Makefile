# Directions for building the website:
# 1. check out stable-tor and cvs-tor and website onto moria.
# 2. edit the two lines below to point to them.
# 3. (edit include/versions.wmi or others if you like)
# 4. make
# 5. scp *.html.* arma@tor.eff.org:/www/tor.eff.org/docs/

TORCVSSTABLE = ../tor.0.1.0-branch
TORCVSHEAD = ../tor-head
#TORCVSSTABLE = /home/arma/work/onion/tor-010x/tor
#TORCVSHEAD = /home/arma/work/onion/cvs/tor

WMLBASE = .
SUBDIRS=eff gui

include $(WMLBASE)/Makefile.common
all: $(SUBDIRS)

eff:
	$(MAKE) -C "$@" WMLBASE=../$(WMLBASE)
gui:
	$(MAKE) -C "$@" WMLBASE=../$(WMLBASE)

.PHONY: eff gui
