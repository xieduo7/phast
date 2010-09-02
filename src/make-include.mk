###########################################################################
# this file defines variables used by all Makefiles
###########################################################################

# set below to point to top-level directory of PHAST installation
ifndef PHAST
PHAST=${HOME}/phast
endif
# (if you prefer, you can set the environment variable PHAST instead)

# specify alternative compiler or utilities if necessary
CC = gcc
AR = ar
# Enable this CC and AR for windows builds
#CC = /usr/bin/i586-mingw32msvc-gcc
#AR = /usr/bin/i586-mingw32msvc-ar
LN = ln

LIB = ${PHAST}/lib
INC = ${PHAST}/include
BIN = ${PHAST}/bin

TARGETLIB = ${LIB}/libphast.a

# set compiler options; uncomment one of the lines below or define
# an appropriate alternative

# for debugging
#CFLAGS = -g -fno-inline
# for best performance
CFLAGS = -O3
# use this CFLAGS for windows builds
#CFLAGS = -O3
# some other options
#CFLAGS = -mcpu=opteron -O3
#CFLAGS = -mcpu=pentiumpro -O3 


PHAST_VERSION=\"$(shell cat ${PHAST}/version)\"
CFLAGS += -I${INC} -DPHAST_VERSION=${PHAST_VERSION} -DPHAST_HOME=\"${PHAST}\" -I${PHAST}/src/lib/pcre
LIBPATH = -L${LIB} 

# uncomment these lines for profiling (add -g for line-by-line
# profiling and -a for monitoring of basic blocks)
#CFLAGS += -pg

# this flag tells certain routines to dump internal, debugging output.
# Don't uncomment unless you know what you're doing.
#CFLAGS += -DDEBUG

# ignore the section below if installing RPHAST
ifndef RPHAST

# the following line should be uncommented during phast development
# to make sure RPHAST C files stay up-to-date.
# Not necessary for installing phast or RPHAST.
#RPHAST = T
ifdef RPHAST
RDIR=/usr/share/R/include
CFLAGS += -fPIC -I${RDIR}
endif
endif

# The next section is concerned with the LAPACK linear algebra
# package, which is used by PHAST for matrix diagonalization and
# matrix inversion.  You have two options: (1) If you are running Mac
# OS version 10.3 (Panther) or later, you can use the LAPACK libraries
# that are pre-installed as part of the vecLib framework; or (2) you
# can separately install the CLAPACK package and use its libraries
# (see README.txt for details).  You can also bypass LAPACK
# altogether, but in this case several key programs (including
# phastCons, exoniphy, and phyloFit) will not be usable.

# vecLib on Mac OS X; uncomment to use
#VECLIB = T

# separately installed CLAPACK; uncomment CLAPACKPATH definition and
# set appropriately to use
CLAPACKPATH = /usr/local/software/CLAPACK
# for windows use the pre-compiled clapack libraries bundled with phast
#CLAPACKPATH = ${PHAST}/src/lib/clapack/windows
# platform-specific suffix used for CLAPACK libraries; use the same
# value as in CLAPACK's "make.inc" file 
PLAT = _x86
# PLAT is empty for windows builds
#PLAT = 
# F2C libraries used by CLAPACK; most users won't need to edit
F2CPATH = ${CLAPACKPATH}/F2CLIBS


# if neither VECLIB nor CLAPACKPATH is defined, then LAPACK will be
# bypassed altogether


# Most users shouldn't edit the lines below (but see note about older
# versions of CLAPACK)

# vecLib
ifdef VECLIB
CFLAGS += -DVECLIB
LIBS = -lphast -framework vecLib -lc -lm

# CLAPACK
else
ifdef CLAPACKPATH
CFLAGS += -I${CLAPACKPATH}/INCLUDE -I${F2CPATH}
LIBS = -lphast -llapack -ltmg -lblaswr -lc -lf2c -lm
# Use the following CFLAGS and LIBS for windows build
#CFLAGS += -I${CLAPACKPATH}/INCLUDE -I${F2CPATH} -DPCRE_STATIC
#LIBS = -lphast -lm  ${CLAPACKPATH}/liblapack.a ${CLAPACKPATH}/libf2c.a ${CLAPACKPATH}/libblas.a
# IMPORTANT: use the following two lines instead for versions of CLAPACK
# older than 3.1.1
#CFLAGS += -I${CLAPACKPATH} -I${F2CPATH}
#LIBS = -lphast -llapack -ltmg -lblaswr -lc -lF77 -lI77 -lm
LIBPATH += -L${F2CPATH} 

# bypass
else
CFLAGS += -DSKIP_LAPACK
LIBS = -lphast -lc -lm
# Use the following CFLAGS and LIBS for windows build
#CFLAGS += -DSKIP_LAPACK -DPCRE_STATIC
#LIBS = -lphast -lm  
endif
endif

