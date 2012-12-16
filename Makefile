#
# Makefile for Thrift4OZW
# Elias Karakoulakis <elias.karakoulakis@gmail.com>
# based on Makefile for OpenWave Control Panel application by Greg Satz

# GNU make only

.SUFFIXES:	.cpp .o .a .s .thrift

CC     := gcc
CXX    := g++
LD     := ld
AR     := ar rc
RANLIB := ranlib

# Change for DEBUG or RELEASE
TARGET := DEBUG

DEBUG_CFLAGS    := -DHAVE_INTTYPES_H -DHAVE_NETINET_IN_H -Wall -Wno-format -g -DDEBUG -Werror -O0 -DDEBUG_BOOSTSTOMP 
RELEASE_CFLAGS  := -DHAVE_INTTYPES_H -DHAVE_NETINET_IN_H -Wall -Wno-unknown-pragmas -Wno-format -O3 -DNDEBUG

DEBUG_LDFLAGS	:= -g

# change directories if needed
OPENZWAVE	:= ../open-zwave
OPENZWAVE_INC	:= $(OPENZWAVE)/cpp/src
THRIFT		:= /usr/local/include/thrift
THRIFT_INC	:= /usr/local/include/thrift
BOOSTSTOMP 	:= ../BoostStomp
BOOSTSTOMP_INC	:= $(BOOSTSTOMP)

CFLAGS	:= -c $($(TARGET)_CFLAGS) 
LDFLAGS	:= $($(TARGET)_LDFLAGS) \
		-L/usr/lib/ -L/usr/local/lib -L/usr/local/lib/thrift \
		-L$(BOOSTSTOMP) \
		-Wl,-rpath=$(OPENZWAVE)/cpp/lib/linux/ \
		-Wl,-rpath=$(BOOSTSTOMP) \
		-Wl,-rpath=/usr/local/lib 

INCLUDES := -I $(OPENZWAVE)/cpp/src -I $(OPENZWAVE)/cpp/src/command_classes/ \
	-I $(OPENZWAVE)/cpp/src/value_classes/ -I $(OPENZWAVE)/cpp/src/platform/ \
	-I $(OPENZWAVE)/cpp/src/platform/unix -I $(OPENZWAVE)/cpp/tinyxml/ \
    -I $(THRIFT_INC) -I $(BOOSTSTOMP_INC) \
	-I . -I gen-cpp/

# Remove comment below for gnutls support
GNUTLS := -lgnutls

LIBZWAVE_STATIC := $(OPENZWAVE)/cpp/lib/linux/libopenzwave.a
LIBZWAVE_DYNAMIC := $(OPENZWAVE)/cpp/lib/linux/libopenzwave.so
LIBUSB := -ludev
LIBBOOST := -lboost_thread -lboost_program_options -lboost_filesystem -lboost_system
LIBBOOST_STATIC := -lboost_thread -lboost_program_options -lboost_filesystem -lboost_system
LIBTHRIFT := -lthrift
LIBBOOSTSTOMP := -lbooststomp
LIBBOOSTSTOMP_STATIC := $(BOOSTSTOMP)/libbooststomp.a

# for Mac OS X comment out above 2 lines and uncomment next 2 lines
#LIBZWAVE := $(wildcard $(OPENZWAVE)/cpp/lib/mac/*.a)
#LIBUSB := -framework IOKit -framework CoreFoundation

LIBS := $(GNUTLS) $(LIBUSB) $(LIBBOOST) $(LIBTHRIFT) $(LIBBOOSTSTOMP)

%.o : %.cpp
	$(CXX) $(CFLAGS) $(INCLUDES) -o $@ $<

%.o : %.c
	$(CC) $(CFLAGS) $(INCLUDES) -o $@ $<

#all: openzwave booststomp ozwd ozwd.static
all: openzwave booststomp ozwd

