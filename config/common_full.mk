# Inherit common Bliss stuff
$(call inherit-product, vendor/bliss/config/common.mk)

# Include Bliss audio files
include vendor/bliss/config/bliss_audio.mk

# Include Bliss LatinIME dictionaries
PRODUCT_PACKAGE_OVERLAYS += vendor/bliss/overlay/dictionaries

# Optional Bliss packages
PRODUCT_PACKAGES += \
    LiveWallpapers \
    LiveWallpapersPicker \
    SoundRecorder

# Extra tools in Bliss
PRODUCT_PACKAGES += \
    vim \
    zip \
    unrar
