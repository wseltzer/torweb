# Directions for building the website:
#
# FIXME: this is incorrect, because maint-0.2.1 and master merged
# 1. Clone the Tor git repository, switch to branch maint-0.2.1, and
# make TORSVNSTABLE point to it: 
#
# 	git clone git://git.torproject.org/tor/ tor-stable
# 	cd tor-stable && git checkout maint-0.2.1
#
# 2. Clone the Tor git repository again and make TORGIT point to it:
#
# 	git clone git://git.torproject.org/tor/ tor
#
# 3. Edit include/versions.wmi or others if you like
# 4. Update STABLETAG and DEVTAG below if there is a new git tag
# 5. make
# 6. ./publish

# FIXME: these are the same
export TORSVNSTABLE=/home/phobos/onionrouter/onionrouter/tor/
export TORGIT=/home/phobos/onionrouter/onionrouter/tor.git/.git
export STABLETAG=tor-0.2.2.17-alpha
export DEVTAG=tor-0.2.2.17-alpha

WMLBASE=.
SUBDIRS=docs eff projects press about download download getinvolved donate

include $(WMLBASE)/Makefile.common
all: $(SUBDIRS)

docs:
	$(MAKE) -C "$@" WMLBASE=..
eff:
	$(MAKE) -C "$@" WMLBASE=..
projects:
	$(MAKE) -C "$@" WMLBASE=..
press:
	$(MAKE) -C "$@" WMLBASE=..
about:
	$(MAKE) -C "$@" WMLBASE=.. 
download:
	$(MAKE) -C "$@" WMLBASE=.. 
getinvolved:
	$(MAKE) -C "$@" WMLBASE=.. 
donate:
	$(MAKE) -C "$@" WMLBASE=..  
mirrors:
	./update-mirrors.pl
translations:
	./po2wml.sh
qrcode:
	qrencode -o img/android/orbot-qr-code-latest.png \
    "https://www.torproject.org/dist/android/alpha-orbot-latest.apk"

# XXX: this also depends on all subs' wmlfiles.  How to fix?
#translation-status.html.en: $(LANGS) $(WMIFILES) $(WMLFILES)

.PHONY: docs eff projects press about download download getinvolved donate
