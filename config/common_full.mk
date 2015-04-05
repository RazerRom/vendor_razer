# Inherit common BlissRom stuff
$(call inherit-product, vendor/bliss/config/common.mk)

# Include BlissRom audio files
include vendor/bliss/config/bliss_audio.mk

# Include BlissRom LatinIME dictionaries
PRODUCT_PACKAGE_OVERLAYS += vendor/bliss/overlay/dictionaries

# Optional BlissRom packages
PRODUCT_PACKAGES += \
    Galaxy4 \
    HoloSpiralWallpaper \
    LiveWallpapers \
    LiveWallpapersPicker \
    MagicSmokeWallpapers \
    NoiseField \
    PhaseBeam \
    VisualizationWallpapers \
    PhotoTable \
    SoundRecorder \
    PhotoPhase

# Extra tools in BlissRom
PRODUCT_PACKAGES += \
    vim \
    zip \
    unrar
