export TARGET = iphone:11.2:9.0

INSTALL_TARGET_PROCESSES = Preferences

ifneq ($(RESPRING),0)
    INSTALL_TARGET_PROCESSES += SpringBoard
endif

export ADDITIONAL_CFLAGS = -DTHEOS_LEAN_AND_MEAN -fobjc-arc

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Vitality
Vitality_FILES = $(wildcard *.x) $(wildcard *.m)
Vitality_FRAMEWORKS = UIKit QuartzCore ImageIO MobileCoreServices
Vitality_EXTRA_FRAMEWORKS = Cephei

BUNDLE_NAME = Vitality-Default
Vitality-Default_INSTALL_PATH = /var/mobile/Library/Vitality/

SUBPROJECTS = Settings

include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS)/makefiles/bundle.mk
include $(THEOS_MAKE_PATH)/aggregate.mk
