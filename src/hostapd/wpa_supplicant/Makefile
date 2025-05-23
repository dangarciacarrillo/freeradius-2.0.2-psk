ifndef CC
CC=gcc
endif

ifndef CFLAGS
CFLAGS = -MMD -O2 -Wall -g
endif

CFLAGS += -I../src
CFLAGS += -I../src/crypto
CFLAGS += -I../src/utils
CFLAGS += -I../src/common
CFLAGS += -I../src/rsn_supp

ALL=wpa_supplicant wpa_passphrase wpa_cli

all: verify_config $(ALL) dynamic_eap_methods

verify_config:
	@if [ ! -r .config ]; then \
		echo 'Building wpa_supplicant requires a configuration file'; \
		echo '(.config). See README for more instructions. You can'; \
		echo 'run "cp defconfig .config" to create an example'; \
		echo 'configuration.'; \
		exit 1; \
	fi

mkconfig:
	@if [ -e .config ]; then \
		echo '.config exists - did not replace it'; \
		exit 1; \
	fi
	echo CONFIG_DRIVER_HOSTAP=y >> .config
	echo CONFIG_DRIVER_WEXT=y >> .config
	echo CONFIG_WIRELESS_EXTENSION=y >> .config

install: all
	mkdir -p $(DESTDIR)/usr/local/sbin/
	for i in $(ALL); do cp $$i $(DESTDIR)/usr/local/sbin/$$i; done

OBJS = config.o
OBJS += ../src/utils/common.o
OBJS += ../src/utils/wpa_debug.o
OBJS += ../src/utils/wpabuf.o
OBJS += ../src/crypto/md5.o
OBJS += ../src/crypto/rc4.o
OBJS += ../src/crypto/md4.o
OBJS += ../src/crypto/sha1.o
OBJS += ../src/crypto/des.o
OBJS_p = wpa_passphrase.o
OBJS_p += ../src/utils/common.o
OBJS_p += ../src/utils/wpa_debug.o
OBJS_p += ../src/crypto/md5.o
OBJS_p += ../src/crypto/md4.o
OBJS_p += ../src/crypto/sha1.o
OBJS_p += ../src/crypto/des.o
OBJS_c = wpa_cli.o ../src/common/wpa_ctrl.o

-include .config

ifndef CONFIG_OS
ifdef CONFIG_NATIVE_WINDOWS
CONFIG_OS=win32
else
CONFIG_OS=unix
endif
endif

ifeq ($(CONFIG_OS), internal)
CFLAGS += -DOS_NO_C_LIB_DEFINES
endif

OBJS += ../src/utils/os_$(CONFIG_OS).o
OBJS_p += ../src/utils/os_$(CONFIG_OS).o
OBJS_c += ../src/utils/os_$(CONFIG_OS).o

ifndef CONFIG_ELOOP
CONFIG_ELOOP=eloop
endif
OBJS += ../src/utils/$(CONFIG_ELOOP).o


ifdef CONFIG_EAPOL_TEST
CFLAGS += -Werror -DEAPOL_TEST
endif

ifndef CONFIG_BACKEND
CONFIG_BACKEND=file
endif

ifeq ($(CONFIG_BACKEND), file)
OBJS += config_file.o
ifndef CONFIG_NO_CONFIG_BLOBS
NEED_BASE64=y
endif
CFLAGS += -DCONFIG_BACKEND_FILE
endif

ifeq ($(CONFIG_BACKEND), winreg)
OBJS += config_winreg.o
endif

ifeq ($(CONFIG_BACKEND), none)
OBJS += config_none.o
endif

ifdef CONFIG_NO_CONFIG_WRITE
CFLAGS += -DCONFIG_NO_CONFIG_WRITE
endif

ifdef CONFIG_NO_CONFIG_BLOBS
CFLAGS += -DCONFIG_NO_CONFIG_BLOBS
endif

ifdef CONFIG_NO_SCAN_PROCESSING
CFLAGS += -DCONFIG_NO_SCAN_PROCESSING
endif

ifdef CONFIG_DRIVER_HOSTAP
CFLAGS += -DCONFIG_DRIVER_HOSTAP
OBJS_d += ../src/drivers/driver_hostap.o
CONFIG_WIRELESS_EXTENSION=y
endif

ifdef CONFIG_DRIVER_WEXT
CFLAGS += -DCONFIG_DRIVER_WEXT
CONFIG_WIRELESS_EXTENSION=y
endif

ifdef CONFIG_DRIVER_NL80211
CFLAGS += -DCONFIG_DRIVER_NL80211
OBJS_d += ../src/drivers/driver_nl80211.o
LIBS += -lnl
ifdef CONFIG_CLIENT_MLME
OBJS_d += ../src/drivers/radiotap.o
endif
endif

ifdef CONFIG_DRIVER_PRISM54
CFLAGS += -DCONFIG_DRIVER_PRISM54
OBJS_d += ../src/drivers/driver_prism54.o
CONFIG_WIRELESS_EXTENSION=y
endif

ifdef CONFIG_DRIVER_HERMES
CFLAGS += -DCONFIG_DRIVER_HERMES
OBJS_d += ../src/drivers/driver_hermes.o
CONFIG_WIRELESS_EXTENSION=y
endif

ifdef CONFIG_DRIVER_MADWIFI
CFLAGS += -DCONFIG_DRIVER_MADWIFI
OBJS_d += ../src/drivers/driver_madwifi.o
CONFIG_WIRELESS_EXTENSION=y
endif

ifdef CONFIG_DRIVER_ATMEL
CFLAGS += -DCONFIG_DRIVER_ATMEL
OBJS_d += ../src/drivers/driver_atmel.o
CONFIG_WIRELESS_EXTENSION=y
endif

ifdef CONFIG_DRIVER_NDISWRAPPER
CFLAGS += -DCONFIG_DRIVER_NDISWRAPPER
OBJS_d += ../src/drivers/driver_ndiswrapper.o
CONFIG_WIRELESS_EXTENSION=y
endif

ifdef CONFIG_DRIVER_RALINK
CFLAGS += -DCONFIG_DRIVER_RALINK
OBJS_d += ../src/drivers/driver_ralink.o
endif

ifdef CONFIG_DRIVER_BROADCOM
CFLAGS += -DCONFIG_DRIVER_BROADCOM
OBJS_d += ../src/drivers/driver_broadcom.o
endif

