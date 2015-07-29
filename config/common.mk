PRODUCT_BRAND ?= razer

ifneq ($(TARGET_SCREEN_WIDTH) $(TARGET_SCREEN_HEIGHT),$(space))
# determine the smaller dimension
TARGET_BOOTANIMATION_SIZE := $(shell \
  if [ $(TARGET_SCREEN_WIDTH) -lt $(TARGET_SCREEN_HEIGHT) ]; then \
    echo $(TARGET_SCREEN_WIDTH); \
  else \
    echo $(TARGET_SCREEN_HEIGHT); \
  fi )

# get a sorted list of the sizes
bootanimation_sizes := $(subst .zip,, $(shell ls vendor/razer/prebuilt/common/bootanimation))
bootanimation_sizes := $(shell echo -e $(subst $(space),'\n',$(bootanimation_sizes)) | sort -rn)

# find the appropriate size and set
define check_and_set_bootanimation
$(eval TARGET_BOOTANIMATION_NAME := $(shell \
  if [ -z "$(TARGET_BOOTANIMATION_NAME)" ]; then
    if [ $(1) -le $(TARGET_BOOTANIMATION_SIZE) ]; then \
      echo $(1); \
      exit 0; \
    fi;
  fi;
  echo $(TARGET_BOOTANIMATION_NAME); ))
endef
$(foreach size,$(bootanimation_sizes), $(call check_and_set_bootanimation,$(size)))

ifeq ($(TARGET_BOOTANIMATION_HALF_RES),true)
PRODUCT_BOOTANIMATION := vendor/razer/prebuilt/common/bootanimation/halfres/$(TARGET_BOOTANIMATION_NAME).zip
else
PRODUCT_BOOTANIMATION := vendor/razer/prebuilt/common/bootanimation/$(TARGET_BOOTANIMATION_NAME).zip
endif
endif

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

# Google property overides
PRODUCT_PROPERTY_OVERRIDES += \
    keyguard.no_require_sim=true \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.url.legal.android_privacy=http://www.google.com/intl/%s/mobile/android/basic/privacy.html \
    ro.com.android.wifi-watchlist=GoogleGuest \
    ro.setupwizard.enterprise_mode=1 \
    ro.com.android.dateformat=MM-dd-yyyy \
    ro.com.android.dataroaming=false \

PRODUCT_PROPERTY_OVERRIDES += \
    ro.build.selinux=1

# Thank you, please drive thru!
PRODUCT_PROPERTY_OVERRIDES += persist.sys.dun.override=0

ifneq ($(TARGET_BUILD_VARIANT),eng)
# Enable ADB authentication
ADDITIONAL_DEFAULT_PROPERTIES += ro.adb.secure=1
endif

# Backup Tool
ifneq ($(WITH_GMS),true)
PRODUCT_COPY_FILES += \
    vendor/razer/prebuilt/common/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/razer/prebuilt/common/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/razer/prebuilt/common/bin/50-razer.sh:system/addon.d/50-razer.sh \
    vendor/razer/prebuilt/common/bin/blacklist:system/addon.d/blacklist \
    vendor/razer/prebuilt/common/bin/99-backup.sh:system/addon.d/99-backup.sh \
    vendor/razer/prebuilt/common/etc/backup.conf:system/etc/backup.conf
endif

# Signature compatibility validation
PRODUCT_COPY_FILES += \
    vendor/razer/prebuilt/common/bin/otasigcheck.sh:install/bin/otasigcheck.sh

# init.d support
PRODUCT_COPY_FILES += \
    vendor/razer/prebuilt/common/etc/init.d/00banner:system/etc/init.d/00banner \
    vendor/razer/prebuilt/common/bin/sysinit:system/bin/sysinit

# Proprietary latinime lib needed for Keyboard swyping
PRODUCT_COPY_FILES += \
    vendor/razer/prebuilt/lib/libjni_latinimegoogle.so:system/lib/libjni_latinimegoogle.so

ifneq ($(TARGET_BUILD_VARIANT),user)
# userinit support
PRODUCT_COPY_FILES += \
    vendor/razer/prebuilt/common/etc/init.d/90userinit:system/etc/init.d/90userinit
endif

# fstrim support
PRODUCT_COPY_FILES += \
    vendor/razer/prebuilt/common/etc/init.d/98fstrim:system/etc/init.d/98fstrim

