#
# Compile all *.c files to individual binaries
#
SRC := $(wildcard *.c)
BINS := $(patsubst %.c,%$(SUFFIX),$(SRC))

all: $(BINS)

clean:
	$(RM) $(BINS)

install: all
	./install.sh -Vf

#
# Additional targets
#
# Generate README.md from scripts 'abstract' tag
#
SRCPATH=https://github.com/jbrubake/scripts/blob/master
scripts=$(filter-out Makefile,$(filter-out peru.yaml,$(wildcard *)))

readme:
	@> README.md
	@echo "## My Scripts" >> README.md
	@echo >> README.md
	@echo "A collection of scripts that I wrote or modified from someone else" >> README.md
	@echo >> README.md
	@awk ' \
	    /abstract:/ { \
	        printf("- [%s]($(SRCPATH)/%s) - %s\n", \
	            FILENAME, \
	            gensub(/\..*$$/, "", 1, FILENAME), \
	            gensub(/^.*abstract: /, "", 1, $$0)) \
	    }' $(scripts) >> README.md
	@echo >> README.md
	@echo "## External Files" >> README.md
	@echo >> README.md
	@echo "These files come from external repositories, but are synced here using [peru](https://github.com/buildinspace/peru)" >> README.md
	@echo >> README.md
	@awk ' \
            /url:/ {gsub(/.*url: /, ""); url = $$0} \
	    /abstract:/ { \
                printf("- [%s](%s) - %s\n", \
                    $$2, url, \
                    gensub(/^.*abstract: /, "", 1, $$0)) \
            }' peru.yaml | sort >> README.md
	@echo >> README.md

