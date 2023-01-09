TARGET := iphone:clang:latest:13.0
INSTALL_TARGET_PROCESSES = Passbook

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = ApplePayfixforiOS14

ApplePayfixforiOS14_FILES = Tweak.m $(wildcard UI/**/*.m) $(wildcard Extensions/*.m)

ApplePayfixforiOS14_CFLAGS = -fobjc-arc


ApplePayfixforiOS14_PRIVATE_FRAMEWORKS += PassKitCore

include $(THEOS_MAKE_PATH)/tweak.mk

ifeq ($(TROLLSTORE), 1)
ApplePayfixforiOS14_CFLAGS = -fobjc-arc -DTROLLSTORE=1
before-all::
	$(ECHO_BEGIN)$(PRINT_FORMAT_YELLOW) "Compiling For TROLLSTORE"$(ECHO_END)
else
ApplePayfixforiOS14_EXTRA_FRAMEWORKS += Cephei
SUBPROJECTS += prefs
endif
include $(THEOS_MAKE_PATH)/aggregate.mk
