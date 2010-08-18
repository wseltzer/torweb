# Directions for building the website:
#
# 1. Clone the Tor git repository, switch to branch release-0.2.1, and
#    make TORSVNSTABLE point to it:
#
# 	git clone git://git.torproject.org/tor/ tor-stable
# 	cd tor-stable && git checkout release-0.2.1
#
# 2. Clone the Tor git repository again and make TORGIT point to it:
#
# 	git clone git://git.torproject.org/tor/ tor
#
#    note that you need to either make this a bare repository or point
#    TORGIT to the .git subdirectory in your clone.
#
# 3. Edit include/versions.wmi or others if you like
# 4. Update STABLETAG and DEVTAG below if there is a new git tag
# 5. make
# 6. ./publish

TORSVNSTABLE = /home/arma/work/onion/git/tor-021
TORGIT = /home/arma/work/onion/git/tor/.git
STABLETAG = tor-0.2.1.26
DEVTAG = tor-0.2.2.14-alpha

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
qrcode:
	qrencode -o img/android/orbot-qr-code-latest.png \
    "http://www.torproject.org/dist/android/alpha-orbot-latest.apk"

# XXX: this also depends on all subs' wmlfiles.  How to fix?
translation-status.html.en: $(LANGS) $(WMIFILES) $(WMLFILES)

.PHONY: docs eff gui torbrowser torbutton tordnsel projects torvm press gettor vidalia
