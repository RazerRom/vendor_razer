PRODUCT_BRAND ?= bliss

ifneq ($(TARGET_SCREEN_WIDTH) $(TARGET_SCREEN_HEIGHT),$(space))
# determine the smaller dimension
TARGET_BOOTANIMATION_SIZE := $(shell \
  if [ $(TARGET_SCREEN_WIDTH) -lt $(TARGET_SCREEN_HEIGHT) ]; then \
    echo $(TARGET_SCREEN_WIDTH); \
  else \
    echo $(TARGET_SCREEN_HEIGHT); \
  fi )

# get a sorted list of the sizes
bootanimation_sizes := $(subst .zip,, $(shell ls vendor/bliss/prebuilt/common/bootanimation))
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
PRODUCT_BOOTANIMATION := vendor/bliss/prebuilt/common/bootanimation/halfres/$(TARGET_BOOTANIMATION_NAME).zip
else
PRODUCT_BOOTANIMATION := vendor/bliss/prebuilt/common/bootanimation/$(TARGET_BOOTANIMATION_NAME).zip
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

PRODUCT_PROPERTY_OVERRIDES += \
    keyguard.no_require_sim=true \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.url.legal.android_privacy=http://www.google.com/intl/%s/mobile/android/basic/privacy.html \
    ro.com.android.wifi-watchlist=GoogleGuest \
    ro.setupwizard.enterprise_mode=1 \
    ro.com.android.dateformat=MM-dd-yyyy \
    ro.com.android.dataroaming=false

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
    vendor/bliss/prebuilt/common/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/bliss/prebuilt/common/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/bliss/prebuilt/common/bin/50-bliss.sh:system/addon.d/50-bliss.sh \
    vendor/bliss/prebuilt/common/bin/blacklist:system/addon.d/blacklist
endif

# Signature compatibility validation
PRODUCT_COPY_FILES += \
    vendor/bliss/prebuilt/common/bin/otasigcheck.sh:install/bin/otasigcheck.sh

# init.d support
PRODUCT_COPY_FILES += \
    vendor/bliss/prebuilt/common/etc/init.d/00banner:system/etc/init.d/00banner \
    vendor/bliss/prebuilt/common/bin/sysinit:system/bin/sysinit

# Proprietary latinime lib needed for Keyboard swyping
PRODUCT_COPY_FILES += \
    vendor/bliss/prebuilt/lib/libjni_latinimegoogle.so:system/lib/libjni_latinimegoogle.so

# userinit support
PRODUCT_COPY_FILES += \
    vendor/bliss/prebuilt/common/etc/init.d/90userinit:system/etc/init.d/90userinit
    
# fstrim support
PRODUCT_COPY_FILES += \
    vendor/bliss/prebuilt/common/etc/init.d/98fstrim:system/etc/init.d/98fstrim
    
# SuperSU
PRODUCT_COPY_FILES += \
    vendor/bliss/prebuilt/common/UPDATE-SuperSU.zip:system/addon.d/UPDATE-SuperSU.zip \
    vendor/bliss/prebuilt/common/etc/init.d/99SuperSUDaemon:system/etc/init.d/99SuperSUDaemon

# Bliss-specific init file
PRODUCT_COPY_FILES += \
    vendor/bliss/prebuilt/common/etc/init.local.rc:root/init.cm.rc

# Bring in camera effects
PRODUCT_COPY_FILES +=  \
    vendor/bliss/prebuilt/common/media/LMprec_508.emd:system/media/LMprec_508.emd \
    vendor/bliss/prebuilt/common/media/PFFprec_600.emd:system/media/PFFprec_600.emd

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

# This is Bliss!
PRODUCT_COPY_FILES += \
    vendor/bliss/config/permissions/com.bliss.android.xml:system/etc/permissions/com.bliss.android.xml

# T-Mobile theme engine
include vendor/bliss/config/themes_common.mk

# RomStats
PRODUCT_PACKAGES += \
    RomStats

# Screen recorder
PRODUCT_PACKAGES += \
    ScreenRecorder \
    libscreenrecorder

# Required CM packages
PRODUCT_PACKAGES += \
    Development \
    LatinIME \
    BluetoothExt

# Optional CM packages
PRODUCT_PACKAGES += \
    VoicePlus \
    Basic \
    libemoji

# Custom CM packages
PRODUCT_PACKAGES += \
    AudioFX \
    Eleven \
    LockClock \
    OmniSwitch \
    BlissPapers \
    Terminal

# Bliss Hardware Abstraction Framework
PRODUCT_PACKAGES += \
    org.cyanogenmod.hardware \
    org.cyanogenmod.hardware.xml

# Extra tools in Bliss
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
    libstagefright_soft_ffmpegadec \
    libstagefright_soft_ffmpegvdec \
    libFFmpegExtractor \
    libnamparser

# These packages are excluded from user builds
ifneq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_PACKAGES += \
    procmem \
    procrank \
    su
    
# HFM Files
PRODUCT_COPY_FILES += \
	vendor/bliss/prebuilt/etc/hosts.alt:system/etc/hosts.alt \
	vendor/bliss/prebuilt/etc/hosts.og:system/etc/hosts.og

endif

PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.root_access=0


PRODUCT_PACKAGE_OVERLAYS += vendor/bliss/overlay/common

# by default, do not update the recovery with system updates
PRODUCT_PROPERTY_OVERRIDES += persist.sys.recovery_update=false

# BLISS Versioning System
-include vendor/bliss/config/versions.mk

-include $(WORKSPACE)/build_env/image-auto-bits.mk

