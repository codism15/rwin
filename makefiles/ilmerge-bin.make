# this make file assumes in a visual studio output folder like Debug or Release.
# the merged exe is put in the parent folder.

BINARIES = $(filter-out %.vshost.exe, $(wildcard *.exe *.dll))
EXE = $(firstword $(BINARIES))

../$(EXE):	$(BINARIES)
	ilmerge.exe /out:$@ $^