# SuperSU
PRODUCT_COPY_FILES += \
    vendor/razer/prebuilt/common/UPDATE-SuperSU.zip:system/addon.d/UPDATE-SuperSU.zip \
    vendor/razer/prebuilt/common/etc/init.d/99SuperSUDaemon:system/etc/init.d/99SuperSUDaemon

# Razer-specific init file
PRODUCT_COPY_FILES += \
    vendor/razer/prebuilt/common/etc/init.local.rc:root/init.cm.rc

# Bring in camera effects
PRODUCT_COPY_FILES +=  \
    vendor/razer/prebuilt/common/media/LMprec_508.emd:system/media/LMprec_508.emd \
    vendor/razer/prebuilt/common/media/PFFprec_600.emd:system/media/PFFprec_600.emd

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

# Enable wireless Xbox 360 controller support
PRODUCT_COPY_FILES += \
    frameworks/base/data/keyboards/Vendor_045e_Product_028e.kl:system/usr/keylayout/Vendor_045e_Product_0719.kl

# Chromium Prebuilt
ifeq ($(PRODUCT_PREBUILT_WEBVIEWCHROMIUM),yes)
-include prebuilts/chromium/$(TARGET_DEVICE)/chromium_prebuilt.mk
endif

# This is RazerRom!
PRODUCT_COPY_FILES += \
    vendor/razer/config/permissions/com.razer.android.xml:system/etc/permissions/com.razer.android.xml

# T-Mobile theme engine
-include vendor/razer/config/themes_common.mk

# RazerRom Audio Mods
-include vendor/razer/config/razer_audio_mod.mk

# RomStats
#PRODUCT_PACKAGES += \
#    RomStats

# Screen recorder
#PRODUCT_PACKAGES += \
    #ScreenRecorder \
    #libscreenrecorder

# Required CM packages
PRODUCT_PACKAGES += \
    Development \
    BluetoothExt \
    Profiles

# Optional CM packages
PRODUCT_PACKAGES += \
    VoicePlus \
    Basic \
    libemoji \
    Terminal

# Custom CM packages
PRODUCT_PACKAGES += \
    LockClock

# CM Platform Library
PRODUCT_PACKAGES += \
    org.cyanogenmod.platform-res \
    org.cyanogenmod.platform \
    org.cyanogenmod.platform.xml

# CM Hardware Abstraction Framework
PRODUCT_PACKAGES += \
    org.cyanogenmod.hardware \
    org.cyanogenmod.hardware.xml

# Other packages
PRODUCT_PACKAGES += \
    KernelAdiutor \
    OmniSwitch \
    WallpaperPicker

# Extra tools in RazerRom
PRODUCT_PACKAGES += \
    libsepol \
    e2fsck \
    mke2fs \
    tune2fs \
    bash \
    nano \
    htop \
    powertop \
    lsof \
    mount.exfat \
    fsck.exfat \
    mkfs.exfat \
    mkfs.f2fs \
    fsck.f2fs \
    fibmap.f2fs \
    ntfsfix \
    ntfs-3g \
    gdbserver \
    micro_bench \
    oprofiled \
    sqlite3 \
    strace

# Extra tools
PRODUCT_PACKAGES += \
    vim \
    zip \
    unrar

# Openssh
PRODUCT_PACKAGES += \
    scp \
    sftp \
    ssh \
    sshd \
    sshd_config \
    ssh-keygen \
    start-ssh

# rsync
PRODUCT_PACKAGES += \
    rsync

# Stagefright FFMPEG plugin
PRODUCT_PACKAGES += \
    libffmpeg_extractor \
    libffmpeg_omx \
    media_codecs_ffmpeg.xml

PRODUCT_PROPERTY_OVERRIDES += \
    media.sf.omx-plugin=libffmpeg_omx.so \
    media.sf.extractor-plugin=libffmpeg_extractor.so

# These packages are excluded from user builds
ifneq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_PACKAGES += \
    procmem \
    procrank \
    su

# HFM Files
PRODUCT_COPY_FILES += \
    vendor/razer/prebuilt/etc/hosts.alt:system/etc/hosts.alt \
    vendor/razer/prebuilt/etc/hosts.og:system/etc/hosts.og

endif

PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.root_access=0

PRODUCT_PACKAGE_OVERLAYS += vendor/razer/overlay/common

# by default, do not update the recovery with system updates
PRODUCT_PROPERTY_OVERRIDES += persist.sys.recovery_update=false

