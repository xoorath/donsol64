ROOTDIR = $(N64_INST)
GCCN64PREFIX = $(ROOTDIR)/bin/mips64-elf-
CHKSUM64PATH = $(ROOTDIR)/bin/chksum64
MKDFSPATH = $(ROOTDIR)/bin/mkdfs
HEADERPATH = $(ROOTDIR)/mips64-elf/lib
N64TOOL = $(ROOTDIR)/bin/n64tool
HEADERNAME = header
LINK_FLAGS = -L$(ROOTDIR)/mips64-elf/lib -led64 -ldragon -lc -lm -ldragonsys -Tn64.ld
CFLAGS = -std=gnu99 -march=vr4300 -mtune=vr4300 -O2 -Wall -I$(ROOTDIR)/mips64-elf/include
CXXFLAGS = -std=c++11 -march=vr4300 -mtune=vr4300 -O2 -Wall -I$(ROOTDIR)/mips64-elf/include
ASFLAGS = -mtune=vr4300 -march=vr4300
CC = $(GCCN64PREFIX)gcc
CXX = $(GCCN64PREFIX)g++
AS = $(GCCN64PREFIX)as
LD = $(GCCN64PREFIX)ld
OBJCOPY = $(GCCN64PREFIX)objcopy

BUILD_PATH = $(CURDIR)/build
OBJDIR = $(BUILD_PATH)
SOURCE_PATH = $(CURDIR)/src
PROG_NAME = $(BUILD_PATH)/main

N64_FLAGS = -l 2M -h $(HEADERPATH)/$(HEADERNAME) -o $(PROG_NAME)$(ROM_EXTENSION) $(PROG_NAME).bin

ifeq ($(N64_BYTE_SWAP),true)
ROM_EXTENSION = .v64
N64_FLAGS = -b $(N64_FLAGS)
else
ROM_EXTENSION = .z64
endif

$(PROG_NAME)$(ROM_EXTENSION): $(PROG_NAME).elf
	$(OBJCOPY) $(PROG_NAME).elf $(PROG_NAME).bin -O binary
	rm -f $(PROG_NAME)$(ROM_EXTENSION)
	$(N64TOOL) $(N64_FLAGS) -t "Donsol64"
	$(CHKSUM64PATH) $(PROG_NAME)$(ROM_EXTENSION)

CSOURCES =  ${wildcard $(SOURCE_PATH)/*.c}
CPPSOURCES =  ${wildcard $(SOURCE_PATH)/*.cpp}

SOURCEOBJ = ${patsubst $(SOURCE_PATH)/%,$(OBJDIR)/%,$(CSOURCES:.c=.o)} ${patsubst $(SOURCE_PATH)/%,$(OBJDIR)/%,$(CPPSOURCES:.cpp=.o)}

$(OBJDIR)/%.o: $(SOURCE_PATH)/%.c
	mkdir -p $(BUILD_PATH)
	$(CC) -c -o $@ $< $(CFLAGS)


$(OBJDIR)/%.o: $(SOURCE_PATH)/%.cpp
	mkdir -p $(BUILD_PATH)
	$(CXX) -c -o $@ $< $(CXXFLAGS)

$(PROG_NAME).elf: $(SOURCEOBJ)
	$(LD) -o $@ $^ $(LINK_FLAGS)

all: $(PROG_NAME)$(ROM_EXTENSION)

.PHONY: clean

clean:
	rm -rf $(BUILD_PATH)/*
