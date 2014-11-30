GO_EASY_ON_ME = 1

ARCHS = armv7 arm64
TARGET = iphone:clang:latest:latest
THEOS_BUILD_DIR = Packages

include theos/makefiles/common.mk

TWEAK_NAME = QuickPhil
QuickPhil_FILES = Tweak.xm
QuickPhil_FRAMEWORKS = MediaPlayer UIKit
QuickPhil_LDFLAGS = -lactivator
QuickPhil_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

internal-stage::
	$(ECHO_NOTHING)ssh iphone killcydia$(ECHO_END)

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += quickphil
include $(THEOS_MAKE_PATH)/aggregate.mk
