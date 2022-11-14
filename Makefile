TARGET := iphone:clang:latest:14.0
INSTALL_TARGET_PROCESSES = Passbook


include $(THEOS)/makefiles/common.mk

TWEAK_NAME = ApplePayfixforiOS14

ApplePayfixforiOS14_FILES = Tweak.x
ApplePayfixforiOS14_CFLAGS = -fobjc-arc

ApplePayfixforiOS14_EXTRA_FRAMEWORKS += Cephei

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += prefs
include $(THEOS_MAKE_PATH)/aggregate.mk