ifdef CONFIG_DRIVER_IPW
CFLAGS += -DCONFIG_DRIVER_IPW
OBJS_d += ../src/drivers/driver_ipw.o
CONFIG_WIRELESS_EXTENSION=y
endif

ifdef CONFIG_DRIVER_BSD
CFLAGS += -DCONFIG_DRIVER_BSD
OBJS_d += ../src/drivers/driver_bsd.o
ifndef CONFIG_L2_PACKET
CONFIG_L2_PACKET=freebsd
endif
endif

ifdef CONFIG_DRIVER_NDIS
CFLAGS += -DCONFIG_DRIVER_NDIS
OBJS_d += ../src/drivers/driver_ndis.o
ifdef CONFIG_NDIS_EVENTS_INTEGRATED
OBJS_d += ../src/drivers/driver_ndis_.o
endif
ifndef CONFIG_L2_PACKET
CONFIG_L2_PACKET=pcap
endif
CONFIG_WINPCAP=y
ifdef CONFIG_USE_NDISUIO
CFLAGS += -DCONFIG_USE_NDISUIO
endif
endif

ifdef CONFIG_DRIVER_WIRED
CFLAGS += -DCONFIG_DRIVER_WIRED
OBJS_d += ../src/drivers/driver_wired.o
endif

ifdef CONFIG_DRIVER_TEST
CFLAGS += -DCONFIG_DRIVER_TEST
OBJS_d += ../src/drivers/driver_test.o
endif

ifdef CONFIG_DRIVER_OSX
CFLAGS += -DCONFIG_DRIVER_OSX
OBJS_d += ../src/drivers/driver_osx.o
LDFLAGS += -framework CoreFoundation
LDFLAGS += -F/System/Library/PrivateFrameworks -framework Apple80211
endif

ifdef CONFIG_DRIVER_PS3
CFLAGS += -DCONFIG_DRIVER_PS3 -m64
OBJS_d += ../src/drivers/driver_ps3.o
LDFLAGS += -m64
endif

ifdef CONFIG_DRIVER_IPHONE
CFLAGS += -DCONFIG_DRIVER_IPHONE
OBJS_d += ../src/drivers/driver_iphone.o
OBJS_d += ../src/drivers/MobileApple80211.o
LIBS += -framework CoreFoundation
endif

ifdef CONFIG_DRIVER_ROBOSWITCH
CFLAGS += -DCONFIG_DRIVER_ROBOSWITCH
OBJS_d += ../src/drivers/driver_roboswitch.o
endif

ifndef CONFIG_L2_PACKET
CONFIG_L2_PACKET=linux
endif

OBJS_l2 += ../src/l2_packet/l2_packet_$(CONFIG_L2_PACKET).o

ifeq ($(CONFIG_L2_PACKET), pcap)
ifdef CONFIG_WINPCAP
CFLAGS += -DCONFIG_WINPCAP
LIBS += -lwpcap -lpacket
LIBS_w += -lwpcap
else
LIBS += -ldnet -lpcap
endif
endif

ifeq ($(CONFIG_L2_PACKET), winpcap)
LIBS += -lwpcap -lpacket
LIBS_w += -lwpcap
endif

ifeq ($(CONFIG_L2_PACKET), freebsd)
LIBS += -lpcap
endif

ifdef CONFIG_EAP_TLS
# EAP-TLS
ifeq ($(CONFIG_EAP_TLS), dyn)
CFLAGS += -DEAP_TLS_DYNAMIC
EAPDYN += ../src/eap_peer/eap_tls.so
else
CFLAGS += -DEAP_TLS
OBJS += ../src/eap_peer/eap_tls.o
OBJS_h += ../src/eap_server/eap_tls.o
endif
TLS_FUNCS=y
CONFIG_IEEE8021X_EAPOL=y
endif

ifdef CONFIG_EAP_PEAP
# EAP-PEAP
ifeq ($(CONFIG_EAP_PEAP), dyn)
CFLAGS += -DEAP_PEAP_DYNAMIC
EAPDYN += ../src/eap_peer/eap_peap.so
else
CFLAGS += -DEAP_PEAP
OBJS += ../src/eap_peer/eap_peap.o
OBJS += ../src/eap_common/eap_peap_common.o
OBJS_h += ../src/eap_server/eap_peap.o
endif
TLS_FUNCS=y
CONFIG_IEEE8021X_EAPOL=y
endif

ifdef CONFIG_EAP_TTLS
# EAP-TTLS
ifeq ($(CONFIG_EAP_TTLS), dyn)
CFLAGS += -DEAP_TTLS_DYNAMIC
EAPDYN += ../src/eap_peer/eap_ttls.so
else
CFLAGS += -DEAP_TTLS
OBJS += ../src/eap_peer/eap_ttls.o
OBJS_h += ../src/eap_server/eap_ttls.o
endif
MS_FUNCS=y
TLS_FUNCS=y
CHAP=y
CONFIG_IEEE8021X_EAPOL=y
endif

ifdef CONFIG_EAP_MD5
# EAP-MD5
ifeq ($(CONFIG_EAP_MD5), dyn)
CFLAGS += -DEAP_MD5_DYNAMIC
EAPDYN += ../src/eap_peer/eap_md5.so
else
CFLAGS += -DEAP_MD5
OBJS += ../src/eap_peer/eap_md5.o
OBJS_h += ../src/eap_server/eap_md5.o
endif
CHAP=y
CONFIG_IEEE8021X_EAPOL=y
endif

# backwards compatibility for old spelling
ifdef CONFIG_MSCHAPV2
ifndef CONFIG_EAP_MSCHAPV2
CONFIG_EAP_MSCHAPV2=y
endif
endif

ifdef CONFIG_EAP_MSCHAPV2
# EAP-MSCHAPv2
ifeq ($(CONFIG_EAP_MSCHAPV2), dyn)
CFLAGS += -DEAP_MSCHAPv2_DYNAMIC
EAPDYN += ../src/eap_peer/eap_mschapv2.so
EAPDYN += ../src/eap_peer/mschapv2.so
else
CFLAGS += -DEAP_MSCHAPv2
OBJS += ../src/eap_peer/eap_mschapv2.o
OBJS += ../src/eap_peer/mschapv2.o
OBJS_h += ../src/eap_server/eap_mschapv2.o
endif
MS_FUNCS=y
CONFIG_IEEE8021X_EAPOL=y
endif

