#
# Compile all *.c files to individual binaries
#
SRC := $(wildcard *.c)
BINS := $(patsubst %.c,%$(SUFFIX),$(SRC))

peru := .peru/lastimports

all: $(BINS) README.md

clean:
	$(RM) $(BINS)

install: all
	./install.sh -Vf

# Generate README.md from scripts 'abstract' tag
#
SRCPATH = https://github.com/jbrubake/scripts/blob/master

# Look for 'abstract' in all files except $(ignore)
#
# Get contents of .ignore, replace * with % (so patterns work with make)
# and remove newlines (join)
ignore := $(join $(subst *,%,$(file < .ignore)),)
# Unignore source files
ignore := $(filter-out %.c,$(ignore))
# Get list of all files
# Use git ls-files to avoid pulling in untracked binaries
scripts := $(filter-out $(ignore),$(shell git ls-files))

README.md: $(peru) $(scripts)
	@echo Building README.md...
	@> README.md
	@echo "## My Scripts" >> README.md
	@echo >> README.md
	@echo "A collection of scripts that I wrote or modified from someone else" >> README.md
	@echo >> README.md
	@echo "(Files licensed under different terms than GPLv3 have the license" >> README.md
	@echo " embedded in the file.)" >> README.md
	@echo >> README.md
	./mkreadme.awk -v base_url=$(SRCPATH) $(filter-out $<,$^) >> README.md
	@echo >> README.md
	@echo "## External Files" >> README.md
	@echo >> README.md
	@echo "These files come from external repositories, but are synced here using [peru](https://github.com/buildinspace/peru)" >> README.md
	@echo >> README.md
	@echo "(Files licensed under different terms than GPLv3 are indicated, along with the" >> README.md
	@echo " name of the license file if necessary.)" >> README.md
	@echo >> README.md
	./mkreadme.awk < peru.yaml | sort >> README.md
	@echo >> README.md

$(peru): peru.yaml
	peru sync

