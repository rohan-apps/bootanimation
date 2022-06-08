#
# Make options
#
#	CROSS_COMPILE	: define cross compiler (default arm-linux-gnueabihf-gcc)
#	DEBUG=y		: use debug build
#

CROSS_COMPILE := arm-linux-gnueabihf-
#CROSS_COMPILE := aarch64-linux-gnu-

CC  = $(CROSS_COMPILE)gcc
STRIP  = $(CROSS_COMPILE)strip
CFLAGS  := -Wall
CFLAGS  += -O3
# remove unused functions
CFLAGS  += -ffunction-sections -fdata-sections -Wl,--gc-sections
#CFLAGS  += -Wno-implicit-function-declaration
#CFLAGS  += -Werror

ifeq ($(G),y)
CFLAGS  += -g -rdynamic
CFLAGS  += -fno-omit-frame-pointer
endif

#LDFLAGS := -static
LIBS	:= -lpng -lz -lm

ifeq ($(DEBUG),y)
CFLAGS  += -DDEBUG
endif

COBJS	:= bootanimation.o fb.o jz.o png.o bmp.o
OBJS	:= $(COBJS)

TARGET = bootanimation 

all : $(TARGET)

$(TARGET) : depend $(OBJS)
	$(CC) -o $@ $(LDFLAGS) $(OBJS) $(LIBS)
ifneq ($(G),y)
	$(STRIP) --strip-unneeded $@
endif

.PHONY: clean

clean :
	rm -rf $(OBJS) $(TARGET) core .depend

ifeq (.depend,$(wildcard .depend))
include .depend
endif

SRCS := $(COBJS:.o=.c)
depend dep:
	$(CC)  -M $(CFLAGS) $(SRCS) > .depend

%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $< $(LIBS)
