# **********************************************************************
#
# Copyright (c) 2003-2015 ZeroC, Inc. All rights reserved.
#
# This copy of Ice is licensed to you under the terms described in the
# ICE_LICENSE file included in this distribution.
#
# **********************************************************************

#
# Select an installation base directory. The directory will be created
# if it does not exist.
#
!if "$(PREFIX)" == ""
prefix			= C:\Ice-$(VERSION)
!else
prefix			= $(PREFIX)
!endif

#
# Define OPTIMIZE as yes if you want to build with
# optimization. Otherwise Ice is build with debug information.
#
#OPTIMIZE		= yes

#
# Define if you want pdb files to be generated for optimized/release
# builds
#
#RELEASEPDBS            = yes

#
# Specify your C++ compiler, or leave unset for auto-detection.
# Supported values are: VC100, VC110, VC120
#
# CPP_COMPILER = VCxxx

#
# Define if you want to build for WinRT
#
#WINRT		        = yes

#
# If MCPP is not installed in a standard location where the compiler
# can find it, set MCPP_HOME to the Mcpp installation directory.
#
# MCPP_HOME		= C:\mcpp

#
# If third party libraries are not installed in the default location
# or THIRDPARTY_HOME is not set in your environment variables then
# change the following setting to reflect the installation location.
#
!if "$(THIRDPARTY_HOME)" == ""
!if "$(PROCESSOR_ARCHITECTURE)" == "AMD64"
THIRDPARTY_HOME = $(PROGRAMFILES) (x86)\ZeroC\Ice-$(VERSION)-ThirdParty
!else
THIRDPARTY_HOME = $(PROGRAMFILES)\ZeroC\Ice-$(VERSION)-ThirdParty
!endif
!endif

#
# Define if you want the Ice DLLs to have compiler specific names.
# Will be set to yes by default when CPP_COMPILER=VC100, and unset
# otherwise
#
#UNIQUE_DLL_NAMES       = yes

#
# Define if you want the Ice DLLs and executable files to be authenticode
# signed.
#
#SIGN_CERTIFICATE	= MyCertFile.pfx
#SIGN_PASSWORD		= MyCertPassword
#SIGN_TIMESTAMPSERVER	= http://timestamp.verisign.com/scripts/timstamp.dll

# ----------------------------------------------------------------------
# Don't change anything below this line!
# ----------------------------------------------------------------------

#
# Common definitions
#
ice_language     = cpp
!if "$(USE_BIN_DIST)" == "yes" || !exist ($(top_srcdir)\..\cpp)
slice_translator = slice2cpp.exe
ice_require_cpp  = 1
!endif

#
# If CPP_COMPILER is not set, get Make.common.rules.mak to figure it
# out by setting CPP_COMPILER to "auto"
#
!if "$(CPP_COMPILER)" == ""
CPP_COMPILER=auto
!endif

#
# Compile scanner and grammar files?
#
!if "$(BISON_FLEX)" == ""
#BISON_FLEX             = yes
!endif

!if exist ($(top_srcdir)\..\config\Make.common.rules.mak)
!include $(top_srcdir)\..\config\Make.common.rules.mak
!else
!include $(top_srcdir)\config\Make.common.rules.mak
!endif

#
# With VC100, we want unique dll names by default
#
!if "$(CPP_COMPILER)" == "VC100" && "$(UNIQUE_DLL_NAMES)" == ""
UNIQUE_DLL_NAMES        = yes
!endif

bindir			= $(top_srcdir)\bin
libdir			= $(top_srcdir)\lib
headerdir		= $(top_srcdir)\include

!if "$(WINRT)" == "yes"
!if "$(SOURCE_DIR)" != ""
includedir      = $(top_srcdir)\include
!else
# To build the tests against the SDK headers
includedir      = $(SDK_INCLUDE_PATH)
!endif
!else
!if "$(ice_src_dist)" != ""
includedir		= $(top_srcdir)\include
!else
includedir		= $(ice_dir)\include
!endif
!endif

install_libdir	  	= $(prefix)\lib$(x64suffix)
install_includedir	= $(prefix)\include
install_configdir	= $(prefix)\config

SETARGV			= setargv.obj

#
# Compiler specific definitions
#
!include        $(top_srcdir)/config/Make.rules.msvc

!if "$(WINRT)" == "yes" && "$(CPP_COMPILER)" != "VC110" && "$(CPP_COMPILER)" != "VC120" && "$(CPP_COMPILER)" != "VC140"
!error CPP_COMPILER: $(CPP_COMPILER) not supported to build Ice for WinRT
!endif

!if "$(CPP_COMPILER)" == "VC140"
libsuff                 = \vc140$(x64suffix)
!elseif "$(CPP_COMPILER)" == "VC110"
libsuff                 = \vc110$(x64suffix)
!elseif "$(CPP_COMPILER)" == "VC100"
libsuff                 = \vc100$(x64suffix)
!else
libsuff			= $(x64suffix)
!endif

