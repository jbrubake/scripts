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
readme_hdr := readme.header
readme_ext := readme.external

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

$(readme): peru.yaml $(readme_hdr) $(readme_ext)  $(scripts)
	> $@

	cat $(readme_hdr) >> $@
	./mkreadme.awk -v base_url=$(SRCPATH) $(filter-out $< $(readme_hdr) $(readme_ext),$^) >> $@
	echo >> $@

	cat $(readme_ext) >> $@
	./mkreadme.awk < $< | sort >> $@
	echo >> $@