ifdef CONFIG_EAP_GTC
# EAP-GTC
ifeq ($(CONFIG_EAP_GTC), dyn)
CFLAGS += -DEAP_GTC_DYNAMIC
EAPDYN += ../src/eap_peer/eap_gtc.so
else
CFLAGS += -DEAP_GTC
OBJS += ../src/eap_peer/eap_gtc.o
OBJS_h += ../src/eap_server/eap_gtc.o
endif
CONFIG_IEEE8021X_EAPOL=y
endif

ifdef CONFIG_EAP_OTP
# EAP-OTP
ifeq ($(CONFIG_EAP_OTP), dyn)
CFLAGS += -DEAP_OTP_DYNAMIC
EAPDYN += ../src/eap_peer/eap_otp.so
else
CFLAGS += -DEAP_OTP
OBJS += ../src/eap_peer/eap_otp.o
endif
CONFIG_IEEE8021X_EAPOL=y
endif

ifdef CONFIG_EAP_SIM
# EAP-SIM
ifeq ($(CONFIG_EAP_SIM), dyn)
CFLAGS += -DEAP_SIM_DYNAMIC
EAPDYN += ../src/eap_peer/eap_sim.so
else
CFLAGS += -DEAP_SIM
OBJS += ../src/eap_peer/eap_sim.o
OBJS_h += ../src/eap_server/eap_sim.o
endif
CONFIG_IEEE8021X_EAPOL=y
CONFIG_EAP_SIM_COMMON=y
endif

ifdef CONFIG_EAP_LEAP
# EAP-LEAP
ifeq ($(CONFIG_EAP_LEAP), dyn)
CFLAGS += -DEAP_LEAP_DYNAMIC
EAPDYN += ../src/eap_peer/eap_leap.so
else
CFLAGS += -DEAP_LEAP
OBJS += ../src/eap_peer/eap_leap.o
endif
MS_FUNCS=y
CONFIG_IEEE8021X_EAPOL=y
endif

ifdef CONFIG_EAP_PSK
# EAP-PSK
ifeq ($(CONFIG_EAP_PSK), dyn)
CFLAGS += -DEAP_PSK_DYNAMIC
EAPDYN += ../src/eap_peer/eap_psk.so
else
CFLAGS += -DEAP_PSK
OBJS += ../src/eap_peer/eap_psk.o ../src/eap_common/eap_psk_common.o
OBJS_h += ../src/eap_server/eap_psk.o
endif
CONFIG_IEEE8021X_EAPOL=y
NEED_AES=y
endif

ifdef CONFIG_EAP_AKA
# EAP-AKA
ifeq ($(CONFIG_EAP_AKA), dyn)
CFLAGS += -DEAP_AKA_DYNAMIC
EAPDYN += ../src/eap_peer/eap_aka.so
else
CFLAGS += -DEAP_AKA
OBJS += ../src/eap_peer/eap_aka.o
OBJS_h += ../src/eap_server/eap_aka.o
endif
CONFIG_IEEE8021X_EAPOL=y
CONFIG_EAP_SIM_COMMON=y
endif

ifdef CONFIG_EAP_SIM_COMMON
OBJS += ../src/eap_common/eap_sim_common.o
OBJS_h += ../src/eap_server/eap_sim_db.o
NEED_AES=y
NEED_FIPS186_2_PRF=y
endif

ifdef CONFIG_EAP_FAST
# EAP-FAST
ifeq ($(CONFIG_EAP_FAST), dyn)
CFLAGS += -DEAP_FAST_DYNAMIC
EAPDYN += ../src/eap_peer/eap_fast.so
EAPDYN += ../src/eap_common/eap_fast_common.o
else
CFLAGS += -DEAP_FAST
OBJS += ../src/eap_peer/eap_fast.o ../src/eap_peer/eap_fast_pac.o
OBJS += ../src/eap_common/eap_fast_common.o
OBJS_h += ../src/eap_server/eap_fast.o
endif
TLS_FUNCS=y
NEED_T_PRF=y
endif

ifdef CONFIG_EAP_PAX
# EAP-PAX
ifeq ($(CONFIG_EAP_PAX), dyn)
CFLAGS += -DEAP_PAX_DYNAMIC
EAPDYN += ../src/eap_peer/eap_pax.so
else
CFLAGS += -DEAP_PAX
OBJS += ../src/eap_peer/eap_pax.o ../src/eap_common/eap_pax_common.o
OBJS_h += ../src/eap_server/eap_pax.o
endif
CONFIG_IEEE8021X_EAPOL=y
endif

ifdef CONFIG_EAP_SAKE
# EAP-SAKE
ifeq ($(CONFIG_EAP_SAKE), dyn)
CFLAGS += -DEAP_SAKE_DYNAMIC
EAPDYN += ../src/eap_peer/eap_sake.so
else
CFLAGS += -DEAP_SAKE
OBJS += ../src/eap_peer/eap_sake.o ../src/eap_common/eap_sake_common.o
OBJS_h += ../src/eap_server/eap_sake.o
endif
CONFIG_IEEE8021X_EAPOL=y
endif

ifdef CONFIG_EAP_GPSK
# EAP-GPSK
ifeq ($(CONFIG_EAP_GPSK), dyn)
CFLAGS += -DEAP_GPSK_DYNAMIC
EAPDYN += ../src/eap_peer/eap_gpsk.so
else
CFLAGS += -DEAP_GPSK
OBJS += ../src/eap_peer/eap_gpsk.o ../src/eap_common/eap_gpsk_common.o
OBJS_h += ../src/eap_server/eap_gpsk.o
endif
CONFIG_IEEE8021X_EAPOL=y
ifdef CONFIG_EAP_GPSK_SHA256
CFLAGS += -DEAP_GPSK_SHA256
endif
NEED_SHA256=y
endif

ifdef CONFIG_WPS
# EAP-WSC
ifeq ($(CONFIG_EAP_WSC), dyn)
CFLAGS += -DCONFIG_WPS -DEAP_WSC_DYNAMIC
EAPDYN += ../src/eap_peer/eap_wsc.so
else
CFLAGS += -DCONFIG_WPS -DEAP_WSC
OBJS += ../src/utils/uuid.o
OBJS += ../src/eap_peer/eap_wsc.o ../src/eap_common/eap_wsc_common.o
OBJS += ../src/wps/wps.o
OBJS += ../src/wps/wps_common.o
OBJS += ../src/wps/wps_dev_attr.o
OBJS += ../src/wps/wps_enrollee.o
OBJS += ../src/wps/wps_registrar.o
OBJS_h += ../src/eap_server/eap_wsc.o
endif
CONFIG_IEEE8021X_EAPOL=y
NEED_DH_GROUPS=y
endif

