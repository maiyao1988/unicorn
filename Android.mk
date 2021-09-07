LOCAL_PATH := $(call my-dir)


include $(CLEAR_VARS)
LOCAL_MODULE := arm

#$(warning "the value of LOCAL_PATH is $(LOCAL_PATH)")

# (1). ndk-build NDK_LOG=1
# 用于配置LOG级别，打印ndk编译时的详细输出信息。
# (2). ndk-build NDK_PROJECT_PATH=.
# 指定NDK编译的代码路径为当前目录，如果不配置，则必须把工程代码放到Android工程的jni目录下
# (3). ndk-build APP_BUILD_SCRIPT=./Android.mk
# 指定NDK编译使用的Android.mk文件 ，默认是$PROJECT/jni/下
# (4). ndk-build NDK_APP_APPLICATION_MK=./Application.mk
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


LOCAL_CFLAGS := -Wall -fPIC -fpic -fvisibility=hidden

LOCAL_CFLAGS += -DNEED_CPU_H 
LOCAL_C_INCLUDES := qemu/target-arm qemu/arm-softmmu \
					qemu/tcg/arm \
					qemu \
					qemu/include \
					qemu/tcg \
					include

#LOCAL_LDLIBS += -llog


include $(BUILD_STATIC_LIBRARY)
