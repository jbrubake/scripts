SRC := $(wildcard *.c)
BINS := $(patsubst %.c,%$(SUFFIX),$(SRC))

all: $(BINS) $(readme)

clean:
	$(RM) $(BINS)
	$(RM) $(readme)

install: all
	./install.sh -Vf

# Generate README.md from 'abstract' tags
#
readme := README.md

# Base URL for README links
SRCPATH := https://github.com/jbrubake/scripts/blob/master

# Look for 'abstract' in all tracked files except those in $(ignore)
#
# Get contents of .ignore, replace * with % (so patterns work with make)
# and remove newlines (join)
ignore := $(join $(subst *,%,$(file < .ignore)),)
# Unignore source files
ignore := $(filter-out %.c,$(ignore))
# Get list of all files and remove what is in $(ignore)
# Use git ls-files to avoid pulling in untracked binaries
scripts := $(filter-out $(ignore),$(shell git ls-files))

$(readme): $(peru) $(scripts)
	@echo Building $@...
	@> $@
	@echo "## My Scripts" >> $@
	@echo >> $@
	@echo "A collection of scripts that I wrote or modified from someone else" >> $@
	@echo >> $@
	@echo "(Files licensed under different terms than GPLv3 have the license" >> $@
	@echo " embedded in the file.)" >> $@
	@echo >> $@
	./mkreadme.awk -v base_url=$(SRCPATH) $(filter-out $<,$^) >> $@
	@echo >> $@
	@echo "## External Files" >> $@
	@echo >> $@
	@echo "These files come from external repositories, but are synced here using [peru](https://github.com/buildinspace/peru)" >> $@
	@echo >> $@
	@echo "(Files licensed under different terms than GPLv3 are indicated, along with the" >> $@
	@echo " name of the license file if necessary.)" >> $@
	@echo >> $@
	./mkreadme.awk < peru.yaml | sort >> $@
	@echo >> $@