gen-cpp/RemoteManager_server.cpp: create_server.rb gen-cpp/RemoteManager.cpp
	patch -p0 gen-cpp/ozw_types.h <gen-cpp/ozw_types.h.patch
	ruby create_server.rb --ozwroot=${OPENZWAVE} --thriftroot=$(THRIFT)
	cp gen-cpp/RemoteManager_server.cpp gen-cpp/RemoteManager_server.cpp.orig
	cp gen-cpp/ozw_types.h gen-cpp/ozw_types.h.orig
	patch -p0 gen-cpp/RemoteManager_server.cpp < gen-cpp/RemoteManager_server.cpp.patch
    
gen-cpp/RemoteManager.cpp: ozw.thrift
	thrift --gen cocoa --gen cpp --gen csharp --gen erl --gen go --gen java --gen js --gen perl --gen php --gen py --gen rb ozw.thrift

gen-cpp/RemoteManager.o: gen-cpp/RemoteManager.cpp
	$(CXX) $(CFLAGS) -c gen-cpp/RemoteManager.cpp -o gen-cpp/RemoteManager.o $(INCLUDES)

gen-cpp/ozw_constants.o:  gen-cpp/ozw_constants.cpp
	$(CXX) $(CFLAGS) -c gen-cpp/ozw_constants.cpp -o gen-cpp/ozw_constants.o $(INCLUDES)
    
gen-cpp/ozw_types.o:  gen-cpp/ozw_types.cpp gen-cpp/ozw_types.h
	$(CXX) $(CFLAGS) -c gen-cpp/ozw_types.cpp -o gen-cpp/ozw_types.o $(INCLUDES)

Main.o: Main.cpp gen-cpp/RemoteManager_server.cpp
	$(CXX) $(CFLAGS) -c Main.cpp $(INCLUDES)   
	
openzwave: $(LIBZWAVE_STATIC) $(LIBZWAVE_DYNAMIC)
	cd $(OPENZWAVE)/cpp/build/linux/; make
	
booststomp:
	cd $(BOOSTSTOMP); make

ozwd.static: Main.o booststomp gen-cpp/RemoteManager.o gen-cpp/ozw_constants.o gen-cpp/ozw_types.o $(LIBZWAVE_STATIC)
	$(CXX) -static -static-libgcc -o $@ $(LDFLAGS) Main.o gen-cpp/RemoteManager.o gen-cpp/ozw_constants.o gen-cpp/ozw_types.o  $(LIBZWAVE_STATIC) $(LIBBOOSTSTOMP_STATIC) $(LIBBOOST_STATIC) -lpthread -ludev -lthrift -lrt

ozwd:   Main.o booststomp gen-cpp/RemoteManager.o gen-cpp/ozw_constants.o gen-cpp/ozw_types.o $(LIBZWAVE_DYNAMIC) 
	$(CXX) -o $@ $(LDFLAGS) Main.o gen-cpp/RemoteManager.o gen-cpp/ozw_constants.o gen-cpp/ozw_types.o $(LIBS) $(LIBZWAVE_DYNAMIC)	 

dist:	main
	rm -f Thrift4OZW.tar.gz
	tar -c --exclude=".git" --exclude ".svn" --exclude "*.o" -hvzf Thrift4OZW.tar.gz *.cpp *.h *.thrift *.sm *.rb Makefile gen-*/ license/ README*

bindist: main
	rm -f Thrift4OZW_bin_`uname -i`.tar.gz
	upx ozwd*
	tar -c --exclude=".git" --exclude ".svn" -hvzf Thrift4OZW_bin_`uname -i`.tar.gz ozwd license/ README*

clean:
	rm -f ozwd*.o gen-cpp/RemoteManager.cpp gen-cpp/RemoteManager_server.cpp gen-cpp/ozw_types.h

binclean: 
	rm -f ozwd *.o  gen-cpp/*.o
    
thrift: gen-cpp/RemoteManager.cpp

patchdiffs:
	- diff -C3 gen-cpp/ozw_types.h.orig gen-cpp/ozw_types.h.patched > gen-cpp/ozw_types.h.patch
	- diff -C3 gen-cpp/RemoteManager_server.cpp.orig gen-cpp/RemoteManager_server.cpp.patched > gen-cpp/RemoteManager_server.cpp.patch
