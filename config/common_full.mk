# Inherit common Razer stuff
$(call inherit-product, vendor/razer/config/common.mk)

# Include Razer audio files
include vendor/razer/config/razer_audio.mk

# Optional Razer packages
PRODUCT_PACKAGES += \
    LiveWallpapersPicker \
    SoundRecorder

# Extra tools in Razer
PRODUCT_PACKAGES += \
    vim \
    zip \
    unrar