!if "$(ice_src_dist)" != ""
!if "$(THIRDPARTY_HOME)" != ""
CPPFLAGS        = -I"$(THIRDPARTY_HOME)\include" $(CPPFLAGS)
LDFLAGS         = $(PRELIBPATH)"$(THIRDPARTY_HOME)\lib$(libsuff)" $(LDFLAGS)
!endif
!else
!endif

!if "$(UNIQUE_DLL_NAMES)" == "yes"
!if "$(CPP_COMPILER)" == "VC100"
COMPSUFFIX	= _vc100
!elseif "$(CPP_COMPILER)" == "VC110"
COMPSUFFIX  = _vc110
!elseif "$(CPP_COMPILER)" == "VC120"
COMPSUFFIX  = _vc120
!elseif "$(CPP_COMPILER)" == "VC140"
COMPSUFFIX  = _vc140
!endif
!endif

!if "$(OPTIMIZE)" != "yes"
LIBSUFFIX	= d
RCFLAGS		= -nologo -D_DEBUG
!else
RCFLAGS         = -nologo
!endif

!if "$(WINRT)" != "yes"
ICEUTIL_OS_LIBS         = rpcrt4.lib advapi32.lib DbgHelp.lib
ICE_OS_LIBS             = advapi32.lib ws2_32.lib Iphlpapi.lib
SSL_OS_LIBS             = advapi32.lib secur32.lib crypt32.lib ws2_32.lib

BZIP2_LIBS              = libbz2$(LIBSUFFIX).lib
DB_LIBS                 = libdb53$(LIBSUFFIX).lib
!if "$(MCPP_HOME)" != ""
MCPP_LIBS               = $(MCPP_HOME)/mcpp$(LIBSUFFIX).lib
!else
MCPP_LIBS               = mcpp$(LIBSUFFIX).lib
!endif

EXPAT_LIBS              = libexpat.lib
!endif


CPPFLAGS		= $(CPPFLAGS) -I"$(includedir)"
ICECPPFLAGS		= -I"$(slicedir)"
SLICE2CPPFLAGS		= $(ICECPPFLAGS) $(SLICE2CPPFLAGS)
BISONFLAGS		= -dvt

!if "$(WINRT)" != "yes"
!if "$(ice_src_dist)" != ""
LDFLAGS			= $(LDFLAGS) $(PRELIBPATH)"$(libdir)"
!else
LDFLAGS			= $(LDFLAGS) $(PRELIBPATH)"$(ice_dir)\lib$(libsuff)"
!endif
!else
LDFLAGS			= $(LDFLAGS) $(PRELIBPATH)"$(SDK_LIBRARY_PATH)"
!endif

LDFLAGS			= $(LDFLAGS) $(LDPLATFORMFLAGS) $(CXXFLAGS)

!if "$(ice_src_dist)" != ""
SLICEPARSERLIB		= $(libdir)\slice$(LIBSUFFIX).lib
SLICE2CPP		= $(bindir)\slice2cpp.exe
SLICE2FREEZE		= $(bindir)\slice2freeze.exe
!else
SLICE2CPP		= $(ice_dir)\bin\slice2cpp.exe
SLICEPARSERLIB		= $(SLICE2CPP)
SLICE2FREEZE		= $(ice_dir)\bin\slice2freeze.exe
!endif

#
# In WinRT tests we don't want a dependency on SLICEPARSELIB, as we can build all
# test configurations using the same slice2cpp and slice.lib.
#
!if "$(WINRT)" == "yes"
SLICEPARSERLIB	= $(SLICE2CPP)
!endif

MT 			= mt.exe

EVERYTHING		= all clean install depend

EVERYTHING_EXCEPT_INSTALL = all clean depend

.SUFFIXES:
.SUFFIXES: .y .l .ice .cpp .c .obj .res .rc .h .d

DEPEND_DIR = .depend.mak
SLICE_DEPEND_DIR = .depend.mak\slice

depend::


!if "$(WINRT)" != "yes"

!if "$(SLICE_OBJS)" != "" || "$(OBJS)" != ""
depend::
	@del /q .depend.mak
!endif

!if "$(SLICE_OBJS)" != ""
SLICE_SRCS = $(SLICE_OBJS:.obj=.cpp)
SLICE_SRCS = $(SLICE_SRCS:.\=)

$(SLICE_SRCS): "$(SLICE2CPP)" "$(SLICEPARSERLIB)"

all:: $(SLICE_SRCS)

SLICE_OBJS_DEPEND = $(SLICE_OBJS:.obj=.d)
SLICE_OBJS_DEPEND = $(SLICE_OBJS_DEPEND:.\=.depend.mak\slice\)
depend:: $(SLICE_SRCS) $(SLICE_OBJS_DEPEND)
!endif

