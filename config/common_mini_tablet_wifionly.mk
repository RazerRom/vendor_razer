# Inherit common Razer stuff
$(call inherit-product, vendor/razer/config/common.mk)

# Include Razer audio files
include vendor/razer/config/razer_audio.mk

# Required RazerRom packages
PRODUCT_PACKAGES += \
    LatinIME

# Default notification/alarm sounds
PRODUCT_PROPERTY_OVERRIDES += \
    ro.config.notification_sound=Argon.ogg \
    ro.config.alarm_alert=Hassium.ogg

ifeq ($(TARGET_SCREEN_WIDTH) $(TARGET_SCREEN_HEIGHT),$(space))
    PRODUCT_COPY_FILES += \
        vendor/razer/prebuilt/common/bootanimation/800.zip:system/media/bootanimation.zip
endif
