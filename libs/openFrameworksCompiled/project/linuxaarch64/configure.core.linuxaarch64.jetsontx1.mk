###############################################################################
# CONFIGURE CORE PLATFORM MAKEFILE
#   This file is where we make platform and architecture specific 
#   configurations. This file can be specified for a generic architecture or can
#   be defined as variants. For instance, normally this file will be located in 
#   a platform specific subpath such as 
#
#        $(OF_ROOT)/libs/openFrameworksComplied/linux64
#
#   This file will then be a generic platform file like:
#
#        configure.linux64.default.make
#
#   Or it can specify a specific platform variant like:
#
#        configure.linuxarmv6l.raspberrypi.make
#
################################################################################

################################################################################
# include common rules
#
#   all linux systems have several rules in common so most of them are included
#   from the following file
#
################################################################################

include $(OF_SHARED_MAKEFILES_PATH)/config.linux.common.mk

################################################################################
# PLATFORM DEFINES
#   Create a list of DEFINES for this platform.  The list will be converted into 
#   CFLAGS with the "-D" flag later in the makefile.  An example of fully 
#   qualified flag might look something like this: -DTARGET_OPENGLES2
#
#   DEFINES are used throughout the openFrameworks code, especially when making
#   #ifdef decisions for cross-platform compatibility.  For instance, when 
#   choosing a video playback framework, the openFrameworks base classes look at
#   the DEFINES to determine what source files to include or what default player 
#   to use.
#
#   Note: Leave a leading space when adding list items with the += operator
################################################################################

# defines used inside openFrameworks libs.
PLATFORM_DEFINES += TARGET_JETSON_TX1

################################################################################
# PLATFORM CFLAGS
#   This is a list of fully qualified CFLAGS required when compiling for this 
#   platform. These flags will always be added when compiling a project or the 
#   core library.  These flags are presented to the compiler AFTER the 
#   PLATFORM_OPTIMIZATION_CFLAGS below. 
#
#   Note: Leave a leading space when adding list items with the += operator
#   Refer to this for options: https://gcc.gnu.org/onlinedocs/gcc/AArch64-Options.html
################################################################################

PLATFORM_CFLAGS += -march=armv8-a
PLATFORM_CFLAGS += -mtune=cortex-a57
PLATFORM_CFLAGS += -fPIC
PLATFORM_CFLAGS += -ftree-vectorize
PLATFORM_CFLAGS += -Wno-psabi
PLATFORM_CFLAGS += -pipe

PLATFORM_CFLAGS += -I/usr/include/cairo
PLATFORM_CFLAGS += -I/usr/include/gstreamer-0.10
PLATFORM_CFLAGS += -I/usr/include/glib-2.0
PLATFORM_CFLAGS += -I/usr/lib/aarch64-linux-gnu/glib-2.0/include
PLATFORM_CFLAGS += -I/usr/include/gtk-3.0
PLATFORM_CFLAGS += -I/usr/include/pango-1.0
PLATFORM_CFLAGS += -I/usr/include/gdk-pixbuf-2.0
PLATFORM_CFLAGS += -I/usr/include/atk-1.0
PLATFORM_CFLAGS += -I/usr/include/freetype2

################################################################################
# PLATFORM LIBRARIES
# These are library names/paths that are platform specific and are specified
# using names or paths. The library flag (i.e. -l) is prefixed automatically.
#
# PLATFORM_LIBRARIES are libraries that can be found in the library search
# paths.
# PLATFORM_STATIC_LIBRARIES is a list of required static libraries.
# PLATFORM_SHARED_LIBRARIES is a list of required shared libraries.
# PLATFORM_PKG_CONFIG_LIBRARIES is a list of required libraries that are
# under system control and are easily accesible via the package
# configuration utility (i.e. pkg-config)
#
# See the helpfile for the -l flag here for more information:
# http://gcc.gnu.org/onlinedocs/gcc/Link-Options.html
#
# Note: Leave a leading space when adding list items with the += operator
################################################################################

PLATFORM_PKG_CONFIG_LIBRARIES += gl
PLATFORM_PKG_CONFIG_LIBRARIES += glu
PLATFORM_PKG_CONFIG_LIBRARIES += glew

ifeq ($(CROSS_COMPILING),1)
	GCC_PREFIX=aarch64-linux-gnu
    PLATFORM_CXX = $(GCC_PREFIX)-g++
	PLATFORM_CC = $(GCC_PREFIX)-gcc
	PLATFORM_AR = $(GCC_PREFIX)-ar
	PLATFORM_LD = $(GCC_PREFIX)-ld
	
	# Code Generation Option Flags (http://gcc.gnu.org/onlinedocs/gcc/Code-Gen-Options.html)
	PLATFORM_CFLAGS += --sysroot=$(SYSROOT)
	
	PLATFORM_HEADER_SEARCH_PATHS += $(SYSROOT)/usr/include/c++/4.6/
	PLATFORM_HEADER_SEARCH_PATHS += $(SYSROOT)/usr/include/c++/4.6/aarch64-linux-gnu
	
	PLATFORM_LDFLAGS += --sysroot=$(SYSROOT)
	PLATFORM_LDFLAGS += -Wl,-rpath-link $(SYSROOT)/usr/lib
	PLATFORM_LDFLAGS += -Wl,-rpath-link $(SYSROOT)/usr/lib/aarch64-linux-gnu
	PLATFORM_LDFLAGS += -Wl,-rpath-link $(SYSROOT)/lib
	PLATFORM_LDFLAGS += -Wl,-rpath-link $(SYSROOT)/lib/aarch64-linux-gnu
	
	PKG_CONFIG_LIBDIR=$(SYSROOT)/usr/lib/pkgconfig:$(SYSROOT)/usr/lib/aarch64-linux-gnu/pkgconfig:$(SYSROOT)/usr/share/pkgconfig
	
	PLATFORM_LIBRARIES += dl
endif