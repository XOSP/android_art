#
# Copyright (C) 2011 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

ifndef ART_ANDROID_COMMON_PATH_MK
ART_ANDROID_COMMON_PATH_MK := true

include art/build/Android.common.mk

# Directory used for dalvik-cache on device.
ART_TARGET_DALVIK_CACHE_DIR := /data/dalvik-cache

# Directory used for gtests on device.
# $(TARGET_OUT_DATA_NATIVE_TESTS) will evaluate to the nativetest directory in the target part on
# the host, so we can strip everything but the directory to find out whether it is "nativetest" or
# "nativetest64."
ART_TARGET_NATIVETEST_DIR := /data/$(notdir $(TARGET_OUT_DATA_NATIVE_TESTS))/art

ART_TARGET_NATIVETEST_OUT := $(TARGET_OUT_DATA_NATIVE_TESTS)/art

# Directory used for oat tests on device.
ART_TARGET_TEST_DIR := /data/art-test
ART_TARGET_TEST_OUT := $(TARGET_OUT_DATA)/art-test

# Directory used for temporary test files on the host.
ifneq ($(TMPDIR),)
ART_HOST_TEST_DIR := $(TMPDIR)/test-art-$(shell echo $$PPID)
else
ART_HOST_TEST_DIR := /tmp/$(USER)/test-art-$(shell echo $$PPID)
endif

# core.oat location on the device.
TARGET_CORE_OAT := $(ART_TARGET_TEST_DIR)/$(DEX2OAT_TARGET_ARCH)/core.oat
ifdef TARGET_2ND_ARCH
2ND_TARGET_CORE_OAT := $(ART_TARGET_TEST_DIR)/$($(TARGET_2ND_ARCH_VAR_PREFIX)DEX2OAT_TARGET_ARCH)/core.oat
endif

CORE_OAT_SUFFIX := .oat

# core.oat locations under the out directory.
HOST_CORE_OAT_OUT_BASE := $(HOST_OUT_JAVA_LIBRARIES)/$(ART_HOST_ARCH)/core
ifneq ($(HOST_PREFER_32_BIT),true)
2ND_HOST_CORE_OAT_OUT_BASE := $(HOST_OUT_JAVA_LIBRARIES)/$(2ND_ART_HOST_ARCH)/core
endif
HOST_CORE_OAT_OUTS :=
TARGET_CORE_OAT_OUT_BASE := $(ART_TARGET_TEST_OUT)/$(DEX2OAT_TARGET_ARCH)/core
ifdef TARGET_2ND_ARCH
2ND_TARGET_CORE_OAT_OUT_BASE := $(ART_TARGET_TEST_OUT)/$($(TARGET_2ND_ARCH_VAR_PREFIX)DEX2OAT_TARGET_ARCH)/core
endif
TARGET_CORE_OAT_OUTS :=

CORE_IMG_SUFFIX := .art

# core.art locations under the out directory.
HOST_CORE_IMG_OUT_BASE := $(HOST_OUT_JAVA_LIBRARIES)/$(ART_HOST_ARCH)/core
ifneq ($(HOST_PREFER_32_BIT),true)
2ND_HOST_CORE_IMG_OUT_BASE := $(HOST_OUT_JAVA_LIBRARIES)/$(2ND_ART_HOST_ARCH)/core
endif
HOST_CORE_IMG_OUTS :=
TARGET_CORE_IMG_OUT_BASE := $(ART_TARGET_TEST_OUT)/$(DEX2OAT_TARGET_ARCH)/core
ifdef TARGET_2ND_ARCH
2ND_TARGET_CORE_IMG_OUT_BASE := $(ART_TARGET_TEST_OUT)/$($(TARGET_2ND_ARCH_VAR_PREFIX)DEX2OAT_TARGET_ARCH)/core
endif
TARGET_CORE_IMG_OUTS :=

# Oat location of core.art.
HOST_CORE_IMG_LOCATION := $(HOST_OUT_JAVA_LIBRARIES)/core.art
TARGET_CORE_IMG_LOCATION := $(ART_TARGET_TEST_OUT)/core.art

# Jar files for core.art.
TARGET_CORE_JARS := core-oj core-libart conscrypt okhttp bouncycastle apache-xml
HOST_CORE_JARS := $(addsuffix -hostdex,$(TARGET_CORE_JARS))

