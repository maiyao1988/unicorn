LOCAL_PATH := $(call my-dir)


include $(CLEAR_VARS)
LOCAL_MODULE := arm-softmmu

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

LOCAL_SRC_FILES := \
    qemu/cpu-exec.c \
    qemu/cpus.c \
    qemu/cputlb.c \
    qemu/exec.c \
    qemu/fpu/softfloat.c \
    qemu/hw/arm/tosa.c \
    qemu/hw/arm/virt.c \
    qemu/ioport.c \
    qemu/memory.c \
    qemu/memory_mapping.c \
    qemu/target-arm/cpu.c \
    qemu/target-arm/crypto_helper.c \
    qemu/target-arm/helper.c \
    qemu/target-arm/iwmmxt_helper.c \
    qemu/target-arm/neon_helper.c \
    qemu/target-arm/op_helper.c \
    qemu/target-arm/psci.c \
    qemu/target-arm/translate.c \
    qemu/target-arm/unicorn_arm.c \
    qemu/tcg/optimize.c \
    qemu/tcg/tcg.c \
    qemu/translate-all.c


#softmmu结尾的都是生成的目录
#qemu/tcg/arm运行机器的abi
LOCAL_C_INCLUDES := qemu/target-arm \
					qemu/arm-softmmu \
					qemu/tcg/arm \
					qemu \
					qemu/include \
					qemu/tcg \
					include

#注意，这里-include 参数是强制每个源文件都包含arm.h 这个实际上是qemu/arm.h
#实际上#define ARM_REGS_STORAGE_SIZE ARM_REGS_STORAGE_SIZE_arm，将ARM_REGS_STORAGE_SIZE define走
#而在qemu/target-arm/unicorn_arm.c ARM_REGS_STORAGE_SIZE定义，实际上是ARM_REGS_STORAGE_SIZE_arm的定义，不这么做ARM_REGS_STORAGE_SIZE_arm将会未定义
#逻辑很绕
LOCAL_CFLAGS := -Wall -fPIC -fpic -fvisibility=hidden -include arm.h

LOCAL_CFLAGS += -DNEED_CPU_H -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE #-DUNICORN_HAS_X86 -DUNICORN_HAS_ARM -DUNICORN_HAS_ARM64



include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := unicorn
LOCAL_C_INCLUDES := \
                    qemu \
                    qemu/include \
                    qemu/tcg \
                    include 

LOCAL_SRC_FILES :=  \
                    list.c \
                    qemu/accel.c \
                    qemu/glib_compat.c \
                    qemu/hw/core/machine.c \
                    qemu/hw/core/qdev.c \
                    qemu/qapi/qapi-dealloc-visitor.c \
                    qemu/qapi/qapi-visit-core.c \
                    qemu/qapi/qmp-input-visitor.c \
                    qemu/qapi/qmp-output-visitor.c \
                    qemu/qapi/string-input-visitor.c \
                    qemu/qemu-log.c \
                    qemu/qemu-timer.c \
                    qemu/qobject/qbool.c \
                    qemu/qobject/qdict.c \
                    qemu/qobject/qerror.c \
                    qemu/qobject/qfloat.c \
                    qemu/qobject/qint.c \
                    qemu/qobject/qlist.c \
                    qemu/qobject/qstring.c \
                    qemu/qom/container.c \
                    qemu/qom/cpu.c \
                    qemu/qom/object.c \
                    qemu/qom/qom-qobject.c \
                    qemu/tcg-runtime.c \
                    qemu/util/aes.c \
                    qemu/util/bitmap.c \
                    qemu/util/bitops.c \
                    qemu/util/crc32c.c \
                    qemu/util/cutils.c \
                    qemu/util/error.c \
                    qemu/util/getauxval.c \
                    qemu/util/host-utils.c \
                    qemu/util/module.c \
                    qemu/util/qemu-timer-common.c \
                    qemu/vl.c \
                    uc.c \
                    \
                    qemu/util/oslib-posix.c \
                    qemu/util/qemu-thread-posix.c \
                    qemu/qapi-types.c \
                    qemu/qapi-visit.c

LOCAL_CFLAGS := -Wall -fPIC -fvisibility=hidden -fstack-protector-strong

LOCAL_CFLAGS += -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE -DUNICORN_HAS_ARM

LOCAL_STATIC_LIBRARIES := arm-softmmu
LOCAL_LDLIBS += -llog
include $(BUILD_SHARED_LIBRARY)