ifdef CONFIG_EAP_IKEV2
# EAP-IKEv2
ifeq ($(CONFIG_EAP_IKEV2), dyn)
CFLAGS += -DEAP_IKEV2_DYNAMIC
EAPDYN += ../src/eap_peer/eap_ikev2.so ../src/eap_peer/ikev2.o
EAPDYN += ../src/eap_common/eap_ikev2_common.o ../src/eap_common/ikev2_common.o
else
CFLAGS += -DEAP_IKEV2
OBJS += ../src/eap_peer/eap_ikev2.o ../src/eap_peer/ikev2.o
OBJS += ../src/eap_common/eap_ikev2_common.o ../src/eap_common/ikev2_common.o
OBJS_h += ../src/eap_server/eap_ikev2.o
OBJS_h += ../src/eap_server/ikev2.o
endif
CONFIG_IEEE8021X_EAPOL=y
NEED_DH_GROUPS=y
endif

ifdef CONFIG_EAP_VENDOR_TEST
ifeq ($(CONFIG_EAP_VENDOR_TEST), dyn)
CFLAGS += -DEAP_VENDOR_TEST_DYNAMIC
EAPDYN += ../src/eap_peer/eap_vendor_test.so
else
CFLAGS += -DEAP_VENDOR_TEST
OBJS += ../src/eap_peer/eap_vendor_test.o
OBJS_h += ../src/eap_server/eap_vendor_test.o
endif
CONFIG_IEEE8021X_EAPOL=y
endif

ifdef CONFIG_EAP_TNC
# EAP-TNC
CFLAGS += -DEAP_TNC
OBJS += ../src/eap_peer/eap_tnc.o
OBJS += ../src/eap_peer/tncc.o
NEED_BASE64=y
endif

ifdef CONFIG_IEEE8021X_EAPOL
# IEEE 802.1X/EAPOL state machines (e.g., for RADIUS authentication)
CFLAGS += -DIEEE8021X_EAPOL
OBJS += ../src/eapol_supp/eapol_supp_sm.o ../src/eap_peer/eap.o ../src/eap_common/eap_common.o ../src/eap_peer/eap_methods.o
ifdef CONFIG_DYNAMIC_EAP_METHODS
CFLAGS += -DCONFIG_DYNAMIC_EAP_METHODS
LIBS += -ldl -rdynamic
endif
endif

ifdef CONFIG_EAP_SERVER
CFLAGS += -DEAP_SERVER
OBJS_h += ../src/eap_server/eap.o
OBJS_h += ../src/eap_server/eap_identity.o
OBJS_h += ../src/eap_server/eap_methods.o
endif

ifdef CONFIG_RADIUS_CLIENT
OBJS_h += ../src/utils/ip_addr.o
OBJS_h += ../src/radius/radius.o
OBJS_h += ../src/radius/radius_client.o
endif

ifdef CONFIG_AUTHENTICATOR
OBJS_h += ../hostapd/eapol_sm.o
OBJS_h += ../hostapd/ieee802_1x.o
endif

ifdef CONFIG_WPA_AUTHENTICATOR
OBJS_h += ../hostapd/wpa.o
OBJS_h += ../hostapd/wpa_auth_ie.o
ifdef CONFIG_IEEE80211R
OBJS_h += ../hostapd/wpa_ft.o
endif
ifdef CONFIG_PEERKEY
OBJS_h += ../hostapd/peerkey.o
endif
endif

ifdef CONFIG_PCSC
# PC/SC interface for smartcards (USIM, GSM SIM)
CFLAGS += -DPCSC_FUNCS -I/usr/include/PCSC
OBJS += ../src/utils/pcsc_funcs.o
# -lpthread may not be needed depending on how pcsc-lite was configured
ifdef CONFIG_NATIVE_WINDOWS
#Once MinGW gets support for WinScard, -lwinscard could be used instead of the
#dynamic symbol loading that is now used in pcsc_funcs.c
#LIBS += -lwinscard
else
LIBS += -lpcsclite -lpthread
endif
endif

ifdef CONFIG_SIM_SIMULATOR
CFLAGS += -DCONFIG_SIM_SIMULATOR
NEED_MILENAGE=y
endif

ifdef CONFIG_USIM_SIMULATOR
CFLAGS += -DCONFIG_USIM_SIMULATOR
NEED_MILENAGE=y
endif

ifdef NEED_MILENAGE
OBJS += ../src/hlr_auc_gw/milenage.o
endif

ifndef CONFIG_TLS
CONFIG_TLS=openssl
endif

ifeq ($(CONFIG_TLS), internal)
ifndef CONFIG_CRYPTO
CONFIG_CRYPTO=internal
endif
endif
ifeq ($(CONFIG_CRYPTO), libtomcrypt)
CFLAGS += -DCONFIG_INTERNAL_X509
endif
ifeq ($(CONFIG_CRYPTO), internal)
CFLAGS += -DCONFIG_INTERNAL_X509
endif


