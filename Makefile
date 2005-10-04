TORCVSSTABLE = ../tor.0.1.0-branch
TORCVSHEAD = ../tor-head

WMLBASE  = .
WMLOPT  = -D IMGROOT=$(WMLBASE)/images \
          -D DOCROOT="." -I include \
          -D TORCVSSTABLE=$(TORCVSSTABLE) \
          -D TORCVSHEAD=$(TORCVSHEAD)

WMLFILES=$(wildcard en/*.wml \
                    de/*.wml \
                    it/*.wml \
          )
#WMIFILES=$(wildcard include/*.wmi \
#                    en/*.wmi      \
#                    de/*.wmi      \
#                    it/*.wmi      \
#          )
HTMLFILES = $(patsubst de/%.wml, %.de.html, \
            $(patsubst en/%.wml, %.en.html, \
            $(patsubst it/%.wml, %.it.html, \
            $(WMLFILES))))
DEPFILES =  $(patsubst de/%.wml,.deps/%.de.html.d,   \
            $(patsubst en/%.wml,.deps/%.en.html.d,   \
            $(patsubst it/%.wml,.deps/%.it.html.d,   \
            $(WMLFILES))))


all: $(HTMLFILES)



%.en.html: en/%.wml
	wml $(WMLOPT) -I en -D LANG=en $< -o $@
.deps/%.en.html.d: en/%.wml
	@[ -d .deps ] || mkdir .deps
	OUT=`echo $@ | sed -e 's,\.deps/\(.*\)\.d$$,\1,'`; \
		wml $(WMLOPT) -I en -D LANG=en $< -o $$OUT --depend > $@

%.de.html: de/%.wml en/%.wml
	wml $(WMLOPT) -I de -D LANG=de $< -o $@
.deps/%.de.html.d: de/%.wml
	@[ -d .deps ] || mkdir .deps
	OUT=`echo $@ | sed -e 's,\.deps/\(.*\)\.d$$,\1,'`; \
		wml $(WMLOPT) -I de -D LANG=de $< -o $$OUT --depend > $@

%.it.html: it/%.wml it/%.wml
	wml $(WMLOPT) -I it -D LANG=it $< -o $@
.deps/%.it.html.d: it/%.wml
	@[ -d .deps ] || mkdir .deps
	OUT=`echo $@ | sed -e 's,\.deps/\(.*\)\.d$$,\1,'`; \
		wml $(WMLOPT) -I it -D LANG=it $< -o $$OUT --depend > $@


tor-manual-cvs.en.html: $(TORCVSHEAD)/doc/tor.1.in
tor-manual.en.html: $(TORCVSSTABLE)/doc/tor.1.in


dep: $(DEPFILES)

clean:
	rm -f $(HTMLFILES) $(DEPFILES)

include $(DEPFILES)
