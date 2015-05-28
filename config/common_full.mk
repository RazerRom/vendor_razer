# Inherit common RazerRom stuff
$(call inherit-product, vendor/razer/config/common.mk)

# Include RazerRom audio files
include vendor/razer/config/razer_audio.mk

# Include RazerRom LatinIME dictionaries
PRODUCT_PACKAGE_OVERLAYS += vendor/razer/overlay/dictionaries

# Optional RazerRom packages
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

# Extra tools in RazerRom
PRODUCT_PACKAGES += \
    vim \
    zip \
    unrar