!if "$(BISON_FLEX_OBJS)" != ""
BISON_FLEX_SRCS = $(BISON_FLEX_OBJS:.obj=.cpp)
BISON_FLEX_SRCS = $(BISON_FLEX_SRCS:.\=)

all:: $(BISON_FLEX_SRCS)

!endif

!if "$(OBJS)" != ""
all::$(OBJS:.obj=.cpp)
OBJS_DEPEND = $(OBJS:.obj=.d)
OBJS_DEPEND = $(OBJS_DEPEND:.\=.depend.mak\)
depend:: $(OBJS:.obj=.cpp) $(RC_SRCS:.rc=.h) $(OBJS_DEPEND)
!endif

.cpp{$(DEPEND_DIR)}.d:
	@echo Generating dependencies for $<
	@$(CXX) /E $(CPPFLAGS) $(CXXFLAGS) /showIncludes $< 1>$(*F).i 2>$(*F).d && \
	cscript /NoLogo $(top_srcdir)\..\config\makedepend.vbs $(*F).cpp $(top_srcdir)
	@del /q $(*F).d $(*F).i

{$(SDIR)\}.ice{$(SLICE_DEPEND_DIR)\}.d:
	@echo Generating dependencies for $<
	@"$(SLICE2CPP)" $(SLICE2CPPFLAGS) --depend $< | cscript /NoLogo $(top_srcdir)\..\config\makedepend-slice.vbs $(*F).ice

.ice{$(SLICE_DEPEND_DIR)\}.d:
	@echo Generating dependencies for $<
	@"$(SLICE2CPP)" $(SLICE2CPPFLAGS) --depend $(*F).ice | cscript /NoLogo $(top_srcdir)\..\config\makedepend-slice.vbs $(*F).ice

.cpp.obj::
	$(CXX) /c $(CPPFLAGS) $(CXXFLAGS) $<

.c.obj:
	$(CC) /c $(CPPFLAGS) $(CFLAGS) $<

{$(SDIR)\}.ice{$(HDIR)\}.h:
	del /q $(HDIR)\$(*F).h $(*F).cpp
	"$(SLICE2CPP)" $(SLICE2CPPFLAGS) $<
	move $(*F).h $(HDIR)

{$(SDIR)\}.ice.cpp:
	del /q $(HDIR)\$(*F).h $(*F).cpp
	"$(SLICE2CPP)" $(SLICE2CPPFLAGS) $<
	move $(*F).h $(HDIR)

.ice.cpp:
	del /q $(*F).h $(*F).cpp
	"$(SLICE2CPP)" $(SLICE2CPPFLAGS) $(*F).ice


!if "$(BISON_FLEX)" == "yes"
.y.cpp:
	del /q $(*F).h $(*F).cpp
	bison $(BISONFLAGS) $<
	move $(*F).tab.c $(*F).cpp
	move $(*F).tab.h $(*F).h
	del /q $(*F).output

.l.cpp:
	flex $<
	del /q $@
	echo #include "IceUtil/ScannerConfig.h" >> $(*F).cpp
	type lex.yy.c >> $@
	del /q lex.yy.c
!endif

!else

!if "$(SLICE_SRCS)" != "" || "$(SRCS)" != ""
depend::
	@del /q .depend.mak
!endif

!if "$(SLICE_SRCS)" != ""
depend:: $(SLICE_SRCS:.ice=.d)
!else

!if "$(SLICE_OBJS)" != ""
SLICE_SRCS = $(SLICE_OBJS:.obj=.cpp)
SLICE_SRCS = $(SLICE_SRCS:winrt\=)
SLICE_SRCS = $(SLICE_SRCS:.\=)
all:: $(SLICE_SRCS)
!endif

!endif

!if "$(SRCS)" != ""
OBJS_DEPEND = $(SRCS:.cpp=.d)
OBJS_DEPEND = $(OBJS_DEPEND:..\..\=.depend.mak\)
OBJS_DEPEND = $(OBJS_DEPEND:..\=.depend.mak\)
depend:: $(SRCS) $(OBJS_DEPEND)
!endif

{..}.cpp{$(DEPEND_DIR)}.d:
	@if not exist "$(ARCH)\$(CONFIG)" mkdir $(ARCH)\$(CONFIG)
	@echo Generating dependencies for $<
	@$(CXX) /E /Fo$(ARCH)\$(CONFIG)\ $(CPPFLAGS) $(CXXFLAGS) /showIncludes $< 1>$(*F).i 2>$(*F).d && \
	cscript /NoLogo $(top_srcdir)\..\config\makedepend.vbs $< $(top_srcdir)
	@del /q $(*F).d $(*F).i