-include vendor/cyngn/product.mk

$(call prepend-product-if-exists, vendor/extra/product.mk)

# BlissPopGM Extras

# property overides
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
    dalvik.vm.profiler=1 \
    dalvik.vm.isa.arm.features=lpae,div

# statistics identity
PRODUCT_PROPERTY_OVERRIDES += \
    ro.romstats.url=http://http://team.blissroms.com/RomStats/website/stats.php \
    ro.romstats.name=BlissPopGM \
    ro.romstats.version=$(BLISS_VERSION) \
    ro.romstats.askfirst=0 \
    ro.romstats.tframe=1

PRODUCT_PROPERTY_OVERRIDES += \
    BUILD_DISPLAY_ID=$(BUILD_ID) \
    ro.bliss.version=$(BLISS_VERSION)

# L Speed Reborn
PRODUCT_COPY_FILES += \
    vendor/bliss/prebuilt/common/L_speed/data/L_Speed/Logs/01Seeder.log:data/L_Speed/Logs/01Seeder.log \
    vendor/bliss/prebuilt/common/L_speed/data/L_Speed/Logs/02VM_tweaks.log:data/L_Speed/Logs/02VM_tweaks.log \
    vendor/bliss/prebuilt/common/L_speed/data/L_Speed/Logs/03Ram_manager.log:data/L_Speed/Logs/03Ram_manager.log \
    vendor/bliss/prebuilt/common/L_speed/data/L_Speed/Logs/04Cleaner.log:data/L_Speed/Logs/04Cleaner.log \
    vendor/bliss/prebuilt/common/L_speed/data/L_Speed/Logs/05Net_tweaks.log:data/L_Speed/Logs/05Net_tweaks.log \
    vendor/bliss/prebuilt/common/L_speed/data/L_Speed/Logs/06SD_tweak.log:data/L_Speed/Logs/06SD_tweak.log \
    vendor/bliss/prebuilt/common/L_speed/data/L_Speed/Logs/07Zipalign.log:data/L_Speed/Logs/07Zipalign.log \
    vendor/bliss/prebuilt/common/L_speed/system/bin/0L-check:system/bin/0L-check \
    vendor/bliss/prebuilt/common/L_speed/system/bin/0L_Wizard:system/bin/0L_Wizard \
    vendor/bliss/prebuilt/common/L_speed/system/bin/0seeder:system/bin/0seeder \
    vendor/bliss/prebuilt/common/L_speed/system/bin/0uninstaller:system/bin/0uninstaller \
    vendor/bliss/prebuilt/common/L_speed/system/bin/L_Speed:system/bin/L_Speed \
    vendor/bliss/prebuilt/common/L_speed/system/etc/init.d/00init.d_check:system/etc/init.d/00init.d_check \
    vendor/bliss/prebuilt/common/L_speed/system/etc/init.d/01Seeder:system/etc/init.d/01Seeder \
    vendor/bliss/prebuilt/common/L_speed/system/etc/init.d/02VM_tweaks:system/etc/init.d/02VM_tweaks \
    vendor/bliss/prebuilt/common/L_speed/system/etc/init.d/03Ram_manager:system/etc/init.d/03Ram_manager \
    vendor/bliss/prebuilt/common/L_speed/system/etc/init.d/04Cleaner:system/etc/init.d/04Cleaner \
    vendor/bliss/prebuilt/common/L_speed/system/etc/init.d/05Net_tweaks:system/etc/init.d/05Net_tweaks \
    vendor/bliss/prebuilt/common/L_speed/system/etc/init.d/06SD_tweak:system/etc/init.d/06SD_tweak \
    vendor/bliss/prebuilt/common/L_speed/system/etc/init.d/07Zipalign:system/etc/init.d/07Zipalign \
    vendor/bliss/prebuilt/common/L_speed/system/etc/L_Speed/00changelog:system/etc/L_Speed/00changelog \
    vendor/bliss/prebuilt/common/L_speed/system/etc/L_Speed/01Seeder:system/etc/L_Speed/01Seeder \
    vendor/bliss/prebuilt/common/L_speed/system/etc/L_Speed/02VM_tweaks:system/etc/L_Speed/02VM_tweaks \
    vendor/bliss/prebuilt/common/L_speed/system/etc/L_Speed/03Ram_manager:system/etc/L_Speed/03Ram_manager \
    vendor/bliss/prebuilt/common/L_speed/system/etc/L_Speed/04Cleaner:system/etc/L_Speed/04Cleaner \
    vendor/bliss/prebuilt/common/L_speed/system/etc/L_Speed/05Net_tweaks:system/etc/L_Speed/05Net_tweaks \
    vendor/bliss/prebuilt/common/L_speed/system/etc/L_Speed/06SD_tweak:system/etc/L_Speed/06SD_tweak \
    vendor/bliss/prebuilt/common/L_speed/system/etc/L_Speed/07Zipalign:system/etc/L_Speed/07Zipalign \
    vendor/bliss/prebuilt/common/L_speed/system/xbin/entro:system/xbin/entro \
    vendor/bliss/prebuilt/common/L_speed/system/xbin/openvpn:system/xbin/openvpn \
    vendor/bliss/prebuilt/common/L_speed/system/xbin/rngd:system/xbin/rngd \
    vendor/bliss/prebuilt/common/L_speed/system/xbin/zipalign:system/xbin/zipalign

# Nova Launcher
PRODUCT_COPY_FILES += \
    vendor/bliss/prebuilt/common/app/NovaLauncher.apk:system/priv-app/NovaLauncher/NovaLauncher.apk
