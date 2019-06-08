#
# Makefile for 'hidapitester'
# 2019 Tod E. Kurt, todbot.com
#

# overide this with `HIDAPI_DIR make`
HIDAPI_DIR ?= ../hidapi

# try to do some autodetecting
UNAME := $(shell uname -s)

ifeq "$(UNAME)" "Darwin"
	OS=macosx
endif
ifeq "$(OS)" "Windows_NT"
	OS=windows
endif
ifeq "$(UNAME)" "Linux"
	OS=linux
endif

# deal with stupid Windows not having 'cc'
ifeq (default,$(origin CC))
  CC = gcc
endif


#############  Mac
ifeq "$(OS)" "macosx"

LIBS=-framework IOKit -framework CoreFoundation
OBJS=$(HIDAPI_DIR)/mac/hid.o 
EXE=

endif

############# Windows
ifeq "$(OS)" "windows"

LIBS += -lsetupapi -Wl,--enable-auto-import -static-libgcc -static-libstdc++
OBJS = $(HIDAPI_DIR)/windows/hid.o
EXE=.exe

endif

############ Linux (hidraw)
ifeq "$(OS)" "linux"

LIBS = `pkg-config libudev --libs`
OBJS = $(HIDAPI_DIR)/linux/hid.o
EXE=

endif


############# common

CFLAGS=-I $(HIDAPI_DIR)/hidapi
OBJS += hidapitester.o

all: hidapitester

$(OBJS): %.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@


hidapitester: $(OBJS) 
	$(CC) $(CFLAGS) $(OBJS) -o hidapitester$(EXE) $(LIBS)

clean:
	rm -f $(OBJS)
	rm -f hidapitester$(EXE)
