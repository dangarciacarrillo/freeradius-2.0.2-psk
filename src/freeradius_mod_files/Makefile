#
# $Id: Makefile,v 1.2 2007/12/18 08:15:11 aland Exp $
#

#
#  This module is EXPERIMENTAL!
#

#
#  You will have to edit this Makefile to define where the
#  hostap distribution is located.
#
#  You will also have to edit: hostap/eap_example/Makefile
#  to enable it to create a shared library, rather than a static one.
#


HOSTAP	    = /src/hostapd

TARGET      = rlm_eap2
SRCS        = rlm_eap2.c
HEADERS     =
RLM_CFLAGS  = $(INCLTDL) -I$(HOSTAP)/src/eap_common \
	      -I$(HOSTAP)/src/eap_server  -I$(HOSTAP)/src  \
	      -I$(HOSTAP)/src/common -I$(HOSTAP)/src/utils
RLM_LIBS    = $(HOSTAP)/eap_example/libeap.so

## this uses the RLM_CFLAGS and RLM_LIBS and SRCS defs to make TARGET.
include ../rules.mak