ifdef TLS_FUNCS
# Shared TLS functions (needed for EAP_TLS, EAP_PEAP, EAP_TTLS, and EAP_FAST)
CFLAGS += -DEAP_TLS_FUNCS
OBJS += ../src/eap_peer/eap_tls_common.o
OBJS_h += ../src/eap_server/eap_tls_common.o
NEED_TLS_PRF=y
ifeq ($(CONFIG_TLS), openssl)
CFLAGS += -DEAP_TLS_OPENSSL
OBJS += ../src/crypto/tls_openssl.o
LIBS += -lssl -lcrypto
LIBS_p += -lcrypto
endif
ifeq ($(CONFIG_TLS), gnutls)
OBJS += ../src/crypto/tls_gnutls.o
LIBS += -lgnutls -lgcrypt -lgpg-error
LIBS_p += -lgcrypt
ifdef CONFIG_GNUTLS_EXTRA
CFLAGS += -DCONFIG_GNUTLS_EXTRA
LIBS += -lgnutls-extra
endif
endif
ifeq ($(CONFIG_TLS), schannel)
OBJS += ../src/crypto/tls_schannel.o
endif
ifeq ($(CONFIG_TLS), internal)
OBJS += ../src/crypto/tls_internal.o
OBJS += ../src/tls/tlsv1_common.o ../src/tls/tlsv1_record.o
OBJS += ../src/tls/tlsv1_cred.o ../src/tls/tlsv1_client.o
OBJS += ../src/tls/tlsv1_client_write.o ../src/tls/tlsv1_client_read.o
OBJS += ../src/tls/asn1.o ../src/tls/x509v3.o
OBJS_p += ../src/tls/asn1.o
OBJS_p += ../src/crypto/rc4.o ../src/crypto/aes_wrap.o ../src/crypto/aes.o
NEED_BASE64=y
NEED_TLS_PRF=y
CFLAGS += -DCONFIG_TLS_INTERNAL
CFLAGS += -DCONFIG_TLS_INTERNAL_CLIENT
ifeq ($(CONFIG_CRYPTO), internal)
ifdef CONFIG_INTERNAL_LIBTOMMATH
CFLAGS += -DCONFIG_INTERNAL_LIBTOMMATH
ifdef CONFIG_INTERNAL_LIBTOMMATH_FAST
CFLAGS += -DLTM_FAST
endif
else
LIBS += -ltommath
LIBS_p += -ltommath
endif
endif
ifeq ($(CONFIG_CRYPTO), libtomcrypt)
LIBS += -ltomcrypt -ltfm
LIBS_p += -ltomcrypt -ltfm
endif
endif
ifeq ($(CONFIG_TLS), none)
OBJS += ../src/crypto/tls_none.o
CFLAGS += -DEAP_TLS_NONE
CONFIG_INTERNAL_AES=y
CONFIG_INTERNAL_SHA1=y
CONFIG_INTERNAL_MD5=y
CONFIG_INTERNAL_SHA256=y
endif
ifdef CONFIG_SMARTCARD
ifndef CONFIG_NATIVE_WINDOWS
ifneq ($(CONFIG_L2_PACKET), freebsd)
LIBS += -ldl
endif
endif
endif
NEED_CRYPTO=y
else
OBJS += ../src/crypto/tls_none.o
endif

ifdef CONFIG_PKCS12
CFLAGS += -DPKCS12_FUNCS
endif

ifdef CONFIG_SMARTCARD
CFLAGS += -DCONFIG_SMARTCARD
endif

ifdef MS_FUNCS
OBJS += ../src/crypto/ms_funcs.o
NEED_CRYPTO=y
endif

ifdef CHAP
OBJS += ../src/eap_common/chap.o
endif

ifdef NEED_CRYPTO
ifndef TLS_FUNCS
ifeq ($(CONFIG_TLS), openssl)
LIBS += -lcrypto
LIBS_p += -lcrypto
endif
ifeq ($(CONFIG_TLS), gnutls)
LIBS += -lgcrypt
LIBS_p += -lgcrypt
endif
ifeq ($(CONFIG_TLS), schannel)
endif
ifeq ($(CONFIG_TLS), internal)
ifeq ($(CONFIG_CRYPTO), libtomcrypt)
LIBS += -ltomcrypt -ltfm
LIBS_p += -ltomcrypt -ltfm
endif
endif
endif
ifeq ($(CONFIG_TLS), openssl)
OBJS += ../src/crypto/crypto_openssl.o
OBJS_p += ../src/crypto/crypto_openssl.o
CONFIG_INTERNAL_SHA256=y
endif
ifeq ($(CONFIG_TLS), gnutls)
OBJS += ../src/crypto/crypto_gnutls.o
OBJS_p += ../src/crypto/crypto_gnutls.o
CONFIG_INTERNAL_SHA256=y
endif
ifeq ($(CONFIG_TLS), schannel)
OBJS += ../src/crypto/crypto_cryptoapi.o
OBJS_p += ../src/crypto/crypto_cryptoapi.o
CONFIG_INTERNAL_SHA256=y
endif
ifeq ($(CONFIG_TLS), internal)
ifeq ($(CONFIG_CRYPTO), libtomcrypt)
OBJS += ../src/crypto/crypto_libtomcrypt.o
OBJS_p += ../src/crypto/crypto_libtomcrypt.o
CONFIG_INTERNAL_SHA256=y
endif
ifeq ($(CONFIG_CRYPTO), internal)
OBJS += ../src/crypto/crypto_internal.o ../src/tls/rsa.o ../src/tls/bignum.o
OBJS_p += ../src/crypto/crypto_internal.o ../src/tls/rsa.o ../src/tls/bignum.o
CFLAGS += -DCONFIG_CRYPTO_INTERNAL
CONFIG_INTERNAL_AES=y
CONFIG_INTERNAL_DES=y
CONFIG_INTERNAL_SHA1=y
CONFIG_INTERNAL_MD4=y
CONFIG_INTERNAL_MD5=y
CONFIG_INTERNAL_SHA256=y
endif
ifeq ($(CONFIG_CRYPTO), cryptoapi)
OBJS += ../src/crypto/crypto_cryptoapi.o
OBJS_p += ../src/crypto/crypto_cryptoapi.o
CFLAGS += -DCONFIG_CRYPTO_CRYPTOAPI
CONFIG_INTERNAL_SHA256=y
endif
endif
ifeq ($(CONFIG_TLS), none)
OBJS += ../src/crypto/crypto_none.o
OBJS_p += ../src/crypto/crypto_none.o
CONFIG_INTERNAL_SHA256=y
endif
else
CONFIG_INTERNAL_AES=y
CONFIG_INTERNAL_SHA1=y
CONFIG_INTERNAL_MD5=y
endif

ifdef CONFIG_INTERNAL_AES
CFLAGS += -DINTERNAL_AES
endif
ifdef CONFIG_INTERNAL_SHA1
CFLAGS += -DINTERNAL_SHA1
endif
ifdef CONFIG_INTERNAL_SHA256
CFLAGS += -DINTERNAL_SHA256
endif
ifdef CONFIG_INTERNAL_MD5
CFLAGS += -DINTERNAL_MD5
endif
ifdef CONFIG_INTERNAL_MD4
CFLAGS += -DINTERNAL_MD4
endif
ifdef CONFIG_INTERNAL_DES
CFLAGS += -DINTERNAL_DES
endif

ifdef CONFIG_IEEE80211R
NEED_SHA256=y
endif

ifdef CONFIG_IEEE80211W
CFLAGS += -DCONFIG_IEEE80211W
NEED_SHA256=y
endif

ifdef NEED_SHA256
OBJS += ../src/crypto/sha256.o
CFLAGS += -DNEED_SHA256
endif

