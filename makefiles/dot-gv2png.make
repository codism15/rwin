# "C:\Program Files\Graphviz2.26.3\bin\dot.exe" -Tpng "%1" "-o%1.png"

OBJS = $(patsubst %.gv, %.png, $(wildcard *.gv))

all:	$(OBJS)
	@echo $(OBJS) are up to date
	
%.png:	%.gv
	"/cygdrive/c/Program Files/Graphviz2.26.3/bin/dot.exe" -Tpng "$<" "-o$@"

clean:
	rm -f $(OBJS)