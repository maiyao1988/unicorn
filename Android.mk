#$(warning "the value of LOCAL_PATH is $(LOCAL_PATH)")

# (1). ndk-build NDK_LOG=1
# 用于配置LOG级别，打印ndk编译时的详细输出信息。
# (2). ndk-build NDK_PROJECT_PATH=.
# 指定NDK编译的代码路径为当前目录，如果不配置，则必须把工程代码放到Android工程的jni目录下
# (3). ndk-build APP_BUILD_SCRIPT=./Android.mk
# 指定NDK编译使用的Android.mk文件 ，默认是$PROJECT/jni/下
# (4). ndk-build NDK_APPLICATION_MK=./Application.mk
# 指定NDK编译使用的application.mk文件 ，默认是$PROJECT/jni/下
# (5). ndk-build clean
# 清除所有编译出来的临时文件和目标文件

LOCAL_PATH := $(call my-dir)

ARM_SRCS := \
        $(LOCAL_PATH)/qemu/cpu-exec.c \
        $(LOCAL_PATH)/qemu/cpus.c \
        $(LOCAL_PATH)/qemu/cputlb.c \
        $(LOCAL_PATH)/qemu/exec.c \
        $(LOCAL_PATH)/qemu/fpu/softfloat.c \
        $(LOCAL_PATH)/qemu/hw/arm/tosa.c \
        $(LOCAL_PATH)/qemu/hw/arm/virt.c \
        $(LOCAL_PATH)/qemu/ioport.c \
        $(LOCAL_PATH)/qemu/memory.c \
        $(LOCAL_PATH)/qemu/memory_mapping.c \
        $(LOCAL_PATH)/qemu/target-arm/cpu.c \
        $(LOCAL_PATH)/qemu/target-arm/crypto_helper.c \
        $(LOCAL_PATH)/qemu/target-arm/helper.c \
        $(LOCAL_PATH)/qemu/target-arm/iwmmxt_helper.c \
        $(LOCAL_PATH)/qemu/target-arm/neon_helper.c \
        $(LOCAL_PATH)/qemu/target-arm/op_helper.c \
        $(LOCAL_PATH)/qemu/target-arm/psci.c \
        $(LOCAL_PATH)/qemu/target-arm/translate.c \
        $(LOCAL_PATH)/qemu/target-arm/unicorn_arm.c \
        $(LOCAL_PATH)/qemu/tcg/optimize.c \
        $(LOCAL_PATH)/qemu/tcg/tcg.c \
        $(LOCAL_PATH)/qemu/translate-all.c

COMMON_DEFS := -DNEED_CPU_H -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE

COMMON_CFLAGS := -Wall -fPIC -fpic -fvisibility=hidden

#qemu/tcg/arm运行机器的abi
COMMON_INCLUDE := \
                    $(LOCAL_PATH)/android \
					$(LOCAL_PATH)/qemu/tcg/arm \
					$(LOCAL_PATH)/qemu \
					$(LOCAL_PATH)/qemu/include \
					$(LOCAL_PATH)/qemu/tcg \
                    $(LOCAL_PATH)/include 

#arm
include $(CLEAR_VARS)


LOCAL_MODULE := arm-softmmu


LOCAL_SRC_FILES := $(ARM_SRCS)


#softmmu结尾的都是生成的目录
LOCAL_C_INCLUDES := $(COMMON_INCLUDE) \
                    $(LOCAL_PATH)/qemu/target-arm \
					$(LOCAL_PATH)/android/arm-softmmu 

					

#注意，这里-include 参数是强制每个源文件都包含arm.h 这个实际上是qemu/arm.h
#实际上#define ARM_REGS_STORAGE_SIZE ARM_REGS_STORAGE_SIZE_arm，将ARM_REGS_STORAGE_SIZE define走
#而在qemu/target-arm/unicorn_arm.c ARM_REGS_STORAGE_SIZE定义，实际上是ARM_REGS_STORAGE_SIZE_arm的定义，不这么做ARM_REGS_STORAGE_SIZE_arm将会未定义
#逻辑很绕
LOCAL_CFLAGS := $(COMMON_CFLAGS) -include arm.h

LOCAL_CFLAGS += $(COMMON_DEFS)

include $(BUILD_STATIC_LIBRARY)


