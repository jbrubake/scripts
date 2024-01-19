#
# Compile all *.c files to individual binaries
#
# Based on:
#   'A Generic Makefile for Building Multiple main() Targets in $PWD'
#   by Robert A. Nader (2012) Email: naderra at some g Web: xiberix
#
# Append .exe to binaries if USE_SUFFIX == 1
ifeq ($(USE_SUFFIX),1)
    SUFFIX=.exe
else
    SUFFIX=
endif

SRC := $(wildcard *.c)
BINS := $(patsubst %.c,%$(SUFFIX),$(SRC))

all: $(BINS)

%$(SUFFIX) : %.c
	$(CC) $(CFLAGS) $(LDFLAGS) $< -o $@

clean:
	$(RM) $(BINS)

install: all
	./install.sh -V

#
# Additional targets
#
# Generate README.md from scripts 'abstract' tag
#
SRCPATH=https://github.com/jbrubake/scripts/blob/master
readme:
	@> README.md
	@echo "## My Scripts" >> README.md
	@echo >> README.md
	@echo "A collection of scripts that I wrote or modified from someone else" >> README.md
	@echo >> README.md
	@awk 'BEGIN {FS="abstract:"} \
	     FILENAME == "peru.yaml" || FILENAME == "Makefile" {next} \
	     /abstract:/ { \
	     printf("- [%s]($(SRCPATH)/%s) - %s\n", gensub(/\..*$$/, "", 1, FILENAME), FILENAME, gensub(/^\s*/, "", 1, $$2))}' *  \
	     | sort >> README.md
	@echo >> README.md
	@echo "## External Files" >> README.md
	@echo >> README.md
	@echo "These files come from external repositories, but are synced here using [peru](https://github.com/buildinspace/peru)" >> README.md
	@echo >> README.md
	@awk ' /url:/ {url = $$2} \
	    /abstract:/ {printf("- [%s](%s) - %s\n", $$2, url, gensub(/^.*abstract: /, "", 1, $$0))}  \
	    ' peru.yaml | sort >> README.md
	@echo >> README.md
	