{..}.cpp{$(ARCH)\$(CONFIG)\}.obj::
	@if not exist "$(ARCH)\$(CONFIG)" mkdir $(ARCH)\$(CONFIG)
	$(CXX) /c /Fo$(ARCH)\$(CONFIG)\ $(CPPFLAGS) $(CXXFLAGS) $<

.cpp{$(OBJDIR)\}.obj::
	@if not exist "$(OBJDIR)" mkdir $(OBJDIR)
	$(CXX) /c /Fd$(OBJDIR)\ /Fo$(OBJDIR)\ $(CPPFLAGS) $(CXXFLAGS) $<

{$(slicedir)\Glacier2\}.ice{Glacier2\}.d:
	@echo Generating dependencies for $<
	@"$(SLICE2CPP)" $(SLICE2CPPFLAGS) --depend $< | cscript /NoLogo $(top_srcdir)\..\config\makedepend-slice.vbs $(*F).ice "..\"

{$(slicedir)\IceStorm\}.ice{IceStorm\}.d:
	@echo Generating dependencies for $<
	@"$(SLICE2CPP)" $(SLICE2CPPFLAGS) --depend $< | cscript /NoLogo $(top_srcdir)\..\config\makedepend-slice.vbs $(*F).ice "..\"

{$(slicedir)\IceGrid\}.ice{IceGrid\}.d:
	@echo Generating dependencies for $<
	@"$(SLICE2CPP)" $(SLICE2CPPFLAGS) --depend $< | cscript /NoLogo $(top_srcdir)\..\config\makedepend-slice.vbs $(*F).ice "..\"

{$(SDIR)\}.ice{..}.cpp:
	del /q $(HDIR)\$(*F).h ..\$(*F).cpp
	"$(SLICE2CPP)" $(SLICE2CPPFLAGS) $<
	move $(*F).h $(HDIR)
	move $(*F).cpp ..

{$(SDIR)\}.ice{$(HDIR)}.h:
	del /q $(HDIR)\$(*F).h ..\$(*F).cpp
	"$(SLICE2CPP)" $(SLICE2CPPFLAGS) $<
	move $(*F).h $(HDIR)
	move $(*F).cpp ..

.ice.cpp:
	del /q $(*F).h $(*F).cpp
	"$(SLICE2CPP)" $(SLICE2CPPFLAGS) $(*F).ice

!if "$(BISON_FLEX)" == "yes"
.y.cpp:
	del /q $(*F).h $(*F).cpp
	bison $(BISONFLAGS) $<
	move $(*F).tab.c $(*F).cpp
	move $(*F).tab.h $(*F).h
	del /q $(*F).output

.l.cpp:
	flex $<
	del /q $@
	echo #include "IceUtil/ScannerConfig.h" >> $(*F).cpp
	type lex.yy.c >> $@
	del /q lex.yy.c
!endif

!if "$(INCLUDE_DIR)" != ""
.h{$(SDK_INCLUDE_PATH)\$(INCLUDE_DIR)\}.h:
	copy $(*F).h $(SDK_INCLUDE_PATH)\$(INCLUDE_DIR)

$(SDK_INCLUDE_PATH)\$(INCLUDE_DIR):
	mkdir $(SDK_INCLUDE_PATH)\$(INCLUDE_DIR)

all:: $(SDK_INCLUDE_PATH)\$(INCLUDE_DIR)
!endif

!endif

!if exist(.depend.mak)
!include .depend.mak
!endif

.rc.res:
	rc $(RCFLAGS) $<


all:: $(TARGETS)

!if "$(TARGETS)" != ""

clean::
	-del /q $(TARGETS)

!endif

!if "$(WINRT)" != "yes"

# Suffix set, we're using a debug build.
!if "$(LIBSUFFIX)" != ""

!if "$(LIBNAME)" != ""
clean::
	-del /q $(LIBNAME:d.lib=.lib)
	-del /q $(LIBNAME)
!endif
!if "$(DLLNAME)" != ""
clean::
	-del /q $(DLLNAME:d.dll=.*)
	-del /q $(DLLNAME:.dll=.*)
!endif

!else

!if "$(LIBNAME)" != ""
clean::
	-del /q $(LIBNAME:.lib=d.lib)
	-del /q $(LIBNAME)
!endif
!if "$(DLLNAME)" != ""
clean::
	-del /q $(DLLNAME:.dll=d.*)
	-del /q $(DLLNAME:.dll=.*)
!endif

!endif

!endif

!if "$(OBJDIR)" == ""
clean::
	-del /q *.obj *.bak *.ilk *.exp *.pdb *.tds *.idb
!else
clean::
	-del /q $(OBJDIR)\*.obj $(OBJDIR)\*.bak $(OBJDIR)\*.ilk $(OBJDIR)\*.exp $(OBJDIR)\*.pdb $(OBJDIR)\*.tds $(OBJDIR)\*.idb
!endif

install::

depend::