# RazerRom Versioning System
-include vendor/razer/config/versions.mk

-include $(WORKSPACE)/build_env/image-auto-bits.mk

-include vendor/cyngn/product.mk

$(call prepend-product-if-exists, vendor/extra/product.mk)

# statistics identity
#PRODUCT_PROPERTY_OVERRIDES += \
#    ro.romstats.url=http://www.razerzone.com/ca-en \
#    ro.romstats.name=RazerRom \
#    ro.romstats.version=$(RAZER_VERSION) \
#    ro.romstats.askfirst=0 \
#    ro.romstats.tframe=1

PRODUCT_PROPERTY_OVERRIDES += \
    BUILD_DISPLAY_ID=$(BUILD_ID) \
    ro.razer.version=$(RAZER_VERSION)

ifndef CM_PLATFORM_SDK_VERSION
  # This is the canonical definition of the SDK version, which defines
  # the set of APIs and functionality available in the platform.  It
  # is a single integer that increases monotonically as updates to
  # the SDK are released.  It should only be incremented when the APIs for
  # the new release are frozen (so that developers don't write apps against
  # intermediate builds).
  CM_PLATFORM_SDK_VERSION := 2
endif

# CyanogenMod Platform SDK Version
PRODUCT_PROPERTY_OVERRIDES += \
  ro.cm.build.version.plat.sdk=$(CM_PLATFORM_SDK_VERSION)

-include $(WORKSPACE)/build_env/image-auto-bits.mk

-include vendor/cyngn/product.mk

$(call prepend-product-if-exists, vendor/extra/product.mk)

##                     ##
#- Gamerman123x Extras -# 
##                     ##

# Razer property overides
PRODUCT_PROPERTY_OVERRIDES += \
    ro.sys.fw.bg_apps_limit=24 \
    pm.sleep.mode=1 \
    wifi.supplicant_scan_interval=180 \
    windowsmgr.max_events_per_sec=150 \
    debug.performance.tuning=1 \
    ro.ril.power_collapse=1 \
    persist.service.lgospd.enable=0 \
    persist.service.pcsync.enable=0 \
    ro.facelock.black_timeout=400 \
    ro.facelock.det_timeout=1500 \
    ro.facelock.rec_timeout=2500 \
    ro.facelock.lively_timeout=2500 \
    ro.facelock.est_max_time=600 \
    ro.facelock.use_intro_anim=false \
    ro.setupwizard.network_required=false \
    ro.setupwizard.gservices_delay=-1 \
    net.tethering.noprovisioning=true \
    persist.sys.dun.override=0
    dalvik.vm.profiler=1 \
    dalvik.vm.isa.arm.features=lpae,div \
    dalvik.vm.image-dex2oat-filter=everything \
    dalvik.vm.dex2oat-filter=everything

# CameraNextMod
PRODUCT_COPY_FILES += \
    vendor/razer/prebuilt/CameraNextMod/CameraNextMod.apk:system/app/CameraNextMod/CameraNextMod.apk \
    vendor/razer/prebuilt/CameraNextMod/libjni_mosaic_next.so:system/lib/libjni_mosaic_next.so \
    vendor/razer/prebuilt/CameraNextMod/libjni_tinyplanet_next.so:system/lib/libjni_tinyplanet_next.so

# ES File Explorer
PRODUCT_COPY_FILES += \
    vendor/razer/prebuilt/ESFileExplorer/ESFileExplorer.apk:system/app/ESFileExplorer/ESFileExplorer.apk \
    vendor/razer/prebuilt/ESFileExplorer/libmyaes.so:system/lib/libmyaes.so

# Nova Launcher
PRODUCT_COPY_FILES += \
    vendor/razer/prebuilt/NovaLauncher.apk:system/app/NovaLauncher/NovaLauncher.apk

# Poweramp
PRODUCT_COPY_FILES += \
    vendor/razer/prebuilt/Poweramp/Poweramp.apk:system/app/Poweramp/Poweramp.apk \
    vendor/razer/prebuilt/Poweramp/libstubnotused.so:system/lib/libstubnotused.so

# Quick Pic
PRODUCT_COPY_FILES += \
    vendor/razer/prebuilt/QuickPic/QuickPic.apk:system/app/QuickPic/QuickPic.apk \
    vendor/razer/prebuilt/QuickPic/libqpicjni156.so:system/lib/libqpicjni156.so
