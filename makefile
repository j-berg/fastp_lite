#
#  makefile
#  fastp_lite
#
#  Created by Jordan Berg on 3/12/20.
#  Copyright © 2020 Jordan Berg. All rights reserved.
#

DIR_INC := ./inc
DIR_SRC := ./src
DIR_OBJ := ./obj

PREFIX ?= /usr/local
BINDIR ?= $(PREFIX)/bin
INCLUDE_DIRS ?=
LIBRARY_DIRS ?=

SRC := $(wildcard ${DIR_SRC}/*.cpp)
OBJ := $(patsubst %.cpp,${DIR_OBJ}/%.o,$(notdir ${SRC}))

TARGET := fastp_lite

BIN_TARGET := ${TARGET}

# CC
ifeq ($(UNAME_S),Darwin)
  CC := clang++ -arch x86_64
else
  CC := g++
endif

CXXFLAGS := -std=c++11 -g -O3 -I${DIR_INC} $(foreach includedir,$(INCLUDE_DIRS),-I$(includedir)) ${CXXFLAGS}
LIBS := -lz -lpthread
LD_FLAGS := $(foreach librarydir,$(LIBRARY_DIRS),-L$(librarydir)) $(LIBS) $(LD_FLAGS)


${BIN_TARGET}:${OBJ}
	$(CXX) $(OBJ) -o $@ $(LD_FLAGS)

${DIR_OBJ}/%.o:${DIR_SRC}/%.cpp make_obj_dir
	$(CXX) -c $< -o $@ $(CXXFLAGS)

.PHONY:clean
clean:
	rm obj/*.o
	rm $(TARGET)

make_obj_dir:
	@if test ! -d $(DIR_OBJ) ; \
	then \
		mkdir $(DIR_OBJ) ; \
	fi

install:
	install $(TARGET) $(BINDIR)/$(TARGET)
	@echo "Installed."