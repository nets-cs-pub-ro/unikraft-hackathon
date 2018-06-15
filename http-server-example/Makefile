CPPFLAGS = -DDEBUG -DLOG_LEVEL=LOG_DEBUG -I. -I.. -I../..
CFLAGS = -Wall -g

.PHONY: all clean

build: all

all: http_reply_once


http_reply_once: http_reply_once.o sock_util.o http-parser/http_parser.o

http-parser/http_parser.o: http-parser/http_parser.c http-parser/http_parser.h
	make -C http-parser/ http_parser.o

clean:
	-rm -f *~
	-rm -f *.o
	-rm -f http-parser/http_parser.o
	-rm -f http_reply_once