ifdef CONFIG_WIRELESS_EXTENSION
CFLAGS += -DCONFIG_WIRELESS_EXTENSION
OBJS_d += ../src/drivers/driver_wext.o
endif

ifdef CONFIG_CTRL_IFACE
ifeq ($(CONFIG_CTRL_IFACE), y)
ifdef CONFIG_NATIVE_WINDOWS
CONFIG_CTRL_IFACE=named_pipe
else
CONFIG_CTRL_IFACE=unix
endif
endif
CFLAGS += -DCONFIG_CTRL_IFACE
ifeq ($(CONFIG_CTRL_IFACE), unix)
CFLAGS += -DCONFIG_CTRL_IFACE_UNIX
endif
ifeq ($(CONFIG_CTRL_IFACE), udp)
CFLAGS += -DCONFIG_CTRL_IFACE_UDP
endif
ifeq ($(CONFIG_CTRL_IFACE), named_pipe)
CFLAGS += -DCONFIG_CTRL_IFACE_NAMED_PIPE
endif
OBJS += ctrl_iface.o ctrl_iface_$(CONFIG_CTRL_IFACE).o
endif

ifdef CONFIG_CTRL_IFACE_DBUS
CFLAGS += -DCONFIG_CTRL_IFACE_DBUS -DDBUS_API_SUBJECT_TO_CHANGE
OBJS += ctrl_iface_dbus.o ctrl_iface_dbus_handlers.o dbus_dict_helpers.o
ifndef DBUS_LIBS
DBUS_LIBS := $(shell pkg-config --libs dbus-1)
endif
LIBS += $(DBUS_LIBS)
ifndef DBUS_INCLUDE
DBUS_INCLUDE := $(shell pkg-config --cflags dbus-1)
endif
dbus_version=$(subst ., ,$(shell pkg-config --modversion dbus-1))
DBUS_VERSION_MAJOR=$(word 1,$(dbus_version))
DBUS_VERSION_MINOR=$(word 2,$(dbus_version))
ifeq ($(DBUS_VERSION_MAJOR),)
DBUS_VERSION_MAJOR=0
endif
ifeq ($(DBUS_VERSION_MINOR),)
DBUS_VERSION_MINOR=0
endif
DBUS_INCLUDE += -DDBUS_VERSION_MAJOR=$(DBUS_VERSION_MAJOR)
DBUS_INCLUDE += -DDBUS_VERSION_MINOR=$(DBUS_VERSION_MINOR)
CFLAGS += $(DBUS_INCLUDE)
endif

ifdef CONFIG_READLINE
CFLAGS += -DCONFIG_READLINE
LIBS_c += -lncurses -lreadline
endif

ifdef CONFIG_NATIVE_WINDOWS
CFLAGS += -DCONFIG_NATIVE_WINDOWS
LIBS += -lws2_32 -lgdi32 -lcrypt32
LIBS_c += -lws2_32
LIBS_p += -lws2_32 -lgdi32
ifeq ($(CONFIG_CRYPTO), cryptoapi)
LIBS_p += -lcrypt32
endif
endif

ifdef CONFIG_NO_STDOUT_DEBUG
CFLAGS += -DCONFIG_NO_STDOUT_DEBUG
ifndef CONFIG_CTRL_IFACE
CFLAGS += -DCONFIG_NO_WPA_MSG
endif
endif

ifdef CONFIG_IPV6
# for eapol_test only
CFLAGS += -DCONFIG_IPV6
endif

ifdef CONFIG_PEERKEY
CFLAGS += -DCONFIG_PEERKEY
endif

ifdef CONFIG_IEEE80211R
CFLAGS += -DCONFIG_IEEE80211R
OBJS += ../src/rsn_supp/wpa_ft.o
endif

ifndef CONFIG_NO_WPA
OBJS += ../src/rsn_supp/wpa.o
OBJS += ../src/rsn_supp/preauth.o
OBJS += ../src/rsn_supp/pmksa_cache.o
OBJS += ../src/rsn_supp/peerkey.o
OBJS += ../src/rsn_supp/wpa_ie.o
OBJS += ../src/common/wpa_common.o
NEED_AES=y
else
CFLAGS += -DCONFIG_NO_WPA -DCONFIG_NO_WPA2
endif

ifdef CONFIG_NO_WPA2
CFLAGS += -DCONFIG_NO_WPA2
endif

ifdef CONFIG_NO_WPA_PASSPHRASE
CFLAGS += -DCONFIG_NO_PBKDF2
endif

ifdef CONFIG_NO_AES_EXTRAS
CFLAGS += -DCONFIG_NO_AES_WRAP
CFLAGS += -DCONFIG_NO_AES_CTR -DCONFIG_NO_AES_OMAC1
CFLAGS += -DCONFIG_NO_AES_EAX -DCONFIG_NO_AES_CBC
CFLAGS += -DCONFIG_NO_AES_ENCRYPT
CFLAGS += -DCONFIG_NO_AES_ENCRYPT_BLOCK
endif

ifdef NEED_AES
OBJS += ../src/crypto/aes_wrap.o ../src/crypto/aes.o
endif

ifdef NEED_DH_GROUPS
OBJS += ../src/crypto/dh_groups.o
endif

ifndef NEED_FIPS186_2_PRF
CFLAGS += -DCONFIG_NO_FIPS186_2_PRF
endif

ifndef NEED_T_PRF
CFLAGS += -DCONFIG_NO_T_PRF
endif

ifndef NEED_TLS_PRF
CFLAGS += -DCONFIG_NO_TLS_PRF
endif

ifdef NEED_BASE64
OBJS += ../src/utils/base64.o
endif

ifdef CONFIG_CLIENT_MLME
OBJS += mlme.o ../src/common/ieee802_11_common.o
CFLAGS += -DCONFIG_CLIENT_MLME
endif

ifndef CONFIG_MAIN
CONFIG_MAIN=main
endif

ifdef CONFIG_DEBUG_FILE
CFLAGS += -DCONFIG_DEBUG_FILE
endif

ifdef CONFIG_DELAYED_MIC_ERROR_REPORT
CFLAGS += -DCONFIG_DELAYED_MIC_ERROR_REPORT
endif

OBJS += ../src/drivers/scan_helpers.o