#armeb
include $(CLEAR_VARS)
LOCAL_MODULE := armeb-softmmu

LOCAL_SRC_FILES := $(ARM_SRCS)


LOCAL_C_INCLUDES := $(COMMON_INCLUDE) \
                    $(LOCAL_PATH)/qemu/target-arm \
					$(LOCAL_PATH)/android/armeb-softmmu

#armeb.h原理同arm.h
LOCAL_CFLAGS := $(COMMON_CFLAGS) -include armeb.h

LOCAL_CFLAGS += $(COMMON_DEFS)

include $(BUILD_STATIC_LIBRARY)

#x86_64
include $(CLEAR_VARS)
LOCAL_MODULE := x86_64-softmmu

LOCAL_SRC_FILES :=  \
                    $(LOCAL_PATH)/qemu/cpu-exec.c \
                    $(LOCAL_PATH)/qemu/cpus.c \
                    $(LOCAL_PATH)/qemu/cputlb.c \
                    $(LOCAL_PATH)/qemu/exec.c \
                    $(LOCAL_PATH)/qemu/fpu/softfloat.c \
                    $(LOCAL_PATH)/qemu/hw/i386/pc.c \
                    $(LOCAL_PATH)/qemu/hw/i386/pc_piix.c \
                    $(LOCAL_PATH)/qemu/hw/intc/apic.c \
                    $(LOCAL_PATH)/qemu/hw/intc/apic_common.c \
                    $(LOCAL_PATH)/qemu/ioport.c \
                    $(LOCAL_PATH)/qemu/memory.c \
                    $(LOCAL_PATH)/qemu/memory_mapping.c \
                    $(LOCAL_PATH)/qemu/target-i386/arch_memory_mapping.c \
                    $(LOCAL_PATH)/qemu/target-i386/cc_helper.c \
                    $(LOCAL_PATH)/qemu/target-i386/cpu.c \
                    $(LOCAL_PATH)/qemu/target-i386/excp_helper.c \
                    $(LOCAL_PATH)/qemu/target-i386/fpu_helper.c \
                    $(LOCAL_PATH)/qemu/target-i386/helper.c \
                    $(LOCAL_PATH)/qemu/target-i386/int_helper.c \
                    $(LOCAL_PATH)/qemu/target-i386/mem_helper.c \
                    $(LOCAL_PATH)/qemu/target-i386/misc_helper.c \
                    $(LOCAL_PATH)/qemu/target-i386/seg_helper.c \
                    $(LOCAL_PATH)/qemu/target-i386/smm_helper.c \
                    $(LOCAL_PATH)/qemu/target-i386/svm_helper.c \
                    $(LOCAL_PATH)/qemu/target-i386/translate.c \
                    $(LOCAL_PATH)/qemu/target-i386/unicorn.c \
                    $(LOCAL_PATH)/qemu/tcg/optimize.c \
                    $(LOCAL_PATH)/qemu/tcg/tcg.c \
                    $(LOCAL_PATH)/qemu/translate-all.c


LOCAL_C_INCLUDES := $(COMMON_INCLUDE) \
                    $(LOCAL_PATH)/qemu/target-i386 \
					$(LOCAL_PATH)/android/x86_64-softmmu

LOCAL_CFLAGS := $(COMMON_CFLAGS) -include x86_64.h

LOCAL_CFLAGS += $(COMMON_DEFS)

include $(BUILD_STATIC_LIBRARY)


#unicorn
include $(CLEAR_VARS)
LOCAL_MODULE := unicorn
LOCAL_C_INCLUDES := \
                    $(LOCAL_PATH)/android \
                    $(LOCAL_PATH)/qemu \
                    $(LOCAL_PATH)/qemu/include \
                    $(LOCAL_PATH)/qemu/tcg \
                    $(LOCAL_PATH)/include 

