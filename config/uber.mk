# Written for UBER toolchains
# Find host os

# Set GCC colors
export GCC_COLORS := 'error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

UNAME := $(shell uname -s)

ifeq (Linux,$(UNAME))
  HOST_OS := linux
endif

ifeq (linux,$(HOST_OS))
ifeq (arm,$(TARGET_ARCH))
# Path to toolchain
ifeq (4.8,$(TARGET_GCC_VERSION))
UBER_AND_PATH := prebuilts/gcc/$(HOST_PREBUILT_TAG)/arm/arm-linux-androideabi-4.8
UBER_AND := $(shell $(UBER_AND_PATH)/bin/arm-linux-androideabi-gcc --version)
else
UBER_AND_PATH := prebuilts/gcc/$(HOST_PREBUILT_TAG)/arm/arm-linux-androideabi-4.9
UBER_AND := $(shell $(UBER_AND_PATH)/bin/arm-linux-androideabi-gcc --version)
endif

# Find strings in version info
ifneq ($(filter (UBERTC%),$(UBER_AND)),)
UBER_AND_NAME := $(filter (UBERTC%),$(UBER_AND))
UBER_AND_DATE := $(filter 20150% 20151%,$(UBER_AND))
UBER_AND_VERSION := $(UBER_AND_NAME)-$(UBER_AND_DATE)
ADDITIONAL_BUILD_PROPERTIES += \
    ro.uber.android=$(UBER_AND_VERSION)
endif

ifneq ($(TARGET_GCC_VERSION_ARM),)
UBER_KERNEL_PATH := prebuilts/gcc/$(HOST_PREBUILT_TAG)/arm/arm-eabi-$(TARGET_GCC_VERSION_ARM)
UBER_KERNEL := $(shell $(UBER_KERNEL_PATH)/bin/arm-eabi-gcc --version)
else
UBER_KERNEL_PATH := prebuilts/gcc/$(HOST_PREBUILT_TAG)/arm/arm-eabi-$(TARGET_GCC_VERSION)
UBER_KERNEL := $(shell $(UBER_KERNEL_PATH)/bin/arm-eabi-gcc --version)
endif

ifneq ($(filter (UBERTC%),$(UBER_KERNEL)),)
UBER_KERNEL_NAME := $(filter (UBERTC%),$(UBER_KERNEL))
UBER_KERNEL_DATE := $(filter 20150% 20151%,$(UBER_KERNEL))
UBER_KERNEL_VERSION := $(UBER_KERNEL_NAME)-$(UBER_KERNEL_DATE)
ADDITIONAL_BUILD_PROPERTIES += \
    ro.uber.kernel=$(UBER_KERNEL_VERSION)
endif
endif

ifeq (arm64,$(TARGET_ARCH))
# Path to toolchain
UBER_AND_PATH := prebuilts/gcc/$(HOST_PREBUILT_TAG)/aarch64/aarch64-linux-android-4.9
UBER_AND := $(shell $(UBER_AND_PATH)/bin/aarch64-linux-android-gcc --version)

# Find strings in version info
ifneq ($(filter (UBERTC%),$(UBER_AND)),)
UBER_AND_NAME := $(filter (UBERTC%),$(UBER_AND))
UBER_AND_DATE := $(filter 20150% 20151%,$(UBER_AND))
UBER_AND_VERSION := $(UBER_AND_NAME)-$(UBER_AND_DATE)
ADDITIONAL_BUILD_PROPERTIES += \
    ro.uber.android=$(UBER_AND_VERSION)
endif
endif

ifeq (true,$(USE_O3_OPTIMIZATIONS))
OPT1 := (O3)
endif

ifeq (true,$(STRICT_ALIASING))
OPT2 := (strict)
endif

ifeq (true,$(GRAPHITE_OPTS))
OPT3 := (graphite)
endif

ifeq (true,$(KRAIT_TUNINGS))
OPT4 := ($(TARGET_CPU_VARIANT))
endif

ifeq (true,$(ENABLE_GCCONLY))
OPT5 := (gcconly)
endif

ifeq (true,$(FLOOP_NEST_OPTIMIZE))
OPT6 := (floop_nest_optimize)
endif

ifeq (true,$(TARGET_USE_PIPE))
OPT7 := (pipe)
endif

ifeq (true,$(USE_HOST_4_8))
OPT8 := (host_4_8)
endif

ifeq (true,$(FFAST_MATH))
OPT9 := (fast_math)
endif

GCC_OPTIMIZATION_LEVELS := $(OPT1)$(OPT2)$(OPT3)$(OPT4)$(OPT5)$(OPT6)$(OPT7)$(OPT8)$(OPT9)
ifneq (,$(GCC_OPTIMIZATION_LEVELS))
ADDITIONAL_BUILD_PROPERTIES += \
    ro.uber.flags=$(GCC_OPTIMIZATION_LEVELS)
endif
endif
