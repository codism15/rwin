# this make file assumes in a visual studio output folder like Debug or Release.
# the merged exe is put in the parent folder.

BINARIES = $(filter-out %.vshost.exe, $(wildcard *.exe *.dll))
EXE = $(firstword $(BINARIES))

../$(EXE):	$(BINARIES)
	ilmerge.exe "/targetplatform:v4,C:\Program Files (x86)\Reference Assemblies\Microsoft\Framework\.NETFramework\v4.0" /out:$@ $^ /allowDup
	