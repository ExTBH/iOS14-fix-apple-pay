TARGET := iphone:clang:latest:13.0

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = FAPPrefs

FAPPrefs_FILES = FAPRootListController.m
FAPPrefs_FRAMEWORKS = UIKit
FAPPrefs_PRIVATE_FRAMEWORKS = Preferences
FAPPrefs_EXTRA_FRAMEWORKS += Cephei CepheiPrefs
FAPPrefs_INSTALL_PATH = /Library/PreferenceBundles
FAPPrefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk
