# Makefile, v1
# Sistemas Operativos, DEI/IST/ULisboa 2021-22
#
# This makefile should be run from the *root* of the project

CC ?= gcc
LD ?= gcc

# space separated list of directories with header files
INCLUDE_DIRS := fs .
# this creates a space separated list of -I<dir> where <dir> is each of the values in INCLUDE_DIRS
INCLUDES = $(addprefix -I, $(INCLUDE_DIRS))

SOURCES  := $(wildcard */*.c)
HEADERS  := $(wildcard */*.h)
OBJECTS  := $(SOURCES:.c=.o)
TARGET_EXECS := tests/threads1
TARGET_EXECS += tests/threads2
TARGET_EXECS += tests/threads3

# VPATH is a variable used by Makefile which finds *sources* and makes them available throughout the codebase
# vpath %.h <DIR> tells make to look for header files in <DIR>
vpath # clears VPATH
vpath %.h $(INCLUDE_DIRS)

LFLAGS = -lpthread
CFLAGS = -std=c11 -D_POSIX_C_SOURCE=200809L
CFLAGS += $(INCLUDES)

# Warnings
CFLAGS += -fdiagnostics-color=always -Wall -Werror -Wextra -Wcast-align -Wconversion -Wfloat-equal -Wformat=2 -Wnull-dereference -Wshadow -Wsign-conversion -Wswitch-default -Wswitch-enum -Wundef -Wunreachable-code -Wunused
# Warning suppressions
CFLAGS += -Wno-sign-compare

# optional debug symbols: run make DEBUG=no to deactivate them
ifneq ($(strip $(DEBUG)), no)
  CFLAGS += -g
endif

# optional O3 optimization symbols: run make OPTIM=no to deactivate them
ifeq ($(strip $(OPTIM)), no)
  CFLAGS += -O0
else
  CFLAGS += -O3
endif

# A phony target is one that is not really the name of a file
# https://www.gnu.org/software/make/manual/html_node/Phony-Targets.html
.PHONY: all clean depend fmt

CandC: clean all
all: $(TARGET_EXECS)

# The following target can be used to invoke clang-format on all the source and header
# files. clang-format is a tool to format the source code based on the style specified 
# in the file '.clang-format'.
# More info available here: https://clang.llvm.org/docs/ClangFormat.html

# The $^ keyword is used in Makefile to refer to the right part of the ":" in the 
# enclosing rule. See https://www.cs.colby.edu/maxwell/courses/tutorials/maketutor/

fmt: $(SOURCES) $(HEADERS)
	clang-format -i $^



# Note the lack of a rule.
# make uses a set of default rules, one of which compiles C binaries
# the CC, LD, CFLAGS and LDFLAGS are used in this rule
tests/copy_to_external_errors: tests/copy_to_external_errors.o fs/operations.o fs/state.o $(LFLAGS)
tests/copy_to_external_simple: tests/copy_to_external_simple.o fs/operations.o fs/state.o $(LFLAGS)
tests/write_10_blocks_spill: tests/write_10_blocks_spill.o fs/operations.o fs/state.o $(LFLAGS)
tests/write_10_blocks_simple: tests/write_10_blocks_simple.o fs/operations.o fs/state.o $(LFLAGS)
tests/write_more_than_10_blocks_simple: tests/write_more_than_10_blocks_simple.o fs/operations.o fs/state.o $(LFLAGS)
tests/test1: tests/test1.o fs/operations.o fs/state.o $(LFLAGS)
tests/threads1: tests/threads1.o fs/operations.o fs/state.o $(LFLAGS)
tests/threads2: tests/threads2.o fs/operations.o fs/state.o $(LFLAGS)
tests/threads3: tests/threads3.o fs/operations.o fs/state.o $(LFLAGS)
tests/threads4: tests/threads4.o fs/operations.o fs/state.o $(LFLAGS)
tests/threads5: tests/threads5.o fs/operations.o fs/state.o $(LFLAGS)
tests/threads6: tests/threads6.o fs/operations.o fs/state.o $(LFLAGS)
tests/threads7: tests/threads7.o fs/operations.o fs/state.o $(LFLAGS)
tests/threads8: tests/threads8.o fs/operations.o fs/state.o $(LFLAGS)
tests/threads9: tests/threads9.o fs/operations.o fs/state.o $(LFLAGS)


clean:
	rm -f $(OBJECTS) $(TARGET_EXECS)


# This generates a dependency file, with some default dependencies gathered from the include tree
# The dependencies are gathered in the file autodep. You can find an example illustrating this GCC feature, without Makefile, at this URL: https://renenyffenegger.ch/notes/development/languages/C-C-plus-plus/GCC/options/MM
# Run `make depend` whenever you add new includes in your files
depend : $(SOURCES)
	$(CC) $(INCLUDES) -MM $^ > autodep
