#
# Compile all *.c files to individual binaries
#
SRC := $(wildcard *.c)
BINS := $(patsubst %.c,%$(SUFFIX),$(SRC))

all: $(BINS) README.md

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
# Look for 'abstract' in all files except $(ignore)
ignore = Makefile peru.yaml LICENSE% %.md tags cscope.out %.c
scripts = $(filter-out $(ignore),$(wildcard *))

README.md: $(scripts)
	@echo Building README.md...
	@> README.md
	@echo "## My Scripts" >> README.md
	@echo >> README.md
	@echo "A collection of scripts that I wrote or modified from someone else" >> README.md
	@echo >> README.md
	@echo "(Files licensed under different terms than GPLv3 have the license" >> README.md
	@echo " embedded in the file.)" >> README.md
	@echo >> README.md
	@awk ' \
	    /abstract:/ { \
	        printf("- [%s]($(SRCPATH)/%s) - %s\n", \
	            FILENAME, \
	            gensub(/\..*$$/, "", 1, FILENAME), \
	            gensub(/^.*abstract: /, "", 1, $$0)) \
	    }' $(filter-out $<,$^) >> README.md
	@echo >> README.md
	@echo "## External Files" >> README.md
	@echo >> README.md
	@echo "These files come from external repositories, but are synced here using [peru](https://github.com/buildinspace/peru)" >> README.md
	@echo >> README.md
	@echo "(Files licensed under different terms than GPLv3 are indicated, along with the" >> README.md
	@echo " name of the license file if necessary.)" >> README.md
	@echo >> README.md
	@awk ' \
            /url:/ {gsub(/.*url: /, ""); url = $$0; license = ""} \
	    /license:/ {gsub(/.*license: /, ""); license = $$0} \
	    /abstract:/ { \
                printf("- [%s](%s) - %s%s\n", \
                    $$2, url, \
                    gensub(/^.*abstract: /, "", 1, $$0), \
                    license ? " (" license ")" : "" \
                ) \
            }' peru.yaml | sort >> README.md
	@echo >> README.md