HOST_CORE_DEX_LOCATIONS   := $(foreach jar,$(HOST_CORE_JARS),  $(HOST_OUT_JAVA_LIBRARIES)/$(jar).jar)
ifeq ($(ART_TEST_ANDROID_ROOT),)
TARGET_CORE_DEX_LOCATIONS := $(foreach jar,$(TARGET_CORE_JARS),/$(DEXPREOPT_BOOT_JAR_DIR)/$(jar).jar)
else
TARGET_CORE_DEX_LOCATIONS := $(foreach jar,$(TARGET_CORE_JARS),$(ART_TEST_ANDROID_ROOT)/framework/$(jar).jar)
endif

HOST_CORE_DEX_FILES   := $(foreach jar,$(HOST_CORE_JARS),  $(call intermediates-dir-for,JAVA_LIBRARIES,$(jar),t,COMMON)/javalib.jar)
TARGET_CORE_DEX_FILES := $(foreach jar,$(TARGET_CORE_JARS),$(call intermediates-dir-for,JAVA_LIBRARIES,$(jar), ,COMMON)/javalib.jar)

# Classpath for Jack compilation: we only need core-libart.
HOST_JACK_CLASSPATH_DEPENDENCIES   := $(call intermediates-dir-for,JAVA_LIBRARIES,core-oj-hostdex,t,COMMON)/classes.jack $(call intermediates-dir-for,JAVA_LIBRARIES,core-libart-hostdex,t,COMMON)/classes.jack
HOST_JACK_CLASSPATH                := $(abspath $(call intermediates-dir-for,JAVA_LIBRARIES,core-oj-hostdex,t,COMMON)/classes.jack):$(abspath $(call intermediates-dir-for,JAVA_LIBRARIES,core-libart-hostdex,t,COMMON)/classes.jack)
TARGET_JACK_CLASSPATH_DEPENDENCIES := $(call intermediates-dir-for,JAVA_LIBRARIES,core-oj, ,COMMON)/classes.jack $(call intermediates-dir-for,JAVA_LIBRARIES,core-libart, ,COMMON)/classes.jack
TARGET_JACK_CLASSPATH              := $(abspath $(call intermediates-dir-for,JAVA_LIBRARIES,core-oj, ,COMMON)/classes.jack):$(abspath $(call intermediates-dir-for,JAVA_LIBRARIES,core-libart, ,COMMON)/classes.jack)

ART_HOST_DEX_DEPENDENCIES := $(foreach jar,$(HOST_CORE_JARS),$(HOST_OUT_JAVA_LIBRARIES)/$(jar).jar)
ART_TARGET_DEX_DEPENDENCIES := $(foreach jar,$(TARGET_CORE_JARS),$(TARGET_OUT_JAVA_LIBRARIES)/$(jar).jar)

ART_CORE_SHARED_LIBRARIES := libjavacore libopenjdk libopenjdkjvm libopenjdkjvmti
ART_HOST_SHARED_LIBRARY_DEPENDENCIES := $(foreach lib,$(ART_CORE_SHARED_LIBRARIES), $(ART_HOST_OUT_SHARED_LIBRARIES)/$(lib)$(ART_HOST_SHLIB_EXTENSION))
ifdef HOST_2ND_ARCH
ART_HOST_SHARED_LIBRARY_DEPENDENCIES += $(foreach lib,$(ART_CORE_SHARED_LIBRARIES), $(2ND_HOST_OUT_SHARED_LIBRARIES)/$(lib).so)
endif

ART_TARGET_SHARED_LIBRARY_DEPENDENCIES := $(foreach lib,$(ART_CORE_SHARED_LIBRARIES), $(TARGET_OUT_SHARED_LIBRARIES)/$(lib).so)
ifdef TARGET_2ND_ARCH
ART_TARGET_SHARED_LIBRARY_DEPENDENCIES += $(foreach lib,$(ART_CORE_SHARED_LIBRARIES), $(2ND_TARGET_OUT_SHARED_LIBRARIES)/$(lib).so)
endif

ART_CORE_EXECUTABLES := \
    dex2oat \
    imgdiag \
    oatdump \
    patchoat \
    profman \

# Depend on the -target or -host phony targets generated by the build system
# for each module
ART_TARGET_EXECUTABLES := $(foreach name,$(ART_CORE_EXECUTABLES),$(name)-target)
ART_HOST_EXECUTABLES := $(foreach name,$(ART_CORE_EXECUTABLES),$(name)-host)

endif # ART_ANDROID_COMMON_PATH_MK
