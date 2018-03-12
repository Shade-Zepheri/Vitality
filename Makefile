export TARGET = iphone:10.1

INSTALL_TARGET_PROCESSES = Preferences

ifneq ($(RESPRING),0)
		INSTALL_TARGET_PROCESSES += SpringBoard
endif

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Vitality
Vitality_FILES = $(wildcard *.x) $(wildcard *.m)
Vitality_FRAMEWORKS = UIKit QuartzCore ImageIO MobileCoreServices
VitalityCFLAGS = -fobjc-arc

BUNDLE_NAME = Vitality-Default
Vitality-Default_INSTALL_PATH = /Library/Application Support/Vitality/Wallpapers/

SUBPROJECTS = vitality

include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS)/makefiles/bundle.mk
include $(THEOS_MAKE_PATH)/aggregate.mk