LOCAL_SRC_FILES :=  \
                    $(LOCAL_PATH)/list.c \
                    $(LOCAL_PATH)/qemu/accel.c \
                    $(LOCAL_PATH)/qemu/glib_compat.c \
                    $(LOCAL_PATH)/qemu/hw/core/machine.c \
                    $(LOCAL_PATH)/qemu/hw/core/qdev.c \
                    $(LOCAL_PATH)/qemu/qapi/qapi-dealloc-visitor.c \
                    $(LOCAL_PATH)/qemu/qapi/qapi-visit-core.c \
                    $(LOCAL_PATH)/qemu/qapi/qmp-input-visitor.c \
                    $(LOCAL_PATH)/qemu/qapi/qmp-output-visitor.c \
                    $(LOCAL_PATH)/qemu/qapi/string-input-visitor.c \
                    $(LOCAL_PATH)/qemu/qemu-log.c \
                    $(LOCAL_PATH)/qemu/qemu-timer.c \
                    $(LOCAL_PATH)/qemu/qobject/qbool.c \
                    $(LOCAL_PATH)/qemu/qobject/qdict.c \
                    $(LOCAL_PATH)/qemu/qobject/qerror.c \
                    $(LOCAL_PATH)/qemu/qobject/qfloat.c \
                    $(LOCAL_PATH)/qemu/qobject/qint.c \
                    $(LOCAL_PATH)/qemu/qobject/qlist.c \
                    $(LOCAL_PATH)/qemu/qobject/qstring.c \
                    $(LOCAL_PATH)/qemu/qom/container.c \
                    $(LOCAL_PATH)/qemu/qom/cpu.c \
                    $(LOCAL_PATH)/qemu/qom/object.c \
                    $(LOCAL_PATH)/qemu/qom/qom-qobject.c \
                    $(LOCAL_PATH)/qemu/tcg-runtime.c \
                    $(LOCAL_PATH)/qemu/util/aes.c \
                    $(LOCAL_PATH)/qemu/util/bitmap.c \
                    $(LOCAL_PATH)/qemu/util/bitops.c \
                    $(LOCAL_PATH)/qemu/util/crc32c.c \
                    $(LOCAL_PATH)/qemu/util/cutils.c \
                    $(LOCAL_PATH)/qemu/util/error.c \
                    $(LOCAL_PATH)/qemu/util/getauxval.c \
                    $(LOCAL_PATH)/qemu/util/host-utils.c \
                    $(LOCAL_PATH)/qemu/util/module.c \
                    $(LOCAL_PATH)/qemu/util/qemu-timer-common.c \
                    $(LOCAL_PATH)/qemu/vl.c \
                    $(LOCAL_PATH)/uc.c \
                    \
                    $(LOCAL_PATH)/qemu/util/oslib-posix.c \
                    $(LOCAL_PATH)/qemu/util/qemu-thread-posix.c \
                    $(LOCAL_PATH)/qemu/qapi-types.c \
                    $(LOCAL_PATH)/qemu/qapi-visit.c

LOCAL_CFLAGS := -Wall -fPIC -fvisibility=hidden -fstack-protector-strong

LOCAL_CFLAGS += -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE -DUNICORN_HAS_ARM -DUNICORN_HAS_ARMEB -DUNICORN_HAS_X86

LOCAL_STATIC_LIBRARIES := arm-softmmu armeb-softmmu x86_64-softmmu
LOCAL_LDLIBS += -llog
include $(BUILD_SHARED_LIBRARY)



#samples

include $(CLEAR_VARS)
LOCAL_MODULE := sample_arm
LOCAL_C_INCLUDES := \
                    $(LOCAL_PATH)/include 

LOCAL_SRC_FILES := $(LOCAL_PATH)/samples/sample_arm.c
                    

LOCAL_CFLAGS := -Wall -fvisibility=hidden -fstack-protector-strong
LOCAL_CFLAGS += -fPIE -pie
LOCAL_LDFLAGS += -fPIE -pie

LOCAL_CFLAGS += -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE

LOCAL_SHARED_LIBRARIES := unicorn
LOCAL_LDLIBS += -llog
include $(BUILD_EXECUTABLE)



include $(CLEAR_VARS)
LOCAL_MODULE := mem_apis
LOCAL_C_INCLUDES := \
                    $(LOCAL_PATH)/include 

LOCAL_SRC_FILES := $(LOCAL_PATH)/samples/mem_apis.c
                    

LOCAL_CFLAGS := -Wall -fvisibility=hidden -fstack-protector-strong
LOCAL_CFLAGS += -fPIE -pie
LOCAL_LDFLAGS += -fPIE -pie

LOCAL_CFLAGS += -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE

LOCAL_SHARED_LIBRARIES := unicorn
LOCAL_LDLIBS += -llog
include $(BUILD_EXECUTABLE)