OBJS_wpa_rm := ctrl_iface.o mlme.o ctrl_iface_unix.o
OBJS_wpa := $(filter-out $(OBJS_wpa_rm),$(OBJS)) $(OBJS_h) tests/test_wpa.o
ifdef CONFIG_AUTHENTICATOR
OBJS_wpa += tests/link_test.o
endif
OBJS_wpa += $(OBJS_l2)
OBJS += wpa_supplicant.o events.o blacklist.o wpas_glue.o scan.o
OBJS_t := $(OBJS) $(OBJS_l2) eapol_test.o ../src/radius/radius.o ../src/radius/radius_client.o
OBJS_t += ../src/utils/ip_addr.o
OBJS_t2 := $(OBJS) $(OBJS_l2) preauth_test.o
OBJS += $(CONFIG_MAIN).o

ifdef CONFIG_PRIVSEP
OBJS_priv += $(OBJS_d) ../src/drivers/drivers.o ../src/drivers/scan_helpers.o
OBJS_priv += $(OBJS_l2)
OBJS_priv += ../src/utils/os_$(CONFIG_OS).o
OBJS_priv += ../src/utils/$(CONFIG_ELOOP).o
OBJS_priv += ../src/utils/common.o
OBJS_priv += ../src/utils/wpa_debug.o
OBJS_priv += wpa_priv.o
ifdef CONFIG_DRIVER_TEST
OBJS_priv += ../src/crypto/sha1.o
OBJS_priv += ../src/crypto/md5.o
ifeq ($(CONFIG_TLS), openssl)
OBJS_priv += ../src/crypto/crypto_openssl.o
endif
ifeq ($(CONFIG_TLS), gnutls)
OBJS_priv += ../src/crypto/crypto_gnutls.o
endif
ifeq ($(CONFIG_TLS), internal)
ifeq ($(CONFIG_CRYPTO), libtomcrypt)
OBJS_priv += ../src/crypto/crypto_libtomcrypt.o
else
OBJS_priv += ../src/crypto/crypto_internal.o
endif
endif
endif # CONFIG_DRIVER_TEST
OBJS += ../src/l2_packet/l2_packet_privsep.o
OBJS += ../src/drivers/driver_privsep.o
EXTRA_progs += wpa_priv
else
OBJS += $(OBJS_d) ../src/drivers/drivers.o
OBJS += $(OBJS_l2)
endif

ifdef CONFIG_NDIS_EVENTS_INTEGRATED
CFLAGS += -DCONFIG_NDIS_EVENTS_INTEGRATED
OBJS += ../src/drivers/ndis_events.o
EXTRALIBS += -loleaut32 -lole32 -luuid
ifdef PLATFORMSDKLIB
EXTRALIBS += $(PLATFORMSDKLIB)/WbemUuid.Lib
else
EXTRALIBS += WbemUuid.Lib
endif
endif

ifndef LDO
LDO=$(CC)
endif

dynamic_eap_methods: $(EAPDYN)

wpa_priv: $(OBJS_priv)
	$(LDO) $(LDFLAGS) -o wpa_priv $(OBJS_priv) $(LIBS)

wpa_supplicant: .config $(OBJS) $(EXTRA_progs)
	$(LDO) $(LDFLAGS) -o wpa_supplicant $(OBJS) $(LIBS) $(EXTRALIBS)

eapol_test: .config $(OBJS_t)
	$(LDO) $(LDFLAGS) -o eapol_test $(OBJS_t) $(LIBS)

preauth_test: .config $(OBJS_t2) 
	$(LDO) $(LDFLAGS) -o preauth_test $(OBJS_t2) $(LIBS)

wpa_passphrase: $(OBJS_p)
	$(LDO) $(LDFLAGS) -o wpa_passphrase $(OBJS_p) $(LIBS_p)

wpa_cli: $(OBJS_c)
	$(LDO) $(LDFLAGS) -o wpa_cli $(OBJS_c) $(LIBS_c)

link_test: $(OBJS) $(OBJS_h) tests/link_test.o
	$(LDO) $(LDFLAGS) -o link_test $(OBJS) $(OBJS_h) tests/link_test.o $(LIBS)

test_wpa: $(OBJS_wpa) $(OBJS_h)
	$(LDO) $(LDFLAGS) -o test_wpa $(OBJS_wpa) $(LIBS)

OBJSa=../src/tls/asn1_test.o ../src/tls/asn1.o ../src/tls/x509v3.o ../src/utils/common.o ../src/utils/wpa_debug.o ../src/utils/os_unix.o \
	../src/crypto/crypto_$(CONFIG_CRYPTO).o ../src/crypto/md5.o ../src/crypto/sha1.o \
	../src/crypto/rc4.o ../src/crypto/des.o ../src/crypto/aes_wrap.o \
	../src/crypto/aes.o ../src/tls/bignum.o ../src/tls/rsa.o
asn1_test: $(OBJSa)
	$(LDO) $(LDFLAGS) -o asn1_test $(OBJSa)

OBJSx=tests/test_x509v3.o ../src/tls/asn1.o ../src/tls/x509v3.o \
	../src/utils/common.o ../src/utils/wpa_debug.o ../src/utils/os_unix.o \
	../src/crypto/crypto_$(CONFIG_CRYPTO).o \
	../src/crypto/md5.o ../src/crypto/sha1.o ../src/crypto/aes.o \
	../src/crypto/rc4.o ../src/crypto/des.o ../src/crypto/aes_wrap.o \
	../src/crypto/sha256.o \
	../src/tls/bignum.o ../src/tls/rsa.o
test_x509v3: $(OBJSx)
	$(LDO) $(LDFLAGS) -o test_x509v3 $(OBJSx)

win_if_list: win_if_list.c
	$(LDO) $(LDFLAGS) -o $@ win_if_list.c $(CFLAGS) $(LIBS_w)

eap_psk.so: ../src/eap_peer/eap_psk.c ../src/eap_common/eap_psk_common.c
	$(CC) -o $@ $(CFLAGS) -shared -rdynamic -fPIC $^ \
		-Deap_peer_psk_register=eap_peer_method_dynamic_init

eap_pax.so: ../src/eap_peer/eap_pax.c ../src/eap_common/eap_pax_common.c
	$(CC) -o $@ $(CFLAGS) -shared -rdynamic -fPIC $^ \
		-Deap_peer_pax_register=eap_peer_method_dynamic_init

eap_sake.so: ../src/eap_peer/eap_sake.c ../src/eap_common/eap_sake_common.c
	$(CC) -o $@ $(CFLAGS) -shared -rdynamic -fPIC $^ \
		-Deap_peer_sake_register=eap_peer_method_dynamic_init

