TARGET = iphone:9.3
CFLAGS = -fobjc-arc -O2

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Vitality
Vitality_FILES = Tweak.xm $(wildcard *.m)
Vitality_FRAMEWORKS = UIKit QuartzCore

BUNDLE_NAME = Vitality-Default
Vitality-Default_INSTALL_PATH = /Library/Application Support/Vitality/Wallpapers/

include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS)/makefiles/bundle.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += vitality
include $(THEOS_MAKE_PATH)/aggregate.mk
