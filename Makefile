# original coffeescript Makefile from
# https://blog.jcoglan.com/2014/02/05/building-javascript-projects-with-make/

PATH  := node_modules/.bin:$(PATH)
SHELL := /bin/bash

source_files    := $(wildcard *.coffee lib/*.coffee)
build_files     := $(source_files:%.coffee=%.js)

.PHONY: all clean devclient devserver foreverclient foreverserver prodclient prodserver

all: $(build_files)

%.js: %.coffee
	coffee -co $(dir $@) $<

clean:
	rm -f *.{js,map} lib/*.{js,map}

devclient:
	nodemon -e '.coffee' -x 'bash' server.sh client

devserver:
	nodemon -e '.coffee' -x 'bash' server.sh server
	
foreverclient:
	./start-restart.sh client

foreverserver:
	./start-restart.sh server

prodclient: | clean all foreverclient

prodserver: | clean all foreverserver