eap_wsc.so: ../src/eap_peer/eap_wsc.c ../src/eap_common/eap_wsc_common.c ../src/wps/wps.c
	$(CC) -o $@ $(CFLAGS) -shared -rdynamic -fPIC $^ \
		-Deap_peer_wsc_register=eap_peer_method_dynamic_init

eap_ikev2.so: ../src/eap_peer/eap_ikev2.c ../src/eap_peer/ikev2.c ../src/eap_common/eap_ikev2_common.o ../src/eap_common/ikev2_common.c
	$(CC) -o $@ $(CFLAGS) -shared -rdynamic -fPIC $^ \
		-Deap_peer_ikev2_register=eap_peer_method_dynamic_init

%.so: %.c
	$(CC) -o $@ $(CFLAGS) -shared -rdynamic -fPIC $< \
		-D$(*:eap_%=eap_peer_%)_register=eap_peer_method_dynamic_init


wpa_supplicant.exe: wpa_supplicant
	mv -f $< $@
wpa_cli.exe: wpa_cli
	mv -f $< $@
wpa_passphrase.exe: wpa_passphrase
	mv -f $< $@
win_if_list.exe: win_if_list
	mv -f $< $@
eapol_test.exe: eapol_test
	mv -f $< $@

WINALL=wpa_supplicant.exe wpa_cli.exe wpa_passphrase.exe win_if_list.exe

windows-bin: $(WINALL)
	$(STRIP) $(WINALL)

wpa_gui/Makefile:
	qmake -o wpa_gui/Makefile wpa_gui/wpa_gui.pro 

wpa_gui: wpa_gui/Makefile
	$(MAKE) -C wpa_gui

wpa_gui-qt4/Makefile:
	qmake -o wpa_gui-qt4/Makefile wpa_gui-qt4/wpa_gui.pro 

wpa_gui-qt4: wpa_gui-qt4/Makefile
	$(MAKE) -C wpa_gui-qt4

TEST_MS_FUNCS_OBJS = ../src/crypto/crypto_openssl.o ../src/crypto/sha1.o ../src/crypto/md5.o \
	../src/utils/os_unix.o ../src/crypto/rc4.o tests/test_ms_funcs.o
test-ms_funcs: $(TEST_MS_FUNCS_OBJS)
	$(LDO) $(LDFLAGS) -o $@ $(TEST_MS_FUNCS_OBJS) $(LIBS) -lcrypto
	./test-ms_funcs
	rm test-ms_funcs

TEST_SHA1_OBJS = ../src/crypto/sha1.o ../src/crypto/md5.o tests/test_sha1.o #../src/crypto/crypto_openssl.o
test-sha1: $(TEST_SHA1_OBJS)
	$(LDO) $(LDFLAGS) -o $@ $(TEST_SHA1_OBJS) $(LIBS)
	./test-sha1
	rm test-sha1

TEST_SHA256_OBJS = ../src/crypto/sha256.o ../src/crypto/md5.o tests/test_sha256.o ../src/crypto/crypto_openssl.o
test-sha256: $(TEST_SHA256_OBJS)
	$(LDO) $(LDFLAGS) -o $@ $(TEST_SHA256_OBJS) $(LIBS)
	./test-sha256
	rm test-sha256

TEST_AES_OBJS = ../src/crypto/aes_wrap.o ../src/crypto/aes.o tests/test_aes.o
test-aes: $(TEST_AES_OBJS)
	$(LDO) $(LDFLAGS) -o $@ $(TEST_AES_OBJS) $(LIBS)
	./test-aes
	rm test-aes

TEST_EAP_SIM_COMMON_OBJS = ../src/crypto/sha1.o ../src/crypto/md5.o \
	../src/crypto/aes_wrap.o ../src/utils/common.o ../src/utils/os_unix.o \
	../src/utils/wpa_debug.o ../src/crypto/aes.o \
	tests/test_eap_sim_common.o
test-eap_sim_common: $(TEST_EAP_SIM_COMMON_OBJS)
	$(LDO) $(LDFLAGS) -o $@ $(TEST_AES_OBJS) $(LIBS)
	./test-eap_sim_common
	rm test-eap_sim_common

TEST_MD4_OBJS = ../src/crypto/md4.o tests/test_md4.o #../src/crypto/crypto_openssl.o
test-md4: $(TEST_MD4_OBJS)
	$(LDO) $(LDFLAGS) -o $@ $(TEST_MD4_OBJS) $(LIBS)
	./test-md4
	rm test-md4

TEST_MD5_OBJS = ../src/crypto/md5.o tests/test_md5.o #../src/crypto/crypto_openssl.o
test-md5: $(TEST_MD5_OBJS)
	$(LDO) $(LDFLAGS) -o $@ $(TEST_MD5_OBJS) $(LIBS)
	./test-md5
	rm test-md5

tests: test-ms_funcs test-sha1 test-aes test-eap_sim_common test-md4 test-md5

clean:
	$(MAKE) -C ../src clean
	rm -f core *~ *.o *.d eap_*.so $(ALL) $(WINALL)

%.eps: %.fig
	fig2dev -L eps $*.fig $*.eps

%.png: %.fig
	fig2dev -L png -m 3 $*.fig | pngtopnm | pnmscale 0.4 | pnmtopng \
		> $*.png

docs-pics: doc/wpa_supplicant.png doc/wpa_supplicant.eps

docs: docs-pics
	(cd ..; doxygen wpa_supplicant/doc/doxygen.full; cd wpa_supplicant)
	$(MAKE) -C doc/latex
	cp doc/latex/refman.pdf wpa_supplicant-devel.pdf

docs-fast: docs-pics
	doxygen doc/doxygen.fast

clean-docs:
	rm -rf doc/latex doc/html
	rm -f doc/wpa_supplicant.{eps,png} wpa_supplicant-devel.pdf

wpa_supplicant-sparse: .config $(OBJS)
	@echo Sparse run completed

run-sparse:
	CC="sparse -D__linux__ -Dlinux -D__STDC__ -Dunix -D__unix__ -D__INT_MAX__=2147483647 -D__SHRT_MAX__=32767 -D__LONG_MAX__=2147483647 -D__SCHAR_MAX__=127 -Wbitwise" $(MAKE) wpa_supplicant-sparse

-include $(OBJS:%.o=%.d)
