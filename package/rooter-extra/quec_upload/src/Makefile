PROG = quec_upload
CFLAGS = -w -Wall -g -O0 $(CFLAGS_EXTRA)
SOURCES = $(PROG).c

$(PROG): $(SOURCES)
	$(CC) -o $(PROG) $(SOURCES) $(CFLAGS)
clean:
	rm -rf $(PROG) *.dSYM *.obj *.exp .*o *.lib
