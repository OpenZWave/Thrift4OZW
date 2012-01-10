#
# Makefile for Thrift4OZW
# Elias Karakoulakis <elias.karakoulakis@gmail.com>
# based on Makefile for OpenWave Control Panel application by Greg Satz

# GNU make only

.SUFFIXES:	.cpp .o .a .s .thrift

CC     := gcc
CXX    := g++
LD     := g++
AR     := ar rc
RANLIB := ranlib

DEBUG_CFLAGS    := -Wall -Wno-format -g -DDEBUG -Werror -O0
RELEASE_CFLAGS  := -Wall -Wno-unknown-pragmas -Wno-format -O3 -DNDEBUG

DEBUG_LDFLAGS	:= -g

# Change for DEBUG or RELEASE
CFLAGS	:= -c $(DEBUG_CFLAGS)
LDFLAGS	:= $(DEBUG_LDFLAGS)

# change directories if needed
OPENZWAVE := ../open-zwave
THRIFT := /usr/local/include/thrift
# LIBTHRIFT := ../libmicrohttpd/src/daemon/.libs/libmicrohttpd.a
SMC := /opt/smc

INCLUDES := -I $(OPENZWAVE)/cpp/src -I $(OPENZWAVE)/cpp/src/command_classes/ \
	-I $(OPENZWAVE)/cpp/src/value_classes/ -I $(OPENZWAVE)/cpp/src/platform/ \
	-I $(OPENZWAVE)/cpp/src/platform/unix -I $(OPENZWAVE)/cpp/tinyxml/ \
    -I $(THRIFT) -I $(SMC)/lib/C++/ \
	-I . -I gen-cpp/

# Remove comment below for gnutls support
GNUTLS := -lgnutls

# for Linux uncomment out next two lines
LIBZWAVE := $(wildcard $(OPENZWAVE)/cpp/lib/linux/*.a)
LIBUSB := -ludev
LIBPOCO := -lPocoNet -lboost_thread
LIBTHRIFT := -lthrift

# for Mac OS X comment out above 2 lines and uncomment next 2 lines
#LIBZWAVE := $(wildcard $(OPENZWAVE)/cpp/lib/mac/*.a)
#LIBUSB := -framework IOKit -framework CoreFoundation

LIBS := $(LIBZWAVE) $(GNUTLS) $(LIBMICROHTTPD) $(LIBTHRIFT) $(LIBUSB) $(LIBPOCO)

%.o : %.cpp
	$(CXX) $(CFLAGS) $(INCLUDES) -o $@ $<

%.o : %.c
	$(CC) $(CFLAGS) $(INCLUDES) -o $@ $<

all: main

gen-cpp/RemoteManager_server.cpp: create_server.rb gen-cpp/RemoteManager.cpp
	ruby1.9.1 create_server.rb --ozwroot=${OPENZWAVE} --thriftroot=$(THRIFT)
	patch -p0 gen-cpp/RemoteManager_server.cpp < gen-cpp/RemoteManager_server.cpp.patch
	patch -p0 gen-cpp/ozw_types.h <gen-cpp/ozw_types.h.patch
    
gen-cpp/RemoteManager.cpp: ozw.thrift
	thrift --gen cocoa --gen cpp --gen csharp --gen erl --gen go --gen java --gen js --gen perl --gen php --gen py --gen rb ozw.thrift

gen-cpp/RemoteManager.o: gen-cpp/RemoteManager.cpp
	g++ $(CFLAGS) -c gen-cpp/RemoteManager.cpp -o gen-cpp/RemoteManager.o $(INCLUDES)

gen-cpp/ozw_constants.o:  gen-cpp/ozw_constants.cpp
	g++ $(CFLAGS) -c gen-cpp/ozw_constants.cpp -o gen-cpp/ozw_constants.o $(INCLUDES)
    
gen-cpp/ozw_types.o:  gen-cpp/ozw_types.cpp gen-cpp/ozw_types.h
	g++ $(CFLAGS) -c gen-cpp/ozw_types.cpp -o gen-cpp/ozw_types.o $(INCLUDES)
    
Stomp_sm.cpp: Stomp.sm
	smc -c++ Stomp.sm 

Stomp_sm.o: Stomp_sm.cpp 
	g++ $(CFLAGS) -c Stomp_sm.cpp $(INCLUDES)
    
StompSocket.o: StompSocket.cpp StompSocket.h
	g++ $(CFLAGS) -c StompSocket.cpp $(INCLUDES)
    
PocoStomp.o:  PocoStomp.cpp PocoStomp.h Stomp_sm.cpp StompSocket.o
	g++ $(CFLAGS) -c PocoStomp.cpp $(INCLUDES)    

Main.o: Main.cpp Stomp_sm.o gen-cpp/RemoteManager_server.cpp
	g++ $(CFLAGS) -c Main.cpp $(INCLUDES)
    
main:   Main.o  Stomp_sm.o StompSocket.o PocoStomp.o gen-cpp/RemoteManager.o gen-cpp/ozw_constants.o gen-cpp/ozw_types.o
	$(LD) -o $@ $(LDFLAGS) Main.o Stomp_sm.o StompSocket.o PocoStomp.o gen-cpp/RemoteManager.o gen-cpp/ozw_constants.o gen-cpp/ozw_types.o $(LIBS)
    
dist:	main
	rm -f Ansible_OpenZWave.tar.gz
	tar -c --exclude=".git" --exclude ".svn" -hvzf Ansible_OpenZWave.tar.gz ozwcp config/ cp.html cp.js openzwavetinyicon.png README

clean:
	rm -f main *.o Stomp_sm.* gen-cpp/RemoteManager.cpp gen-cpp/RemoteManager_server.cpp gen-cpp/ozw_types.h

